local path = "weapons/tfa_ins2/wf_mg25/"
local pref = "TFA_INS2.WF_MG25"
local hudcolor = Color(255, 80, 0, 191)

HORDE:Sound_AddSound(pref .. ".1", CHAN_AUTO, 1, 140, {95, 105}, {path .. "U100-1.wav", path .. "U100-2.wav", path .. "U100-3.wav"}, ")")

HORDE:Sound_AddSound(pref .. ".Shoulder", CHAN_ITEM, .7, 75, 100, path .. "m249_shoulder.wav", ")")
HORDE:Sound_AddSound(pref .. ".ArmMovement_01", CHAN_ITEM, .1, 75, 100, path .. "m249_armmovement_01.wav", "")
HORDE:Sound_AddSound(pref .. ".FetchMag", CHAN_ITEM, .3, 75, 100, path .. "m249_fetchmag.wav", ")")
HORDE:Sound_AddSound(pref .. ".BeltAlign", CHAN_ITEM, .3, 75, 100, path .. "m249_beltalign.wav", ")")
HORDE:Sound_AddSound(pref .. ".BeltJingle", CHAN_ITEM, .3, 75, 100, path .. "m249_bulletjingle.wav", ")")
HORDE:Sound_AddSound(pref .. ".CoverOpen", CHAN_ITEM, .3, 75, 100, path .. "m249_coveropen.wav", ")")
HORDE:Sound_AddSound(pref .. ".CoverClose", CHAN_ITEM, .4, 75, 100, path .. "m249_coverclose.wav", ")")
HORDE:Sound_AddSound(pref .. ".MagHit", CHAN_ITEM, 1, 75, 100, path .. "m249_maghit.wav", ")")
HORDE:Sound_AddSound(pref .. ".Magin", CHAN_ITEM, .3, 75, 100, path .. "m249_magin.wav", ")")
HORDE:Sound_AddSound(pref .. ".Magout", CHAN_ITEM, .3, 75, 100, path .. "m249_magout.wav", ")")
HORDE:Sound_AddSound(pref .. ".MagoutFull", CHAN_ITEM, .3, 75, 100, path .. "m249_magout_full.wav", ")")
HORDE:Sound_AddSound(pref .. ".ThrowAway", CHAN_ITEM, .5, 75, 100, path .. "m249_throwawayremaining.wav", ")")
HORDE:Sound_AddSound(pref .. ".Boltback", CHAN_ITEM, .3, 75, 100, path .. "m249_boltback.wav", ")")
HORDE:Sound_AddSound(pref .. ".Boltrelease", CHAN_ITEM, .3, 75, 100, path .. "m249_boltrelease.wav", ")")
HORDE:Sound_AddSound(pref .. ".Empty", CHAN_ITEM, .3, 75, 100, path .. "m249_empty.wav", ")")

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_kaclmg", "vgui/killicons/tfa_ins2_kaclmg", hudcolor)
end