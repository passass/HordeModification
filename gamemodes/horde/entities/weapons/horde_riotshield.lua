SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CoD MW2R"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.Type_Displayed = "Riot Shield"
SWEP.Author = "Olli, Fox, Mav"
SWEP.Slot = 0
SWEP.PrintName = "Riot Shield"
SWEP.DrawCrosshair = false
SWEP.DrawCrosshairIS = false

TFA.AddWeaponSound("TFA_MW2R_RIOT.Swing", {"weapons/tfa_mw2r/riotshield/riot_shield_melee_punch_03.wav", "weapons/tfa_mw2r/riotshield/riot_shield_melee_punch_04.wav"})
TFA.AddWeaponSound("TFA_MW2R_RIOT.Hit", {"weapons/tfa_mw2r/riotshield/riot_shield_impact01.wav", "weapons/tfa_mw2r/riotshield/riot_shield_impact02.wav"})
TFA.AddWeaponSound("TFA_MW2R_RIOT.Impact", {"weapons/tfa_mw2r/riotshield/h2_bulletimpact_riotshield_01.wav", "weapons/tfa_mw2r/riotshield/h2_bulletimpact_riotshield_02.wav", "weapons/tfa_mw2r/riotshield/h2_bulletimpact_riotshield_03.wav", "weapons/tfa_mw2r/riotshield/h2_bulletimpact_riotshield_04.wav"})
TFA.AddWeaponSound("TFA_MW2R_RIOT.Holster", "weapons/tfa_mw2r/riotshield/riot_shield_lower_weapon.wav")
TFA.AddWeaponSound("TFA_MW2R_RIOT.Lift", "weapons/tfa_mw2r/riotshield/riot_shield_raise_weapon.wav")
TFA.AddWeaponSound("TFA_MW2R_RIOT.Raise", "weapons/tfa_mw2r/riotshield/wpn_h2_riotshield_first_raise_01.wav")
TFA.AddWeaponSound("TFA_MW2R_RIOT.Look1", "weapons/tfa_mw2r/riotshield/wpn_h2_riotshield_inspect_look_1_01.wav")
TFA.AddWeaponSound("TFA_MW2R_RIOT.Look2", "weapons/tfa_mw2r/riotshield/wpn_h2_riotshield_inspect_look_2_01.wav")
TFA.AddWeaponSound("TFA_MW2R_RIOT.Rest", "weapons/tfa_mw2r/riotshield/wpn_h2_riotshield_inspect_look_rest_01.wav")
TFA.AddWeaponSound("TFA_MW2R_RIOT.Walk", {"weapons/tfa_mw2r/riotshield/riot_shield_plant_move_01.wav", "weapons/tfa_mw2r/riotshield/riot_shield_plant_move_02.wav", "weapons/tfa_mw2r/riotshield/riot_shield_plant_move_03.wav"})

