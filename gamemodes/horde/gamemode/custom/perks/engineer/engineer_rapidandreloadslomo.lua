PERK.PrintName = "Sleight of Hand"
PERK.Description = [[makes rapid fire in slomo like in real time and reload speed.]]
PERK.Icon = "perks/rapidfire.png"

PERK.Hooks = {}

PERK.Hooks.SlowMotion_RPMBonus_Allow = function(ply)
	return true
end

PERK.Hooks.SlowMotion_ReloadBonus_Allow = PERK.Hooks.SlowMotion_RPMBonus_Allow
