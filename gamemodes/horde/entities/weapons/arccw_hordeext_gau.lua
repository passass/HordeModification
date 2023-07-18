if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/arccw_horde_gau")
    SWEP.DrawWeaponInfoBox	= false
    SWEP.BounceWeaponIcon = false
    killicon.Add("arccw_hordeext_gau", "vgui/hud/arccw_horde_gau", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_gau"

SWEP.Damage = 45
SWEP.DamageMin = 38
SWEP.Horde_TotalMaxAmmoMult = 1.5

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
        Time = 30/30,
    },
    ["reload"] = {
        Source = "reload",
        Time = 113/24,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
						{s = "horde/weapons/gau/reload.wav", 		t = 0},
					},
    },
    ["spin"] = {
        Source = "shoot1",
        Mult = 3,
    },
}


function SWEP:Rev()
	if self.lastRev > CurTime() then return end
    self.revving = true
    self:PlayAnimation("spin")

    self.lastRev = CurTime() + 0.05
    timer.Simple(0.05, function ()
        self.revved = true
        self.revving = nil
    end)
end

function SWEP:Spin()
	if self.lastRev > CurTime() then return end
    self:PlayAnimation("spin")
    self.lastRev = CurTime() + 0.05
end