local function BlockDamageRiotShield( ent, dmginfo, bonus )
	--replacing the entire function like a dumbass cause i cant code for shit and dont know who to ask for help
		if dmginfo:IsDamageType( DMG_DROWNRECOVER ) or dmginfo:IsDamageType(DMG_DIRECT) then return end
		local wep = ent:GetActiveWeapon()

		if (wep.IsTFAWeapon and wep.RiotShieldDamageTypes and wep.RiotShield == true) then
		local RiotShield
		for _,v in ipairs(wep.RiotShieldDamageTypes) do
			if dmginfo:IsDamageType(v) then RiotShield = true end
		end
		if RiotShield then
			local blockthreshold = ( wep.RiotShieldCone or 135 ) / 2
			local damageinflictor = dmginfo:GetInflictor()

			if (not IsValid(damageinflictor)) then
				damageinflictor = dmginfo:GetAttacker()
			end

			--if angle_mult_cv then
			--	blockthreshold = blockthreshold * angle_mult_cv:GetFloat()
			--end

			if (IsValid(damageinflictor) and ( math.abs(math.AngleDifference( ent:EyeAngles().y, ( damageinflictor:GetPos() - ent:GetPos() ):Angle().y )) <= blockthreshold)) then
				if wep.RiotShieldPreHook and wep:RiotShieldPreHook() then
                    return
                end
				
				--local olddmg = dmginfo:GetDamage()
				local dmgscale = math.min( wep.RiotShieldMaximum, wep.RiotShieldDamageCap / dmginfo:GetDamage() )
				bonus.less = bonus.less * dmgscale
				--dmginfo:ScaleDamage(dmgscale)
				dmginfo:SetDamagePosition(vector_origin)
				dmginfo:SetDamageType( bit.bor( dmginfo:GetDamageType(), DMG_DROWNRECOVER ) )
				wep:EmitSound(wep.RiotShieldImpact or "")

				--if deflect_cv and deflect_cv:GetInt() == 2 then
				--	DeflectBullet( ent, dmginfo, olddmg )
				--end

                if wep.RiotShieldPostHook then wep:RiotShieldPostHook(dmginfo) end
			end
		end
	end
end

hook.Add("Horde_OnPlayerDamageTaken", "horde_riotshieldblockdamage", function( ply, dmginfo, bonus )
	BlockDamageRiotShield( ply, dmginfo, bonus )
end)


--[Model]--
SWEP.ViewModel			= "models/weapons/tfa_mw2cr/riotshield/c_riotshield.mdl"
SWEP.ViewModelFOV = 70
SWEP.WorldModel			= "models/weapons/tfa_mw2cr/riotshield/w_riotshield.mdl"
SWEP.HoldType = "camera"
SWEP.CameraAttachmentOffsets = {}
SWEP.CameraAttachmentScale = 1.5
if CLIENT then
    SWEP.WepSelectIcon = Material("entities/horde_riotshield.png")
    killicon.Add("horde_riotshield", "entities/horde_riotshield", Color(0, 0, 0, 255))
end
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = 6,
        Right = 8,
        Forward = 5,
        },
        Ang = {
		Up = -90,
        Right = 170,
        Forward = -12
        },
		Scale = 1.1
}

--[Attack]--
SWEP.Primary.Sound = Sound("TFA_MW2R_RIOT.Swing")
SWEP.Primary.Sound_Hit = Sound("TFA_MW2R_RIOT.Hit")
SWEP.SwordClash = Sound("TFA_MW2R_RIOT.Impact")
SWEP.ImpactDecal = ""
SWEP.Primary.Damage = 65
SWEP.Primary.DamageType = bit.bor(DMG_CLUB, DMG_SLASH)

--[Blocking]--
SWEP.RiotShield = true
SWEP.RiotShieldCone = 90 --Think of the player's view direction as being the middle of a sector, with the sector's angle being this
SWEP.RiotShieldMaximum = 0.0 --Multiply damage by this for a maximumly effective block
SWEP.RiotShieldImpact = "TFA_MW2R_RIOT.Impact"
SWEP.RiotShieldCanDeflect = false
SWEP.RiotShieldDamageCap = 100
SWEP.RiotShieldDamageTypes = {
	DMG_SLASH,DMG_CLUB,DMG_BULLET
}

SWEP.RiotShieldHealth = 250

function SWEP:RiotShieldPostHook(dmginfo)
	if CLIENT then
		if isstring(dmginfo) then
			self.RiotShieldHealth = tonumber(dmginfo) or self.RiotShieldHealth
		end
	else
		print(self.RiotShieldHealth, dmginfo:GetDamage())
		self.RiotShieldHealth = self.RiotShieldHealth - dmginfo:GetDamage()
		if self.RiotShieldHealth <= 0 then
			self:GetOwner():StripWeapon(self:GetClass())
			self:EmitSound("physics/wood/wood_crate_break1.wav")
		else
			self:CallOnClient("RiotShieldPostHook", "" .. self.RiotShieldHealth)
		end
	end
