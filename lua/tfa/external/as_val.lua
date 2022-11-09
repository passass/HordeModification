local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then
       killicon.Add(  "tfa_at_as_val","vgui/hud/tfa_at_as_val", icol  )
	end
local path = "weapons/tfa_at_as_val/"
local pref = "TFA_AT_AS_VAL"

TFA.AddFireSound(pref .. ".1", path .. "fpval.wav", false, ")")

TFA.AddWeaponSound(pref .. ".Empty", path .. "emptyval.wav")
TFA.AddWeaponSound(pref .. ".Boltback", path .. "boltbackval.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "boltreleaseval.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "clipoutval.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "clipinval.wav")
TFA.AddWeaponSound(pref .. ".Firemode", path .. "fireval.wav")
TFA.AddWeaponSound(pref .. ".Slideforward", path .. "slideforwardval.wav")
