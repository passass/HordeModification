local old_enemies = HORDE.GetDefaultEnemiesData

local names = {
    ["Subject: Wallace Breen"] = "npc_vj_hordeext_breen",
    ["Gamma Gonome"] = "npc_vj_hordeext_gamma_gonome",
    ["Lesion"] = "npc_vj_hordeext_lesion",
    ["Screecher"] = "npc_vj_hordeext_screecher",
    ["Vomitter"] = "npc_vj_hordeext_vomitter",
    ["Xen Destroyer Unit"] = "npc_vj_hordeext_xen_destroyer_unit",
    ["Xen Host Unit"] = "npc_vj_hordeext_xen_host_unit",
    ["Xen Psychic Unit"] = "npc_vj_hordeext_xen_psychic_unit",
}

function HORDE:GetDefaultEnemiesData()
    old_enemies()
    for k, v in pairs(names) do
        for i = 1, 10 do
            local enemy = HORDE.enemies[k .. i]
            if enemy then
                enemy.class = v
            end
        end
    end
end