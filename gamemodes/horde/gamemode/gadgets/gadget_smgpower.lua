GADGET.PrintName = "SMG Power"
GADGET.Description = "25% SMG damage."
GADGET.Icon = "items/gadgets/smg_power.png"
GADGET.Duration = 0
GADGET.Cooldown = 0
GADGET.Params = {
    [1] = {value = 0.25, percent = true},
}
GADGET.Hooks = {}

GADGET.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if ply:Horde_GetGadget() ~= "gadget_smgpower" then return end
    local inflictor = dmginfo:GetInflictor()
    if IsValid(inflictor) and inflictor:IsWeapon() then
        local item = HORDE.items[inflictor:GetClass()]
        if item and item.category == "SMG" then
            bonus.increase = bonus.increase + 0.25
        end 
    end
end
