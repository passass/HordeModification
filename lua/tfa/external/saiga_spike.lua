local path, pref

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_saiga_spike", "vgui/killicons/tfa_ins2_saiga_spike", color_white)
end

-- Saiga Spike
path = "weapons/tfa_ins2/saiga_spike/"
pref = "TFA_INS2.WF_SHG46."

TFA.AddFireSound(pref .. "1", {path .. "shg46_fire_fp_01.wav", path .. "shg46_fire_fp_02.wav", path .. "shg46_fire_fp_03.wav"}, false, ")")
TFA.AddFireSound(pref .. "2", {path .. "shg46_fp_fire_silencer_07.wav", path .. "shg46_fp_fire_silencer_08.wav", path .. "shg46_fp_fire_silencer_09.wav"}, false, ")")

TFA.AddWeaponSound(pref .. "WpnUp", path .. "shg46_reload_fp_01_wpnup.wav")
TFA.AddWeaponSound(pref .. "ClipOut", path .. "shg46_reload_fp_02_clipout.wav")
TFA.AddWeaponSound(pref .. "ClipIn", path .. "shg46_reload_fp_03_clipin.wav")
TFA.AddWeaponSound(pref .. "BoltBack", path .. "shg46_reload_fp_04_cockback.wav")
TFA.AddWeaponSound(pref .. "BoltForward", path .. "shg46_reload_fp_05_cockfwd.wav")

TFA.AddWeaponSound(pref .. "Empty", path .. "ak74_empty.wav")