end

if CLIENT then
	function SWEP:GetHUDData()
		local hpamount = math.Round(self.RiotShieldHealth)
		return {
			ammoname = "HP",
			clip = hpamount,
			ammo = hpamount,
		}
	end
end

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 90, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 45, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = SWEP.Primary.Damage, --Damage
		["dmgtype"] = SWEP.Primary.DamageType,
		["delay"] = 4 / 30, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = SWEP.Primary.Sound, -- Sound ID
		["hitflesh"] = SWEP.Primary.Sound_Hit,
		["hitworld"] = SWEP.Primary.Sound_Hit,
		["viewpunch"] = Angle(2, 2.5, 0), --viewpunch angle
		["end"] = 1.35, --time before next attack
		["hull"] = 10, --Hullsize
	},
}

--[Misc]--
SWEP.Primary.RPM = 60 / 0.4
SWEP.Primary.Length = 500
SWEP.AllowSprintAttack = false
SWEP.Secondary.CanBash = false
SWEP.InspectPos = Vector(0, 1, 0)
SWEP.InspectAng = Vector(0, 0, 0)
SWEP.Primary.MaxCombo = 0
SWEP.MoveSpeed = 0.8
SWEP.AltAttack = false

--[Tables]--
SWEP.SequenceRateOverride = {
	[ACT_VM_DRAW] = 40 / 30,
	[ACT_VM_HOLSTER] = 40 / 30,
}

SWEP.SprintAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_in", --Number for act, String/Number for sequence
	},
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_loop", --Number for act, String/Number for sequence
		["is_idle"] = true
	},
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_out", --Number for act, String/Number for sequence
	}
}

