function HealInfo:IsImmediately()
    return self.immediately != false
end

function HealInfo:SetImmediately(immediately)
    self.immediately = immediately
end

function HealInfo:GetDelay()
    return self.delay or 0.11
end

function HealInfo:SetDelay(delay)
    self.delay = delay
end

local plymeta = FindMetaTable("Player")

function plymeta:Horde_GetTotalHP()
	return math.min(self:Health() + (self.Horde_HealHPRemain or 0), self.Horde_HealLastMaxHealth)
end

util.AddNetworkString("Horde_SlowHeal_Proceed")

function HORDE:Horde_SendSlowHealData(ply, hp)
    if !ply.Horde_HealHPRemain or ply.Horde_HealHPRemain < 1 then return end
    net.Start("Horde_SlowHeal_Proceed")
    net.WriteEntity(ply)
    net.WriteInt(math.floor(ply.Horde_HealHPRemain + (hp or ply:Health())), 10)
    net.Broadcast()
end

function HORDE:Horde_SendStopSlowHeal(ply)
    net.Start("Horde_SlowHeal_Proceed")
    net.WriteEntity(ply)
    net.WriteInt(0, 10)
    net.Broadcast()
end

function HORDE:Horde_HealBy(ply, hp, maxhealth_limit)
    if !IsValid(ply) or !hp then return end
    if maxhealth_limit then
        ply:SetHealth(math.min(ply:GetMaxHealth(), ply:Health() + hp))
    else
        ply:SetHealth(ply:Health() + hp)
    end
    HORDE:Horde_SendSlowHealData(ply)
end

function HORDE:Horde_SetHealth(ply, hp)
    ply:SetHealth(hp)
    HORDE:Horde_SendSlowHealData(ply)
end

hook.Add("Horde_OnPlayerDamageTakenPost", "Horde_SlowHeal_Proceed", function(ply, dmg, bonus)
    if ply.Horde_HealHPRemain and ply.Horde_HealHPRemain >= 1 then
        HORDE:Horde_SendSlowHealData(ply, ply:Health() - dmg:GetDamage())
    end
end)

function plymeta:Horde_SlowHeal(amount, healinfo, overhealmult)

    overhealmult = overhealmult or 1 + healinfo:GetOverHealPercentage()
    
	if hook.Run("Horde_SlowHeal_NotAllow", self, amount, overhealmult) then return end

    --------------------> setup vars
    
    local maxhealth = self:GetMaxHealth() * overhealmult
    local lastmaxhealth = self.Horde_HealLastMaxHealth
    local health

    --------------------> setup vars
    local remainhp = self.Horde_HealHPRemain
    if !remainhp or remainhp < 0 then
        remainhp = 0
    end
    self.Horde_HealHPRemain = remainhp + amount
    
    local timer_obj
    if !self.Horde_HealTimer or !self.Horde_HealTimer:IsValid() then
        timer_obj = HORDE.Timers:New({
            linkwithent = self,
            timername = "Horde_" .. self:EntIndex() .. "SlowlyHeal",
            ResetStats = function()
                timer_obj.delay = timer_obj.vars_on_init.delay
                self.Horde_HealLastMaxHealth = nil
                self.Horde_HealHPRemain = 0
                HORDE:Horde_SendStopSlowHeal(self)
            end,
            --OnStop = function()
            --    HORDE:Horde_SendStopSlowHeal(self)
            --end,
            func = function(timerobj)
                remainhp = self.Horde_HealHPRemain
                if IsValid(self) and remainhp and remainhp >= 1 then
                    health = self:Health()
                    if health < self.Horde_HealLastMaxHealth then
                        self.Horde_HealHPRemain = remainhp - 1
                        self:SetHealth(health + 1)
                        return
                    end
                end
                timerobj:Stop()
                timerobj.ResetStats()
            end,
            callfunconstart = true,
            delay = HealInfo:GetDelay()
        })
        self.Horde_HealTimer = timer_obj
    else
        timer_obj = self.Horde_HealTimer
    end

    local is_update_timer = false

    if !lastmaxhealth or lastmaxhealth < maxhealth then
        self.Horde_HealLastMaxHealth = maxhealth
        is_update_timer = true
    end

    if healinfo:GetDelay() < timer_obj.delay then
        timer_obj:SetDelay(healinfo:GetDelay())
        is_update_timer = true
    end

    if is_update_timer or !timer_obj:TimerExists() or timer_obj:IsStopped() then
        timer_obj:UpdateTimer()
    end

    HORDE:Horde_SendSlowHealData(self)

    hook.Run("Horde_SlowHeal_Post", self, amount, overhealmult)
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
        if healinfo:IsImmediately() == false then
            ply:Horde_SlowHeal(heal_bonus * healinfo:GetHealAmount(), healinfo, maxhealth_mult)
        else
            HORDE:Horde_SetHealth(ply, math.min(
                ply:GetMaxHealth() * maxhealth_mult,
                ply:Health() + heal_bonus * healinfo:GetHealAmount()
            ))
        end
    else
        if healinfo:IsImmediately() == false then
            ply:Horde_SlowHeal(healinfo:GetHealAmount(), healinfo, maxhealth_mult)
        else
            HORDE:Horde_SetHealth(ply, math.min(
                ply:GetMaxHealth() * maxhealth_mult,
                ply:Health() + healinfo:GetHealAmount()
            ))
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

