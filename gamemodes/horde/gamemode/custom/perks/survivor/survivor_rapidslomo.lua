PERK.PrintName = "Rapid Fire"
PERK.Description = [[makes rapid fire in slomo like in real time
greatly reduces recoil in slomo.]]
PERK.Icon = "perks/rapidfire.png"

PERK.Hooks = {}

PERK.Hooks.SlowMotion_RPMBonus_Allow = function(ply)
	return true
end

PERK.Hooks.SlowMotion_RPMBonus_Bonus = function(ply)
	return 2
end

PERK.Hooks.SlowMotion_Hook = function(ply, slow_motion_stage, slomo_bonus)
	if slow_motion_stage == 1.0 then
		HORDE:Modifier_AddToWeapons(ply, "Mult_Recoil", "survivor_rapidslomo")
		return
	end
	HORDE:Modifier_AddToWeapons(ply, "Mult_Recoil", "survivor_rapidslomo", 1 / Lerp((1 - slow_motion_stage) * 1.5, 1, 10000))
end
