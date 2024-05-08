function HORDE:GiveAmmo(ply, wpn, count, withsecondary)
    local clip_size = wpn.RegularClipSize or wpn:GetMaxClip1()
    local ammo_id = wpn:GetPrimaryAmmoType()
	local total_ammo
	if clip_size > 0 then
		total_ammo = clip_size * count
    elseif ammo_id >= 1 then
		total_ammo = count
	else
		return false
	end

	local result = false

	local remain = HORDE:Ammo_RemainToFillAmmo(wpn)
	if remain > 0 then
		ply:GiveAmmo(math.min(remain, total_ammo), ammo_id, false)
		result = true
	end
	if withsecondary then
		local item = HORDE.items[wpn:GetClass()]
		if item and item.secondary_ammo_price > 0 then
			local remain_secondary = HORDE:Ammo_RemainToFillAmmo_Secondary(wpn)
			if remain_secondary > 0 then
				local ammo_type_2
				local clipsize_2
				if wpn.ArcCW and wpn:GetBuff_Override("UBGL") then
					ammo_type_2 = wpn:GetBuff_Override("UBGL_Ammo")
					clipsize_2 = wpn:GetBuff_Override("UBGL_Capacity")
				else
					ammo_type_2 = wpn.Secondary.Ammo
					clipsize_2 = wpn.Secondary.ClipSize
				end 
				ply:GiveAmmo(math.min(remain_secondary, clipsize_2), ammo_type_2, false)
				result = true
			end
		end
	end
	return result
end