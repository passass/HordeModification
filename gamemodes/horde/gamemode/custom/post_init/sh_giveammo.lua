function HORDE:GiveAmmo(ply, wpn, count)
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
	local remain = HORDE:Ammo_RemainToFillAmmo(wpn)
	if remain > 0 then
		ply:GiveAmmo(math.min(remain, total_ammo), ammo_id, false)
		return true
	end
	return false
end