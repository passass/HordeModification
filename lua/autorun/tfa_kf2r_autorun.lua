--[[ AUTHORS ]]
// 	TFA KF2 Remake by JFA aka Alex35ru
// 	Original TFA KF2 addon by TheForgottenArchitect and Designated Kitty
//	Models/Animations:	Tripwire Interactive
// 	Sounds: 			Trappa Keepa / MagmaCow / KenBoy / Valve / Navaro / Vunsunta / Tripwire Interactive
//	Particles: 			Matsilagi / Zool / NMRiH Std.

--[[ FONTS ]]
resource.AddFile("resource/fonts/holo.ttf")
resource.AddFile("resource/fonts/holo_b.ttf")
if CLIENT then
surface.CreateFont('sight_holo',{font='Transponder AOE',size=100,antialias=true})
surface.CreateFont('sight_holo_b',{font='Transponder Grid AOE',size=100,antialias=true})
surface.CreateFont('sight_holo_r',{font='Transponder AOE',size=60,antialias=true})
surface.CreateFont('sight_holo_rb',{font='Transponder Grid AOE',size=60,antialias=true})
end

--[[ PARTICLES ]]
game.AddParticles("particles/matsilagi_muzzle_kf.pcf")
game.AddParticles("particles/kf2_flamethrower2.pcf")
game.AddParticles("particles/ef_flamer.pcf")

--[[ KILLICONS ]]
local ic =  Color( 255, 255, 255, 255 )
if CLIENT then
	killicon.Add("tfa_kf2r_9mm", "vgui/hud/tfa_kf2_9mm.vtf", ic)
	killicon.Add("tfa_kf2r_aa12", "vgui/hud/tfa_kf2_aa12.vtf", ic)
	killicon.Add("tfa_kf2r_ak12", "vgui/hud/tfa_kf2_ak12.vtf", ic)
	killicon.Add("tfa_kf2r_ar15", "vgui/hud/tfa_kf2_ar15.vtf", ic)
	killicon.Add("tfa_kf2r_double_barrel", "vgui/hud/tfa_kf2_doublebarrel.vtf", ic)
	killicon.Add("tfa_kf2r_flamethrower", "vgui/hud/tfa_kf2_flamethrower.vtf", ic)
	killicon.Add("tfa_kf2r_l85a2", "vgui/hud/tfa_kf2_l85a2.vtf", ic)
	killicon.Add("tfa_kf2r_m4", "vgui/hud/tfa_kf2_m4.vtf", ic)
	killicon.Add("tfa_kf2r_mb500", "vgui/hud/tfa_kf2_mb500.vtf", ic)
	killicon.Add("tfa_kf2r_medic_assault", "vgui/hud/tfa_kf2_medicassault.vtf", ic)
	killicon.Add("tfa_kf2r_medic_pistol", "vgui/hud/tfa_kf2_medicpist.vtf", ic)
	killicon.Add("tfa_kf2r_medic_shotgun", "vgui/hud/tfa_kf2_medicshotgun.vtf", ic)
	killicon.Add("tfa_kf2r_medic_smg", "vgui/hud/tfa_kf2_medicsmg.vtf", ic)
	killicon.Add("tfa_kf2r_scar", "vgui/hud/tfa_kf2_scar.vtf", ic)	
	killicon.Add("tfa_kf2r_deagle", "vgui/hud/tfa_kf2_deagle.vtf", ic)	
end

--[[ SOUNDS ]]
if CLIENT then
// 9MM
sound.Add({
	name = 			"TFA_KF2_9MM.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/9mm/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_9MM.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/9mm/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_9MM.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/9mm/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_9MM.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/9mm/9mm-magout.wav"
})
sound.Add({
	name = 			"TFA_KF2_9MM.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/9mm/9mm-magin.wav"
})
sound.Add({
	name = 			"TFA_KF2_9MM.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/9mm/9mm-boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_9MM.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/9mm/9mm-boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_9MM.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/9mm/9mm-equip.wav"
})

// AA12
sound.Add({
	name = 			"TFA_KF2_AA12.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/aa12/aa12_fire.wav"
})
sound.Add({
	name = 			"TFA_KF2_AA12.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/aa12/aa12_clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_AA12.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/aa12/aa12_clipin.wav"
})
sound.Add({
	name = 			"TFA_KF2_AA12.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/aa12/aa12_boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_AA12.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/aa12/aa12_boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_AA12.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/aa12/aa12_equip.wav"
})

// AK12
sound.Add({
	name = 			"TFA_KF2_AK12.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/ak12/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_AK12.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/ak12/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_AK12.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/ak12/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_AK12.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ak12/ak12_clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_AK12.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ak12/ak12_clipin.wav"
})
sound.Add({
	name = 			"TFA_KF2_AK12.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ak12/ak12_boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_AK12.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ak12/ak12_boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_AK12.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ak12/ak12_equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_AK12.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ak12/ak12_equip.wav"
})

// AR15
sound.Add({
	name = 			"TFA_KF2_AR15.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/ar15/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/ar15/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/ar15/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ar15/clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.MagRelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ar15/magrelease.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ar15/clipin.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.ClipSlide",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ar15/clipslide.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ar15/boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ar15/boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ar15/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_AR15.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/ar15/equip.wav"
})

