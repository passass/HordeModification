if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_hordeext_akimbo_ak47")
    killicon.AddAlias("arccw_hordeext_akimbo_ak47", "arccw/weaponicons/arccw_hordeext_akimbo_ak47")
end
SWEP.Base = "arccw_horde_akimbo_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
SWEP.WeaponCamBone = tag_camera

SWEP.PrintName = "MP5 + MP5"
SWEP.Trivia_Class = "Handgun"
SWEP.Trivia_Desc = "Semi-automatic (single fire)\nUnofficial."

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/fesiugmw2/c_glock17_1.mdl"
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(-14, 6, -4),
    ang = Angle(-10, 0, 180)
}

SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.ViewModelFOV = 65
SWEP.ClipsPerAmmoBox = 2
SWEP.Damage = 40
SWEP.DamageMin = 20
SWEP.Range = 740 * 0.025  -- GAME UNITS * 0.025 = METRES
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any


SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 17

SWEP.VisualRecoilMult = 0


SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = {"weapon_pistol"}
SWEP.NPCWeight = 100



SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 105 -- pitch of shoot sound

SWEP.MuzzleEffect = "muzzleflash_mp5"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellPitch = 100
SWEP.ShellScale = 1.25
SWEP.ShellRotateAngle = Angle(0, 180, 0)

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.8
SWEP.SightTime = 0.125


SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.IronSightStruct = {
    Pos = Vector(-1.998, 0, 1.563),
    Ang = Angle(-1.112, 0, 0),
    ViewModelFOV = 65,
    Magnification = 1,
}

--[[SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "revolver"
SWEP.HoldtypeSights = "revolver"]]

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 0, 1.34)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(3, 0, -1)
SWEP.CustomizeAng = Angle(10, 19, 0)

SWEP.CrouchPos = Vector(-2.764, -0.927, -0.202)
SWEP.CrouchAng = Angle(1.12, -1, -21.444)

SWEP.HolsterPos = Vector(1, 0, 1)
SWEP.HolsterAng = Angle(-10, 12, 0)

