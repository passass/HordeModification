local SoundChannels = {
	["shoot"] = CHAN_WEAPON,
	["shootwrap"] = CHAN_STATIC,
	["misc"] = CHAN_AUTO
}

local SoundChars = {
	["*"] = "STREAM",--Streams from the disc and rapidly flushed; good on memory, useful for music or one-off sounds
	["#"] = "DRYMIX",--Skip DSP, affected by music volume rather than sound volume
	["@"] = "OMNI",--Play the sound audible everywhere, like a radio voiceover or surface.PlaySound
	[">"] = "DOPPLER",--Left channel for heading towards the listener, Right channel for heading away
	["<"] = "DIRECTIONAL",--Left channel = front facing, Right channel = read facing
	["^"] = "DISTVARIANT",--Left channel = close, Right channel = far
	["("] = "SPATIALSTEREO_LOOP",--Position a stereo sound in 3D space; broken
	[")"] = "SPATIALSTEREO",--Same as above but actually useful
	["}"] = "FASTPITCH",--Low quality pitch shift
	["$"] = "CRITICAL",--Keep it around in memory
	["!"] = "SENTENCE",--NPC dialogue
	["?"] = "USERVOX"--Fake VOIP data; not that useful
}
local DefaultSoundChar = ")"
function HORDE:Sound_PatchSound( path, kind )
	local pathv
	local c = string.sub(path,1,1)

	if SoundChars[c] then
		pathv = string.sub( path, 2, string.len(path) )
	else
		pathv = path
	end

	local kindstr = kind
	if not kindstr then
		kindstr = DefaultSoundChar
	end
	if string.len(kindstr) > 1 then
		local found = false
		for k,v in pairs( SoundChars ) do
			if v == kind then
				kindstr = k
				found = true
				break
			end
		end
		if not found then
			kindstr = DefaultSoundChar
		end
	end

	return kindstr .. pathv
end

function HORDE:Sound_AddSound( name, channel, volume, level, pitch, wave, char )
	char = char or ""

	local SoundData = {
		name = name,
		channel = channel or CHAN_AUTO,
		volume = volume or 1,
		level = level or 75,
		pitch = pitch or 100
	}

	if char ~= "" then
		if type(wave) == "string" then
			wave = HORDE:Sound_PatchSound(wave, char)
		elseif type(wave) == "table" then
			local patchWave = table.Copy(wave)

			for k, v in pairs(patchWave) do
				patchWave[k] = HORDE:Sound_PatchSound(v, char)
			end

			wave = patchWave
		end
	end

	SoundData.sound = wave

	sound.Add(SoundData)
end

function HORDE:Sound_AddFireSound( id, path, wrap, kindv )
	kindv = kindv or ")"

	HORDE:Sound_AddSound(id, wrap and SoundChannels.shootwrap or SoundChannels.shoot, 1, 120, {97, 103}, path, kindv)
end

function HORDE:Sound_AddWeaponSound( id, path, kindv )
	kindv = kindv or ")"

	HORDE:Sound_AddSound(id, SoundChannels.misc, 1, 80, {97, 103}, path, kindv)
end

function HORDE:Ammo_Add( id, name )
	game.AddAmmoType({
		name = id
	})
	return id
end

local particles = {}

particles["tfa_muzzle_rifle"] = "tfa_muzzleflashes"
particles["tfa_muzzle_sniper"] = "tfa_muzzleflashes"
particles["tfa_muzzle_energy"] = "tfa_muzzleflashes"
particles["tfa_muzzle_energy"] = "tfa_muzzleflashes"
particles["tfa_muzzle_gauss"] = "tfa_muzzleflashes"

for k, v in pairs(particles) do
	game.AddParticles("particles/" .. v .. ".pcf")
	PrecacheParticleSystem(k)
end