local blacklist = {["init.lua"] = true, ["cl_init.lua"] = true, ["loader.lua"] = true}
local function NEW_AddCSLuaFile(name)
	blacklist[name] = true
	AddCSLuaFile(name)
end
local function NEW_include(name)
	blacklist[name] = true
	include(name)
end

NEW_include("shared.lua")
NEW_include("sh_particles.lua")
NEW_include("sh_translate.lua")
NEW_include("sh_horde.lua")
NEW_include("sh_slowmotion.lua")
NEW_include("sh_gadget.lua")
NEW_include("sh_status.lua")
NEW_include("sh_damage.lua")
NEW_include("sh_infusion.lua")
NEW_include("sh_item.lua")
NEW_include("sh_item_new.lua")
NEW_include("sh_class.lua")
NEW_include("sh_mutation.lua")
NEW_include("sh_enemy.lua")
NEW_include("sh_perk.lua")
NEW_include("sh_maps.lua")
NEW_include("sh_custom.lua")
NEW_include("sh_rank.lua")
NEW_include("sh_sync.lua")
NEW_include("sh_misc.lua")

if SERVER then
	NEW_AddCSLuaFile("cl_init.lua")
	NEW_AddCSLuaFile("shared.lua")
	NEW_AddCSLuaFile("sh_particles.lua")
	NEW_AddCSLuaFile("sh_translate.lua")
	NEW_AddCSLuaFile("sh_horde.lua")
	NEW_AddCSLuaFile("sh_slowmotion.lua")
	NEW_AddCSLuaFile("sh_gadget.lua")
	NEW_AddCSLuaFile("sh_status.lua")
	NEW_AddCSLuaFile("sh_damage.lua")
	NEW_AddCSLuaFile("sh_infusion.lua")
	NEW_AddCSLuaFile("sh_item.lua")
	NEW_AddCSLuaFile("sh_item_new.lua")
	NEW_AddCSLuaFile("sh_class.lua")
	NEW_AddCSLuaFile("sh_enemy.lua")
	NEW_AddCSLuaFile("sh_mutation.lua")
	NEW_AddCSLuaFile("sh_perk.lua")
	NEW_AddCSLuaFile("sh_maps.lua")
	NEW_AddCSLuaFile("sh_custom.lua")
	NEW_AddCSLuaFile("sh_rank.lua")
	NEW_AddCSLuaFile("sh_sync.lua")
	NEW_AddCSLuaFile("sh_misc.lua")

	NEW_AddCSLuaFile("cl_economy.lua")
	NEW_AddCSLuaFile("cl_achievement.lua")
	NEW_AddCSLuaFile("gui/cl_gameinfo.lua")
	NEW_AddCSLuaFile("gui/cl_status.lua")
	NEW_AddCSLuaFile("gui/cl_ready.lua")
	NEW_AddCSLuaFile("gui/cl_class.lua")
	NEW_AddCSLuaFile("gui/cl_description.lua")
	NEW_AddCSLuaFile("gui/cl_infusion.lua")
	NEW_AddCSLuaFile("gui/cl_item.lua")
	NEW_AddCSLuaFile("gui/cl_itemconfig.lua")
	NEW_AddCSLuaFile("gui/cl_classconfig.lua")
	NEW_AddCSLuaFile("gui/cl_enemyconfig.lua")
	NEW_AddCSLuaFile("gui/cl_mapconfig.lua")
	NEW_AddCSLuaFile("gui/cl_configmenu.lua")
	NEW_AddCSLuaFile("gui/cl_shop.lua")
	NEW_AddCSLuaFile("gui/cl_stats.lua")
	NEW_AddCSLuaFile("gui/cl_summary.lua")
	NEW_AddCSLuaFile("gui/cl_scoreboard.lua")
	NEW_AddCSLuaFile("gui/cl_3d2d.lua")
	NEW_AddCSLuaFile("gui/cl_subclassbutton.lua")
	NEW_AddCSLuaFile("gui/cl_perkbutton.lua")

	NEW_include("sv_damage.lua")
	NEW_include("sv_heal.lua")
	NEW_include("status/buff/sv_buff.lua")
	NEW_include("status/buff/sv_headhunter.lua")
	NEW_include("status/buff/sv_camoflague.lua")
	NEW_include("status/buff/sv_adrenaline.lua")
	NEW_include("status/buff/sv_health_regen.lua")
	NEW_include("status/buff/sv_armor_regen.lua")
	NEW_include("status/buff/sv_fortify.lua")
	NEW_include("status/buff/sv_berserk.lua")
	NEW_include("status/buff/sv_haste.lua")
	NEW_include("status/buff/sv_phalanx.lua")
	NEW_include("status/buff/sv_aerial_guard.lua")
	NEW_include("status/buff/sv_warden_aura.lua")
	NEW_include("status/buff/sv_entropy_shield.lua")
	NEW_include("status/buff/sv_foresight.lua")
	NEW_include("status/debuff/sv_debuff.lua")
	NEW_include("status/debuff/sv_hinder.lua")
	NEW_include("status/debuff/sv_weaken.lua")
	NEW_include("status/debuff/sv_ignite.lua")
	NEW_include("status/debuff/sv_burst.lua")
	NEW_include("status/debuff/sv_stun.lua")
	NEW_include("status/debuff/sv_break.lua")
	NEW_include("status/debuff/sv_frostbite.lua")
	NEW_include("status/debuff/sv_shock.lua")
	NEW_include("status/debuff/sv_bleeding.lua")
	NEW_include("status/debuff/sv_freeze.lua")

	NEW_include("obj_entity_extend_sv.lua")
	NEW_include("sv_perk.lua")
	NEW_include("sv_rank.lua")
	NEW_include("sv_economy.lua")
	NEW_include("sv_commands.lua")
	NEW_include("sv_playerlifecycle.lua")
	NEW_include("sv_nodegraph.lua")
	NEW_include("sv_difficulty.lua")
	NEW_include("sv_tip.lua")
	NEW_include("sv_hooks.lua")
	NEW_include("sv_misc.lua")
	NEW_include("sv_horde.lua")
