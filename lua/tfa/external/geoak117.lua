local path = "/weapons/ak117/"
local pref = "AK117"

TFA.AddFireSound(pref .. ".Fire", {path .. "ak47_01.wav"}, true, ")")
TFA.AddFireSound(pref .. ".FireS", {path .. "aksupp.ogg"}, true, ")")

TFA.AddWeaponSound(pref .. ".Empty", path .. "empty.wav")

TFA.AddWeaponSound(pref .. ".Magout", path .. "magout.wav")
TFA.AddWeaponSound(pref .. ".MagoutRattle", path .. "MagoutRattle.wav")
TFA.AddWeaponSound(pref .. ".Magrelease", path .. "magrelease.wav")

TFA.AddWeaponSound(pref .. ".Magin", path .. "magin.wav")
TFA.AddWeaponSound(pref .. ".Rattle", path .. "Rattle.wav")

TFA.AddWeaponSound(pref .. ".Boltback", path .. "boltback.wav")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "boltrelease.wav")

TFA.AddWeaponSound(pref .. ".ROF", path .. "rof.wav")