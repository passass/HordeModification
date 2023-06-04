-- sounds

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

--[[AMMO TYPES]]
TFA.AddAmmo("kf2r_pistol", "Pistol ammo")
TFA.AddAmmo("kf2r_rifle", "Rifle ammo")
TFA.AddAmmo("kf2r_shotgun", "Shotgun ammo")
TFA.AddAmmo("kf2r_flame", "Flamethrower fuel")

--

SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Killing Floor 2" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_kf2_ak12")
    killicon.Add("arccw_kf2_ak12", "arccw/weaponicons/arccw_kf2_ak12", Color(0, 0, 0, 255))
end
SWEP.PrintName = "AK12"
--[[SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = ".40 Caliber semi automatic pistol. Commonly used among police and popular with civilians for its reliability."
SWEP.Trivia_Manufacturer = "Auschen Waffenfabrik"
SWEP.Trivia_Calibre = ".40 S&W"
SWEP.Trivia_Mechanism = "Short Recoil"
SWEP.Trivia_Country = "Austria"
SWEP.Trivia_Year = 1993]]

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel			= "models/weapons/kf2/arccw_v_ak12.mdl"
SWEP.WorldModel			= "models/weapons/kf2/tfa_w_ak12.mdl"
SWEP.ViewModelFOV = 60

SWEP.ActivePos = Vector(4, 1, -.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.Damage = 75
SWEP.DamageMin = 65 -- damage done at maximum range
SWEP.Range = 70 -- in METRES
SWEP.Penetration = 8
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 400 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 45
SWEP.ReducedClipSize = 15

SWEP.Recoil = .535
SWEP.RecoilSide = .35
SWEP.RecoilRise = 1.8

SWEP.Delay = 60 / 480 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 3,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 500 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 300

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
local snd1 = Sound("TFA_KF2_AK12.1")
local snd2 = Sound("TFA_KF2_AK12.2")
local snd3 = Sound("TFA_KF2_AK12.3")
SWEP.ShootSound = {snd1, snd2, snd3}
SWEP.ShootSoundSilenced = "arccw_go/m4a1/m4a1_silencer_01.wav"

SWEP.MuzzleEffect = "muzzleflash_ak47"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5
SWEP.ShellRotateAngle = Angle(0, 180, 0)

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.3

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 18

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(0, 3, .95),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "smg"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.WorldModelOffset = {
    pos = Vector(9, 1, -5),
    ang = Angle( 0, 90, 190 ),
}

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic_lp", "optic"}, -- what kind of attachments can fit here, can be string or table
        Bone = "RW_Sight", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(1, 0, 0), -- offset that the attachment will be relative to the bone
                vang = Angle(0, 0, 0),
                wpos = Vector(13.5, 1.476, -7),
                wang = Angle(-10, 0, 180)
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "RW_ForeGrip",
        Offset = {
            vpos = Vector(3, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(17, 1, -4.5),
            wang = Angle(-11, 0, 0)
        },
        InstalledEles = {"sidemount"},
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "RW_Muzzle",
        Offset = {
            vpos = Vector(2.5, 0, 0),
            vang = Angle(0, 0, 0),
            wpos = Vector(28, 0, -8.125),
            wang = Angle(-10, 0, 0)
        },
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Stock",
        Slot = "stock",
        DefaultAttName = "Standard Stock"
    },
    {
        PrintName = "Fire Group",
        Slot = "fcg",
        DefaultAttName = "Standard FCG"
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo"
    },
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "v_weapon.USP_Slide", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-0.5, 0.1, -4), -- offset that the attachment will be relative to the bone
            vang = Angle(-90, 0, -90),
            wpos = Vector(8, 2.3, -3.5),
            wang = Angle(-2.829, -4.902, 180)
        },
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["ready"] = {
        Source = "draw",
        Time = .25
    },
    ["draw_empty"] = {
        Source = "idle_empty",
    },
    ["draw"] = {
        Source = "draw",
        Time = 1
    },
    ["fire"] = {
		Source = "shoot",
	},
    ["fire_iron"] = {
        Source = {"shoot_iron", "shoot_iron2", "shoot_iron3"},
    },
    ["reload"] = {
        MinProgress = 3.66, ForceEnd = true,
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    },
    ["reload_empty"] = {
        MinProgress = 3.75,
        Source = "reload_empty", ForceEnd = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
    },
    ["holster"] = {
		Source = "holster",
	},
}