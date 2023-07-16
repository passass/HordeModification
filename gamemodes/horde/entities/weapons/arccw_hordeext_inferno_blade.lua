if not ArcCWInstalled then return end

if CLIENT then
    killicon.Add("arccw_hordeext_inferno_blade", "vgui/hud/arccw_horde_inferno_blade", Color(0, 0, 0, 255))
end

SWEP.Base = "arccw_horde_inferno_blade"

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
    BaseClass.Initialize( self )

    if SERVER then
        if self.Charged then
            net.Start("Horde_DemonicEdgeCharge")
                net.WriteBool(true)
            net.Send(self.Owner)
        else
            net.Start("Horde_DemonicEdgeCharge")
                net.WriteBool(false)
            net.Send(self.Owner)
        end
    end
end