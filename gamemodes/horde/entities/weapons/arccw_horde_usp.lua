SWEP.Base = "arccw_go_usp"

SWEP.Damage = 32
SWEP.DamageMin = 21
SWEP.Primary.Ammo = "pistol"


if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/" .. SWEP.Base .. ".vtf")
    killicon.Add("arccw_horde_usp", "arccw/weaponicons/" .. SWEP.Base, Color(0, 0, 0, 255))
end

SWEP.Attachments = {
    {
        PrintName = "Optic",
        Slot = "optic_lp",
        Bone = "v_weapon.223_parent",
        DefaultAttName = "Iron Sights",
        Offset = {
            vpos = Vector(-0.05, -3.8, 3),
            vang = Angle(90, 0, -90),
            wpos = Vector(22, 1, -7),
            wang = Angle(-9.79, 0, 180)
        },
        InstalledEles = {"rail"},
        CorrectiveAng = Angle(-1.35, 0, 0)
    },
    {
        PrintName = "Tactical",
        Slot = {"tac", "foregrip"},
        Bone = "v_weapon.223_parent",
        Offset = {
            vpos = Vector(-0.05, -1.75, 6),
            vang = Angle(90, 0, -90),
        },
        InstalledEles = {"tacms"},
    },
    {
        PrintName = "Slide",
        Slot = "go_usp_slide",
        DefaultAttName = "110mm USP Slide"
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "v_weapon.223_parent",
        Offset = {
            vpos = Vector(-0.05, -2.99, 7.35),
            vang = Angle(90, 0, -90),
        },
    },
    {
        PrintName = "Magazine",
        Slot = "go_usp_mag",
        DefaultAttName = "12-Round .45 USP"
    },
    {
        PrintName = "Stock",
        Slot = "go_stock_pistol_bt",
        DefaultAttName = "Standard Stock",
        Bone = "v_weapon.223_parent",
        Offset = {
            vpos = Vector(-0.05, -1.9, -1),
            vang = Angle(90, 0, -90),
        },
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo"
    },
    {
        PrintName = "Perk",
        Slot = {"go_perk", "go_perk_pistol"}
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "v_weapon.slide", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.5, -0.4, 1.5), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
        },
        VMScale = Vector(0.5, 0.5, 0.5)
    },
}

function SWEP:Hook_TranslateAnimation(anim)
    if anim == "fire_iron" then
        if !self.Attachments[6].Installed then return "fire" end
    elseif anim == "fire_iron_empty" then
        if !self.Attachments[6].Installed then return "fire_empty" end
    end
end

DEFINE_BASECLASS(SWEP.Base)

SWEP.WorldModel = BaseClass.WorldModel
SWEP.ViewModel = BaseClass.ViewModel