else
	NEW_include("cl_economy.lua")
	NEW_include("cl_achievement.lua")
	NEW_include("cl_hitnumbers.lua")
	NEW_include("gui/cl_gameinfo.lua")
	NEW_include("gui/cl_status.lua")
	NEW_include("gui/cl_ready.lua")
	NEW_include("gui/cl_class.lua")
	NEW_include("gui/cl_description.lua")
	NEW_include("gui/cl_infusion.lua")
	NEW_include("gui/cl_item.lua")
	NEW_include("gui/cl_itemconfig.lua")
	NEW_include("gui/cl_classconfig.lua")
	NEW_include("gui/cl_enemyconfig.lua")
	NEW_include("gui/cl_mapconfig.lua")
	NEW_include("gui/cl_configmenu.lua")
	NEW_include("gui/cl_shop.lua")
	NEW_include("gui/cl_stats.lua")
	NEW_include("gui/cl_summary.lua")
	NEW_include("gui/cl_scoreboard.lua")
	NEW_include("gui/cl_3d2d.lua")
	NEW_include("gui/cl_subclassbutton.lua")
	NEW_include("gui/cl_perkbutton.lua")

	NEW_include("gui/npcinfo/sh_npcinfo.lua")
	NEW_include("gui/npcinfo/cl_npcinfo.lua")

	NEW_include("status/sh_mind.lua")
	NEW_include("gui/scoreboard/dpingmeter.lua")
	NEW_include("gui/scoreboard/dheaderpanel.lua")
	NEW_include("gui/scoreboard/dplayerline.lua")
end

local function ExtInclude(name, dir)

	local sep = string.Split(name, "_")
	name = dir .. name

	-- Determine where to load the files
	if sep[1] == "sv" then
		if SERVER then
			include(name)
		end
	elseif sep[1] == "sh" then
		if SERVER then
			AddCSLuaFile(name)
			include(name)
		else
			include(name)
		end
	elseif sep[1] == "cl" then
		if SERVER then
			AddCSLuaFile(name)
		else
			include(name)
		end
	end
end

-- Run this on both client and server
function AnalyzeDirection(direction)
    local files, dirs = file.Find( "horde/gamemode/" .. direction .. "*", "LUA" )

    for k,v in pairs(files) do
        if !blacklist[direction .. v] then
        	ExtInclude(v, direction)
		end
    end

    for k,v in pairs(dirs) do
        AnalyzeDirection(direction .. v .. "/" )
    end
end

AnalyzeDirection("")
