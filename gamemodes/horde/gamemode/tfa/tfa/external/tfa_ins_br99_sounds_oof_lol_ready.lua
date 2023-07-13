local path = "weapons/tfa_ins2_br99/"
local pref = "Weapon_BR99"
local hudcolor = Color(255, 255, 255, 255)

HORDE:Sound_AddWeaponSound(pref .. ".Boltrelease", path .. "m16_boltrelease.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Boltback", path .. "m16_boltback.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Magrelease", path .. "m16_magrelease.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Empty", path .. "m16_empty.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Magout", path .. "m16_magout.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Magin", path .. "m16_magin.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Hit", path .. "m16_hit.wav")
HORDE:Sound_AddWeaponSound(pref .. ".ROF", path .. "m16_fireselect.wav")


if killicon and killicon.Add then
	killicon.Add("tfa_ins2_br99", "vgui/hud/tfa_ins2_br99", hudcolor)
end