SWEP.EventTable = {
[ACT_VM_DRAW] = {
{ ["time"] = 1 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Lift") },
},
[ACT_VM_HOLSTER] = {
{ ["time"] = 1 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Holster") },
},
["sprint_loop"] = {
{ ["time"] = 1 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Walk") },
{ ["time"] = 11 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Walk") },
},
[ACT_VM_HITCENTER] = {
{ ["time"] = 1 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Lift") },
},
[ACT_VM_DRAW_DEPLOYED] = {
{ ["time"] = 0 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_MED.Draw") },
{ ["time"] = 0 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Raise") },
},
[ACT_VM_FIDGET] = {
{ ["time"] = 5 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Look1") },
{ ["time"] = 60 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Look2") },
{ ["time"] = 101 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_RIOT.Rest") },
},
}

--[Shit]--
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.05 --Start an idle this far early into the end of another animation
SWEP.SprintBobMult = 0

DEFINE_BASECLASS( SWEP.Base )

local hudhangtime_cvar = GetConVar("cl_tfa_hud_hangtime")
local hudfade_cvar = GetConVar("cl_tfa_hud_ammodata_fadein")
function SWEP:DoDrawCrosshair() end
function SWEP:DrawHUDAmmo()
	local self2 = self:GetTable()
	local stat = self2.GetStatus(self)

	if self2.GetStatL(self, "BoltAction") then
		if stat == TFA.Enum.STATUS_SHOOTING then
			if not self2.LastBoltShoot then
				self2.LastBoltShoot = l_CT()
			end
		elseif self2.LastBoltShoot then
			self2.LastBoltShoot = nil
		end
	end

	fm = self:GetFireMode()
	targbool = (not TFA.Enum.HUDDisabledStatus[stat]) or fm ~= lfm
	targbool = targbool or (stat == TFA.Enum.STATUS_SHOOTING and self2.LastBoltShoot and l_CT() > self2.LastBoltShoot + self2.BoltTimerOffset)
	targbool = targbool or (self2.GetStatL(self, "PumpAction") and (stat == TFA.Enum.STATUS_PUMP or (stat == TFA.Enum.STATUS_SHOOTING and self:Clip1() == 0)))
	targbool = targbool or (stat == TFA.Enum.STATUS_FIDGET)

	targ = targbool and 1 or 0
	lfm = fm

	if targ == 1 then
		lactive = RealTime()
	elseif RealTime() < lactive + hudhangtime_cvar:GetFloat() then
		targ = 1
	elseif self:GetOwner():KeyDown(IN_RELOAD) then
		targ = 1
	end

	self2.CLAmmoProgress = math.Approach(self2.CLAmmoProgress, targ, (targ - self2.CLAmmoProgress) * RealFrameTime() * 2 / hudfade_cvar:GetFloat())

	local myalpha = 225 * self2.CLAmmoProgress
	if myalpha < 1 then return end
	local amn = self2.GetStatL(self, "Primary.Ammo")
	if not amn then return end
	if amn == "none" or amn == "" then return end
	local mzpos = self:GetMuzzlePos()

	if self2.GetStatL(self, "IsAkimbo") then
		self2.MuzzleAttachmentRaw = self2.MuzzleAttachmentRaw2 or 1
	end

	if self2.GetHidden(self) then return end

	local xx, yy

	if mzpos and mzpos.Pos then
		local pos = mzpos.Pos
		local textsize = self2.textsize and self2.textsize or 1
		local pl = IsValid(self:GetOwner()) and self:GetOwner() or LocalPlayer()
		local ang = pl:EyeAngles() --(angpos.Ang):Up():Angle()
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
		ang:RotateAroundAxis(ang:Forward(), 0)
		pos = pos + ang:Right() * (self2.textupoffset and self2.textupoffset or -2 * (textsize / 1))
		pos = pos + ang:Up() * (self2.textfwdoffset and self2.textfwdoffset or 0 * (textsize / 1))
		pos = pos + ang:Forward() * (self2.textrightoffset and self2.textrightoffset or -1 * (textsize / 1))
		cam.Start3D()
		local postoscreen = pos:ToScreen()
		cam.End3D()
		xx = postoscreen.x
		yy = postoscreen.y
	else -- fallback to pseudo-3d if no muzzle
		xx, yy = ScrW() * .65, ScrH() * .6
	end

	local v, newx, newy, newalpha = hook.Run("TFA_DrawHUDAmmo", self, xx, yy, myalpha)
	if v ~= nil then
		if v then
			xx = newx or xx
			yy = newy or yy
			myalpha = newalpha or myalpha
		else
			return
		end
	end

	if self:GetInspectingProgress() < 0.01 and self2.GetStatL(self, "Primary.Ammo") ~= "" and self2.GetStatL(self, "Primary.Ammo") ~= 0 then
		local str, clipstr

		if self2.GetStatL(self, "Primary.ClipSize") and self2.GetStatL(self, "Primary.ClipSize") ~= -1 then
			clipstr = language.GetPhrase("tfa.hud.ammo.clip1")

			if self2.GetStatL(self, "IsAkimbo") and self2.GetStatL(self, "EnableAkimboHUD") ~= false then
				str = clipstr:format(math.ceil(self:Clip1() / 2))

				if (self:Clip1() > self2.GetStatL(self, "Primary.ClipSize")) then
					str = clipstr:format(math.ceil(self:Clip1() / 2) - 1 .. " + " .. (math.ceil(self:Clip1() / 2) - math.ceil(self2.GetStatL(self, "Primary.ClipSize") / 2)))
				end
			else
				str = clipstr:format(self:Clip1())

				if (self:Clip1() > self2.GetStatL(self, "Primary.ClipSize")) then
					str = clipstr:format(self2.GetStatL(self, "Primary.ClipSize") .. " + " .. (self:Clip1() - self2.GetStatL(self, "Primary.ClipSize")))
				end
			end

			draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			str = language.GetPhrase("tfa.hud.ammo.reserve1"):format(self2.Ammo1(self))
			yy = yy + TFA.Fonts.SleekHeight
			xx = xx - TFA.Fonts.SleekHeight / 3
			draw.DrawText(str, "TFASleekMedium", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleekMedium", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			yy = yy + TFA.Fonts.SleekHeightMedium
			xx = xx - TFA.Fonts.SleekHeightMedium / 3
		else
			str = language.GetPhrase("tfa.hud.ammo1"):format(self2.Ammo1(self))
			draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			yy = yy + TFA.Fonts.SleekHeightMedium
			xx = xx - TFA.Fonts.SleekHeightMedium / 3
		end


		yy = yy + TFA.Fonts.SleekHeightSmall
		xx = xx - TFA.Fonts.SleekHeightSmall / 3

		if self2.GetStatL(self, "IsAkimbo") and self2.GetStatL(self, "EnableAkimboHUD") ~= false then
			local angpos2 = self:GetOwner():ShouldDrawLocalPlayer() and self:GetAttachment(2) or self2.OwnerViewModel:GetAttachment(2)

			if angpos2 then
				local pos2 = angpos2.Pos
				local ts2 = pos2:ToScreen()

				xx, yy = ts2.x, ts2.y
			else
				xx, yy = ScrW() * .35, ScrH() * .6
			end

			if self2.GetStatL(self, "Primary.ClipSize") and self2.GetStatL(self, "Primary.ClipSize") ~= -1 then
				clipstr = language.GetPhrase("tfa.hud.ammo.clip1")

				str = clipstr:format(math.floor(self:Clip1() / 2))

				if (math.floor(self:Clip1() / 2) > math.floor(self2.GetStatL(self, "Primary.ClipSize") / 2)) then
					str = clipstr:format(math.floor(self:Clip1() / 2) - 1 .. " + " .. (math.floor(self:Clip1() / 2) - math.floor(self2.GetStatL(self, "Primary.ClipSize") / 2)))
				end

				draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				str = language.GetPhrase("tfa.hud.ammo.reserve1"):format(self2.Ammo1(self))
				yy = yy + TFA.Fonts.SleekHeight
				xx = xx - TFA.Fonts.SleekHeight / 3
				draw.DrawText(str, "TFASleekMedium", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekMedium", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				yy = yy + TFA.Fonts.SleekHeightMedium
				xx = xx - TFA.Fonts.SleekHeightMedium / 3
			else
				str = language.GetPhrase("tfa.hud.ammo1"):format(self2.Ammo1(self))
				draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				yy = yy + TFA.Fonts.SleekHeightMedium
				xx = xx - TFA.Fonts.SleekHeightMedium / 3
			end
		end

		if self2.GetStatL(self, "Secondary.Ammo") and self2.GetStatL(self, "Secondary.Ammo") ~= "" and self2.GetStatL(self, "Secondary.Ammo") ~= "none" and self2.GetStatL(self, "Secondary.Ammo") ~= 0 and not self2.GetStatL(self, "IsAkimbo") then
			if self2.GetStatL(self, "Secondary.ClipSize") and self2.GetStatL(self, "Secondary.ClipSize") ~= -1 then
				clipstr = language.GetPhrase("tfa.hud.ammo.clip2")
				str = (self:Clip2() > self2.GetStatL(self, "Secondary.ClipSize")) and clipstr:format(self2.GetStatL(self, "Secondary.ClipSize") .. " + " .. (self:Clip2() - self2.GetStatL(self, "Primary.ClipSize"))) or clipstr:format(self:Clip2())
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				str = language.GetPhrase("tfa.hud.ammo.reserve2"):format(self2.Ammo2(self))
				yy = yy + TFA.Fonts.SleekHeightSmall
				xx = xx - TFA.Fonts.SleekHeightSmall / 3
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			else
				str = language.GetPhrase("tfa.hud.ammo2"):format(self2.Ammo2(self))
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			end
		end
	end
end
function SWEP:GenerateInspectionDerma() end