// DOUBLE BARREL
sound.Add({
	name = 			"TFA_KF2_DB.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/doublebarrel/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_DB.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/doublebarrel/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_DB.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/doublebarrel/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_DB.Open",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/doublebarrel/open.wav"
})
sound.Add({
	name = 			"TFA_KF2_DB.Close",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/doublebarrel/close.wav"
})
sound.Add({
	name = 			"TFA_KF2_DB.Insert",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/doublebarrel/insert.wav"
})
sound.Add({
	name = 			"TFA_KF2_DB.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/doublebarrel/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_DB.Cloth",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/doublebarrel/cloth1.wav"
})
sound.Add({
	name = 			"TFA_KF2_DB.Cloth2",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/doublebarrel/cloth2.wav"
})

// FLAMETHROWER
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/flamethrower/clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/flamethrower/trapper/NapalmCannonIn.wav"
})
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/flamethrower/trapper/FlameOut.wav"
})
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/flamethrower/trapper/FlameIn.wav"
})
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.Start",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1,
	sound = 			"weapons/kf2/flamethrower/trapper/FlamerStart.wav"
})
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.Loop",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1,
	sound = 			"weapons/kf2/flamethrower/trapper/FlamerLoop.wav"
})
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.End",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1,
	sound = 			"weapons/kf2/flamethrower/trapper/FlamerStop.wav"
})
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/flamethrower/boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_FLAMETHROWER.Holster",
	channel = 		CHAN_USER_BASE+10,
	volume = 		0.9,
	sound = 			"weapons/kf2/flamethrower/boltback.wav"
})

// L85A2
sound.Add({
	name = 			"TFA_KF2_L85A2.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/l85a2/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/l85a2/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/l85a2/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/l85a2/clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/l85a2/clipin.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.ClipSlide",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/l85a2/clipslide.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/l85a2/boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/l85a2/boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/l85a2/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_L85A2.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/l85a2/equip.wav"
})

// M4
sound.Add({
	name = 			"TFA_KF2_M4.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/m4/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/m4/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/m4/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.Open",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/m4/open.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.Insert",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/m4/insertshell.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/m4/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/m4/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.Cloth",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/m4/cloth1.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/m4/boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_M4.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/m4/boltforward.wav"
})

// MB500
sound.Add({
	name = 			"TFA_KF2_MB500.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/mb500/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_MB500.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/mb500/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_MB500.Insert",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/mb500/insertshell.wav"
})
sound.Add({
	name = 			"TFA_KF2_MB500.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/mb500/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_MB500.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/mb500/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_MB500.Cloth",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/mb500/cloth1.wav"
})
sound.Add({
	name = 			"TFA_KF2_MB500.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/mb500/boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_MB500.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/mb500/boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_MB500.ChanClear",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.5,
	sound = 			"weapons/kf2/mb500/chanclear.wav"
})

// MED ASSAULT
sound.Add({
	name = 			"TFA_KF2_MEDICAR.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicar/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicar/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicar/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicar/fire1-old1.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicar/clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.MagRelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicar/magrelease.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicar/clipin.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.ClipSlide",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicar/clipslide.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicar/boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicar/boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicar/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICAR.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicar/equip.wav"
})

// MED PISTOL
sound.Add({
	name = 			"TFA_KF2_MEDIPISTOL.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicpistol/medicpistol-1.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDIPISTOL.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicpistol/medicpistol-magout.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDIPISTOL.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicpistol/medicpistol-magin.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDIPISTOL.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicpistol/medicpistol-boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDIPISTOL.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicpistol/medicpistol-boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDIPISTOL.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicpistol/medicpistol-equip.wav"
})

// MED SHOTGUN
sound.Add({
	name = 			"TFA_KF2_MEDICSG.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicsg/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicsg/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicsg/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsg/clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsg/clipin.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.ClipSlide",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsg/clipslide.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsg/boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsg/boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsg/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSG.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsg/equip.wav"
})

// MED SMG
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicsmg/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicsmg/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicsmg/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.4",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/medicsmg/fire1-old1.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsmg/clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsmg/clipin.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.ClipSlide",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsmg/clipslide.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsmg/boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsmg/boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsmg/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_MEDICSMG.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/medicsmg/equip.wav"
})

// SCAR
sound.Add({
	name = 			"TFA_KF2_SCAR.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/scar/fire1.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.2",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/scar/fire2.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.3",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kf2/scar/fire3.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.ClipOut",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/scar/clipout.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.MagRelease",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/scar/magrelease.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.ClipIn",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/scar/clipin.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.ClipSlide",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/scar/clipslide.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.BoltBack",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/scar/boltback.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.BoltForward",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/scar/boltforward.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.Equip",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/scar/equip.wav"
})
sound.Add({
	name = 			"TFA_KF2_SCAR.Holster",
	channel = 		CHAN_USER_BASE+11,
	volume = 		0.9,
	sound = 			"weapons/kf2/scar/equip.wav"
})

end

// I HATE THIS GAME...
// AND GARRY TOO...