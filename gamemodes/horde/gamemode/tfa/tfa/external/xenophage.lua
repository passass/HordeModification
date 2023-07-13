local path1 = "weapons/"
local pref1 = "TFA_XENOPHAGE_FIRE"

HORDE:Sound_AddWeaponSound(pref1 .. ".1", { path1 .. "XenophageFire1.wav", path1 .. "XenophageFire2.wav", path1 .. "XenophageFire3.wav", path1 .. "XenophageFire4.wav" }, ")")
HORDE:Sound_AddWeaponSound("TFA_XENOPHAGE_RELOAD.1", path1 .. "XenophageReload.wav", false, ")")
HORDE:Sound_AddWeaponSound("TFA_XENOPHAGE_IRONIN.1", path1 .. "XenophageIronIn.wav", false, ")")
HORDE:Sound_AddWeaponSound("TFA_XENOPHAGE_IRONOUT.1", path1 .. "XenophageIronOut.wav", false, ")")
HORDE:Sound_AddWeaponSound("TFA_XENOPHAGE_DRAW.1", path1 .. "XenophageDraw.wav", false, ")")

local icol = Color( 255, 100, 0, 255 ) 
if CLIENT then
	killicon.Add(  "destiny_xenophage",	"vgui/killicons/destiny_xenophage", icol  )
end