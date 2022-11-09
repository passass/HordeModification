local path = "weapons/tfa_ins2_g28/"
local pref = "TFA_INS2_G28"
local hudcolor = Color(255, 255, 255, 255)

TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "g28_boltrelease.wav")
TFA.AddWeaponSound(pref .. ".Magout", path .. "g28_magout.wav")
TFA.AddWeaponSound(pref .. ".Magin", path .. "g28_magin.wav")
TFA.AddWeaponSound(pref .. ".Hit", path .. "g28_hit.wav")

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_g28", "vgui/hud/tfa_ins2_g28", hudcolor)
end