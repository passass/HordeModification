att.PrintName = "Gjallarhorn"
att.Description = "Gjallarhorn scope."

att.SortOrder = 2.5

att.Desc_Pros = {
}
att.Desc_Cons = {
}

att.AutoStats = true
att.Slot = "hordeext_gjallarhorn_scope"

att.Model = "models/weapons/arccw_go/atts/hamr.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 9, -1.56325),
        Ang = Angle(0, 0, 0),
        Magnification = 2,
        ScopeMagnification = 3,
        HolosightBone = "scope",
        HolosightData = {
            Holosight = true,
            HolosightMagnification = 2,
            HolosightReticle = Material("hud/scopes/hamr_go.png", "mips smooth"),
            HolosightNoFlare = true,
            HolosightSize = 12,
            HolosightBlackbox = true,
            Colorable = true,
            HolosightPiece = "models/weapons/arccw/atts/hamr_hsp.mdl"
        },
    },
}

att.Holosight = true
att.HolosightPiece = "models/weapons/arccw_go/atts/hamr_hsp.mdl"