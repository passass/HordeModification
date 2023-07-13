if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = Material("entities/horde_riotshield.png")
    killicon.Add("arccw_horde_riotshield", "entities/horde_riotshield", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Riot Shield"

HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Swing", {"weapons/tfa_mw2r/riotshield/riot_shield_melee_punch_03.wav", "weapons/tfa_mw2r/riotshield/riot_shield_melee_punch_04.wav"})
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Hit", {"weapons/tfa_mw2r/riotshield/riot_shield_impact01.wav", "weapons/tfa_mw2r/riotshield/riot_shield_impact02.wav"})
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Impact", {"weapons/tfa_mw2r/riotshield/h2_bulletimpact_riotshield_01.wav", "weapons/tfa_mw2r/riotshield/h2_bulletimpact_riotshield_02.wav", "weapons/tfa_mw2r/riotshield/h2_bulletimpact_riotshield_03.wav", "weapons/tfa_mw2r/riotshield/h2_bulletimpact_riotshield_04.wav"})
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Holster", "weapons/tfa_mw2r/riotshield/riot_shield_lower_weapon.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Lift", "weapons/tfa_mw2r/riotshield/riot_shield_raise_weapon.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Raise", "weapons/tfa_mw2r/riotshield/wpn_h2_riotshield_first_raise_01.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Look1", "weapons/tfa_mw2r/riotshield/wpn_h2_riotshield_inspect_look_1_01.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Look2", "weapons/tfa_mw2r/riotshield/wpn_h2_riotshield_inspect_look_2_01.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Rest", "weapons/tfa_mw2r/riotshield/wpn_h2_riotshield_inspect_look_rest_01.wav")
HORDE:Sound_AddWeaponSound("TFA_MW2R_RIOT.Walk", {"weapons/tfa_mw2r/riotshield/riot_shield_plant_move_01.wav", "weapons/tfa_mw2r/riotshield/riot_shield_plant_move_02.wav", "weapons/tfa_mw2r/riotshield/riot_shield_plant_move_03.wav"})

local function BlockDamageRiotShield( ent, dmginfo, bonus )
	--replacing the entire function like a dumbass cause i cant code for shit and dont know who to ask for help
		if dmginfo:IsDamageType( DMG_DROWNRECOVER ) or dmginfo:IsDamageType(DMG_DIRECT) then return end
		local wep = ent:GetActiveWeapon()

		if wep.RiotShieldDamageTypes and wep.RiotShield == true then
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

SWEP.RiotShield = true
SWEP.RiotShieldCone = 90 --Think of the player's view direction as being the middle of a sector, with the sector's angle being this
SWEP.RiotShieldMaximum = 0.0 --Multiply damage by this for a maximumly effective block
SWEP.RiotShieldImpact = "TFA_MW2R_RIOT.Impact"
SWEP.RiotShieldCanDeflect = false
SWEP.RiotShieldDamageCap = 100
SWEP.RiotShieldDamageTypes = {
	DMG_SLASH,DMG_CLUB,DMG_BULLET
}
SWEP.ShootWhileSprint = false
SWEP.RiotShieldHealth = 250

function SWEP:RiotShieldPostHook(dmginfo)
	if SERVER then
        local owner = self:GetOwner()
        local RiotShieldHealth = owner:GetAmmoCount("ShieldHp") - dmginfo:GetDamage()
        self.RiotShieldHealth = RiotShieldHealth
        print(self:GetPrimaryAmmoType(), RiotShieldHealth)
		if RiotShieldHealth <= 0 then
			owner:StripWeapon(self:GetClass())
			self:EmitSound("physics/wood/wood_crate_break1.wav")
        else
            owner:SetAmmo(RiotShieldHealth, "ShieldHp")
        end
	end
end
SWEP.SpeedMult = 0.8
if CLIENT then
	function SWEP:Hook_GetHUDData(data)
		local hpamount = math.Round(self.RiotShieldHealth)

        table.Merge(data, {
			ammoname = "HP",
			clip = hpamount,
			ammo = hpamount,
		})
	end
end

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = true

game.AddAmmoType( {
	name = "ShieldHp",
} )

SWEP.Primary.Ammo = "ShieldHp" -- what ammo type the gun uses
SWEP.MagID = "ShieldHp"

SWEP.ViewModel			= "models/weapons/tfa_mw2cr/riotshield/c_riotshield.mdl"
SWEP.ViewModelFOV = 70
SWEP.WorldModel			= "models/weapons/tfa_mw2cr/riotshield/w_riotshield.mdl"
SWEP.WorldModelOffset = {
    pos        =    Vector(6, 8, 5),
    ang        =    Angle(-12, 90, 170),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

SWEP.DefaultSkin = 0
SWEP.DefaultWMSkin = 0

SWEP.MeleeDamage = 75

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamageType = DMG_CLUB
SWEP.MeleeRange = 70
SWEP.MeleeAttackTime = 0
SWEP.MeleeTime = 1.2
SWEP.MeleeGesture = 0

--[[SWEP.MeleeSwingSound = {
    "weapons/tfa_cso/stormgiant/midslash1.wav", "weapons/tfa_cso/stormgiant/midslash2.wav"
}]]
SWEP.MeleeMissSound = {
    Sound("TFA_MW2R_RIOT.Swing")
}
SWEP.MeleeHitSound = {
    Sound("TFA_MW2R_RIOT.Hit")
}
SWEP.MeleeHitNPCSound = {
    Sound("TFA_MW2R_RIOT.Hit")
}

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "camera"

SWEP.Primary.ClipSize = -1

SWEP.AttachmentElements = {
}

SWEP.Attachments = {
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            {s = Sound("TFA_MW2R_RIOT.Lift"), t = 0},
        },
    },
    ["ready"] = {
        Source = "draw_first",
        SoundTable = {

            { t = 0, s = Sound("TFA_MW2R_MED.Draw") },
            { t = 0, s = Sound("TFA_MW2R_RIOT.Raise") },
        },
    },
    ["holster"] = {
        Source = "holster",
        SoundTable = {
            {s = Sound("TFA_MW2R_RIOT.Holster"), t = 0},
        },
        
    },
    ["bash"] = {
        Source = "melee",
        --Mult = .8,
    },

    ["enter_sprint"] = {
        Source = "sprint_in",
        Time = 10 / 30
    },
    ["idle_sprint"] = {
        Source = "sprint_loop",
        Time = 30 / 40
    },
    ["exit_sprint"] = {
        Source = "sprint_out",
        Time = 10 / 30
    },
}

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 0, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0,0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)

function SWEP:Hook_OnDeploy()
    timer.Simple(0, function()
        if IsValid(self) then
            local owner = self:GetOwner()
            if IsValid(owner) then
                owner:SetAmmo(self.RiotShieldHealth, "ShieldHp")
            end
        end
    end)
end