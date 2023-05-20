net.Receive("Horde_HighlightEntities", function (len, ply)
    if GetConVarNumber("horde_enable_halo") == 0 then return end
    local render = net.ReadUInt(3)
    if render == HORDE.render_highlight_enemies then
        hook.Add("PreDrawHalos", "Horde_AddEnemyHalos", function()
            local enemies = ents.FindByClass("npc*")
            for key, enemy in pairs(enemies) do
                if enemy:GetNWEntity("HordeOwner"):IsPlayer() then
                    -- Do not highlight friendly minions
                    enemies[key] = nil
                end
            end
            halo.Add(enemies, Color(255, 0, 0), 1, 1, 1, true, true)
        end)
    elseif render == HORDE.render_highlight_ammoboxes then
        hook.Add("PreDrawHalos", "Horde_AddAmmoBoxHalos", function()
            halo.Add(ents.FindByClass("hordeext_ammobox"), Color(0, 255, 0), 1, 1, 1, true, true)
            halo.Add(ents.FindByClass("horde_gadgetbox"), Color(255, 0, 0), 1, 1, 1, true, true)
        end)
        timer.Simple(10, function ()
            hook.Remove("PreDrawHalos", "Horde_AddAmmoBoxHalos")
        end)
    else
        hook.Remove("PreDrawHalos", "Horde_AddEnemyHalos")
        hook.Remove("PreDrawHalos", "Horde_AddAmmoBoxHalos")
    end
end)