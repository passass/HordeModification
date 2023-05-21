GADGET.PrintName = "Armored"
GADGET.Description =
[[Gives 50 armor every round.]]
GADGET.Icon = "items/gadgets/exoskeleton.png"
GADGET.Params = {}
GADGET.Hooks = {}

GADGET.Hooks.HordeWaveStart = function()
    for _, ply in pairs(player.GetAll()) do
        if ply:Horde_GetGadget() ~= "gadget_armored" or
        !ply:Alive()
        then continue end
        ply:SetArmor(math.min(ply:GetMaxArmor(), ply:Armor() + 50))
    end
end