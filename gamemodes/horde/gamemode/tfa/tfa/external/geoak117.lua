local path = "/weapons/ak117/"
local pref = "AK117"

HORDE:Sound_AddFireSound(pref .. ".Fire", {path .. "ak47_01.wav"}, true, ")")
HORDE:Sound_AddFireSound(pref .. ".FireS", {path .. "aksupp.ogg"}, true, ")")

HORDE:Sound_AddWeaponSound(pref .. ".Empty", path .. "empty.wav")

HORDE:Sound_AddWeaponSound(pref .. ".Magout", path .. "magout.wav")
HORDE:Sound_AddWeaponSound(pref .. ".MagoutRattle", path .. "MagoutRattle.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Magrelease", path .. "magrelease.wav")

HORDE:Sound_AddWeaponSound(pref .. ".Magin", path .. "magin.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Rattle", path .. "Rattle.wav")

HORDE:Sound_AddWeaponSound(pref .. ".Boltback", path .. "boltback.wav")
HORDE:Sound_AddWeaponSound(pref .. ".Boltrelease", path .. "boltrelease.wav")

HORDE:Sound_AddWeaponSound(pref .. ".ROF", path .. "rof.wav")