local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then
       killicon.Add(  "tfa_at_as_val","vgui/hud/tfa_at_as_val", icol  )
	end
local path = "weapons/tfa_at_as_val/"
local pref = "TFA_AT_AS_VAL"



local addfiresound = function()

end

HORDE:Sound_AddFireSound(pref .. ".1", path .. "fpval.wav", false, ")")

HORDE:Sound_AddWeaponSound(pref .. ".Empty", path .. "emptyval.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Boltback", path .. "boltbackval.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Boltrelease", path .. "boltreleaseval.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Magout", path .. "clipoutval.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Magin", path .. "clipinval.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Firemode", path .. "fireval.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Slideforward", path .. "slideforwardval.wav")
