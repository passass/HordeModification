MMODParticleFiles = {}
table.insert(MMODParticleFiles, #MMODParticleFiles, "mmod_xbowparts")
table.insert(MMODParticleFiles, #MMODParticleFiles, "hl2mmod_muzzleflashes")
table.insert(MMODParticleFiles, #MMODParticleFiles, "hl2mmod_explosions")
table.insert(MMODParticleFiles, #MMODParticleFiles, "hl2mmod_weaponeffects")
table.insert(MMODParticleFiles, #MMODParticleFiles, "hl2mmod_tracers")

MMODParticleEffects = {}
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_TFA_MMOD.crossbow_boltidle")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_TFA_MMOD.crossbow_boltrelease")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_TFA_MMOD.crossbow_chargespark")
table.insert(MMODParticleEffects, #MMODParticleEffects, "weapon_rpg_smoketrail_fire")
table.insert(MMODParticleEffects, #MMODParticleEffects, "weapon_rpg_smoketrail_firebase")
table.insert(MMODParticleEffects, #MMODParticleEffects, "weapon_rpg_smoketrail_firemid")
--MUZZLEFLASHES
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_357")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_357_alt")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_ar2")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_ar2_alt")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_ar2_alt_charge") --Altattack charge, attached to Secondary (att 3)
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_ar2_punch") --No idea, probably altattack muzzleflash, attached to punch (att 4)
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_pistol")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_pistol_alt")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_rpg")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_shotgun")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_shotgun_alt")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_smg1")
table.insert(MMODParticleEffects, #MMODParticleEffects, "blast_furnace_muzzle")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_smg1_alt")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_muzzleflash_smg1_grenade")
--WEAPON FX
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_weapon_smg_grenadetrail")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_weapon_rpg_smoketrail")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_weapon_rpg_ignite")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_weapons_grenade_trailandblipglow")
--EXPLOSIONS
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_explosion_grenade")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_explosion_rpg")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_explosion_grenade_noaftersmoke")
--TRACERS
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_shotgun_projbull_tracer")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_shotgun_tracer")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_357_projbull_tracer")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_tracer_ar2")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_tracer_projbull_ar2")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_tracer_ar2_heavy")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_generic_tracer")
table.insert(MMODParticleEffects, #MMODParticleEffects, "hl2mmod_generic_projbull_tracer")

for k, v in pairs(MMODParticleFiles) do
	game.AddParticles("particles/" .. v .. ".pcf")
end

for k, v in pairs(MMODParticleEffects) do
	PrecacheParticleSystem(v)
end