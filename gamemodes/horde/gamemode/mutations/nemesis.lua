MUTATION.PrintName = "Nemesis"
MUTATION.Description = "Leaves behind poisonous clouds on death.\nClouds deal Poison damage based on victim's health."

MUTATION.Hooks = {}

MUTATION.Hooks.Horde_OnSetMutation = function(ent, mutation)
    if SERVER and mutation == "nemesis" then
		local e = ents.Create("obj_mutation_nemesis")
		local col_min, col_max = ent:GetCollisionBounds()
		local height = math.abs(col_min.z - col_max.z)
		local p = ent:GetPos()
		p.z = p.z + height / 2
		e:SetPos(p)
		e:SetParent(ent)

		ent.Horde_Nemesis_Orb = e
    end
end

if SERVER then

	HORDE.Mutations_Nemesis_List = {}

	function HORDE:Mutations_Nemesis_GetAll() 
		return HORDE.Mutations_Nemesis_List
	end

	local function get_free_nemesis_id()
		local trys = 0
		local id = math.random(1, 999)
		local all_nemesises = HORDE:Mutations_Nemesis_GetAll()
		while trys < 1000 and all_nemesises[id] do 
			trys = trys + 1
			id = math.random(1, 999)
		end
		if trys >= 1000 then 
			return false
		end
		return id
	end

	function HORDE:Mutations_Nemesis_Create(ent_pos)
		if hook.Run("Horde_Mutations_Nemesis_Create", ent_pos) then return end
		local id = get_free_nemesis_id()
		if !id then return false end
		HORDE.Mutations_Nemesis_List[id] = true
		timer.Create("Horde_Mutation_Nemesis" .. id, .5, 1, function()
			local try = 0
			timer.Create("Horde_Mutation_Nemesis" .. id, .2, 10, function()
				try = try + 1
				if try == 10 then
					HORDE:Mutations_Nemesis_Delete(id)
				end
				
				local rand = VectorRand()
                if rand.z < 0 then rand.z = -rand.z end
                local pos = ent_pos + rand * math.Rand(10, 50)
                for _, e1 in pairs(ents.FindInSphere(pos, 150)) do
                    if HORDE:IsPlayerOrMinion(e1) == true then
                        local dmginfo = DamageInfo()
                        dmginfo:SetDamage(math.max(5, 0.05 * e1:GetMaxHealth()))
                        dmginfo:SetAttacker(Entity(0))
                        dmginfo:SetInflictor(Entity(0))
                        dmginfo:SetDamagePosition(pos)
                        dmginfo:SetDamageType(DMG_ACID)
                        e1:TakeDamageInfo(dmginfo)
                    end
                end
                local e = EffectData()
                    e:SetOrigin(pos)
                util.Effect("corruption", e, true, true)
                sound.Play("ambient/levels/canals/toxic_slime_sizzle2.wav", pos)
				
			end)
		end)
	end

	function HORDE:Mutations_Nemesis_Delete(id)
		HORDE.Mutations_Nemesis_List[id] = nil
	end

end



MUTATION.Hooks.Horde_OnEnemyKilled = function(victim, killer, weapon)
    if victim:Horde_HasMutation("nemesis") then
        local victim_pos = victim:GetPos()
		HORDE:Mutations_Nemesis_Create(victim_pos)
    end
end

MUTATION.Hooks.Horde_OnUnsetMutation = function (ent, mutation)
    if not ent:IsValid() or mutation ~= "nemesis" then return end
    if SERVER then
        ent.Horde_Nemesis_Orb:Remove()
    end
    ent:StopParticles()
end