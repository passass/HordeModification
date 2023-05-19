local path1 = "weapons/"
local pref1 = "TFA_GHORN_FIRE"

TFA.AddWeaponSound(pref1 .. ".1", path1 .. "gjallyfire.wav", false, ")")
TFA.AddWeaponSound("TFA_GHORN_RELOAD.1", path1 .. "gjallyreload.wav", false, ")")

local icol = Color( 255, 100, 0, 255 ) 
if CLIENT then
	killicon.Add(  "destiny_gjallarhorn",	"vgui/killicons/destiny_gjallarhorn", icol  )
	killicon.Add(  "destiny_ghorn_rocket",	"vgui/killicons/destiny_gjallarhorn", icol  )
	killicon.Add(  "destiny_ghorn_wolfpack",	"vgui/killicons/destiny_gjallarhorn", icol  )
end

game.AddParticles("particles/destiny_ghorn_fx.pcf")
PrecacheParticleSystem("destiny_ghorn_muzzle")