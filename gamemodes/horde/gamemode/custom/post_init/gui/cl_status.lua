--local hp = Material("status/hp.png", "smooth")
--local armor = Material("status/armor.png", "mips smooth")
local mind = Material("status/mind.png", "mips smooth")
local weight = Material("weight.png")
local dead = Material("status/necrosis.png", "mips smooth")

local count_of_GUIs = 0

surface.CreateFont("PlayerName_EXT", { font = "arial", size = ScreenScale(9), extended = true})
local font = "HealthInfo"
local font2 = "HealthInfo2"
local font3 = "Horde_WeaponName"
local fontweight = "Horde_Weight"
local fontplayername = "Horde_Weight"--"PlayerName_EXT"

local health_color = Color(201,13,13,222)
local extra_health_color = Color(223,202,14,222)
local armor_color = Color(40,208,250,222)
local death_color = Color(223, 0, 0)
local vanish = Color(0, 0, 0, 0)

local PANEL = {}

function PANEL:Init()

    count_of_GUIs = count_of_GUIs + 1

end

function PANEL:Think()
    if GetConVarNumber("horde_enable_health_gui") != 1 then self:Remove() return end

    local ply = self.ply
    if !IsValid(ply) then
        self:Remove()
    else

        if GetConVarNumber("horde_enable_health_gui") != 1 then
            if IsValid(self.ply_Avatar) then
                self.ply_Avatar:SetImageColor(vanish)
                self.ply_Avatar.Dead_Pic:SetImageColor( vanish )
            end
            return
        end

        if !ply:Alive() then
            self.ply_Avatar.Dead_Pic:SetImageColor( death_color )
        else
            self.ply_Avatar.Dead_Pic:SetImageColor( vanish )
        end
    end
end

function PANEL:Calculate_Data()
    local ply = self.ply

    ply.Horde_HealthGUI = self

    if MySelf == ply then
        self.player_position = 0
    else
        local all_players = table.Copy(player.GetAll())
        table.RemoveByValue(all_players, MySelf)
        self.player_position = table.KeyFromValue( all_players, ply )
    end

    local airgap = ScreenScale(6)
    local class_icon_y = ScrH() - airgap - ScreenScale(37) - (MySelf != ply and ScreenScale(10) or 0) - self.player_position * ScreenScale(40)

    local size_x, size_y = airgap + ScreenScale(160), ScreenScale(43)
    self:SetPos(airgap, class_icon_y)
    self:SetSize(size_x, size_y)

    if !self.ply_Avatar then
        local prnt_panel = self

        self.ply_Avatar = vgui.Create("AvatarImage", prnt_panel)
        local avatar_size = ScreenScale(8)
        self.ply_Avatar:SetPos(ScreenScale(30), size_y - avatar_size - ScreenScale(1.5))
        self.ply_Avatar:SetSize(avatar_size, avatar_size)
        self.ply_Avatar:SetVisible(true)
        self.ply_Avatar:SetPlayer(ply)
        self.ply_Avatar:SetMouseInputEnabled(false)

        self.ply_Avatar.Dead_Pic = vgui.Create("DImage", self.ply_Avatar)
        self.ply_Avatar.Dead_Pic:SetSize(avatar_size, avatar_size)
        self.ply_Avatar.Dead_Pic:SetPos(0, 0)
        self.ply_Avatar.Dead_Pic:SetImageColor( vanish )
        self.ply_Avatar.Dead_Pic:SetMaterial(dead)
        self.ply_Avatar.Dead_Pic:SetMouseInputEnabled(false)
    end
end

function PANEL:OnRemove()
    self.ply_Avatar:Remove()
    self.ply_Avatar.Dead_Pic:Remove()
    count_of_GUIs = count_of_GUIs - 1
    for _, ply in pairs(player.GetAll()) do
        if ply.Horde_HealthGUI == self then continue end
        ply.Horde_HealthGUI:Calculate_Data()
    end
end

local function draw_rect(x, y, width, height, color)
    surface.SetDrawColor(color)
    surface.DrawRect(x, y, width, height)
end

