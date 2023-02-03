
-- FROM ARCCW

local function MyDrawText(tbl)
    local x = tbl.x
    local y = tbl.y
    surface.SetFont(tbl.font)

    if tbl.alpha then
        tbl.col.a = tbl.alpha
    else
        tbl.col.a = 255
    end

    if tbl.align or tbl.yalign then
        local w, h = surface.GetTextSize(tbl.text)
        if tbl.align == 1 then
            x = x - w
        elseif tbl.align == 2 then
            x = x - (w / 2)
        end
        if tbl.yalign == 1 then
            y = y - h
        elseif tbl.yalign == 2 then
            y = y - h / 2
        end
    end

    if tbl.shadow then
        surface.SetTextColor(Color(0, 0, 0, tbl.alpha or 255))
        surface.SetTextPos(x, y)
        surface.SetFont(tbl.font .. "_Glow")
        surface.DrawText(tbl.text)
    end

    surface.SetTextColor(tbl.col)
    surface.SetTextPos(x, y)
    surface.SetFont(tbl.font)
    surface.DrawText(tbl.text)
end

HORDE.Syringe = {}

local function start_regen_syringes(wep)
    local timername = "Horde_Wep_" .. wep:EntIndex() .. "regen_syrg"
    if timer.Exists(timername) then return end
    timer.Create(timername, 0.15, 0, function()
        if IsValid(wep) then
            local syringes = wep.Horde_Medic_SyringeCount
            if syringes < 100 then
                wep.Horde_Medic_SyringeCount = syringes + 4
                if wep.Horde_Medic_SyringeCount > 100 then
                    wep.Horde_Medic_SyringeCount = 100
                end
                return
            end
        end
        timer.Remove(timername)
    end)
end

local syringe_picture = Material("syringe_icon.png", "mips smooth")

function HORDE.Syringe:ApplyMedicSkills(wep, hptoheal)
    if string.sub(wep.Base, 1, 6) != "arccw_" then return end
    wep.Horde_Medic_SyringeCount = 100
    function wep:ChangeFiremode(pred)
        if self.Horde_Medic_SyringeCount < 50 then return end
        if !self.CanBash and !self:GetBuff_Override("Override_CanBash") then return end
        self.Horde_Medic_SyringeCount = self.Horde_Medic_SyringeCount - 50
        start_regen_syringes(self)
        if CLIENT then return end
        local ply = self:GetOwner()
		local tr = util.TraceHull({
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 5000,
			filter = {ply},
			mins = Vector(-16, -16, -8),
			maxs = Vector(16, 16, 8),
			mask = MASK_SHOT_HULL
		})
        
        if tr.Hit then
            local effectdata = EffectData()
            effectdata:SetOrigin(tr.HitPos)
            effectdata:SetRadius(50)
            util.Effect("heal_mist", effectdata)

            for _, ent in pairs(ents.FindInSphere(tr.HitPos, 100)) do
                if ent:IsPlayer() then
                    local healinfo = HealInfo:New({amount = hptoheal, healer = ply, immediately = false})
                    HORDE:OnPlayerHeal(ent, healinfo)
                elseif ent:GetClass() == "npc_vj_horde_antlion" then
                    local healinfo = HealInfo:New({amount = 10, healer = self.Owner})
                    HORDE:OnAntlionHeal(ent, healinfo)
                elseif ent:IsNPC() then
                    local dmg = DamageInfo()
                    dmg:SetDamage(25)
                    dmg:SetDamageType(DMG_NERVEGAS)
                    dmg:SetAttacker(ply)
                    dmg:SetInflictor(self)
                    dmg:SetDamagePosition(tr.HitPos)
                    ent:TakeDamageInfo(dmg)
                end
            end
        end

        ply:EmitSound("horde/weapons/mp7m/heal.ogg", 125, 100, 1, CHAN_AUTO)

        return true
    end
    if CLIENT then
        local data = {
            ["x"] = 5,
            ["y"] = 5,
            text = 50,
            font = "ArcCW_16",
            col = Color(255, 255, 255),
            align = 1,
            shadow = true,
            alpha = 255,
        }
        function wep:Hook_DrawHUD()
            local x, y = ScrW() - 95, ScrH() - 270
            data.x, data.y, data.text = x, y - 2, self.Horde_Medic_SyringeCount
            MyDrawText(data)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial( syringe_picture )
            surface.DrawTexturedRect( x + 25, y, 50, 50 )
        end
    end
end