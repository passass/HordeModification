local hc = "handcannon/"

HORDE:Sound_AddWeaponSound("TFA_D2HC_CHAMBERCLOSE.1", hc .. "HCChamberClose.wav")
HORDE:Sound_AddWeaponSound("TFA_D2HC_CHAMBEROUT.1", hc .. "HCChamberOut.wav")
HORDE:Sound_AddWeaponSound("TFA_D2HC_CHAMBERSPIN.1", hc .. "HCChamberSpin.wav")
HORDE:Sound_AddWeaponSound("TFA_D2HC_MAGIN.1", hc .. "HCMagIn.wav")
HORDE:Sound_AddWeaponSound("TFA_D2HC_MAGOUT.1", hc .. "HCMagOut.wav")
HORDE:Sound_AddWeaponSound("TFA_D2HC_FIRE.1", { hc .. "HCFire1.wav", hc .. "HCFire2.wav", hc .. "HCFire3.wav" }, false, ")" )
HORDE:Sound_AddWeaponSound("TFA_D2HC_RELOADF.1", hc .. "HCReloadFast.wav")
HORDE:Sound_AddWeaponSound("TFA_D2HC_RELOADS.1", hc .. "HCReloadSlow.wav")

local shotg = "shotgun/"

HORDE:Sound_AddWeaponSound("TFA_D2SHOTGUN_RELOADSTART.1", shotg .. "D2ShotgunReloadStart.wav")
HORDE:Sound_AddWeaponSound("TFA_D2SHOTGUN_RELOADIN.1", shotg .. "D2ShotgunShell.wav")
//HORDE:Sound_AddWeaponSound("TFA_WASTELANDER_RELOADEND.1", shotg .. "D2ShotgunPump.wav")
//HORDE:Sound_AddWeaponSound("TFA_WASTELANDER_DRAW.1", shotg .. "Wastelanderdraw.wav")
HORDE:Sound_AddWeaponSound("TFA_D2SHOTGUN_PUMP.1", shotg .. "D2ShotgunPump2.wav")
HORDE:Sound_AddWeaponSound("TFA_D2SHOTGUN_PUMPFAST.1", shotg .. "D2ShotgunPump.wav")
HORDE:Sound_AddWeaponSound("TFA_D2SHOTGUN_FIRE.1", { shotg .. "D2ShotgunFire1.wav", shotg .. "D2ShotgunFire2.wav" }, false, ")" )

local sniper = "sniper/"
HORDE:Sound_AddWeaponSound("TFA_D2SNIPER_RELOAD.1", sniper .. "D2SniperReload.wav")
HORDE:Sound_AddWeaponSound("TFA_D2SNIPER_FIRE.1", { sniper .. "D2SniperFire1.wav", sniper .. "D2SniperFire2.wav" }, false, ")" )


HORDE:Sound_AddWeaponSound("TFA_D2_CLICK.1", "D2Click.wav")
HORDE:Sound_AddWeaponSound("TFA_D2_MOVEMENT.1", "D2ClothMovement.wav")

if CLIENT then
	surface.CreateFont( "TFA_D2_NORMAL", {
		font = "D2 Normal", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 28,
		weight = 0,
		antialias = true,
		italic = false
	} )
	surface.CreateFont( "TFA_D2_NORMAL_BOLD", {
		font = "NeueHaasGroteskText Pro Md", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		size = 55,
		weight = 10,
		antialias = true,
	} )
	surface.CreateFont( "TFA_COMMEM_AMMO", {
		font = "Name Smile", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 23,
		weight = 0,
		antialias = false,
		italic = false,
		scanlines = 0,
		blursize = 0
	} )
	surface.CreateFont( "TFA_D2_AMMO", {
		font = "Name Smile", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 23,
		weight = 0,
		antialias = false,
		italic = false,
		scanlines = 0,
		blursize = 0
	} )
end