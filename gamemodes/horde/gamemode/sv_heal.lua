--Horde's healing framework
-- Healing is affected by skill bonuses and is logged.
util.AddNetworkString("Horde_RenderHealer")
include("sh_heal_syringe.lua")

HealInfo = {}
HealInfo.__index = HealInfo

function HealInfo:New(o)
    o = o or {}
    setmetatable(o, self)
    if o.immediately == nil then o.immediately = true end
    self.__index = self
    return o
end

function HealInfo:IsImmediately()
    return self.immediately
end

function HealInfo:SetImmediately(immediately)
    self.immediately = immediately
end

function HealInfo:SetHealAmount(amount)
    self.amount = amount
end

function HealInfo:GetHealAmount()
    return self.amount or 0
end

function HealInfo:SetHealer(healer)
    self.healer = healer
end

function HealInfo:GetHealer(healer)
    return self.healer
end

function HealInfo:SetOverHealPercentage(percentage)
    self.over_heal_percentage = percentage
end

function HealInfo:GetOverHealPercentage()
    return self.over_heal_percentage or 0
end

local plymeta = FindMetaTable("Player")

function plymeta:Horde_AddHealAmount(amount)
    if GetConVar("horde_enable_sandbox"):GetInt() == 1 then return end
    if not self.Horde_HealAmount then self.Horde_HealAmount = 0 end
    self.Horde_HealAmount = self.Horde_HealAmount + amount
    if self.Horde_HealAmount >= 100 then
        self.Horde_HealAmount = 0
        if HORDE.current_wave <= 0 then return end
		local class_name = self:Horde_GetClass().name
		if self:Horde_GetLevel(class_name) >= HORDE.max_level then return end
		self:Horde_SetExp(class_name, self:Horde_GetExp(class_name) + 1)
    end
end

function plymeta:Horde_GetTotalHP()
	return math.min(self:Health() + self.Horde_HealHPRemain, self.Horde_HealLastMaxHealth)
end

function plymeta:Horde_MakeSlowHeal(amount, overhealmult)
    local maxhealth = self:GetMaxHealth() * (overhealmult or 1)
    local health = self:Health()
    local remaintoheal = self.Horde_HealHPRemain or 0
    if amount + remaintoheal > maxhealth - health then
        amount = math.Round(maxhealth - health)
    end
    if amount == 0 then return false end
    self.Horde_HealHPRemain = remaintoheal + amount
    local timername = "Horde_" .. self:EntIndex() .. "SlowlyHeal"
	local lastmaxhealth = self.Horde_HealLastMaxHealth
    if not timer.Exists(timername) or lastmaxhealth and lastmaxhealth < maxhealth then
		self.Horde_HealLastMaxHealth = maxhealth
		self.Horde_HealHPRemain = self.Horde_HealHPRemain - 1
		self:SetHealth(health + 1)
        timer.Create(timername, 0.11, 0, function()
            if IsValid(self) then
                if self.Horde_HealHPRemain >= 1 then
                    health = self:Health()
                    if health < maxhealth then
                        self.Horde_HealHPRemain = self.Horde_HealHPRemain - 1
                        self:SetHealth(health + 1)
                        return
                    end
                end
                self.Horde_HealHPRemain = nil
            end
            timer.Remove(timername)
        end)
    end
    return true
end

-- Call this if you want Horde to recognize your healing
function HORDE:OnPlayerHeal(ply, healinfo, silent)
    if (ply.Horde_Debuff_Active and ply.Horde_Debuff_Active[HORDE.Status_Decay]) then return end
    if not ply:IsPlayer() then return end
    if not ply:Alive() then return end
    hook.Run("Horde_OnPlayerHeal", ply, healinfo)
    hook.Run("Horde_PostOnPlayerHeal", ply, healinfo)
	local maxhealth_mult = 1 + healinfo:GetOverHealPercentage()
    if (ply:GetMaxHealth() * maxhealth_mult <= ply:Health()) then return end
    
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:IsValid() then
		local heal_bonus = 1
		local curr_weapon = HORDE:GetCurrentWeapon(healer)
		if curr_weapon and curr_weapon:IsValid() and ply.Horde_Infusions then
			local infusion = ply.Horde_Infusions[curr_weapon:GetClass()]
			
			if infusion and infusion == HORDE.Infusion_Rejuvenating then
				heal_bonus = heal_bonus * 1.25
			end
		end
        if not healinfo:IsImmediately() then
            ply:Horde_MakeSlowHeal(heal_bonus * healinfo:GetHealAmount(), maxhealth_mult)
        else
            ply:SetHealth(
                math.min(
                    ply:GetMaxHealth() * maxhealth_mult,
                    ply:Health() + heal_bonus * healinfo:GetHealAmount()
                )
            )
        end
    else
        if not healinfo:IsImmediately() then
            ply:Horde_MakeSlowHeal(healinfo:GetHealAmount(), maxhealth_mult)
        else
            ply:SetHealth(
                math.min(
                    ply:GetMaxHealth() * maxhealth_mult,
                    ply:Health() + healinfo:GetHealAmount()
                )
            )
        end
        return
    end

    if not HORDE.player_heal[healer:SteamID()] then HORDE.player_heal[healer:SteamID()] = 0 end
    if healer:SteamID() ~= ply:SteamID() then
        HORDE.player_heal[healer:SteamID()] = HORDE.player_heal[healer:SteamID()] + healinfo:GetHealAmount()
    end

    if silent then
        healer:Horde_AddHealAmount(healinfo:GetHealAmount())
        return
    end
    ply:ScreenFade(SCREENFADE.IN, Color(50, 200, 50, 10), 0.3, 0)
    if healer ~= ply then
        healer:Horde_AddMoney(3)
        healer:Horde_SyncEconomy()
        net.Start("Horde_RenderHealer")
            net.WriteString(healer:GetName())
        net.Send(ply)

        healer:Horde_AddHealAmount(healinfo:GetHealAmount())
    end
end

function HORDE:SelfHeal(ply, amount)
    if amount <= 0 then return end
    local healinfo = HealInfo:New({amount=amount, healer=ply})
    HORDE:OnPlayerHeal(ply, healinfo)
end