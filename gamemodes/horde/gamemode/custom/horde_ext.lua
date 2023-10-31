CONFIG.name = "horde_ext"

if SERVER then
	function HORDE:MakeExplosionEffect(pos, ent)
		if CreateGrenadeExplosion then
			CreateGrenadeExplosion(pos)
			if ent then HORDE:EmitExplosionSound(ent, 125) end
		else
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			util.Effect("Explosion", effectdata)
		end
	end
	
	function HORDE:EmitExplosionSound(ent, soundlevel, pitch) 
		ent:EmitSound("weapons/explode" .. math.random(3, 5) .. ".wav", soundlevel, pitch)
	end
end

local blacklist = {["horde_ext.lua"] = true}
local blacklist_folders = {
	["post_init"] = true, ["arccw"] = true, ["subclasses"] = true, ["perks"] = true, ["gadgets"] = true, ["mutations"] = true,
	--["gui"] = true, ["status"] = true
}
local function NEW_AddCSLuaFile(name)
	blacklist[name] = true
	AddCSLuaFile(name)
end
local function NEW_include(name)
	blacklist[name] = true
	include(name)
end

local function ExtInclude(name, dir)

	local sep = string.Split(name, "_")
	name = dir .. name

	-- Determine where to load the files
	if sep[1] == "sv" then
		if SERVER then
			NEW_include(name)
		end
	elseif sep[1] == "cl" then
		if SERVER then
			NEW_AddCSLuaFile(name)
		else
			NEW_include(name)
		end
	elseif sep[1] == "sh" then
		if SERVER then
			NEW_AddCSLuaFile(name)
		end
		NEW_include(name)
	end
end

-- Run this on both client and server
function AnalyzeDirection(direction, all_shared, pre_callback, post_callback, not_in_custom, dont_analyze_folders)
    local files, dirs = file.Find( "horde/gamemode/" .. (not_in_custom and "" or "custom/") .. direction .. "*", "LUA" )
	for k,v in pairs(files) do
        if !blacklist[direction .. v] then
			if all_shared then
				local name = (not_in_custom and "horde/gamemode/" or "horde/gamemode/custom/") .. direction .. v
				if pre_callback and pre_callback(direction, v) then continue end
				if SERVER then
					NEW_AddCSLuaFile(name)
				end
				NEW_include(name)
				if post_callback then post_callback(direction, v) end
			else
        		ExtInclude(v, (not_in_custom and "horde/gamemode/" or "horde/gamemode/custom/") .. direction)
			end
		end
    end
	if !dont_analyze_folders then
		for k, dirname in pairs(dirs) do
			if !blacklist_folders[dirname] then
				AnalyzeDirection(direction .. dirname .. "/", all_shared, pre_callback, post_callback, not_in_custom)
			end
		end
	end
end


AnalyzeDirection("arccw/attachments/", true, function(dir, name)
	if !ArcCWInstalled then
		blacklist[dir .. name] = true
		return true
	end

	att = {}
	
end, function(dir, name)
	if att and att.Slot  then
		ArcCW.LoadAttachmentType( att, string.Split(name, ".")[1] )
	end
	att = nil
end)
AnalyzeDirection("gadgets/", true, function(dir, name)
	GADGET = {}
end, function(dir, name)
	if GADGET.Ignore then return end
	GADGET.ClassName = string.lower(GADGET.ClassName or string.Explode(".", name)[1])
	GADGET.SortOrder = GADGET.SortOrder or 0

	hook.Run("Horde_OnLoadGadget", GADGET)

	HORDE.gadgets[GADGET.ClassName] = GADGET

	for k, v in pairs(GADGET.Hooks or {}) do
		hook.Add(k, "horde_gadget_" .. GADGET.ClassName, v)
	end

	GADGET = nil
end)
AnalyzeDirection("tfa/", true, nil, nil, true)
AnalyzeDirection("")

hook.Add( "InitPostEntity", "HORDE_EXT", function()
	AnalyzeDirection("post_init/")
end )
