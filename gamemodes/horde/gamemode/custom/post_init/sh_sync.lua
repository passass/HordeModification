local EXPECTED_HEADER = "Horde_Rank"

function HORDE:SyncToLocal()
    if SERVER then return end
    local ply = MySelf
    if not ply:IsValid() then return end
    local local_levels = {}
    local local_exps = {}
	local path, path2, strm

	if not file.IsDir("horde/ranks", "DATA") then
		file.CreateDir("horde/ranks", "DATA")
	end
	if not file.IsDir("horde/horde_ext/ranks/", "DATA") then
		file.CreateDir("horde/horde_ext/ranks/", "DATA")
	end
	local steamid = HORDE:ScrubSteamID(ply)
	path = "horde/ranks/" .. steamid .. ".txt"
	path2 = "horde/horde_ext/ranks/" .. steamid .. ".txt"

	local total_path = file.Exists(path2, "DATA") and path2 or file.Exists(path, "DATA") and path

	if total_path then
		strm = file.Open(total_path, "rb", "DATA")
		local header = strm:Read(#EXPECTED_HEADER)

		if header == EXPECTED_HEADER then
			for _, _ in pairs(HORDE.classes) do
                local order = strm:ReadShort()
				local exp = strm:ReadLong()
				local level = strm:ReadShort()
				if order == nil then
				else
					local class_name = HORDE.order_to_class_name[order]
					if class_name then
						local_levels[class_name] = level
						local_exps[class_name] = exp
					end
				end
            end

			-- Write subclass data
			for subclass_name, subclass in pairs(HORDE.subclasses) do
				if not subclass.ParentClass then goto cont end
				strm:WriteULong(HORDE.subclass_name_to_crc[subclass.PrintName])
				strm:WriteLong(ply:Horde_GetExp(subclass.PrintName))
				strm:WriteShort(ply:Horde_GetLevel(subclass.PrintName))
				::cont::
			end
		else
			for _, class in pairs(HORDE.classes) do
                local_levels[class.name] = 0
				local_exps[class.name] = 0
            end
		end
		strm:Close()
	end

    for name, class in pairs(HORDE.classes) do
        local server_level = ply:Horde_GetLevel(name)
        local server_exp = ply:Horde_GetExp(name)
        local_levels[name] = math.max(server_level, local_levels[name] or 0)
        local_exps[name] = math.max(server_exp, local_exps[name] or 0)
    end

	for name, class in pairs(HORDE.subclasses) do
		if not class.ParentClass then goto cont end
        local server_level = ply:Horde_GetLevel(name)
        local server_exp = ply:Horde_GetExp(name)
        local_levels[name] = math.max(server_level, local_levels[name] or 0)
        local_exps[name] = math.max(server_exp, local_exps[name] or 0)
		::cont::
    end

    -- Save
	strm = file.Open(path2, "wb", "DATA" )
		strm:Write(EXPECTED_HEADER)
        for name, class in pairs(HORDE.classes) do
            strm:WriteShort(class.order)
            strm:WriteLong(local_exps[name])
			strm:WriteShort(local_levels[name])
        end

		for name, class in pairs(HORDE.subclasses) do
			if not class.ParentClass then goto cont end
			strm:WriteULong(HORDE.subclass_name_to_crc[class.PrintName])
			strm:WriteLong(local_exps[class.PrintName])
			strm:WriteShort(local_levels[class.PrintName])
			::cont::
		end
	strm:Close()
	
	HORDE:PlayNotification("Sucessfully synced local data from server.")
end