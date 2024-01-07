

local holdout_mat = Material("status/hold.png")
local hold_zones = {}

local obj_mat = Material("status/objective.png")
local payloads = {}
local payload_destinations = {}

local escape_mat = Material("status/escape.png")
local escape_zones = {}

local shldmat = Material('models/horde/antimatter_shield/wall')
local function Render(bdepth, bskybox)
    if bskybox then return end

    if HORDE.Player_Looking_At_Minion then
        local npc = HORDE.Player_Looking_At_Minion
        if not npc:IsValid() or npc:Health() <= 0 then return end
        local base_pos = Vector()
        base_pos = (npc:LocalToWorld(npc:OBBCenter()) + npc:GetUp() * 24)

        local render_pos = base_pos

        -- Distance fading
        local render_mindist = 800
        local render_maxdist = render_mindist + 80

        local dist = (render_pos - EyePos()):Length()
        local dist_clamped = math.Clamp(dist, render_mindist, render_maxdist)
        local dist_alpha = math.Remap(dist_clamped, render_mindist, render_maxdist, 200, 0)

        if dist_alpha == 0 then return end -- Nothing to render

        -- Render ang
        local render_ang = EyeAngles()
        render_ang:RotateAroundAxis(render_ang:Right(),90)
        render_ang:RotateAroundAxis(-render_ang:Up(),90)

        cam.IgnoreZ(true)
        cam.Start3D2D(render_pos, render_ang, 0.35)
            draw.SimpleTextOutlined(tostring(npc:Health()) .. "/" .. tostring(npc:GetMaxHealth()), "DermaDefault", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
        cam.End3D2D()
        cam.IgnoreZ(false)
    end

    if not table.IsEmpty(hold_zones) then
        local render_ang = EyeAngles()
        render_ang:RotateAroundAxis(render_ang:Right(),90)
        render_ang:RotateAroundAxis(-render_ang:Up(),90)
        
        for id, param in pairs(hold_zones) do
            cam.IgnoreZ(true)
            cam.Start3D2D(param.IndicatorPos, render_ang, 0.35)
                surface.SetMaterial(holdout_mat)
                surface.SetDrawColor(Color(0, 255, 0))
                surface.DrawTexturedRect(-32, 0, 64, 64)

                if hold_zones[id].Progress > 0 then
                    draw.RoundedBox(0, -100, 70, 200, 10, HORDE.color_hollow)
                    draw.RoundedBox(0, -100, 70, hold_zones[id].Progress * 2, 10, Color(0, 255, 0))
                    draw.SimpleText("Hold Progress", "Trebuchet18", 0, 95, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5)
                end
            cam.End3D2D()
            cam.IgnoreZ(false)

            render.SetMaterial(shldmat)
            render.DrawBox(param.Pos, Angle(0,0,0), param.OBBMins, param.OBBMaxs, Color(0,255,0))
        end
    end

    if not table.IsEmpty(payloads) and not table.IsEmpty(payload_destinations) then
        local render_ang = EyeAngles()
        render_ang:RotateAroundAxis(render_ang:Right(),90)
        render_ang:RotateAroundAxis(-render_ang:Up(),90)

        for id, param in pairs(payloads) do
            cam.IgnoreZ(true)
            cam.Start3D2D(param.Pos, render_ang, 0.35)
                surface.SetMaterial(param.Icon)
                surface.SetDrawColor(Color(255, 255, 255))
                surface.DrawTexturedRect(-32, 0, 64, 64)

                draw.SimpleText("Collect", "Trebuchet18", 0, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5)
            cam.End3D2D()
            cam.IgnoreZ(false)
        end

        for id, param in pairs(payload_destinations) do
            cam.IgnoreZ(true)
            cam.Start3D2D(param.IndicatorPos, render_ang, 0.35)
                surface.SetMaterial(obj_mat)
                surface.SetDrawColor(Color(0, 255, 0))
                surface.DrawTexturedRect(-32, 0, 64, 64)

                draw.SimpleText("Deliver", "Trebuchet18", 0, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5)
            cam.End3D2D()
            cam.IgnoreZ(false)

            render.SetMaterial(shldmat)
            render.DrawBox(param.Pos, Angle(0,0,0), param.OBBMins, param.OBBMaxs, Color(0,255,0))
        end
    end

    if not table.IsEmpty(escape_zones) then
        local render_ang = EyeAngles()
        render_ang:RotateAroundAxis(render_ang:Right(),90)
        render_ang:RotateAroundAxis(-render_ang:Up(),90)

        for id, param in pairs(escape_zones) do
            cam.IgnoreZ(true)
            cam.Start3D2D(param.IndicatorPos, render_ang, 0.35)
                surface.SetMaterial(escape_mat)
                surface.SetDrawColor(Color(0, 255, 0))
                surface.DrawTexturedRect(-32, 0, 64, 64)

                draw.SimpleText("Escape", "Trebuchet18", 0, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5)
            cam.End3D2D()
            cam.IgnoreZ(false)

            render.SetMaterial(shldmat)
            render.DrawBox(param.Pos, Angle(0,0,0), param.OBBMins, param.OBBMaxs, Color(0,255,0))
        end
    end
end


if GetConVar("horde_enable_3d2d_icon"):GetInt() == 1 then
    hook.Add("PostDrawTranslucentRenderables", "Horde_RenderClassIcon", Render)

    --hook.Add("HUDPaint", "Horde_RenderDebuffs", RenderDebuffs)
end