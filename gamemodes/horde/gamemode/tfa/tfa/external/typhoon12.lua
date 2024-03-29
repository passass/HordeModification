local path, pref

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_typhoon12", "vgui/killicons/tfa_ins2_typhoon12", color_white)
end

-- Typhoon F12
path = "weapons/tfa_ins2/typhoon12/"
pref = "TFA_INS2.WF_SHG53."

HORDE:Sound_AddFireSound(pref .. "1", {path .. "shg53_fire_fp_11.wav", path .. "shg53_fire_fp_12.wav", path .. "shg53_fire_fp_13.wav"}, false, ")")
HORDE:Sound_AddFireSound(pref .. "2", {path .. "shg53_fire_fp_silencer_01.wav", path .. "shg53_fire_fp_silencer_02.wav", path .. "shg53_fire_fp_silencer_03.wav"}, false, ")")

HORDE:Sound_AddWeaponSound(pref .. "WpnUp", path .. "shg53_reload_01_01_wpnup.wav")
HORDE:Sound_AddWeaponSound(pref .. "ClipOut", path .. "shg53_reload_01_02_clipout.wav")
HORDE:Sound_AddWeaponSound(pref .. "ClipIn", path .. "shg53_reload_01_03_clipin.wav")
HORDE:Sound_AddWeaponSound(pref .. "BoltBack", path .. "shg53_reload_01_04_cockbck.wav")
HORDE:Sound_AddWeaponSound(pref .. "BoltForward", path .. "shg53_reload_01_05_cockfwd.wav")

HORDE:Sound_AddWeaponSound(pref .. "WpnUp2", path .. "shg53_reload_02_01_wpnup.wav")
HORDE:Sound_AddWeaponSound(pref .. "ClipOut2", path .. "shg53_reload_02_02_clipout.wav")
HORDE:Sound_AddWeaponSound(pref .. "ClipMove", path .. "shg53_reload_02_03_clipmove.wav")
HORDE:Sound_AddWeaponSound(pref .. "ClipIn2", path .. "shg53_reload_02_04_clipin.wav")
HORDE:Sound_AddWeaponSound(pref .. "BoltBack2", path .. "shg53_reload_02_05_cockbck.wav")
HORDE:Sound_AddWeaponSound(pref .. "BoltForward2", path .. "shg53_reload_02_06_cockfwd.wav")

HORDE:Sound_AddWeaponSound(pref .. "Empty", path .. "m4a1_empty.wav")
