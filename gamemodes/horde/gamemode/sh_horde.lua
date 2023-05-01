CreateConVar("horde_default_enemy_config", 1, FCVAR_SERVER_CAN_EXECUTE, "Use default enemy wave config settings.")
CreateConVar("horde_default_item_config", 1, FCVAR_SERVER_CAN_EXECUTE, "Use default item config settings.")
CreateConVar("horde_default_class_config", 1, FCVAR_SERVER_CAN_EXECUTE, "Use default class config settings.")
CreateConVar("horde_max_wave", 10, FCVAR_SERVER_CAN_EXECUTE, "Max waves.")
CreateConVar("horde_break_time", 60, FCVAR_SERVER_CAN_EXECUTE, "Break time between waves.")
CreateConVar("horde_enable_shop", 1, FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Enables shop menu or not.")
CreateConVar("horde_enable_shop_icons", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Enables shop menu icons or not.")
CreateConVar("horde_enable_perk", 1, FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Enables perks or not.")
CreateConVar("horde_enable_rank", 1, FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Enables ranks or not.")
CreateConVar("horde_enable_client_gui", 1, FCVAR_SERVER_CAN_EXECUTE, "Enables client information ui or not.")
CreateConVar("horde_max_spawn_distance", 2000, FCVAR_SERVER_CAN_EXECUTE, "Maximum enenmy respawn distance.")
CreateConVar("horde_min_spawn_distance", 400, FCVAR_SERVER_CAN_EXECUTE, "Minimum enenmy respawn distance.")
CreateConVar("horde_max_spawn_z_distance", 500, FCVAR_SERVER_CAN_EXECUTE, "Maximum enemy respawn height difference with players.")

CreateConVar("horde_start_money", 900, FCVAR_SERVER_CAN_EXECUTE, "Money given at start.")
CreateConVar("horde_round_bonus", 500, FCVAR_SERVER_CAN_EXECUTE, "Round bonus given at the end of the round.")
CreateConVar("horde_enable_ammobox", 1, FCVAR_SERVER_CAN_EXECUTE, "Enable ammobox spawns.")
CreateConVar("horde_npc_cleanup", 1, FCVAR_SERVER_CAN_EXECUTE, "Kills all NPCs after a wave.")
CreateConVar("horde_external_lua_config", "", FCVAR_SERVER_CAN_EXECUTE, "Name of external config to load. This will take over the configs if exists.")
--CreateConVar("horde_starter_weapon_1", "", FCVAR_ARCHIVE, "Starter weapon 1.")
--CreateConVar("horde_starter_weapon_2", "", FCVAR_ARCHIVE, "Starter weapon 2.")

CreateConVar("horde_director_interval", 5, FCVAR_SERVER_CAN_EXECUTE, "Game director execution interval in seconds. Decreasing this increases spawn rate.")
CreateConVar("horde_max_enemies_alive_base", 20, FCVAR_SERVER_CAN_EXECUTE, "Maximum number of living enemies (base).")
CreateConVar("horde_max_enemies_alive_scale_factor", 5, FCVAR_SERVER_CAN_EXECUTE, "Scale factor of the maximum number of living enemies for multiplayer.")
CreateConVar("horde_max_enemies_alive_max", 50, FCVAR_SERVER_CAN_EXECUTE, "Maximum number of maximum living enemies.")
CreateConVar("horde_corpse_cleanup", 0, FCVAR_SERVER_CAN_EXECUTE, "Remove corpses.")

CreateConVar("horde_base_walkspeed", 180, FCVAR_SERVER_CAN_EXECUTE, "Base walkspeed.")
CreateConVar("horde_base_runspeed", 220, FCVAR_SERVER_CAN_EXECUTE, "Base runspeed.")

CreateConVar("horde_difficulty", 0, FCVAR_SERVER_CAN_EXECUTE, "Difficulty.")
CreateConVar("horde_disable_difficulty_voting", 0, FCVAR_SERVER_CAN_EXECUTE, "Disable difficulty voting.")
CreateConVar("horde_endless", 0, FCVAR_SERVER_CAN_EXECUTE, "Endless.")
CreateConVar("horde_total_enemies_scaling", 0, FCVAR_SERVER_CAN_EXECUTE, "Forces the gamemode to multiply maximum enemy count by this.")

CreateConVar("horde_perk_start_wave", 1, FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "The wave when Tier 1 perks are active.")
CreateConVar("horde_perk_scaling", 2, FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "The multiplier to the level for which wave it is unlocked. e.g. at 1.5, perk level 4 is unlocked at start_wave + 6.", 0)

CreateConVar("horde_enable_starter", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Enables starter weapons.")
CreateConVar("horde_arccw_attinv_free", 1, FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Free ArcCW attachments.")

CreateConVar("horde_ready_countdown_ratio", 0.5, FCVAR_SERVER_CAN_EXECUTE, "Ratio of players required to start the 60 second countdown (0-1).")

CreateConVar("horde_enable_scoreboard", 1, FCVAR_SERVER_CAN_EXECUTE, "Enables built-in scoreboard.")
CreateConVar("horde_enable_3d2d_icon", 1, FCVAR_SERVER_CAN_EXECUTE, "Enables player icon renders.")

CreateConVar("horde_turret_spread", 0.5, FCVAR_SERVER_CAN_EXECUTE, "Turret spread.")

CreateConVar("horde_testing_unlimited_class_change", 0, FCVAR_SERVER_CAN_EXECUTE, "You can change a class for an unlimited times. Please use this only for testing purposes.")
CreateConVar("horde_testing_display_damage", 0, FCVAR_ARCHIVE, "Display damage for testing.")
CreateConVar("horde_display_damage", 1, FCVAR_ARCHIVE, "Display damage.")
CreateConVar("horde_enable_health_gui", 1, FCVAR_ARCHIVE, "Enables health UI.")
CreateConVar("horde_enable_ammo_gui", 1, FCVAR_ARCHIVE, "Enables ammo UI.")
CreateConVar("horde_enable_class_models", 1, FCVAR_ARCHIVE, "Enables ammo UI.")
CreateClientConVar("horde_disable_default_gadget_use_key", 0, FCVAR_ARCHIVE, "Disable default key bind for active gadgets.")

if SERVER then
util.AddNetworkString("Horde_SideNotification")
util.AddNetworkString("Horde_SideNotificationDebuff")
util.AddNetworkString("Horde_PlayerInit")
util.AddNetworkString("Horde_SideNotificationObjective")
util.AddNetworkString("Horde_SyncItems")
util.AddNetworkString("Horde_SyncEnemies")
util.AddNetworkString("Horde_SyncClasses")
util.AddNetworkString("Horde_SyncStatus")
util.AddNetworkString("Horde_SyncSpecialArmor")
util.AddNetworkString("Horde_PlayerReadySync")
util.AddNetworkString("Horde_AmmoboxCountdown")
util.AddNetworkString("Horde_SyncBossSpawned")
util.AddNetworkString("Horde_SyncBossHealth")
end

HORDE = {}
HORDE.__index = HORDE
HORDE.version = "1.2.0.0"
print("[HORDE] HORDE Version is " .. HORDE.version) -- Sanity check

HORDE.color_crimson = Color(220, 20, 60, 225)
HORDE.color_crimson_dim = Color(200, 0, 40)
HORDE.color_crimson_dark = Color(100,0,0)
HORDE.color_crimson_violet = Color(146, 43, 62)
HORDE.color_gadget_active = HORDE.color_crimson
HORDE.color_hollow = Color(40,40,40,225)
HORDE.color_hollow_dim = Color(80, 80, 80, 225)
HORDE.color_config_bar = Color(50, 50, 50, 200)
HORDE.color_config_bg = Color(150, 150, 150, 200)
HORDE.color_config_content_bg = Color(230,230,230)
HORDE.color_gadget_once = Color(238,130,238)
HORDE.color_none = Color(0,0,0,0)
HORDE.color_config_btn = Color(40,40,40)
HORDE.start_game = false
HORDE.total_enemies_per_wave = {15, 19, 23, 27, 30, 33, 36, 39, 42, 45}
--HORDE.total_enemies_per_wave = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

-- Director
HORDE.difficulty = 1
HORDE.total_enemies_this_wave = 0
HORDE.alive_enemies_this_wave = 0
HORDE.killed_enemies_this_wave = 0
HORDE.current_wave = 0
HORDE.total_break_time = math.max(10, GetConVarNumber("horde_break_time"))
HORDE.current_break_time = HORDE.total_break_time

HORDE.max_spawn_distance = math.max(100, GetConVarNumber("horde_max_spawn_distance"))
HORDE.min_spawn_distance = math.max(100, GetConVarNumber("horde_min_spawn_distance"))
HORDE.max_enemies_alive = 20
HORDE.spawned_enemies = {}
HORDE.spawned_enemies_count = {}
HORDE.ai_nodes = {}
HORDE.found_ai_nodes = false
HORDE.enemy_spawn_z = 6
HORDE.min_base_enemy_spawns_per_think = 4
HORDE.max_base_enemy_spawns_per_think = 5
HORDE.spawn_radius = 75
HORDE.max_max_waves = 10
HORDE.max_waves = math.min(HORDE.max_max_waves, math.max(1, GetConVarNumber("horde_max_wave")))
HORDE.start_money = math.max(0, GetConVarNumber("horde_start_money"))
HORDE.total_enemies_this_wave_fixed = 0
HORDE.kill_reward_base = 90
HORDE.round_bonus_base = GetConVar("horde_round_bonus"):GetInt()
HORDE.disable_levels_restrictions = 0
if CLIENT then
net.Receive("Horde_Disable_Levels", function ()
    HORDE.disable_levels_restrictions = 1
end)
end

HORDE.SPAWN_PROXIMITY = 0
HORDE.SPAWN_UNIFORM = 1
HORDE.SPAWN_PROXIMITY_NOISY = 2

-- Ammobox
HORDE.ammobox_max_count_limit = 9
HORDE.ammobox_refresh_interval = 60
HORDE.enable_ammobox = GetConVar("horde_enable_ammobox"):GetInt()

-- Statistics
-- Keep track of entities separately, so we don't have to network entities across
-- the network.
HORDE.player_drop_entities = {}
HORDE.player_ready = {}
HORDE.player_damage = {}
HORDE.player_damage_taken = {}
HORDE.player_heal = {}
HORDE.player_headshots = {}
HORDE.player_elite_kills = {}
HORDE.player_vote_map_change = {}

-- Render / Gui
HORDE.render_highlight_disable = 0
HORDE.render_highlight_enemies = 1
HORDE.render_highlight_ammoboxes = 2
HORDE.difficulty_text = {"NORMAL", "HARD", "REALISM", "NIGHTMARE", "APOCALYPSE"}

-- ArcCW Attachments
if ArcCWInstalled then
    if GetConVar("horde_arccw_attinv_free"):GetInt() == 0 then
        RunConsoleCommand("arccw_attinv_free", "0")
    else
        RunConsoleCommand("arccw_attinv_free", "1")
    end

    -- Disable perks that messes up with Horde's own system.
    if GetConVar("horde_default_item_config"):GetInt() == 1 then
	
		--
		ArcCW.AttachmentBlacklistTable["go_perk_diver"] = true
		ArcCW.AttachmentBlacklistTable["go_perk_light"] = true
		ArcCW.AttachmentBlacklistTable["go_perk_quickdraw"] = true
		ArcCW.AttachmentBlacklistTable["go_perk_cowboy"] = true
		--
	
        ArcCW.AttachmentBlacklistTable["go_perk_headshot"] = true
        ArcCW.AttachmentBlacklistTable["go_perk_ace"] = true
        ArcCW.AttachmentBlacklistTable["go_perk_last"] = true
        ArcCW.AttachmentBlacklistTable["go_perk_refund"] = true
        ArcCW.AttachmentBlacklistTable["go_perk_slow"] = true
        ArcCW.AttachmentBlacklistTable["go_m249_mag_12g_45"] = true
		ArcCW.AttachmentBlacklistTable["perk_fastreload"] = true
		ArcCW.AttachmentBlacklistTable["go_perk_rapidfire"] = true
		ArcCW.AttachmentBlacklistTable["perk_headshot"] = true
    end
end

-- melee attack mults
	local arccw_melees_bases = {arccw_horde_base_melee = true, arccw_base_melee = true}
	local tfa_melees_base = {horde_tfa_melee_base = true, tfa_melee_base = true}

	function HORDE.IsMeleeWeapon(wep)
		return arccw_melees_bases[wep.Base] or tfa_melees_base[wep.Base]
	end

	local function calculate_total_meleeattackspeed(wep, total_mult)
		if wep.ArcCW and arccw_melees_bases[wep.Base] then
			wep.ModifiedCache["Mult_MeleeTime"] = true
			wep.TickCache_Mults["Mult_MeleeTime"] = nil
			wep.Mult_MeleeTime = total_mult

			wep.ModifiedCache["Mult_MeleeTime"] = true
			if wep.ModifiedCache_Permanent then
				wep.ModifiedCache_Permanent["Mult_MeleeTime"] = true
			end
			
			if wep.Animations.bash then
				wep.Animations.bash.Mult = wep.Horde_Mult_MeleeTimeMults_bash * total_mult
			end
			
			if wep.Animations.bash2 then
				wep.Animations.bash2.Mult = wep.Horde_Mult_MeleeTimeMults_bash2 * total_mult
			end
		elseif wep.IsTFAWeapon and tfa_melees_base[wep.Base] then
			if wep.Primary.Attacks then
				if !wep.SequenceRateOverride then wep.SequenceRateOverride = {} end
				if !wep.SequenceRateOverrideScaled then wep.SequenceRateOverrideScaled = {} end
				for _, attacktable in pairs(wep.Primary.Attacks) do
				if !attacktable.act then continue end
					local mult = (wep["Horde_Mult_MeleeTimeMults_" .. attacktable.act] or 1) * (1 / total_mult)
					if mult == 1 then
						mult = nil
					end
					wep.SequenceRateOverride[attacktable.act] = mult
					wep.SequenceRateOverrideScaled[attacktable.act] = mult
					wep.StatCache2["SequenceRateOverrideScaled." .. attacktable.act] = nil
					wep.StatCache2["SequenceRateOverride." .. attacktable.act] = nil
				end
				wep:ClearStatCache()
			end
		end
		return true
	end


	local function init_meleeattackspeed_table(wep)
		if wep.ArcCW and arccw_melees_bases[wep.Base] then
			if wep.Animations.bash then
				wep.Horde_Mult_MeleeTimeMults_bash = wep.Animations.bash.Mult or 1
			end
			
			if wep.Animations.bash2 then
				wep.Horde_Mult_MeleeTimeMults_bash2 = wep.Animations.bash2.Mult or 1
			end
		elseif wep.IsTFAWeapon and tfa_melees_base[wep.Base] then
			if wep.Primary.Attacks then
				if !wep.SequenceRateOverride then wep.SequenceRateOverride = {} end
				if !wep.SequenceRateOverrideScaled then wep.SequenceRateOverrideScaled = {} end
				for _, attacktable in pairs(wep.Primary.Attacks) do
					if !attacktable.act then continue end
					wep["Horde_Mult_MeleeTimeMults_" .. attacktable.act] = wep.SequenceRateOverride[attacktable.act] or 1
				end
			end
		end
		return true
	end

-- melee attack mults

local special_conditions = {
	Mult_MeleeTime = {
		postinit = init_meleeattackspeed_table,
		calculate = calculate_total_meleeattackspeed,
		add_modifier_if = HORDE.IsMeleeWeapon,
	},
	Horde_MaxMags = {
		preinit = function(wep)
			if !wep.Horde_MaxMags then
				wep.Horde_MaxMags = 20
			end
		end,
	},
	Horde_TotalMaxAmmoMult = {
		preinit = function(wep)
			if !wep.Horde_TotalMaxAmmoMult then
				wep.Horde_TotalMaxAmmoMult = 1
			end
		end
	},
}

function HORDE:Modifier_AddSpecialCondition(cond)
	table.insert(special_conditions, cond)
end

local function CanAddModifier(wep, modifier)
	return !special_conditions[modifier] or !special_conditions[modifier].add_modifier_if or special_conditions[modifier].add_modifier_if(wep)
end

local function CalculateTotalMult(wep, modifier)
	local total_mult = 1
	for _, mult in pairs(wep.Horde_ModifiersTable[modifier]) do
		total_mult = total_mult * mult
	end

	if special_conditions[modifier] and special_conditions[modifier].calculate and special_conditions[modifier].calculate(wep, total_mult) then
		return
	end

	wep[modifier] = total_mult

	if wep.ArcCW then
		wep.ModifiedCache[modifier] = true
		wep.TickCache_Mults[modifier] = nil	
		if wep.ModifiedCache_Permanent then
			wep.ModifiedCache_Permanent[modifier] = true
		end
	end
end


local function InitModifierTable(wep, modifier)
	if !wep.Horde_ModifiersTable then
		wep.Horde_ModifiersTable = {}
	end
	
	if special_conditions[modifier] and special_conditions[modifier].preinit and special_conditions[modifier].preinit(wep) then
		return
	end
	
	local init
	if wep.Horde_ModifiersTable[modifier] and wep.Horde_ModifiersTable[modifier]["init"] then
		init = wep.Horde_ModifiersTable[modifier]["init"]
	end
	
	wep.Horde_ModifiersTable[modifier] = {}
	if init then
		wep.Horde_ModifiersTable[modifier]["init"] = init
	elseif wep[modifier] then
		wep.Horde_ModifiersTable[modifier]["init"] = wep[modifier]
	end
	
	if special_conditions[modifier] and special_conditions[modifier].postinit then
		special_conditions[modifier].postinit(wep)
	end
end

function HORDE:Modifier_AddToWeapons(ply, modifier, primarykey, mult)
	if !ply.Horde_ModifiersTable then
		ply.Horde_ModifiersTable = {}
	end
	if !ply.Horde_ModifiersTable[modifier] then
		ply.Horde_ModifiersTable[modifier] = {}
	end
	ply.Horde_ModifiersTable[modifier][primarykey] = mult
	for _, wep in pairs(ply:GetWeapons()) do
		if !CanAddModifier(wep, modifier) then continue end
		if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
			InitModifierTable(wep, modifier)
		end
		wep.Horde_ModifiersTable[modifier][primarykey] = mult

		CalculateTotalMult(wep, modifier)
	end
	if SERVER then
		net.Start("Horde_wepModifierApply")
		net.WriteBool(false)
		net.WriteString(modifier)
		net.WriteString(primarykey)
		if mult then
			net.WriteBool(false)
			net.WriteFloat(mult)
		else
			net.WriteBool(true)
		end
		
		net.Send(ply)
	end
end

function HORDE:LoadToWeaponModifier(wep)
	local ply = SERVER and wep:GetOwner() or MySelf
	if !ply.Horde_ModifiersTable then
		ply.Horde_ModifiersTable = {}
		return
	end
	if SERVER then
		net.Start("Horde_wepModifierApply")
		net.WriteBool(true)
		net.WriteEntity(wep)
		net.Send(ply)
	end
	for modifier, multtable in pairs(ply.Horde_ModifiersTable) do
		if !CanAddModifier(wep, modifier) then continue end
		InitModifierTable(wep, modifier)
		local init = wep.Horde_ModifiersTable[modifier]["init"]
		wep.Horde_ModifiersTable[modifier] = table.Copy(multtable) or {}
		wep.Horde_ModifiersTable[modifier]["init"] = init
		CalculateTotalMult(wep, modifier)
	end
end

if SERVER then
	hook.Add("WeaponEquip", "Horde_ModifiersLoad", function(wep)
		timer.Simple(0, function()
			HORDE:LoadToWeaponModifier(wep)
		end)
	end)
	util.AddNetworkString("Horde_wepModifierApply")
else
	net.Receive("Horde_wepModifierApply", function()
		local loadtowep = net.ReadBool()
		if loadtowep then
			local wep = net.ReadEntity()
			timer.Simple(0.01, function()
				if !IsValid(wep) then
					return
				end
				HORDE:LoadToWeaponModifier(wep)
			end)
		else
			local ply = MySelf
			local modifier = net.ReadString()
			local primarykey = net.ReadString()
			local need_to_delete = net.ReadBool()
			local mult
			if !need_to_delete then
				mult = net.ReadFloat()
			end
			HORDE:Modifier_AddToWeapons(ply, modifier, primarykey, mult)
		end
	end)
end

-- Disable Godmode
RunConsoleCommand("sbox_godmode", "0")
RunConsoleCommand("vj_npc_addfrags", "0")
RunConsoleCommand("vj_npc_knowenemylocation", "1")
RunConsoleCommand("vj_npc_bleedenemyonmelee", "0")

-- Util functions
function HORDE:GiveAmmo(ply, wpn, count)
    local clip_size = wpn.RegularClipSize or wpn:GetMaxClip1()
    local ammo_id = wpn:GetPrimaryAmmoType()
	--local ammo_limit = HORDE:Ammo_GetMaxAmmo(wpn)
	--local cur_ammo = ply:GetAmmoCount(ammo_id)
	
	local total_ammo
	if clip_size > 0 then
		total_ammo = clip_size * count
    elseif ammo_id >= 1 then
		total_ammo = count
	else
		return false
	end
	--[[local enough_to_full_clip = math.max(0, (wpn.RegularClipSize or (wpn.Primary and wpn.Primary.ClipSize) or 1) - wpn:Clip1())
	ammo_limit = ammo_limit + enough_to_full_clip
	print(total_ammo, cur_ammo, ammo_limit, enough_to_full_clip)
	if total_ammo + cur_ammo <= ammo_limit then
		ply:GiveAmmo(total_ammo, ammo_id, false)
		return true
	else]]
		local remain = HORDE:Ammo_RemainToFillAmmo(wpn)
		if remain > 0 then
			ply:GiveAmmo(math.min(remain, total_ammo), ammo_id, false)
			return true
		end
	--end

    return false
end

function HORDE:Round2(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function HORDE:GetUpgradePrice(class, ply)
    local level
    if CLIENT then
        level = MySelf:Horde_GetUpgrade(class)
    else
        level = ply:Horde_GetUpgrade(class)
    end
    if class == "horde_void_projector" or class == "horde_solar_seal" or class == "horde_astral_relic" or class == "horde_carcass" or class == "horde_pheropod" then
        local price = 800 + 25 * level
        return price
    else
        local base_price = HORDE.items[class].price
        local price = HORDE:Round2(math.max(100, base_price / 2) + math.max(10, base_price / 64) * level)
        return price
    end
end