SWEP.SprintPos = Vector(0, 0, 1.34)
SWEP.SprintAng = Angle(0, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 22

SWEP.CanBash				= true
SWEP.MeleeGesture			= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.MeleeMissSound			= ""
SWEP.MeleeHitSound			= "MW2Common.Melee.HitWorld"
SWEP.MeleeHitNPCSound		= "MW2Common.Melee.HitFleshy_Slice"

local wpnmodel = "models/weapons/arccw_go/v_rif_ak47.mdl"



local invis_mat = "Models/effects/vol_light001"
function SWEP:Hook_Think_2()
    if CLIENT and self.VM then
        for _, data in pairs(self.VM) do
            if data.Model:GetModel() == "models/weapons/arccw/fesiugmw2/akimbo/c_glock17_left_1.mdl" then
                --data.Model:SetSubMaterial(0, invis_mat)
                data.Model:SetMaterial(invis_mat)
            end
        end
        self.REAL_VM:SetSubMaterial(0, invis_mat)
    end
end

local vm_scale = .8
local vm_ang = Angle(0, 0, 0)
local Offset_pos = Vector(-12, -4, 3.96)
local reloadtime_mult = 1.4

SWEP.LeftHand_ReloadSound = {
    {s = "ARCCW_GO_AK47.Clipout", t = 0},--4/40
    {s = "ARCCW_GO_AK47.Clipin", 	    t = 36/40},
}
SWEP.LeftHand_ReloadSoundEmpty = {
    {s = "ARCCW_GO_AK47.Clipout", t = 0},
    {s = "ARCCW_GO_AK47.Clipin",  	t = 42/40},
    {s = "ARCCW_GO_AK47.Boltpull", 	t = 67/40},
}

for i, data in pairs(SWEP.LeftHand_ReloadSound) do
    data.t = data.t * reloadtime_mult
end

for i, data in pairs(SWEP.LeftHand_ReloadSoundEmpty) do
    data.t = data.t * reloadtime_mult
end

SWEP.Mult_ReloadTime = 5
SWEP.Primary.ClipSize = 30
SWEP.Recoil = 1
SWEP.RecoilSide = 0.6
SWEP.RecoilRise = 0.3
SWEP.Delay = 60 / 600 -- 60 / RPM
SWEP.AccuracyMOA = 15 / 2.5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 200 / 2.5 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 120
SWEP.Horde_MaxMags = 30
SWEP.Damage = 36
SWEP.DamageMin = 25
SWEP.Range = 100 -- in METRES
SWEP.ShootSound = "arccw_go/ak47/ak47_01.wav"
SWEP.ShootSoundSilenced = "arccw_go/m4a1/m4a1_silencer_01.wav"
SWEP.DistantShootSound = "arccw_go/ak47/ak47-1-distant.wav"

SWEP.Hook_SelectReloadAnimation = function(wep, anim)
    return anim .. "_akimbo_right"
end
SWEP.Hook_TranslateAnimation = function(wep, anim)
    return anim .. "_akimbo_right"
end

SWEP.Attachments = {
    {
        PrintName = "Optic",
        DefaultAttName = "Iron Sights",
        Slot = "optic_lp",
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(-0.8, -0.01, 1.9),
            vang = Angle(0, 0, 0),
        },
        ExcludeFlags = {"arcticfixyoshit1","cantuseshitinakimboyet"},
        InstalledEles = {"railthegrind"},
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(3.7, 0, 0.9),
            vang = Angle(0, 0, 0),
            wpos = Vector(26.648, 0.782, -8.042),
            wang = Angle(-9.79, 0, 180)
        },
		VMScale = Vector(0.67, 0.67, 0.67),
        ExcludeFlags = {"cantuseshitinakimboyet"},
    },
    {
        PrintName = "Underbarrel",
		Slot = {"foregrip_pistol", "style_pistol", "mw2_tacknife"},
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(1.5, 0, -0.5),
            vang = Angle(0, 0, 0),
            wpos = Vector(14.329, 0.602, -4.453),
            wang = Angle(-10.216, 0, 180)
        },
        MergeSlots = {8}, Integral = true,
    },
    {
        PrintName = "Tactical",
        Slot = "tac_pistol",
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(2.5, 0, 0),
            vang = Angle(0, 0, 0),
        },
    },
    {
        PrintName = "Fire Group",
        Slot = "fcg",
        DefaultAttName = "Standard FCG",
        ExcludeFlags = {"cantuseshitinakimboyet"},
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo"
    },
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
    {
        PrintName = "akimboslot_1",
		DefaultEles = {"akimboslot_1"},
        Integral = true,
    },
    {
        PrintName = "akimboslot_2",
		DefaultEles = {"akimboslot_2"},
        Integral = true,
    },
    {
        PrintName = "Akimbotest",
        DefaultAttName = "No LH",
        Slot = "akimbotest",
        Bone = "tag_view",
        Offset = {
            vpos = Vector(0, 0, 0),
            vang = Angle(0, 0, 0),
        },
        Hidden = true,
        Installed = "hordeext_akimbo_anywep",
        Integral = true,
    },
    --[[{
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(1, -0.45, 0.4),
            vang = Angle(0, 0, 0),
            wpos = Vector(8, 2.5, -4),
            wang = Angle(0, 0, 180)
        },
    },]]
}


SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 2/30
    },
    ["idle_empty"] = {
        Source = "idle_empty",
        Time = 2/30
    },
    ["enter_sprint"] = {
        Source = "sprint_in",
        Time = 10/30
    },
    ["idle_sprint"] = {
        Source = "sprint_loop",
        Time = 30/40
    },
    ["exit_sprint"] = {
        Source = "sprint_out",
        Time = 10/30
    },
    ["draw"] = {
        Source = "pullout",
        SoundTable = {{s = "MW2Common.Deploy", 		t = 0}},
        Time = 31/30 /4,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.35,
    },
    ["holster"] = {
        Source = "putaway",
        Time = 32/30 /4,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.35,
    },
    ["draw_empty"] = {
        Source = "pullout_empty",
        SoundTable = {{s = "MW2Common.Deploy", 		t = 0}},
        Time = 31/30 /4,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.35,
    },
    ["holster_empty"] = {
        Source = "putaway_empty",
        Time = 30/30 /4,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.35,
    },
    ["fire"] = {
        Source = "fire",
        Time = 9/30,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "fire_ads",
        Time = 13/30,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "lastfire",
        Time = 9/30,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "lastfire",
        Time = 9/30,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        Time = 51/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        SoundTable = {
						{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_lift_v1.wav", 	t = 0},
						{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_clipout_v1.wav", 	t = 9/24},
						{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_clipin_v1.wav", 	t = 27/24},
					},
        Checkpoints = {24, 97},
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.4,
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 60/30,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        SoundTable = {
						{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_lift_v1.wav", 	t = 0},
						{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_clipout_v1.wav", 	t = 9/24},
						{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_clipin_v1.wav", 	t = 27/24},
						{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_chamber_v1.wav", 	t = 36/24},
					},
        Checkpoints = {24, 97, 131},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.6,
    },
---------------------------------------------------------
--------- LE TACTICAL KNIFE XDXDXDXD---------------------
---------------------------------------------------------
		["idle_knife"] = {
			Source = "idle_knife",
			Time = 300/30
		},
		["idle_empty_knife"] = {
			Source = "idle_knife",
			Time = 300/30
		},
		["enter_sprint_knife"] = {
			Source = "sprint_in_knife",
			Time = 10/30
		},
		["idle_sprint_knife"] = {
			Source = "sprint_loop_knife",
			Time = 30/40
		},
		["exit_sprint_knife"] = {
			Source = "sprint_out_knife",
			Time = 10/30
		},
		["fire_knife"] = {
			Source = "fire_knife",
			Time = 8/30,
			ShellEjectAt = 0,
		},
		["fire_iron_knife"] = {
			Source = "fire_ads_knife",
			Time = 8/30,
			ShellEjectAt = 0,
		},
		["fire_empty_knife"] = {
			Source = "lastfire_knife",
			Time = 8/30,
			ShellEjectAt = 0,
		},
		["fire_iron_empty_knife"] = {
			Source = "lastfire_knife",
			Time = 8/30,
			ShellEjectAt = 0,
		},
		["draw_knife"] = {
			Source = "pullout_knife",
			SoundTable = {{s = "MW2Common.Deploy", 		t = 0}},
			Time = 29/30 /4,
			LHIK = true,
			LHIKIn = 0,
			LHIKOut = 0.35,
		},
		["holster_knife"] = {
			Source = "putaway_knife",
			Time = 31/30 /4,
			LHIK = true,
			LHIKIn = 0,
			LHIKOut = 0.35,
		},
		["draw_empty_knife"] = {
			Source = "pullout_knife",
			SoundTable = {{s = "MW2Common.Deploy", 		t = 0}},
			Time = 29/30 /4,
			LHIK = true,
			LHIKIn = 0,
			LHIKOut = 0.35,
		},
		["holster_empty_knife"] = {
			Source = "putaway_knife",
			Time = 31/30 /4,
			LHIK = true,
			LHIKIn = 0,
			LHIKOut = 0.35,
		},
		["reload_knife"] = {
			Source = "reload_knife",
			Time = 51/24,
			TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
			SoundTable = {
							{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_lift_v1.wav", 	t = 0},
							{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_clipout_v1.wav", 	t = 7/24},
							{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_clipin_v1.wav", 	t = 25/24},
						},
			Checkpoints = {24, 97},
			FrameRate = 30,
			LHIK = true,
			LHIKIn = 0.5,
			LHIKOut = 0.4,
		},
		["reload_empty_knife"] = {
			Source = "reload_empty_knife",
			Time = 46/24,
			TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
			SoundTable = {
							{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_lift_v1.wav", 	t = 0},
							{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_clipout_v1.wav", 	t = 6/24},
							{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_clipin_v1.wav", 	t = 25/24},
							{s = "weapons/fesiugmw2/foley/wpfoly_glock_reload_chamber_v1.wav", 	t = 37/24},
						},
			Checkpoints = {24, 97, 131},
			FrameRate = 37,
			LHIK = true,
			LHIKIn = 0.5,
			LHIKOut = 0.6,
		},
		["bash_knife"] = {
			Source = "melee_knife",
			SoundTable = {{s = "MW2Common.Melee.Swing", 		t = 0}},
			Time = 97/120 / 1.6, -- damn you universal
			LHIK = true,
		},

---------------------------------------------------------
--------- LE akimbo gun ---------------------
---------------------------------------------------------
    ["idle_akimbo_right"] = {
        Source = "idle_akimbo_right",
        Time = 2/30
    },
    ["idle_empty_akimbo_right"] = {
        Source = "idle_empty_akimbo_right",
        Time = 2/30
    },
    ["enter_sprint_akimbo_right"] = {
        Source = "sprint_in_akimbo_right",
        Time = 11/30
    },
    ["idle_sprint_akimbo_right"] = {
        Source = "sprint_loop_akimbo_right",
        Time = 31/40
    },
    ["exit_sprint_akimbo_right"] = {
        Source = "sprint_out_akimbo_right",
        Time = 11/30
    },
    ["draw_akimbo_right"] = {
        Source = "pullout_akimbo_right",
        SoundTable = {{s = "MW2Common.Deploy", 		t = 0}},
        Time = 26/30 /4,
    },
    ["holster_akimbo_right"] = {
        Source = "putaway_akimbo_right",
        Time = 26/30 /4,
    },
    ["fire_akimbo_right"] = {
        Source = "fire_akimbo_right",
        Time = 6/30,
        ShellEjectAt = 0,
    },
    ["fire_empty_akimbo_right"] = {
        Source = "fire_last_akimbo_right",
        Time = 6/30,
        ShellEjectAt = 0,
    },
    ["reload_akimbo_right"] = {
        Source = "reload_akimbo_right",
        Time = 70/40 * reloadtime_mult,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        SoundTable = SWEP.LeftHand_ReloadSound
    },
    ["reload_empty_akimbo_right"] = {
        Source = "reload_empty_akimbo_right",
        Time = 89/40 * reloadtime_mult,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        SoundTable = SWEP.LeftHand_ReloadSoundEmpty,
    },
}

function SWEP:DrawCustomModel(wm, origin, angle)
    if ArcCW.VM_OverDraw then return end
    local owner = self:GetOwner()
    local disttoeye = self:GetPos():DistToSqr(EyePos())
    local visibility = math.pow(GetConVar("arccw_visibility"):GetInt(), 2)
    local always = false
    if GetConVar("arccw_visibility"):GetInt() < 0 or self:GetOwner() == LocalPlayer() then
        always = true
    end
    local models = self.VM
    local vm

    if origin and !angle then
        angle = Angle()
    end
    local custompos = origin and angle
    if custompos then
        wm = true --VM drawing borked
    end

    -- self:KillModel(self.VM)
    -- self:KillModel(self.WM)
    -- self.VM = nil
    -- self.WM = nil

    local vscale = 1

    if wm then
        if !always and disttoeye >= visibility * 2 then return end

        if !self.WM then
            self:SetupModel(wm)
        end

        models = self.WM

        vm = owner

        if self.MirrorVMWM or !IsValid(owner) then
            vm = self.WMModel or self
        end

        if self.WorldModelOffset then
            vscale = self.WorldModelOffset.scale or 1
        end

        if !vm or !IsValid(vm) then return end
    else
        if !self.VM then
            self:SetupModel(wm)
        end

        vm = self.REAL_VM

        if !vm or !IsValid(vm) then return end

        models = self.VM

        -- if self.HSPElement then
        --     self.HSPElement.Model:DrawModel()
        -- end
    end

    thatmodel = NULL
    
    models = table.Copy(models)

    local my_models = {}
    local my_models2 = {}

    for i, k in pairs(models) do
        if k.Model:GetModel() == wpnmodel or k.DrawFunc then
            table.insert(my_models, k)
        else
            table.insert(my_models2, k)
        end
    end
    for i, k in pairs(my_models) do
        table.insert(my_models2, k)
    end

    --table.Reverse(table.Merge(models, {thatmodel}))
    for i, k in pairs(my_models2) do
        if !IsValid(k.Model) then
            self:SetupModel(wm)
            return
        end

        -- local asight = self:GetActiveSights()

        -- if asight then
        --     local activeslot = asight.Slot
        --     if k.Slot == activeslot and ArcCW.Overdraw then
        --         continue
        --     end
        -- end

        if k.IsBaseVM and !custompos then
            k.Model:SetParent(self.REAL_VM)
            vm = self
            selfmode = true
            basewm = true
        elseif k.IsBaseWM then
            if IsValid(owner) and !custompos then
                local wmo = self.WorldModelOffset
                if !wmo then
                    wmo = {pos = Vector(0, 0, 0), ang = Angle(0, 0, 0)}
                end
                k.Model:SetParent(owner)
                vm = owner
                k.OffsetAng = wmo.ang
                k.OffsetPos = wmo.pos
            else
                k.Model:SetParent(self)
                vm = self
                selfmode = true
                basewm = true
                k.OffsetAng = Angle(0, 0, 0)
                k.OffsetPos = Vector(0, 0, 0)
            end
        elseif wm and self:ShouldCheapWorldModel() then
            continue
        else
            if wm and self.MirrorVMWM then
                vm = self.WMModel or self
                -- vm = self
            end

            if wm and !always and disttoeye >= visibility then
                continue
            end
        end

        if k.BoneMerge and !k.NoDraw then
            k.Model:DrawModel()
            continue
        end

        local bonename = k.Bone

        if wm then
            bonename = k.WMBone or "ValveBiped.Bip01_R_Hand"
        end

        local bpos, bang
        local offset = k.OffsetPos

        if k.IsBaseWM and !IsValid(self:GetOwner()) then
            bpos = self:GetPos()
            bang = self:GetAngles()
        elseif bonename then
            local boneindex = vm:LookupBone(bonename)

            if !boneindex then continue end

            if wm then
                bpos, bang = vm:GetBonePosition(boneindex)
            else
                local bonemat = vm:GetBoneMatrix(boneindex)

                if bonemat then
                    bpos = bonemat:GetTranslation()
                    bang = bonemat:GetAngles()
                end
            end

            if custompos and (!self.MirrorVMWM or (self.MirrorVMWM and k.Model:GetModel() == self.ViewModel) ) then
                bpos = origin
                bang = angle
            end

            if k.Slot then

                local attslot = self.Attachments[k.Slot]

                local delta = attslot.SlidePos or 0.5

                local vmelemod = nil
                local wmelemod = nil
                local slidemod = nil

                for _, e in pairs(self:GetActiveElements(true)) do
                    local ele = self.AttachmentElements[e]

                    if !ele then continue end

                    if ((ele.AttPosMods or {})[k.Slot] or {}).vpos then
                        vmelemod = ele.AttPosMods[k.Slot].vpos
                        if self.MirrorVMWM then
                            wmelemod = ele.AttPosMods[k.Slot].vpos
                        end
                    end

                    if !self.MirrorVMWM then
                        if ((ele.AttPosMods or {})[k.Slot] or {}).wpos then
                            wmelemod = ele.AttPosMods[k.Slot].wpos
                        end
                    end

                    if ((ele.AttPosMods or {})[k.Slot] or {}).slide then
                        slidemod = ele.AttPosMods[k.Slot].slide
                    end

                    -- Why the fuck is it called 'slide'. Call it fucking SlideAmount like it is
                    -- in the fucking attachment slot you fucking cockfuck shitdick
                    if ((ele.AttPosMods or {})[k.Slot] or {}).SlideAmount then
                        slidemod = ele.AttPosMods[k.Slot].SlideAmount
                    end
                end

                if wm and !self.MirrorVMWM then
                    offset = wmelemod or (attslot.Offset or {}).wpos or Vector(0, 0, 0)

                    if attslot.SlideAmount then
                        offset = LerpVector(delta, (slidemod or attslot.SlideAmount).wmin or Vector(0, 0, 0), (slidemod or attslot.SlideAmount).wmax or Vector(0, 0, 0))
                    end
                else
                    offset = vmelemod or (attslot.Offset or {}).vpos or Vector(0, 0, 0)

                    if attslot.SlideAmount then
                        offset = LerpVector(delta, (slidemod or attslot.SlideAmount).vmin or Vector(0, 0, 0), (slidemod or attslot.SlideAmount).vmax or Vector(0, 0, 0))
                    end

                    attslot.VMOffsetPos = offset
                end

            end

        end

        local apos, aang

        if k.CharmParent and IsValid(k.CharmParent.Model) then
            local cm = k.CharmParent.Model
            local boneindex = cm:LookupAttachment(k.CharmAtt)
            local angpos = cm:GetAttachment(boneindex)
            if angpos then
                apos, aang = angpos.Pos, angpos.Ang

                local pos = k.CharmOffset
                local ang = k.CharmAngle
                local scale = k.CharmScale or Vector(1, 1, 1)

                apos = apos + aang:Forward() * pos.x * scale.x
                apos = apos + aang:Right() * pos.y * scale.y
                apos = apos + aang:Up() * pos.z * scale.z

                aang:RotateAroundAxis(aang:Right(), ang.p)
                aang:RotateAroundAxis(aang:Up(), ang.y)
                aang:RotateAroundAxis(aang:Forward(), ang.r)
            end
        elseif bang and bpos then

            local pos = offset or Vector(0, 0, 0)
            local ang = k.OffsetAng or Angle(0, 0, 0)

            pos = pos * vscale

            local moffset = (k.ModelOffset or Vector(0, 0, 0))

            apos = bpos + bang:Forward() * pos.x
            apos = apos + bang:Right() * pos.y
            apos = apos + bang:Up() * pos.z

            aang = Angle()
            aang:Set(bang)

            aang:RotateAroundAxis(aang:Right(), ang.p)
            aang:RotateAroundAxis(aang:Up(), ang.y)
            aang:RotateAroundAxis(aang:Forward(), ang.r)

            apos = apos + aang:Forward() * moffset.x
            apos = apos + aang:Right() * moffset.y
            apos = apos + aang:Up() * moffset.z
        else
            continue
        end

        if !apos or !aang then return end

        k.Model:SetPos(apos)
        k.Model:SetAngles(aang)
        k.Model:SetRenderOrigin(apos)
        k.Model:SetRenderAngles(aang)

        if k.Bodygroups then
            k.Model:SetBodyGroups(k.Bodygroups)
        end

        if k.DrawFunc then
            k.DrawFunc(self, k, wm)
        end

        if !k.NoDraw then
            k.Model:DrawModel()
        end

        -- FIXME: activeslot is nil?
        if i != activeslot and ArcCW.Overdraw then
            k.Model:SetBodygroup(1, 0)
        end
    end

    if wm then
        self:DrawFlashlightsWM()
        -- self:KillFlashlightsVM()
    else
        self:DrawFlashlightsVM()
    end

    -- self:RefreshBGs()
end

SWEP.AttachmentElements = {
    ["akimboslot_1"] = {
        AkimboSlot = 1,
        IsBaseVM = true,
        VMElements = {
            {
                Model = wpnmodel,
                IsBaseVM = true,
                Bone = "tag_weapon",
                Scale = Vector(vm_scale, vm_scale, vm_scale),
                Offset = {
                    pos = Offset_pos,
                    ang = vm_ang,
                }
            }
        },
    },
    ["akimboslot_2"] = {
        IsBaseVM = true,
        VMElements = {
            {
                Model = wpnmodel,
                Bone = "tag_weapon",
                IsBaseVM = true,
                --BoneMerge = true,
                DrawFunc = function(self, k, wm)
                    if wm then
                        k.NoDraw = true
                        return
                    end
                    k.NoDraw = false
                    local vm = self.REAL_VM
                    local newparent = vm
                    for _, data in pairs(self.Attachments) do
                        if data.PrintName == "Akimbotest" then
                            if data.VElement then
                                newparent = data.VElement.Model
                            end
                            break
                        end
                    end

                    local bonename = k.Bone
            
                    if wm then
                        bonename = k.WMBone or "ValveBiped.Bip01_R_Hand"
                    end

                    local bpos, bang
                    local offset = k.OffsetPos

                    if k.IsBaseWM and !IsValid(self:GetOwner()) then
                        bpos = self:GetPos()
                        bang = self:GetAngles()
                    elseif bonename then
                        local boneindex = newparent:LookupBone(bonename)

                        if !boneindex then return end

                        if wm then
                            bpos, bang = newparent:GetBonePosition(boneindex)
                        else
                            local bonemat = newparent:GetBoneMatrix(boneindex)

                            if bonemat then
                                bpos = bonemat:GetTranslation()
                                bang = bonemat:GetAngles()
                            end
                        end

                        if custompos and (!self.MirrorVMWM or (self.MirrorVMWM and k.Model:GetModel() == self.ViewModel) ) then
                            bpos = origin
                            bang = angle
                        end

                        if k.Slot then

                            local attslot = self.Attachments[k.Slot]

                            local delta = attslot.SlidePos or 0.5

                            local vmelemod = nil
                            local wmelemod = nil
                            local slidemod = nil

                            for _, e in pairs(self:GetActiveElements(true)) do
                                local ele = self.AttachmentElements[e]

                                if !ele then continue end

                                if ((ele.AttPosMods or {})[k.Slot] or {}).vpos then
                                    vmelemod = ele.AttPosMods[k.Slot].vpos
                                    if self.MirrorVMWM then
                                        wmelemod = ele.AttPosMods[k.Slot].vpos
                                    end
                                end

                                if !self.MirrorVMWM then
                                    if ((ele.AttPosMods or {})[k.Slot] or {}).wpos then
                                        wmelemod = ele.AttPosMods[k.Slot].wpos
                                    end
                                end

                                if ((ele.AttPosMods or {})[k.Slot] or {}).slide then
                                    slidemod = ele.AttPosMods[k.Slot].slide
                                end

                                -- Why the fuck is it called 'slide'. Call it fucking SlideAmount like it is
                                -- in the fucking attachment slot you fucking cockfuck shitdick
                                if ((ele.AttPosMods or {})[k.Slot] or {}).SlideAmount then
                                    slidemod = ele.AttPosMods[k.Slot].SlideAmount
                                end
                            end

                            if wm and !self.MirrorVMWM then
                                offset = wmelemod or (attslot.Offset or {}).wpos or Vector(0, 0, 0)

                                if attslot.SlideAmount then
                                    offset = LerpVector(delta, (slidemod or attslot.SlideAmount).wmin or Vector(0, 0, 0), (slidemod or attslot.SlideAmount).wmax or Vector(0, 0, 0))
                                end
                            else
                                offset = vmelemod or (attslot.Offset or {}).vpos or Vector(0, 0, 0)

                                if attslot.SlideAmount then
                                    offset = LerpVector(delta, (slidemod or attslot.SlideAmount).vmin or Vector(0, 0, 0), (slidemod or attslot.SlideAmount).vmax or Vector(0, 0, 0))
                                end

                                attslot.VMOffsetPos = offset
                            end

                        end

                    end

                    local apos, aang
                    local vscale = 1
                    if wm and self.WorldModelOffset then
                        vscale = self.WorldModelOffset.scale or vscale
                    end

                    if k.CharmParent and IsValid(k.CharmParent.Model) then
                        local cm = k.CharmParent.Model
                        local boneindex = cm:LookupAttachment(k.CharmAtt)
                        local angpos = cm:GetAttachment(boneindex)
                        if angpos then
                            apos, aang = angpos.Pos, angpos.Ang

                            local pos = k.CharmOffset
                            local ang = k.CharmAngle
                            local scale = k.CharmScale or Vector(1, 1, 1)

                            apos = apos + aang:Forward() * pos.x * scale.x
                            apos = apos + aang:Right() * pos.y * scale.y
                            apos = apos + aang:Up() * pos.z * scale.z

                            aang:RotateAroundAxis(aang:Right(), ang.p)
                            aang:RotateAroundAxis(aang:Up(), ang.y)
                            aang:RotateAroundAxis(aang:Forward(), ang.r)
                        end
                    elseif bang and bpos then

                        local pos = offset or Vector(0, 0, 0)
                        local ang = k.OffsetAng or Angle(0, 0, 0)

                        pos = pos * vscale

                        local moffset = (k.ModelOffset or Vector(0, 0, 0))

                        apos = bpos + bang:Forward() * pos.x
                        apos = apos + bang:Right() * pos.y
                        apos = apos + bang:Up() * pos.z

                        aang = Angle()
                        aang:Set(bang)

                        aang:RotateAroundAxis(aang:Right(), ang.p)
                        aang:RotateAroundAxis(aang:Up(), ang.y)
                        aang:RotateAroundAxis(aang:Forward(), ang.r)

                        apos = apos + aang:Forward() * moffset.x
                        apos = apos + aang:Right() * moffset.y
                        apos = apos + aang:Up() * moffset.z
                    end

                    k.Model:SetPos(apos)
                    k.Model:SetAngles(aang)
                    k.Model:SetRenderOrigin(apos)
                    k.Model:SetRenderAngles(aang)
                    k.Model:SetParent(newparent)
                end,
                Scale = Vector(vm_scale, vm_scale, vm_scale),
                Offset = {
                    pos = Offset_pos,
                    ang = -vm_ang,
                }
            }
        },
    },
}