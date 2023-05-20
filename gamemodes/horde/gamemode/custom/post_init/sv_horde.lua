function HORDE:SpawnAmmoboxes(valid_nodes)
    for _, box in pairs(horde_spawned_ammoboxes) do
        if box:IsValid() then box:Remove() end
    end
    horde_spawned_ammoboxes = {}

    for i = 0, math.min(table.Count(player.GetAll()), HORDE.ammobox_max_count_limit) + HORDE.difficulty_additional_ammoboxes[HORDE.difficulty] do
        local pos = table.Random(valid_nodes)
        local spawned_ammobox = ents.Create("hordeext_ammobox")
        spawned_ammobox:SetPos(pos)
        spawned_ammobox:Spawn()
        table.insert(horde_spawned_ammoboxes, spawned_ammobox)
    end

    if table.Count(horde_spawned_ammoboxes) > 0 then
        net.Start("Horde_HighlightEntities")
        net.WriteUInt(HORDE.render_highlight_ammoboxes, 3)
        net.Broadcast()
    end

    horde_ammobox_refresh_timer = HORDE.ammobox_refresh_interval
end