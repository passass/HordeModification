PERK.PrintName = "Speedy"
PERK.Description = "Your healing is faster by {1}."
PERK.Icon = "materials/perks/speedy.png"
PERK.Params = {
    [1] = {value = 0.2, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()

    if healer:IsPlayer() and !healinfo:IsImmediately() and healer:Horde_GetPerk("medic_speedy") then
        healinfo:SetDelay(healinfo:GetDelay() / 1.2)
    end
end
