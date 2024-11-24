HORDE.EntModifiers = {}

function HORDE.EntModifiers:AddModifier(ent, categoryname, modifname, value)
    if !ent.hordeEntModifiers then ent.hordeEntModifiers = {} end
    if !ent.hordeEntModifiers[categoryname] then ent.hordeEntModifiers[categoryname] = {} end
    ent.hordeEntModifiers[categoryname][modifname] = value
end

function HORDE.EntModifiers:RemoveModifier(ent, categoryname, modifname)
    if !ent.hordeEntModifiers then ent.hordeEntModifiers = {} end
    if !ent.hordeEntModifiers[categoryname] then ent.hordeEntModifiers[categoryname] = {} end
    ent.hordeEntModifiers[categoryname][modifname] = nil
end

function HORDE.EntModifiers:HasModifier(ent, categoryname, modifname)
	return !!(ent.hordeEntModifiers and ent.hordeEntModifiers[categoryname] and ent.hordeEntModifiers[categoryname][modifname])
end

function HORDE.EntModifiers:GetBool(ent, categoryname) // -> Bool
	if !ent.hordeEntModifiers or !ent.hordeEntModifiers[categoryname] or table.IsEmpty(ent.hordeEntModifiers[categoryname]) then
		return false
	end

	for _, value in pairs(ent.hordeEntModifiers[categoryname]) do
		if value == false then
			return false
		end
	end
	return true
end

function HORDE.EntModifiers:GetValue(ent, categoryname, basevalue) // -> Any
    basevalue = basevalue or 0
	if !ent.hordeEntModifiers or !ent.hordeEntModifiers[categoryname] or table.IsEmpty(ent.hordeEntModifiers[categoryname]) then
		return basevalue
	end

    local totalmult = 1
	local totaladd = 0
	local totalpostadd = 0
	local override
	local override_priority = 0

	local limit = math.huge
	for _, value in pairs(ent.hordeEntModifiers[categoryname]) do
		if value.mult then
			totalmult = totalmult * value.mult
		end

		if value.override and (!value.priority and !override or value.priority and override_priority < value.priority) then
			override = value.override
			override_priority = value.priority or override_priority
		end

		if value.add then
			totaladd = totaladd + value.add
		end

		if value.postadd then
			totalpostadd = totalpostadd + value.postadd
		end

		if value.limit or value.max then
			limit = math.min(value.limit or value.max, limit)
		end
	end

	--[[if override != nil then
		return override
	end]]

	return override or math.min(limit, (basevalue + totaladd) * totalmult + totalpostadd)
end