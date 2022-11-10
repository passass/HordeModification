local path1 = "weapons/"
local pref1 = "TFA_DEATHBRINGER_FIRE"

TFA.AddWeaponSound(pref1 .. ".1", path1 .. "DeathbringerFire1.wav", false, ")")
TFA.AddWeaponSound("TFA_DEATHBRINGER_EXPLODE.1", path1 .. "DeathbringerExplode.wav", false, ")")
TFA.AddWeaponSound("TFA_DEATHBRINGER_RELOAD.1", path1 .. "DeathbringerReload.wav", false, ")")

local icol = Color( 255, 100, 0, 255 ) 
if CLIENT then
	killicon.Add(  "destiny_deathbringer",	"vgui/killicons/destiny_deathbringer", icol  )
end