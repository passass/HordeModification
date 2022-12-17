include("loader.lua")
AddCSLuaFile("loader.lua")

if SERVER then
	function HORDE:MakeExplosionEffect(pos, ent)
		if CreateGrenadeExplosion then
			CreateGrenadeExplosion(pos)
			if ent then HORDE:EmitExplosionSound(ent, 125) end
		else
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata)
		end
	end
	
	function HORDE:EmitExplosionSound(ent, soundlevel, pitch) 
		ent:EmitSound("weapons/explode" .. math.random(3, 5) .. ".wav", soundlevel, pitch)
	end
end
