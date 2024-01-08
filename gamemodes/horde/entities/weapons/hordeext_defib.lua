AddCSLuaFile()
SWEP.PrintName = "Defibrillator"
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.Slot = 5
SWEP.SlotPos = 3
SWEP.Spawnable = true
SWEP.ViewModel = Model("models/weapons/v_defibbackstabber.mdl")
SWEP.WorldModel = Model("models/weapons/w_defibbackstabber.mdl")
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/hordeext_defib")
end

function SWEP:Initialize()
	self:SetHoldType("slam")
end

local STATE_NONE, STATE_PROGRESS = 0, 1

if SERVER then
	function SWEP:Horde_StartTimeStop()
		local owner = self:GetOwner()
		if self.Medkit_Ammo_Timer and owner ~= HORDE.TimeStop_Activator() then self.Medkit_Ammo_Timer:Stop() end
	end

	function SWEP:Horde_EndTimeStop()
		local owner = self:GetOwner()
		if self.Medkit_Ammo_Timer and owner ~= HORDE.TimeStop_Activator() then self.Medkit_Ammo_Timer:Start() end
	end
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	--[[local tr = util.TraceLine(
		{
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 80,
			filter = self.Owner
		}
	)]]
	--print(tr.Entity)
	--PrintTable(ents.FindInSphere(self:GetOwner():GetPos(), 125))
	for _, ent in pairs(ents.FindInSphere(self:GetOwner():GetPos(), 125)) do
		if IsValid(ent) and ent:GetClass() == "hl2mp_ragdoll" then
			local ply_to_revive
			for _, ply in pairs(player.GetAll()) do
				if !ply:Alive() and ply:GetRagdollEntity() == ent then
					ply_to_revive = ply
					break
					--print(ply:GetRagdollEntity())
				end
			end
			if IsValid(ply_to_revive) then self:BeginDefib(ply_to_revive, ent) end
		end
	end
	
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "DefibState")
	self:NetworkVar("Float", 1, "DefibStartTime")
	self:NetworkVar("String", 0, "StateText")
end

function SWEP:OnRemove()
end

function SWEP:Initialize()
	self:SetDefibState(STATE_NONE)
	self:SetDefibStartTime(0)
end

function SWEP:Deploy()
	self:SetDefibState(STATE_NONE)
	self:SetDefibStartTime(0)
	return true
end

function SWEP:Holster()
	self:SetDefibState(STATE_NONE)
	self:SetDefibStartTime(0)
	return true
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = false
	return self.AmmoDisplay
end

function SWEP:Think()
	if CLIENT then return end
	if self:GetDefibState() == STATE_PROGRESS then
		if not IsValid(self.Owner) then
			--self:FireError()
			return
		end

		if not (IsValid(self.TargetPly) and IsValid(self.TargetRagdoll)) then
			--self:FireError("ERROR - SUBJECT BRAINDEAD")
			return
		end

		--[[local tr = util.TraceLine(
			{
				start = self.Owner:EyePos(),
				endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 80,
				filter = self.Owner
			}
		)

		if tr.Entity ~= self.TargetRagdoll then return end]]
		if !table.HasValue(ents.FindInSphere(self:GetOwner():GetPos(), 125), self.TargetRagdoll) then return end
		if CurTime() >= self:GetDefibStartTime() + 5 then
			if self:HandleRespawn() then
				self.Owner:EmitSound("ambient/energy/weld1.wav", 25, 100)
				self:GetOwner():StripWeapon(self:GetClass())
			else
				return
			end
		end

		self:NextThink(CurTime())
		return true
	end
end

function SWEP:BeginDefib(ply, ragdoll)
	local spawnPos = self:FindPosition(self.Owner)
	local VModel = self.Owner:GetViewModel()
	local EnumToSeq = VModel:SelectWeightedSequence(ACT_VM_PRIMARYATTACK)
	VModel:SendViewModelMatchingSequence(EnumToSeq)
	if not spawnPos then
		--self:FireError("FAILURE - INSUFFICIENT ROOM")
		return
	end

	--self:SetStateText("DEFIBRILLATING - " .. string.upper(ply:Name()))
	self:SetDefibState(STATE_PROGRESS)
	self:SetDefibStartTime(CurTime())
	self:GetOwner():GetViewModel():SendViewModelMatchingSequence(3)
	self.TargetPly = ply
	self.TargetRagdoll = ragdoll
	self:SetNextPrimaryFire(CurTime() + 6)
end

function SWEP:HandleRespawn()
	local ply, ragdoll = self.TargetPly, self.TargetRagdoll
	local spawnPos = self:FindPosition(self.Owner)
	if not spawnPos then return false end
	ply.MarkedForRespawn = true
	ply:Horde_SetGivenStarterWeapons(true)
	ply:Spawn()
	timer.Simple(.5, function()
		if IsValid(ply) then
			ply.MarkedForRespawn = nil
		end
	end)
	ply:SetPos(spawnPos)
	ply:SetEyeAngles(Angle(0, ragdoll:GetAngles().y, 0))
	ragdoll:Remove()
	return true
end

local Positions = {}
for i = 0, 360, 22.5 do -- Populate Around Player
	table.insert(Positions, Vector(math.cos(i), math.sin(i), 0))
end

table.insert(Positions, Vector(0, 0, 1)) -- Populate Above Player
function SWEP:FindPosition(ply)
	local size = Vector(32, 32, 72)
	local StartPos = ply:GetPos() + Vector(0, 0, size.z / 2)
	local len = #Positions
	for i = 1, len do
		local v = Positions[i]
		local Pos = StartPos + v * size * 1.5
		local tr = {}
		tr.start = Pos
		tr.endpos = Pos
		tr.mins = size / 2 * -1
		tr.maxs = size / 2
		local trace = util.TraceHull(tr)
		if not trace.Hit then return Pos - Vector(0, 0, size.z / 2) end
	end
	return false
end

SWEP.CantDropWep = true