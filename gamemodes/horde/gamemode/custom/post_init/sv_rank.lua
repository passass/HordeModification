local EXPECTED_HEADER = "Horde_Rank"

function HORDE:SaveRank(ply)
	if GetConVar("horde_enable_rank"):GetInt() == 0 then return end
	if not ply:IsValid() then return end
	if not ply.Horde_Rank_Loaded then return end

	local path, strm

	if not file.IsDir("horde/ranks", "DATA") then
		file.CreateDir("horde/ranks", "DATA")
	end
    if not file.IsDir("horde/horde_ext/ranks/", "DATA") then
		file.CreateDir("horde/horde_ext/ranks/", "DATA")
	end

	path = "horde/horde_ext/ranks/" .. HORDE:ScrubSteamID(ply) .. ".txt"

	strm = file.Open(path, "wb", "DATA" )
		strm:Write(EXPECTED_HEADER)
        for name, class in pairs(HORDE.classes) do
            strm:WriteShort(class.order)
            strm:WriteLong(ply:Horde_GetExp(name))
			strm:WriteShort(ply:Horde_GetLevel(name))
        end

		-- Write subclass data
		for subclass_name, subclass in pairs(HORDE.subclasses) do
			if not subclass.ParentClass then goto cont end
			strm:WriteULong(HORDE.subclass_name_to_crc[subclass.PrintName])
			strm:WriteLong(ply:Horde_GetExp(subclass.PrintName))
			strm:WriteShort(ply:Horde_GetLevel(subclass.PrintName))
			::cont::
		end
	strm:Close()
end

function HORDE:LoadRank(ply)
	if not ply:IsValid() then return end
	if GetConVar("horde_enable_rank"):GetInt() == 0 then return end

	local path, strm

	if not file.IsDir("horde/ranks", "DATA") then
		file.CreateDir("horde/ranks", "DATA")
	end
    if not file.IsDir("horde/horde_ext/ranks/", "DATA") then
		file.CreateDir("horde/horde_ext/ranks/", "DATA")
	end
    local steamid = HORDE:ScrubSteamID(ply)
	path = "horde/horde_ext/ranks/" .. steamid .. ".txt"

	if not file.Exists(path, "DATA") then
		path = "horde/ranks/" .. steamid .. ".txt"

		if not file.Exists(path, "DATA") then
			print("Path", path, "does not exist!")
			ply.Horde_Rank_Loaded = true
			return
		end
	end

	strm = file.Open(path, "rb", "DATA")
		local header = strm:Read(#EXPECTED_HEADER)

		if header == EXPECTED_HEADER then
			for _, _ in pairs(HORDE.classes) do
                local order = strm:ReadShort()
				local exp = strm:ReadLong()
				local level = strm:ReadShort()
				if order == nil then
				else
					local class_name = HORDE.order_to_class_name[order]
					ply:Horde_SetLevel(class_name, level)
					ply:Horde_SetExp(class_name, exp)
				end
            end

			-- Read subclass data
			while not strm:EndOfFile() do
				local order = strm:ReadULong()
				local exp = strm:ReadLong()
				local level = strm:ReadShort()
				if order == nil then
				else
					local class_name = HORDE.order_to_subclass_name[tostring(order)]
					ply:Horde_SetLevel(class_name, level)
					ply:Horde_SetExp(class_name, exp)
				end
				::cont::
			end
		else
			for _, class in pairs(HORDE.classes) do
				ply:Horde_SetLevel(class.name, 0)
                ply:Horde_SetExp(class.name, 0)
            end
		end
	strm:Close()

	ply.Horde_Rank_Loaded = true
end

HORDE.XpGainRate = 3

if GetConVar("horde_enable_sandbox"):GetInt() == 0 and GetConVar("horde_enable_rank"):GetInt() == 1 then
	hook.Add("Horde_OnEnemyKilled", "Horde_GiveExp", function(victim, killer, wpn)
		if HORDE.current_wave <= 0 or GetConVar("sv_cheats"):GetInt() == 1 then return end
		if killer:IsPlayer() and killer:IsValid() and killer:Horde_GetClass() then
			local class_name = killer:Horde_GetCurrentSubclass()
			if killer:Horde_GetLevel(class_name) >= HORDE.max_level then return end
			if victim:Horde_IsElite() then
				killer:Horde_SetExp(class_name, killer:Horde_GetExp(class_name) + 2 * HORDE.XpGainRate)
				local p = math.random()
				if p < 0.01 or (p < 0.1 and killer:Horde_GetGadget() == "gadget_corporate_mindset") then
					-- Drop a skull token
					local ent = ents.Create("horde_skull_token")
					local pos = victim:GetPos()
					local drop_pos = pos
					drop_pos = drop_pos + VectorRand() * 5
					drop_pos.z = pos.z + 15
					ent:SetPos(drop_pos)
					ent.Owner = killer
					ent:Spawn()
				end
			else
				killer:Horde_SetExp(class_name, killer:Horde_GetExp(class_name) + 1 * HORDE.XpGainRate)
				HORDE:SaveRank(killer)
			end
		end
	end)
end