function PANEL:Paint()

    local ply = self.ply
    
    local airgap = ScreenScale(6)
    local armor_field_size = ScreenScale(3)
    
    --local icon_x = airgap + ScreenScale(55)
    local size_x, size_y = self:GetSize()

    local icon_y = size_y - airgap - ScreenScale(33)

    local bars_size_x = airgap + ScreenScale(90)
    local bars_pos_x = size_x - bars_size_x - ScreenScale(40)

    local vhp = ply:Health()
    local vmaxhp = ply:GetMaxHealth()
    
    
    local armor_color_real
    local varmor
    local vmaxarmor
    if ply:Horde_GetMaxMind() > 0 then
        varmor = ply:Horde_GetMind()
        vmaxarmor = ply:Horde_GetMaxMind()
        armor_color_real = Color(214, 89, 6)
    else
        armor_color_real = armor_color
        varmor = ply:Armor()
        vmaxarmor = ply:GetMaxArmor()
    end

    -- background
    draw_rect(bars_pos_x - ScreenScale(1), size_y - ScreenScale(13) - airgap, bars_size_x, airgap + ScreenScale(3), Color(30,30,30,150))
    -- HP
    local hp_bar_size_y = airgap - ScreenScale(2)
    local hp_perc = math.min(1, vhp / vmaxhp)
    local hpbars_size_x = math.floor((bars_size_x - ScreenScale(2)) * hp_perc)

    --[[draw_rect(bars_pos_x,
    size_y - ScreenScale(9) - airgap,
    hpbars_size_x,
    hp_bar_size_y,
    health_color)]]

    --[[if vhp / vmaxhp > 1 then
        draw_rect(bars_pos_x,
        size_y - ScreenScale(9) - airgap,
        hpbars_size_x * math.min(1, (vhp / vmaxhp) - 1),
        hp_bar_size_y,
        extra_health_color)
    end]]

    local TEMP = math.Clamp(vmaxhp / 50, 1, 4)
    local hp_bars_count = math.ceil(TEMP)

    local hp_bars_pos_y = size_y - ScreenScale(9) - airgap

    if hp_bars_count != 1 then
        local vhp_2 = vhp
        local Horde_SlowHealHP
        if !ply.Horde_HealHPRemain_Max or vhp >= ply.Horde_HealHPRemain_Max then
            ply.Horde_HealHPRemain_Max = 0
            Horde_SlowHealHP = 0
        else
            Horde_SlowHealHP = ply.Horde_HealHPRemain_Max
        end

        local pos_x_mult = hp_bars_count / (vmaxhp / 50)
        for i = 1, hp_bars_count do
            local remain_hp = i != hp_bars_count and 50 or (vmaxhp % 50) == 0 and 50 or (vmaxhp % 50)
            hp_perc = math.min(1, vhp_2 / remain_hp)

            local bar_cut_by = (50 / remain_hp)

            
            local pos_x = math.ceil(bars_pos_x + (bars_size_x - ScreenScale(2)) / hp_bars_count * (i - 1) * pos_x_mult)
            local hr_bar_size_x = math.ceil((bars_size_x - ScreenScale(2)) / hp_bars_count * hp_perc * pos_x_mult / bar_cut_by)
            
            if vhp_2 != 0 then
                draw_rect(pos_x, hp_bars_pos_y, hr_bar_size_x, hp_bar_size_y, health_color)

                vhp_2 = math.max(0, vhp_2 - 50)
            end

            if vhp_2 == 0 and Horde_SlowHealHP >= 50 * (i - 1) then
                draw_rect(math.ceil(pos_x + hr_bar_size_x),
                hp_bars_pos_y,
                math.ceil(
                    ((bars_size_x - ScreenScale(2)) / hp_bars_count * pos_x_mult) * math.min(1, (Horde_SlowHealHP - 50 * (i - 1)) / remain_hp) / bar_cut_by
                ) - hr_bar_size_x
                ,
                hp_bar_size_y,
                Color(199, 199, 199, 204))

                --Horde_SlowHealHP = Horde_SlowHealHP + old_vhp_2 - remain_hp
            end

            if i != 1 then
                draw_rect(pos_x - ScreenScale(1), hp_bars_pos_y, ScreenScale(1), hp_bar_size_y, Color(0,0,0,255))
            end
        end

        if vhp > vmaxhp then
            vhp_2 = vhp - vmaxhp
            for i = 1, hp_bars_count do
                local remain_hp = i != hp_bars_count and 50 or (vmaxhp % 50) == 0 and 50 or (vmaxhp % 50)
                local bar_cut_by = (50 / remain_hp)
                hp_perc = math.min(1, vhp_2 / remain_hp)
                local pos_x = bars_pos_x + (bars_size_x - ScreenScale(2)) / hp_bars_count * (i - 1) * pos_x_mult
                local hr_bar_size_x = (bars_size_x - ScreenScale(2)) / hp_bars_count * hp_perc * pos_x_mult / bar_cut_by
                if vhp_2 != 0 then
                    draw_rect(pos_x, hp_bars_pos_y, hr_bar_size_x, hp_bar_size_y, extra_health_color)

                    vhp_2 = math.max(0, vhp_2 - 50)
                end

                if i != 1 then
                    draw_rect(pos_x - ScreenScale(1), hp_bars_pos_y, ScreenScale(1), hp_bar_size_y, Color(0,0,0,255))
                end
            end
        end
    else
        draw_rect(bars_pos_x, hp_bars_pos_y, (bars_size_x - ScreenScale(2)) * hp_perc, hp_bar_size_y, health_color)
    end

    --for i = 1, (separator_count - 1) do
    --    draw_rect(bars_pos_x + (bars_size_x - ScreenScale(2)) / separator_count * i + right_rel - ScreenScale(1), hp_bars_pos_y, ScreenScale(1), hp_bar_size_y, Color(0,0,0,255))
    --end

    -- Black
    surface.SetDrawColor(Color(0,0,0,255))

    surface.DrawRect(bars_pos_x - ScreenScale(1), hp_bars_pos_y, bars_size_x, ScreenScale(1))
    surface.DrawRect(bars_pos_x - ScreenScale(1), size_y - ScreenScale(11), bars_size_x, ScreenScale(1))
    surface.DrawRect(bars_pos_x - ScreenScale(1), size_y - ScreenScale(13) - airgap, bars_size_x, ScreenScale(1))

    surface.DrawRect(bars_pos_x - ScreenScale(1), size_y - ScreenScale(13) - airgap, ScreenScale(1), airgap + ScreenScale(3))
    surface.DrawRect(bars_pos_x + bars_size_x - ScreenScale(2), size_y - ScreenScale(13) - airgap, ScreenScale(1), airgap + ScreenScale(3))
    -- ARMOR
    local pos_y = size_y - ScreenScale(12) - airgap

    
    local armor_bars_count = math.Clamp(math.ceil(vmaxarmor / 50), 1, 4)

    if armor_bars_count != 1 then
        local pos_x_mult = armor_bars_count / math.Clamp(vmaxarmor / 50, 1, 4)

        for i = 1, armor_bars_count do
            if varmor > 0 then
                local remain_armor = i != armor_bars_count and 50 or (vmaxarmor % 50) == 0 and 50 or (vmaxarmor % 50)
                local bar_cut_by = (50 / remain_armor)

                local armor_perc = math.min(1, varmor / remain_armor)
                local armor_bar_size = (bars_size_x - ScreenScale(2)) * armor_perc / armor_bars_count * pos_x_mult / bar_cut_by

                draw_rect(bars_pos_x + (bars_size_x - ScreenScale(2)) / armor_bars_count * (i - 1) * pos_x_mult, pos_y, armor_bar_size, armor_field_size, armor_color_real)

                varmor = varmor - 50
            end
            if i != 1 then
                draw_rect(bars_pos_x + (bars_size_x - ScreenScale(2)) / armor_bars_count * (i - 1) * pos_x_mult - ScreenScale(1), pos_y, ScreenScale(1), armor_field_size, Color(0,0,0,255))
            end
        end
    else
        local armor_perc = math.min(1, varmor / vmaxarmor)
        draw_rect(bars_pos_x, pos_y, (bars_size_x - ScreenScale(2)) * armor_perc, armor_field_size, armor_color_real)
    end
    
    local subclass = HORDE.subclasses[ply:Horde_GetCurrentSubclass()]
    if not subclass then subclass = HORDE.subclasses[HORDE.Class_Survivor] end
    local display_name = subclass.PrintName
    local class_icon = Material(subclass.Icon, "mips smooth")
    local level = ply:Horde_GetLevel(display_name)
    local rank, rank_level = HORDE:LevelToRank(level)
    
    local class_icon_s = ScreenScale(13)
    local class_icon_x = airgap + ScreenScale(4)
    local class_icon_y = size_y - airgap - ScreenScale(13)

    surface.SetMaterial(class_icon)
    surface.SetDrawColor(HORDE.Rank_Colors[rank])
    surface.DrawTexturedRect(class_icon_x, class_icon_y, class_icon_s, class_icon_s)
    if rank == HORDE.Rank_Master then
        draw.SimpleText(rank_level, "Trebuchet18", class_icon_x, class_icon_y, HORDE.Rank_Colors[rank], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        if rank_level > 0 then
            local star = Material("star.png", "mips smooth")
            surface.SetMaterial(star)
            local x_pos = class_icon_x
            local y_pos = class_icon_y + ScreenScale(12)
            for i = 0, rank_level - 1 do
                surface.DrawTexturedRect(x_pos - ScreenScale(3), y_pos, ScreenScale(4), ScreenScale(4))
                y_pos = y_pos - ScreenScale(3)
            end
        end
    end

    -- NICKNAME
    draw.SimpleTextOutlined(ply:LongName(), fontplayername, class_icon_x + class_icon_s + ScreenScale(20), size_y - ScreenScale(9.5), color_white, nil, nil, 1, Color( 68, 68, 68))
    
    -- WEAPON AND AMMO
    draw.SimpleTextOutlined(ply:Horde_GetMoney() .. "$", fontweight, ScreenScale(32), icon_y + ScreenScale(12), color_white, nil, nil, 1, Color( 68, 68, 68))

    surface.SetMaterial(weight)
    surface.SetDrawColor(color_white)
    local wx = size_x - ScreenScale(52)
    local wy = icon_y + ScreenScale(11)
    surface.DrawTexturedRect(wx, wy, ScreenScale(10), ScreenScale(10))

    draw.SimpleText(tostring(ply:Horde_GetMaxWeight() - ply:Horde_GetWeight()) .. "/" .. tostring(ply:Horde_GetMaxWeight()), fontweight, wx, wy + ScreenScale(1), color_white, TEXT_ALIGN_RIGHT)

    if ply != MySelf then

        local wpn = ply:GetActiveWeapon()
        if IsValid(wpn) then

            local pos_y = icon_y + ScreenScale(12)--ScreenScale(21)--size_y - ScreenScale(1)
            local pos_x = ScreenScale(36)
            local ammo_type = wpn:GetPrimaryAmmoType()
            local has_ammo = ammo_type > 0
            local clip1 = wpn:Clip1()
            local maxclip1 = wpn:GetMaxClip1()
            local has_clip = maxclip1 > 0
            if has_ammo or has_clip then
                local curammo = ply:GetAmmoCount(ammo_type)
                if has_clip then
                    draw.SimpleText(tostring(clip1), fontweight, pos_x, pos_y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
                    if has_ammo then
                        draw.SimpleText("/", fontweight, pos_x + ScreenScale(1), pos_y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                    end
                end
                if has_ammo then
                    local curammo_x = pos_x - ScreenScale(has_clip and -4 or 3)
                    local text_size_x, text_size_y =
                    draw.SimpleText(tostring(curammo), has_clip and font3 or fontweight, curammo_x, pos_y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                    pos_x = math.max(curammo_x + text_size_x + ScreenScale(1), pos_x)
                end
            else
                pos_x = pos_x + ScreenScale(2)
            end
            draw.SimpleText(wpn:GetPrintName(), fontweight, pos_x + ScreenScale(4), pos_y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end

        if ply:Horde_GetGadget() ~= nil then
            local gadget = ply:Horde_GetGadget()
            local charge = ply:Horde_GetGadgetCharges()
            local cd = ply:Horde_GetGadgetInternalCooldown()
            local x = size_x - ScreenScale(38)
            local y = size_y - ScreenScale(33)
            local s = ScreenScale(20) + airgap
            draw.RoundedBox(10, x, y, s, s, Color(40,40,40,150))

            local mat = Material(HORDE.gadgets[gadget].Icon, "mips smooth")
            surface.SetMaterial(mat) -- Use our cached material
            if HORDE.gadgets[gadget].Active then
                if HORDE.gadgets[gadget].Once then
                    surface.SetDrawColor(HORDE.color_gadget_once)
                else
                    surface.SetDrawColor(HORDE.color_gadget_active)
                end
            else
                surface.SetDrawColor(color_white)
            end
            surface.DrawTexturedRect(x - ScreenScale(17), y - ScreenScale(2), ScreenScale(60), ScreenScale(30))

            if cd > 0 then
                draw.RoundedBox(10, x, y, s, s, Color(40,40,40,225))
                surface.SetDrawColor(color_white)
                draw.SimpleText(cd, font, x + s/2, y + s/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            if charge >= 0 then
                draw.SimpleText(charge, fontweight, x + s - ScreenScale(5), y + ScreenScale(5), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
end

vgui.Register("HealthGUI_PlayerStats", PANEL, "Panel")

hook.Add("Think", "Horde_ProceedHealthGUI", function ()
    if GetConVarNumber("horde_enable_health_gui") != 1 then return end
    for _, ply in pairs(player.GetAll()) do
        if !ply.Horde_HealthGUI and (count_of_GUIs < (MySelf.Horde_HealthGUI and 6 or 5) or MySelf == ply ) then
            local HpGUI = vgui.Create("HealthGUI_PlayerStats")
            HpGUI.ply = ply
            HpGUI:Calculate_Data()
        end
    end
end)

hook.Add("HUDPaint", "Horde_DrawHud", function ()
    if GetConVarNumber("horde_enable_client_gui") == 0 then return end
    local colhp = Color(255, 255, 255, 255)
    local airgap = ScreenScale(6)
    
    local icon_x = airgap + ScreenScale(55)
    local icon_y = ScrH() - airgap - ScreenScale(27)
    

    if GetConVarNumber("horde_enable_ammo_gui") == 1 then
        -- Draw Ammo
        draw.RoundedBox(10, ScrW() - airgap - ScreenScale(78), ScrH() - ScreenScale(33) - airgap, airgap + ScreenScale(70), ScreenScale(26) + airgap, Color(40,40,40,150))

        local wpn = MySelf:GetActiveWeapon()
        if wpn and wpn:IsValid() then
            if wpn.Base == "horde_spell_weapon_base" then
                draw.SimpleText(wpn:GetPrintName(), font3, ScrW() - ScreenScale(82), icon_y + ScreenScale(3), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                
                -- Spell Icons
                surface.SetDrawColor(Color(255,255,255))
                surface.DrawOutlinedRect(ScrW() - ScreenScale(81), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15), 2)
                surface.DrawOutlinedRect(ScrW() - ScreenScale(63), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15), 2)
                surface.DrawOutlinedRect(ScrW() - ScreenScale(44), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15), 2)
                surface.DrawOutlinedRect(ScrW() - ScreenScale(26), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15), 2)

                draw.SimpleText("LMB", "Horde_SpellButton", ScrW() - ScreenScale(74), icon_y + ScreenScale(27), c1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("RMB", "Horde_SpellButton", ScrW() - ScreenScale(56), icon_y + ScreenScale(27), c1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("F", "Horde_SpellButton", ScrW() - ScreenScale(37), icon_y + ScreenScale(27), c1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("R", "Horde_SpellButton", ScrW() - ScreenScale(19), icon_y + ScreenScale(27), c1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                
                if MySelf:Horde_GetPrimarySpell() then
                    local spell = MySelf:Horde_GetPrimarySpell()
                    surface.SetMaterial(Material(spell.Icon, "mips smooth"))
                    surface.DrawTexturedRect(ScrW() - ScreenScale(81), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15))
                    local t = MySelf:Horde_GetPrimarySpellCooldown()
                    if t > 0 then
                        surface.SetDrawColor(Color(40,40,40, 200))
                        surface.DrawRect(ScrW() - ScreenScale(81), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15))
                        surface.SetDrawColor(color_white)
                        draw.SimpleText(string.format("%.1f", t), "Horde_SpellCooldown", ScrW() - ScreenScale(74), icon_y + ScreenScale(15), c1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    local c = Color(0,255,0)
                    if MySelf:Horde_GetMind() < spell.Mind[1] then
                        c = Color(200, 0, 0)
                    end
                    draw.SimpleTextOutlined(spell.Mind[1], "Horde_SpellMindCost", ScrW() - ScreenScale(67), icon_y + ScreenScale(20), c, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
                else
                    surface.SetMaterial(mind)
                end

                if MySelf:Horde_GetSecondarySpell() then
                    local spell = MySelf:Horde_GetSecondarySpell()
                    surface.SetMaterial(Material(spell.Icon, "mips smooth"))
                    surface.DrawTexturedRect(ScrW() - ScreenScale(63), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15))
                    local t = MySelf:Horde_GetSecondarySpellCooldown()
                    if t > 0 then
                        surface.SetDrawColor(Color(40,40,40, 200))
                        surface.DrawRect(ScrW() - ScreenScale(63), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15))
                        surface.SetDrawColor(color_white)
                        draw.SimpleText(string.format("%.1f", t), "Horde_SpellCooldown", ScrW() - ScreenScale(56), icon_y + ScreenScale(15), c1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    local c = Color(0,255,0)
                    if MySelf:Horde_GetMind() < spell.Mind[1] then
                        c = Color(200, 0, 0)
                    end
                    draw.SimpleTextOutlined(spell.Mind[1], "Horde_SpellMindCost", ScrW() - ScreenScale(49), icon_y + ScreenScale(20), c, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
                else
                    surface.SetMaterial(mind)
                end

                if MySelf:Horde_GetUtilitySpell() then
                    local spell = MySelf:Horde_GetUtilitySpell()
                    surface.SetMaterial(Material(spell.Icon, "mips smooth"))
                    surface.DrawTexturedRect(ScrW() - ScreenScale(44), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15))
                    local t = MySelf:Horde_GetUtilitySpellCooldown()
                    if t > 0 then
                        surface.SetDrawColor(Color(40,40,40, 200))
                        surface.DrawRect(ScrW() - ScreenScale(44), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15))
                        surface.SetDrawColor(color_white)
                        draw.SimpleText(string.format("%.1f", t), "Horde_SpellCooldown", ScrW() - ScreenScale(37), icon_y + ScreenScale(15), c1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    local c = Color(0,255,0)
                    if MySelf:Horde_GetMind() < spell.Mind[1] then
                        c = Color(200, 0, 0)
                    end
                    draw.SimpleTextOutlined(spell.Mind[1], "Horde_SpellMindCost", ScrW() - ScreenScale(30), icon_y + ScreenScale(20), c, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
                else
                    surface.SetMaterial(mind)
                end

                if MySelf:Horde_GetUltimateSpell() then
                    local spell = MySelf:Horde_GetUltimateSpell()
                    surface.SetMaterial(Material(spell.Icon, "mips smooth"))
                    surface.DrawTexturedRect(ScrW() - ScreenScale(26), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15))
                    local t = MySelf:Horde_GetUltimateSpellCooldown()
                    if t > 0 then
                        surface.SetDrawColor(Color(40,40,40, 200))
                        surface.DrawRect(ScrW() - ScreenScale(26), icon_y + ScreenScale(8), ScreenScale(15), ScreenScale(15))
                        surface.SetDrawColor(color_white)
                        draw.SimpleText(string.format("%.1f", t), "Horde_SpellCooldown", ScrW() - ScreenScale(19), icon_y + ScreenScale(15), c1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    local c = Color(0,255,0)
                    if MySelf:Horde_GetMind() < spell.Mind[1] then
                        c = Color(200, 0, 0)
                    end
                    draw.SimpleTextOutlined(spell.Mind[1], "Horde_SpellMindCost", ScrW() - ScreenScale(12), icon_y + ScreenScale(20), c, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
                else
                    surface.SetMaterial(mind)
                end

            else
                if MySelf:Horde_GetInfusion(wpn:GetClass()) ~= HORDE.Infusion_None then
                    local infusion = MySelf:Horde_GetInfusion(wpn:GetClass())
                    local infusion_mat = Material(HORDE.Infusion_Icons[infusion], "mips smooth")
                    surface.SetMaterial(infusion_mat)
                    surface.SetDrawColor(HORDE.Infusion_Colors[infusion])
                    surface.DrawTexturedRect(ScrW() - ScreenScale(16), icon_y, ScreenScale(6), ScreenScale(6))
                end
                if (wpn:GetMaxClip1() > 0 or wpn:Clip1() > 0) and (wpn:GetMaxClip2() > 0 or wpn:Clip2() > 0) then
                    local c1 = color_white
                    local c2 = color_white
                    if wpn:Clip1() == 0 then c1 = Color(100,0,0) end
                    if wpn:Clip2() == 0 then c2 = Color(100,0,0) end
                    draw.SimpleText(tostring(wpn:Clip1() .. " / " .. MySelf:GetAmmoCount(wpn:GetPrimaryAmmoType())), font, ScrW() - ScreenScale(20), icon_y + ScreenScale(13), c1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(tostring(wpn:Clip2() .. " / " .. MySelf:GetAmmoCount(wpn:GetSecondaryAmmoType())), font2, ScrW() - ScreenScale(20), icon_y + ScreenScale(24), c2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(wpn:GetPrintName(), font3, ScrW() - ScreenScale(82), icon_y + ScreenScale(3), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                elseif (wpn:GetMaxClip1() > 0 or wpn:Clip1() > 0) then
                    local c1 = color_white
                    local c2 = color_white
                    if wpn:Clip1() == 0 then c1 = Color(100,0,0) end
                    if MySelf:GetAmmoCount(wpn:GetPrimaryAmmoType()) == 0 then c2 = Color(100,0,0) end
                    draw.SimpleText(tostring(wpn:Clip1()), font, ScrW() - ScreenScale(55), icon_y + ScreenScale(17), c1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(tostring(MySelf:GetAmmoCount(wpn:GetPrimaryAmmoType())), font2, ScrW() - ScreenScale(20), icon_y + ScreenScale(17), c2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(wpn:GetPrintName(), font3, ScrW() - ScreenScale(82), icon_y + ScreenScale(3), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                elseif (wpn:GetMaxClip2() > 0 or wpn:Clip2() > 0) then
                    local c1 = color_white
                    local c2 = color_white
                    if wpn:Clip2() == 0 then c1 = Color(100,0,0) end
                    if MySelf:GetAmmoCount(wpn:GetPrimaryAmmoType()) == 0 then c2 = Color(100,0,0) end
                    draw.SimpleText(tostring(wpn:Clip2()), font, ScrW() - ScreenScale(55), icon_y + ScreenScale(17), c1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(tostring(MySelf:GetAmmoCount(wpn:GetSecondaryAmmoType())), font2, ScrW() - ScreenScale(20), icon_y + ScreenScale(17), c2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(wpn:GetPrintName(), font3, ScrW() - ScreenScale(82), icon_y + ScreenScale(3), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                elseif wpn:GetPrimaryAmmoType() > 0 then
                    local c1 = color_white
                    local c2 = color_white
                    if wpn:Clip1() == 0 then c1 = Color(100,0,0) end
                    if MySelf:GetAmmoCount(wpn:GetPrimaryAmmoType()) == 0 then c2 = Color(100,0,0) end
                    --draw.SimpleText(tostring(wpn:Clip1()), font, ScrW() - ScreenScale(55), icon_y + ScreenScale(17), c1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(tostring(MySelf:GetAmmoCount(wpn:GetPrimaryAmmoType())), font2, ScrW() - ScreenScale(45), icon_y + ScreenScale(17), c2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(wpn:GetPrintName(), font3, ScrW() - ScreenScale(82), icon_y + ScreenScale(3), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(wpn:GetPrintName(), font3, ScrW() - ScreenScale(47), icon_y + ScreenScale(15), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end
        end

        -- Draw Gadget
        if MySelf:Horde_GetGadget() ~= nil then
            local gadget = MySelf:Horde_GetGadget()
            local charge = MySelf:Horde_GetGadgetCharges()
            local cd = MySelf:Horde_GetGadgetInternalCooldown()
            local x = ScrW() - airgap - ScreenScale(78) - ScreenScale(33)
            local y = ScrH() - ScreenScale(33) - airgap
            local s = ScreenScale(26) + airgap
            draw.RoundedBox(10, x, y, s, s, Color(40,40,40,150))

            local mat = Material(HORDE.gadgets[gadget].Icon, "mips smooth")
            surface.SetMaterial(mat) -- Use our cached material
            if HORDE.gadgets[gadget].Active then
                if HORDE.gadgets[gadget].Once then
                    surface.SetDrawColor(HORDE.color_gadget_once)
                else
                    surface.SetDrawColor(HORDE.color_gadget_active)
                end
            else
                surface.SetDrawColor(color_white)
            end
            surface.DrawTexturedRect(x - ScreenScale(14), y + ScreenScale(1), ScreenScale(60), ScreenScale(30))

            if cd > 0 then
                draw.RoundedBox(10, x, y, s, s, Color(40,40,40,225))
                surface.SetDrawColor(color_white)
                draw.SimpleText(cd, font, x + s/2, y + s/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            if charge >= 0 then
                draw.SimpleText(charge, fontweight, x + s - ScreenScale(5), y + ScreenScale(5), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
end)


net.Receive("Horde_SyncEconomy", function(length)
    local ply = net.ReadEntity()
    local prev_money = ply.Horde_money or 0
    ply.Horde_money = net.ReadInt(32)
    HORDE:PlayMoneyNotification(ply.Horde_money - prev_money, ply.Horde_money, ply)
    ply.Horde_skull_tokens = net.ReadInt(32)
    ply.Horde_weight = net.ReadInt(32)

    local subclass = net.ReadString()
    local class = HORDE.subclasses_to_classes[subclass]
    ply.Horde_class = HORDE.classes[class]
    if not ply.Horde_subclasses then ply.Horde_subclasses = {} end
    ply.Horde_subclasses[class] = subclass
    ply.Horde_drop_entities = net.ReadTable()
end)

function HORDE:PlayMoneyNotification(diff, money, ply)
    if GetConVarNumber("horde_enable_ammo_gui") == 0 then return end
    if diff == 0 then return end
    local color = HORDE.color_crimson_dark
    local text = diff
    if diff > 0 then
        text = "+" .. diff .. "$"
        color = Color(50,205,50)
    else
        text = diff .. "$"
        color = HORDE.color_crimson_dim
    end

    local pos_x, pos_y = ply.Horde_HealthGUI:GetPos()
    local size_x, size_y = ply.Horde_HealthGUI:GetSize()
    
    local main = vgui.Create("DPanel")
    local x = ScreenScale(2) -- 35
    local y_start = pos_y + size_y - ScreenScale(27) -- 322
    local h = ScreenScale(10)
    main:SetSize(ScreenScale(66), h)
    main:SetPos(x, y_start)
    main.Paint = function ()
        draw.SimpleTextOutlined(text, fontweight, ScreenScale(33), 0, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0, Color(40, 40, 40, 200))
    end
    local anim = Derma_Anim("Linear", main, function(pnl, anim, delta, data)
        pnl:SetAlpha(delta * 255)
    end)
    main.Think = function(self)
        if anim:Active() then
            anim:Run()
        end
    end
    anim:Start(0.5) -- Animate for two seconds
    if anim:Active() then
        anim:Run()
    end
    timer.Simple(0.75, function ()
        local anim2 = Derma_Anim("Linear", main, function(pnl, anim, delta, data)
            pnl:SetAlpha(255 - delta * 255)
            pnl:SetPos(x + ScreenScale(20) * delta, y_start)
        end)
        anim2:Start(0.5)
        if anim2:Active() then
            anim2:Run()
        end
        main.Think = function(self)
            if anim2:Active() then
                anim2:Run()
            end
        end
        timer.Simple(0.5, function ()
            display_money = money
            main:Remove()
        end)
    end)
end