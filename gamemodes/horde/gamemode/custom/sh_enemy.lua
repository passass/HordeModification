local old_enemies = HORDE.GetDefaultEnemiesData

local names = {
    ["Subject: Wallace Breen"] = "npc_vj_horde_breen",
    ["Gamma Gonome"] = "npc_vj_horde_gamma_gonome",
    ["Lesion"] = "npc_vj_horde_lesion",
    ["Screecher"] = "npc_vj_horde_screecher",
    ["Vomitter"] = "npc_vj_horde_vomitter",
    ["Xen Destroyer Unit"] = "npc_vj_horde_xen_destroyer_unit",
    ["Xen Host Unit"] = "npc_vj_horde_xen_host_unit",
    ["Xen Psychic Unit"] = "npc_vj_horde_xen_psychic_unit",
}

local standart_to_ext = {
    ["npc_vj_horde_breen"] = "npc_vj_hordeext_breen",
    ["npc_vj_horde_gamma_gonome"] = "npc_vj_hordeext_gamma_gonome",
    ["npc_vj_horde_lesion"] = "npc_vj_hordeext_lesion",
    ["npc_vj_horde_screecher"] = "npc_vj_hordeext_screecher",
    ["npc_vj_horde_vomitter"] = "npc_vj_hordeext_vomitter",
    ["npc_vj_horde_xen_destroyer_unit"] = "npc_vj_hordeext_xen_destroyer_unit",
    ["npc_vj_horde_xen_host_unit"] = "npc_vj_hordeext_xen_host_unit",
    ["npc_vj_horde_xen_psychic_unit"] = "npc_vj_hordeext_xen_psychic_unit",
}

function HORDE:GetDefaultEnemiesData()
    old_enemies()
    for name, id in pairs(names) do
        for i = 1, 10 do
            local enemy = HORDE.enemies[name .. i]
            
            if enemy then
                enemy.class = standart_to_ext[id]
            end
        end
        if HORDE.NPCS[id] then
            HORDE.NPCS[standart_to_ext[id]] = HORDE.NPCS[id]
            HORDE.NPCS[id] = nil
        end
    end
end