if SERVER then
	AddCSLuaFile()
end

SWEP.Base = "arccw_mw2_abase"

DEFINE_BASECLASS(SWEP.Base)

if CLIENT then
	function SWEP:DoLHIKAnimation(key, time, spbitch)
		if !IsValid(self:GetOwner()) then return end
	
		if game.SinglePlayer() and !spbitch then
			timer.Simple(0, function() if IsValid(self) then self:DoLHIKAnimation(key, time, true) end end)
			return
		end
	
		local vm = self:GetOwner():GetViewModel()
		if !IsValid(vm) then return end
	
		local lhik_model
		local lhik_anim_model
		local LHIK_GunDriver
		local LHIK_CamDriver
		local offsetang
	
		local tranim = self:GetBuff_Hook("Hook_LHIK_TranslateAnimation", key)
	
		key = tranim or key
	
		for i, k in pairs(self.Attachments) do
			if !k.Installed then continue end
			if !k.VElement then continue end
	
			if self:GetBuff_Stat("LHIK", i) then
				lhik_model = k.VElement.Model
				lhik_anim_model = k.GodDriver and k.GodDriver.Model or false
				offsetang = k.VElement.OffsetAng
	
				if self:GetBuff_Stat("LHIK_GunDriver", i) then
					LHIK_GunDriver = self:GetBuff_Stat("LHIK_GunDriver", i)
				end
	
				if self:GetBuff_Stat("LHIK_CamDriver", i) then
					LHIK_CamDriver = self:GetBuff_Stat("LHIK_CamDriver", i)
				end
			end
		end
	
		if !IsValid(lhik_model) then return false end
	
		local seq = lhik_model:LookupSequence(key)
	
		if !seq then return false end
		if seq == -1 then return false end
	
		lhik_model:ResetSequence(seq)
		if IsValid(lhik_anim_model) then
			lhik_anim_model:ResetSequence(seq)
		end
		lhik_model:SetPlaybackRate(lhik_model:SequenceDuration(seq) / time)
	
		if !time or time < 0 then time = lhik_model:SequenceDuration(seq) end
	
		self.LHIKAnimation = seq
		self.LHIKAnimationStart = UnPredictedCurTime()
		self.LHIKAnimationTime = time
	
		self.LHIKAnimation_IsIdle = false
	
		if IsValid(lhik_anim_model) and LHIK_GunDriver then
			local att = lhik_anim_model:LookupAttachment(LHIK_GunDriver)
			local ang = lhik_anim_model:GetAttachment(att).Ang
			local pos = lhik_anim_model:GetAttachment(att).Pos
	
			self.LHIKGunAng = lhik_anim_model:WorldToLocalAngles(ang) - Angle(0, 90, 90)
			self.LHIKGunPos = lhik_anim_model:WorldToLocal(pos)
	
			self.LHIKGunAngVM = vm:WorldToLocalAngles(ang) - Angle(0, 90, 90)
			self.LHIKGunPosVM = vm:WorldToLocal(pos)
		end
	
		if IsValid(lhik_anim_model) and LHIK_CamDriver then
			local att = lhik_anim_model:LookupAttachment(LHIK_CamDriver)
			local ang = lhik_anim_model:GetAttachment(att).Ang
	
			self.LHIKCamOffsetAng = offsetang
			self.LHIKCamAng = lhik_anim_model:WorldToLocalAngles(ang)
		end
	
		-- lhik_model:SetCycle(0)
		-- lhik_model:SetPlaybackRate(dur / time)
	
		return true
	end
end

function SWEP:GetFiremodeName()
    if self:GetBuff_Hook("Hook_FiremodeName") then return self:GetBuff_Hook("Hook_FiremodeName") end

    local abbrev = GetConVar("arccw_hud_fcgabbrev"):GetBool() and ".abbrev" or ""

    --[[if self:GetInUBGL() then
        return self:GetBuff_Override("UBGL_PrintName") and self:GetBuff_Override("UBGL_PrintName") or ArcCW.GetTranslation("fcg.ubgl" .. abbrev)
    end]]

    local fm = self:GetCurrentFiremode()

    if fm.PrintName then
        local phrase = ArcCW.GetPhraseFromString(fm.PrintName)
        return phrase and ArcCW.GetTranslation(phrase .. abbrev) or ArcCW.TryTranslation(fm.PrintName)
    end

    local mode = fm.Mode
    if mode == 0 then return ArcCW.GetTranslation("fcg.safe" .. abbrev) end
    if mode == 1 then return ArcCW.GetTranslation("fcg.semi" .. abbrev) end
    if mode >= 2 then return ArcCW.GetTranslation("fcg.auto" .. abbrev) end
    if mode < 0 then return string.format(ArcCW.GetTranslation("fcg.burst" .. abbrev), tostring(-mode)) end
end

function SWEP:GetFiremodeBars()
    if self:GetBuff_Hook("Hook_FiremodeBars") then return self:GetBuff_Hook("Hook_FiremodeBars") end

    --[[if self:GetInUBGL() then
        return "____-"
    end]]

    local fm = self:GetCurrentFiremode()

    if fm.CustomBars then return fm.CustomBars end

    local mode = fm.Mode

    if mode == 0 then return "_____" end
    if mode == 1 then return "-____" end
    if mode >= 2 then return "-----" end
    if mode == -2 then return "--___" end
    if mode == -3 then return "---__" end
    if mode == -4 then return "----_" end

    return "-----"
end
do

	local translate = ArcCW.GetTranslation

	local function ScreenScaleMulti(input)
		return ScreenScale(input) * GetConVar("arccw_hud_size"):GetFloat()
	end

	local cvar_deadzonex, cvar_deadzoney
	local function CopeX()
		if !cvar_deadzonex then cvar_deadzonex = GetConVar("arccw_hud_deadzone_x") end
		return cvar_deadzonex:GetFloat() * ScrW() / 2
	end

	local function CopeY()
		if !cvar_deadzoney then cvar_deadzoney = GetConVar("arccw_hud_deadzone_y") end
		return cvar_deadzoney:GetFloat() * ScrH() / 2
	end

	local function MyDrawText(tbl)
		local x = tbl.x
		local y = tbl.y
		local dontbust = Color(tbl.col.r, tbl.col.g, tbl.col.b, tbl.col.a)
		surface.SetFont(tbl.font)

		if tbl.alpha then
			dontbust.a = tbl.alpha
		else
			dontbust.a = 255
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

		surface.SetTextColor(dontbust)
		surface.SetTextPos(x, y)
		surface.SetFont(tbl.font)
		surface.DrawText(tbl.text)
	end

	local vhp = 0
	local varmor = 0
	local vclip = 0
	local vreserve = 0
	local vclip2 = 0
	local vreserve2 = 0
	local vubgl = 0
	local lastwpn = ""
	local lastinfo = {ammo = 0, clip = 0, firemode = "", plus = 0}
	local lastinfotime = 0

	function SWEP:GetHUDData()
		local data = {
			clip = math.Round(vclip or self:Clip1()),
			ammo = math.Round(vreserve or self:Ammo1()),
			bars = self:GetFiremodeBars(),
			mode = self:GetFiremodeName(),
			ammotype = self.Primary.Ammo,
			ammotype2 = self.Secondary.Ammo,
			heat_enabled        = self:HeatEnabled(),
			heat_name           = translate("ui.heat"),
			heat_level          = self:GetHeat(),
			heat_maxlevel       = self:GetMaxHeat(),
			heat_locked         = self:GetHeatLocked(),
		}

		if data.clip > self:GetCapacity() then
			data.plus = data.clip - self:GetCapacity()
			data.clip = self:GetCapacity()
		end

		local infammo, btmless = self:HasInfiniteAmmo(), self:HasBottomlessClip()
		data.infammo = infammo
		data.btmless = btmless

		if self.PrimaryBash or self:Clip1() == -1 or self:GetCapacity() == 0 or self.Primary.ClipSize == -1 then
			data.clip = "-"
		end
		if self.PrimaryBash then
			data.ammo = "-"
		end

		if self:GetBuff_Override("UBGL") then
			data.clip2 = math.Round(vclip2 or self:Clip2())

			local ubglammo = self:GetBuff_Override("UBGL_Ammo")
			if ubglammo then
				data.ammo2 = tostring(math.Round(vreserve2 or self:GetOwner():GetAmmoCount(ubglammo)))
			end

			if data.clip2 > self:GetBuff_Override("UBGL_Capacity") then
				data.plus2 = (data.clip2 - self:GetBuff_Override("UBGL_Capacity"))
				data.clip2 = self:GetBuff_Override("UBGL_Capacity")
			end
		end

		do
			if infammo then
				data.ammo = btmless and data.ammo or "-"
				data.clip = self.Throwing and "∞" or data.clip
			end
			if btmless then
				data.clip = infammo and "∞" or data.ammo
				data.ammo = "-"
			end

			local ubglammo = self:GetBuff_Override("UBGL_Ammo")
			if ubglammo then
				data.ubgl = self:Clip2() + self:GetOwner():GetAmmoCount(ubglammo)
			end
		end

		data = self:GetBuff_Hook("Hook_GetHUDData", data) or data

		return data
	end

	local bird = Material("arccw/hud/really cool bird.png", "mips smooth")
	local statlocked = Material("arccw/hud/locked_32.png", "mips smooth")

	local bar_fill = Material("arccw/hud/fmbar_filled.png",           "mips smooth")
	local bar_outl = Material("arccw/hud/fmbar_outlined.png",         "mips smooth")
	local bar_shad = Material("arccw/hud/fmbar_shadow.png",           "mips smooth")
	local bar_shou = Material("arccw/hud/fmbar_outlined_shadow.png",  "mips smooth")

	local hp = Material("arccw/hud/hp.png", "smooth")
	local hp_shad = Material("arccw/hud/hp_shadow.png", "mips smooth")

	local armor = Material("arccw/hud/armor.png", "mips smooth")
	local armor_shad = Material("arccw/hud/armor_shadow.png", "mips smooth")
	local ubgl_mat = Material("arccw/hud/ubgl.png", "smooth")
	local bipod_mat = Material("arccw/hud/bipod.png", "smooth")

	function SWEP:DrawHUD()
		if GetConVar("arccw_dev_debug"):GetBool() then
			debug_panel(self)
		end

		if !GetConVar("cl_drawhud"):GetBool() then return false end

		if self:GetState() != ArcCW.STATE_CUSTOMIZE then
			self:GetBuff_Hook("Hook_DrawHUD")
		end

		local col2 = Color(255, 255, 255, 255)
		local col3 = Color(255, 0, 0, 255)

		local airgap = ScreenScaleMulti(8)

		local apan_bg = {
			w = ScreenScaleMulti(128),
			h = ScreenScaleMulti(48),
		}

		local data = self:GetHUDData()

		if data.heat_locked then
			col2 = col3
		end

		local curTime = CurTime()
		--local mode = self:GetFiremodeName()

		local muzz = self:GetBuff_Override("Override_MuzzleEffectAttachment") or self.MuzzleEffectAttachment or 1

		local fmbars = GetConVar("arccw_hud_fcgbars"):GetBool() and string.len( self:GetFiremodeBars() or "-----" ) != 0

		if ArcCW:ShouldDrawHUDElement("CHudAmmo") then
			local decaytime = GetConVar("arccw_hud_3dfun_decaytime"):GetFloat()
			if decaytime == 0 then decaytime = math.huge end
			local visible = (lastinfotime + decaytime + 1 > curTime or lastinfotime - 0.5 > curTime)

			-- Detect changes to stuff drawn in HUD
			local curInfo = {
				ammo = data.ammo,
				clip = data.clip,
				plus = data.plus or "0", -- data.plus is nil when it doesnt exist
				ammo2 = data.ammo2,
				clip2 = data.clip2,
				plus2 = data.plus2 or "0", -- data.plus is nil when it doesnt exist
				ammotype = data.ammotype,
				firemode = data.mode,
				heat = data.heat_level,
				self:GetInUBGL(),
				self:GetInBipod(),
				self:CanBipod(),
			}
			if GetConVar("arccw_hud_3dfun_lite"):GetBool() then
				curInfo.clip = nil
				curInfo.plus = nil
				curInfo.clip2 = nil
				curInfo.plus2 = nil
				curInfo.heat = nil
			end
			for i, v in pairs(curInfo) do
				if v != lastinfo[i] then
					lastinfotime = visible and (curTime - 0.5) or curTime
					lastinfo = curInfo
					break
				end
			end
			local qss = ScreenScaleMulti(24)
			local correct_y = 28
			local correct_x = 0
			if !GetConVar("arccw_hud_3dfun"):GetBool() then
				qss = ScreenScaleMulti(-24)
				correct_y = -36
				correct_x = 52
			end

			-- TODO: There's an issue where this won't ping the HUD when switching in from non-ArcCW weapons
			if LocalPlayer():KeyDown(IN_RELOAD) or lastwpn != self then lastinfotime = visible and (curTime - 0.5) or curTime end

			local alpha
			if lastinfotime + decaytime < curTime then
				alpha = 255 - (curTime - lastinfotime - decaytime) * 255
			elseif lastinfotime + 0.5 > curTime then
				alpha = 255 - (lastinfotime + 0.5 - curTime) * 255
			else
				alpha = 255
			end

			if alpha > 0 then

				local EyeAng = EyeAngles()

				local angpos
				if GetConVar("arccw_hud_3dfun"):GetBool() and self:GetOwner():ShouldDrawLocalPlayer() then
					local bone = "ValveBiped.Bip01_R_Hand"
					local ind = self:GetOwner():LookupBone(bone)

					if ind and ind > -1 then
						local p, a = self:GetOwner():GetBonePosition(ind)
						angpos = {Ang = a, Pos = p}
					end
				elseif GetConVar("arccw_hud_3dfun"):GetBool() then
					local vm = self:GetOwner():GetViewModel()

					if vm and vm:IsValid() then
						angpos = vm:GetAttachment(muzz)
					end
				end

				if GetConVar("arccw_hud_3dfun"):GetBool() and angpos then

					angpos.Pos = angpos.Pos - EyeAng:Up() * GetConVar("arccw_hud_3dfun_up"):GetFloat() - EyeAng:Right() * GetConVar("arccw_hud_3dfun_right"):GetFloat() - EyeAng:Forward() * GetConVar("arccw_hud_3dfun_forward"):GetFloat()
					cam.Start3D()
						local toscreen = angpos.Pos:ToScreen()
					cam.End3D()

					apan_bg.x = toscreen.x - apan_bg.w - ScreenScaleMulti(8)
					apan_bg.y = toscreen.y - apan_bg.h * 0.5
				else
					apan_bg.x = ScrW() - CopeX() - ScreenScaleMulti(128 + 8)
					apan_bg.y = ScrH() - CopeY() - ScreenScaleMulti(48)
				end

				apan_bg.x = math.Clamp(apan_bg.x, ScreenScaleMulti(8), ScrW() - CopeX() - ScreenScaleMulti(128 + 8))
				apan_bg.y = math.Clamp(apan_bg.y, ScreenScaleMulti(8), ScrH() - CopeY() - ScreenScaleMulti(48))

				if !fmbars then
					apan_bg.y = apan_bg.y + ScreenScaleMulti(6)
				end

				local corny = 22 * math.ease.OutSine(math.sin(vubgl * math.pi)) * (self:GetInUBGL() and -1 or 1)
				local ngap = 22 * vubgl
				local wammo = {
					x = apan_bg.x + apan_bg.w - airgap + ScreenScaleMulti(corny),
					y = apan_bg.y - ScreenScaleMulti(4) - ScreenScaleMulti(ngap),
					text = tostring(data.clip),
					font = "ArcCW_26",
					col = col2,
					align = 1,
					shadow = true,
					alpha = alpha,
				}

				wammo.col = col2

				if data.clip == 0 then
					wammo.col = col3
				end

				if tostring(data.clip) == "-" then
					wammo.text = ""
				end
					MyDrawText(wammo)
					wammo.w, wammo.h = surface.GetTextSize(wammo.text)
				surface.SetFont("ArcCW_26")

				if data.plus and !self:HasBottomlessClip() then
					local wplus = {
						x = wammo.x,
						y = wammo.y,
						text = "+" .. tostring(data.plus),
						font = "ArcCW_16",
						col = col2,
						shadow = true,
						alpha = alpha,
					}

					MyDrawText(wplus)
				end

				local wreserve = {
					x = wammo.x - wammo.w - ScreenScaleMulti(4),
					y = apan_bg.y + ScreenScaleMulti(10) - ScreenScaleMulti(ngap),
					text = tostring(data.ammo) .. " /",
					font = "ArcCW_12",
					col = col2,
					align = 1,
					yalign = 2,
					shadow = true,
					alpha = alpha,
				}

				if tonumber(data.ammo) and tonumber(data.clip) and tonumber(data.clip) >= self:GetCapacity() then
					wreserve.text = tostring(data.ammo) .. " |"
				end

				if self:GetPrimaryAmmoType() <= 0 then
					wreserve.text = "!"
				end

				if self.PrimaryBash then
					wreserve.text = ""
				end

				local drew = false
				local ungl = false
				if tostring(data.ammo) != "-" then
					drew = true
					MyDrawText(wreserve)
					surface.SetFont("ArcCW_12")
					wreserve.w, wreserve.h = surface.GetTextSize(wreserve.text)
				end

				if GetConVar("arccw_hud_3dfun_ammotype"):GetBool() and isstring(data.ammotype) then
					local wammotype = {
						x = wammo.x - wammo.w - ScreenScaleMulti(3),
						y = wammo.y + (wammo.h/2),
						text = language.GetPhrase(data.ammotype .. "_ammo"),
						font = "ArcCW_8",
						col = col2,
						align = 1,
						yalign = 2,
						shadow = true,
						alpha = alpha,
					}

					if drew then
						wammotype.x = wreserve.x - wreserve.w - ScreenScaleMulti(3)
						wammotype.y = wreserve.y-- + (wreserve.h/2)
					end

					MyDrawText(wammotype)
				end

				--ubgl
				if self:GetBuff_Override("UBGL") then
					ungl = true
					local ugap = 22 * (1-vubgl)
		
					local wammo = {
						x = apan_bg.x + apan_bg.w - airgap + ScreenScaleMulti(corny*-1),
						y = apan_bg.y - ScreenScaleMulti(4) - ScreenScaleMulti(ugap),
						text = tostring(data.clip2),
						font = "ArcCW_26",
						col = col2,
						align = 1,
						shadow = true,
						alpha = alpha,
					}
		
					wammo.col = col2
		
					if data.clip2 == 0 then
						wammo.col = col3
					end
		
					if tostring(data.clip2) != "-" then
						MyDrawText(wammo)
					end
					surface.SetFont("ArcCW_26")
					wammo.w, wammo.h = surface.GetTextSize(wammo.text)
		
					if data.plus2 and !self:HasBottomlessClip() then
						local wplus = {
							x = wammo.x,
							y = wammo.y,
							text = "+" .. tostring(data.plus2),
							font = "ArcCW_16",
							col = col2,
							shadow = true,
							alpha = alpha,
						}
		
						MyDrawText(wplus)
					end
		
					local wreserve = {
						x = wammo.x - wammo.w - ScreenScaleMulti(4),
						y = apan_bg.y + ScreenScaleMulti(10) - ScreenScaleMulti(ugap),
						text = tostring(data.ammo2) .. " /",
						font = "ArcCW_12",
						col = col2,
						align = 1,
						yalign = 2,
						shadow = true,
						alpha = alpha,
					}

					if tonumber(data.ammo2) and tonumber(data.clip2) and tonumber(data.clip2) >= self:GetBuff_Override("UBGL_Capacity") then
						wreserve.text = tostring(data.ammo2) .. " |"
					end

					if self:GetSecondaryAmmoType() <= 0 then
						wreserve.text = "!"
					end

					local drew = false
					if tostring(data.ammo2) != "-" then
						drew = true
						MyDrawText(wreserve)
						surface.SetFont("ArcCW_12")
						wreserve.w, wreserve.h = surface.GetTextSize(wreserve.text)
					end

					if GetConVar("arccw_hud_3dfun_ammotype"):GetBool() and isstring(data.ammotype) then
						local wammotype = {
							x = wammo.x - wammo.w - ScreenScaleMulti(3),
							y = wammo.y + (wammo.h/2),
							text = language.GetPhrase(data.ammotype2 .. "_ammo"),
							font = "ArcCW_8",
							col = col2,
							align = 1,
							yalign = 2,
							shadow = true,
							alpha = alpha,
						}
		
						if drew then
							wammotype.x = wreserve.x - wreserve.w - ScreenScaleMulti(3)
							wammotype.y = wreserve.y
						end
		
						MyDrawText(wammotype)
					end
				end

				local wmode = {
					x = apan_bg.x + apan_bg.w - airgap,
					y = apan_bg.y + ScreenScaleMulti(28),
					font = "ArcCW_12",
					text = data.mode,
					col = col2,
					align = 1,
					shadow = true,
					alpha = alpha,
				}
				if !fmbars then
					wmode.y = wmode.y - ScreenScaleMulti(6)
				end
				MyDrawText(wmode)

				-- overheat bar 3d
				if self:GetMalfunctionJam() then
					local col = Color(255, 0, 32)

					local wheat = { --cheeeeerios
						x = apan_bg.x + apan_bg.w - airgap,
						y = wmode.y + ScreenScaleMulti(16) * ( !GetConVar("arccw_hud_3dfun"):GetBool() and -2.5 or 1 ),
						font = "ArcCW_12",
						text = translate("ui.jammed"),
						col = col,
						align = 1,
						shadow = true,
						alpha = alpha,
					}
					if fmbars then
						wheat.y = wmode.y + ScreenScaleMulti(16) * ( !GetConVar("arccw_hud_3dfun"):GetBool() and -2.5 or 0.8 )
					end
					if ungl then
						wheat.y = wheat.y - ScreenScaleMulti(24)
					end

					local wheat_shad = {
						x = wheat.x,
						y = wheat.y,
						font = "ArcCW_12_Glow",
						text = wheat.text,
						col = col,
						align = 1,
						shadow = false,
						alpha = alpha,
					}
					MyDrawText(wheat_shad)

					MyDrawText(wheat)
				elseif data.heat_enabled then
					local pers = math.Clamp(1 - (data.heat_level / data.heat_maxlevel), 0, 1)
					local pers2 = math.Clamp(data.heat_level / data.heat_maxlevel, 0, 1)
					local colheat1 = data.heat_locked and Color(255, 0, 0) or Color(255, 128 + 127 * pers, 128 + 127 * pers)
					local colheat2 = data.heat_locked and Color(255, 0, 0) or Color(255 * pers2, 0, 0)

					local wheat = {
						x = apan_bg.x + apan_bg.w - airgap,
						y = wmode.y + ScreenScaleMulti(16) * ( !GetConVar("arccw_hud_3dfun"):GetBool() and -2.5 or 1 ),
						font = "ArcCW_12",
						text = data.heat_name .. " " .. tostring(math.floor(100 * data.heat_level / data.heat_maxlevel)) .. "%",
						col = colheat1,
						align = 1,
						shadow = false,
						alpha = alpha,
					}
					if fmbars then
						wheat.y = wmode.y + ScreenScaleMulti(16) * ( !GetConVar("arccw_hud_3dfun"):GetBool() and -2.5 or 0.8 )
					end
					if ungl then
						wheat.y = wheat.y - ScreenScaleMulti(24)
					end

					local wheat_shad = {
						x = wheat.x,
						y = wheat.y,
						font = "ArcCW_12_Glow",
						text = wheat.text,
						col = colheat2,
						align = 1,
						shadow = false,
						alpha = alpha * pers,
					}
					MyDrawText(wheat_shad)

					MyDrawText(wheat)
				end
				if self:CanBipod() or self:GetInBipod() then
					local size = ScreenScaleMulti(32)
					local awesomematerial = self:GetBuff_Override("Bipod_Icon", bipod_mat)
					local whatsthecolor =   self:GetInBipod() and     Color(255, 255, 255, alpha) or
											self:CanBipod() and   Color(255, 255, 255, alpha / 4) or Color(0, 0, 0, 0)
					local bar = {
						w = size,
						h = size,
						x = (ScrW()/2) - (size/2),
						y = ScrH() - CopeY() - ScreenScaleMulti(40),
					}
					surface.SetDrawColor( whatsthecolor )
					surface.SetMaterial( awesomematerial )
					surface.DrawTexturedRect( bar.x, bar.y, bar.w, bar.h )

					local txt = string.upper(ArcCW:GetBind("+use"))

					local bip = {
						shadow = true,
						x = bar.x + (bar.w/2),
						y = bar.y - ScreenScaleMulti(12),
						align = 2,
						font = "ArcCW_12",
						text = txt,
						col = whatsthecolor,
						alpha = alpha,
					}

					MyDrawText(bip)
				end

				if GetConVar("arccw_hud_togglestats") and GetConVar("arccw_hud_togglestats"):GetBool() then
				local items = {
				}
				--[[
				{
					Icon = "",
					Locked = false,
					Selected = 1,
					Toggles = {
						[1] = "",
						[2] = "",
						[3] = "",
					}
				}
				]]
				
				for k, v in pairs(self.Attachments) do
					local atttbl = v.Installed and ArcCW.AttachmentTable[v.Installed]
					if atttbl and atttbl.ToggleStats then-- and !v.ToggleLock then
						--print(atttbl.PrintName)
						local item = {
							Icon = atttbl.Icon,
							Locked = v.ToggleLock,
							Selected = v.ToggleNum,
							Toggles = {}
						}
						for i, h in ipairs(atttbl.ToggleStats) do
							table.insert(item.Toggles, h.PrintName)
							--print("\t" .. (v.ToggleNum == i and "> " or "") .. atttbl.ToggleStats[i].PrintName .. (v.ToggleNum == i and " <" or ""))
						end
						table.insert(items, item)
					end
				end

				for i=1, 0 do
					table.insert(items, {
						Icon = Material("Test"),
						Locked = false,
						Selected = i,
						Toggles = {
							"Test",
							"Test",
							"Test",
							"Test",
							"Test",
						}
					})
				end

				do
					local size = ScreenScaleMulti(28)
					local lock = ScreenScaleMulti(7)
					local shiit = 1.5
					local gaap = ScreenScaleMulti(7) -- 32 / 8
					if #items == 1 then
						gaap = 0
						shiit = 1
					end
					for index, item in ipairs(items) do
						surface.SetMaterial(item.Icon or bird)
						surface.SetDrawColor(color_white)

						local px, py = (ScrW()/2) - ((size*shiit)*(index-(#items*0.5))) + gaap, (ScrH()-CopeY()-(size*1.25))
						surface.DrawTexturedRect(px, py, size, size)

						if item.Locked then
							surface.SetMaterial(statlocked)
							surface.DrawTexturedRect(px + (size/2) - (lock/2), py + size - (lock/2), lock, lock)
						end

						for tdex, tinfo in ipairs(item.Toggles) do
							local infor = {
								x = px + (size*0.5),
								y = py - (#item.Toggles * ScreenScaleMulti(8)) + (tdex * ScreenScaleMulti(8)),
								font = "ArcCW_8",
								text = tinfo,
								col = col2,
								align = 2,
								yalign = 1,
								shadow = true,
								alpha = alpha * (tdex == item.Selected and 1 or 0.25),
							}
							MyDrawText(infor)
						end
					end
				end
				end

				if fmbars then
					local segcount = string.len( self:GetFiremodeBars() or "-----" )
					local bargap = ScreenScaleMulti(2)
					local bart = {
						w = (ScreenScaleMulti(100) + ((segcount + 1) * bargap)) / segcount,
						h = ScreenScaleMulti(8),
						x = apan_bg.x + apan_bg.w,
						y = apan_bg.y + apan_bg.h
					}

					bart.x = bart.x - ((bart.w / 2 + bargap) * segcount) - ScreenScaleMulti(4) - (bart.w / 4)
					bart.y = bart.y - ScreenScaleMulti(28)

					for i = 1, segcount do
						local c = data.bars[i]

						if c == "#" then continue end

						if c != "!" and c != "-" then
							surface.SetMaterial(bar_shou)
						else
							surface.SetMaterial(bar_shad)
						end
						surface.SetDrawColor(255, 255, 255, 255 / 5 * 3)
						surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)

						if c == "-" then
							-- good ol filled
							surface.SetMaterial(bar_fill)
							surface.SetDrawColor(col2)
							surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)
						elseif c == "!" then
							surface.SetMaterial(bar_fill)
							surface.SetDrawColor(col3)
							surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)
							surface.SetMaterial(bar_outl)
							surface.SetDrawColor(col2)
							surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)
						else
							-- good ol outline
							surface.SetMaterial(bar_outl)
							surface.SetDrawColor(col2)
							surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)
						end

						bart.x = bart.x + (bart.w / 2 + bargap)
					end
				end
			end
		elseif !GetConVar("arccw_override_hud_off"):GetBool() and GetConVar("arccw_hud_minimal"):GetBool() then
			if fmbars then
				local segcount = string.len( self:GetFiremodeBars() or "-----" )
				local bargap = ScreenScaleMulti(2)
				local bart = {
					w = (ScreenScaleMulti(256) - ((segcount + 1) * bargap)) / segcount,
					h = ScreenScaleMulti(8),
					x = ScrW() / 2,
					y = ScrH() - ScreenScaleMulti(24)
				}

				bart.x = bart.x - ((bart.w / 4) * segcount) - bart.w / 3.5 - bargap

				for i = 1, segcount do
					local c = data.bars[i]

					if c == "#" then continue end

					if c != "!" and c != "-" then
						surface.SetMaterial(bar_shou)
					else
						surface.SetMaterial(bar_shad)
					end
					surface.SetDrawColor(255, 255, 255, 255 / 5 * 3)
					surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)

					if c == "-" then
						-- good ol filled
						surface.SetMaterial(bar_fill)
						surface.SetDrawColor(col2)
						surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)
					elseif c == "!" then
						surface.SetMaterial(bar_fill)
						surface.SetDrawColor(col3)
						surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)
						surface.SetMaterial(bar_outl)
						surface.SetDrawColor(col2)
						surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)
					else
						-- good ol outline
						surface.SetMaterial(bar_outl)
						surface.SetDrawColor(col2)
						surface.DrawTexturedRect(bart.x, bart.y, bart.w, bart.h)
					end

					bart.x = bart.x + (bart.w / 2) + bargap
				end
			end
			local wmode = {
				x = ScrW() / 2,
				y = ScrH() - ScreenScaleMulti(34),
				font = "ArcCW_12",
				text = data.mode,
				col = col2,
				align = 2,
				shadow = true,
				alpha = alpha,
			}
			MyDrawText(wmode)

			--[[if self:GetBuff_Override("UBGL") then
				local size = ScreenScaleMulti(32)
				local awesomematerial = self:GetBuff_Override("UBGL_Icon", ubgl_mat)
				local whatsthecolor = self:GetInUBGL() and  Color(255, 255, 255, 255) or
														Color(255, 255, 255, 0)
				local bar2 = {
					w = size,
					h = size,
					x = ScrW() / 2 + ScreenScaleMulti(32),
					y = ScrH() - ScreenScaleMulti(52),
				}
				surface.SetDrawColor( whatsthecolor )
				surface.SetMaterial( awesomematerial )
				surface.DrawTexturedRect( bar2.x, bar2.y, bar2.w, bar2.h )
			end]]

			if self:CanBipod() or self:GetInBipod() then
				local size = ScreenScaleMulti(32)
				local awesomematerial = self:GetBuff_Override("Bipod_Icon", bipod_mat)
				local whatsthecolor =   self:GetInBipod() and   Color(255, 255, 255, 255) or
										self:CanBipod() and     Color(255, 255, 255, 127) or
																Color(255, 255, 255, 0)
				local bar2 = {
					w = size,
					h = size,
					x = ScrW() / 2 - ScreenScaleMulti(64),
					y = ScrH() - ScreenScaleMulti(52),
				}
				surface.SetDrawColor( whatsthecolor )
				surface.SetMaterial( awesomematerial )
				surface.DrawTexturedRect( bar2.x, bar2.y, bar2.w, bar2.h )

				local txt = string.upper(ArcCW:GetBind("+use"))

				local bip = {
					shadow = true,
					x = ScrW() / 2 - ScreenScaleMulti(64),
					y = ScrH() - ScreenScaleMulti(52),
					font = "ArcCW_12",
					text = txt,
					col = whatsthecolor,
				}

				MyDrawText(bip)
			end

			if data.heat_enabled then
				surface.SetDrawColor(col2)
				local perc = data.heat_level / data.heat_maxlevel

				local bar = {
					x = 0,
					y = ScrH() - ScreenScaleMulti(22)
				}

				surface.DrawOutlinedRect(ScrW() / 2 - ScreenScaleMulti(62), bar.y + ScreenScaleMulti(4.5), ScreenScaleMulti(124), ScreenScaleMulti(3))
				surface.DrawRect(ScrW() / 2 - ScreenScaleMulti(62), bar.y + ScreenScaleMulti(4.5), ScreenScaleMulti(124) * perc, ScreenScaleMulti(3))

				surface.SetFont("ArcCW_8")
				local bip = {
					shadow = false,
					x = (ScrW() / 2) - (surface.GetTextSize(data.heat_name) / 2),
					y = bar.y + ScreenScaleMulti(8),
					font = "ArcCW_8",
					text = data.heat_name,
					col = col2,
				}

				MyDrawText(bip)
			end
		end

		-- health + armor

		if ArcCW:ShouldDrawHUDElement("CHudHealth") then

			local colhp = Color(255, 255, 255, 255)
			local gotarmor = false

			if LocalPlayer():Armor() > 0 then
				gotarmor = true
				local armor_s = ScreenScaleMulti(10)
				local war = {
					x = airgap + CopeX() + armor_s + ScreenScaleMulti(6),
					y = ScrH() - ScreenScaleMulti(16) - airgap - CopeY(),
					font = "ArcCW_16",
					text = tostring(math.Round(varmor)),
					col = Color(255, 255, 255, 255),
					shadow = true,
					alpha = alpha
				}

				local armor_x = war.x - armor_s - ScreenScaleMulti(4)
				local armor_y = war.y + ScreenScaleMulti(4)

				surface.SetMaterial(armor_shad)
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawTexturedRect(armor_x, armor_y, armor_s, armor_s)

				surface.SetMaterial(armor)
				surface.SetDrawColor(colhp)
				surface.DrawTexturedRect(armor_x, armor_y, armor_s, armor_s)

				MyDrawText(war)
			end

			local hpicon_s = ScreenScaleMulti(16)
			local hpicon_x = airgap + CopeX()

			if LocalPlayer():Health() <= 30 then
				colhp = col3
			end

			local whp = {
				x = airgap + hpicon_s + CopeX(),
				y = ScrH() - ScreenScaleMulti(26 + (gotarmor and 16 or 0)) - airgap - CopeY(),
				font = "ArcCW_26",
				text = tostring(math.Round(vhp)),
				col = colhp,
				shadow = true,
				alpha = alpha
			}

			local hpicon_y = whp.y + ScreenScaleMulti(8)

			MyDrawText(whp)

			surface.SetMaterial(hp_shad)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRect(hpicon_x, hpicon_y, hpicon_s, hpicon_s)

			surface.SetMaterial(hp)
			surface.SetDrawColor(colhp)
			surface.DrawTexturedRect(hpicon_x, hpicon_y, hpicon_s, hpicon_s)

		end

		vhp = self:GetOwner():Health()
		varmor = self:GetOwner():Armor()

		local clipdiff = math.abs(vclip - self:Clip1())
		local reservediff = math.abs(vreserve - self:Ammo1())

		if clipdiff == 1 then
			vclip = self:Clip1()
		elseif self:Clip1() == ArcCW.BottomlessMagicNumber then
			clipdiff = 0
		end

		vclip = math.Approach(vclip, self:Clip1(), FrameTime() * 30 * clipdiff)
		vreserve = math.Approach(vreserve, self:Ammo1(), FrameTime() * 30 * reservediff)

		do
			local clipdiff = math.abs(vclip2 - self:Clip2())
			local reservediff = math.abs(vreserve2 - self:Ammo2())

			if clipdiff == 1 then
				vclip2 = self:Clip2()
			elseif self:Clip2() == ArcCW.BottomlessMagicNumber then
				clipdiff = 0
			end

			vclip2 = math.Approach(vclip2, self:Clip2(), FrameTime() * 30 * clipdiff)
			vreserve2 = math.Approach(vreserve2, self:Ammo2(), FrameTime() * 30 * reservediff)
		end

		vubgl = math.Approach(vubgl, (self:GetInUBGL() and 1 or 0), (FrameTime() / 0.3) )

		if lastwpn != self then
			vclip = self:Clip1()
			vreserve = self:Ammo1()
			vclip2 = self:Clip2()
			vreserve2 = self:Ammo2()
			vubgl = 0
			vhp = self:GetOwner():Health()
			varmor = self:GetOwner():Armor()
		end

		lastwpn = self
	end

end

--[[function SWEP:ShouldDrawCrosshair()
    if GetConVar("arccw_override_crosshair_off"):GetBool() then return false end
    if !GetConVar("arccw_crosshair"):GetBool() then return false end
    if self:GetReloading() and
	(self:GetMW2Masterkey_ShellInsertTime() != 0 and self:GetMW2Masterkey_ShellInsertTime() > CurTime())
	then return false end
    if self:BarrelHitWall() > 0 then return false end
    local asight = self:GetActiveSights()

    if !self:GetOwner():ShouldDrawLocalPlayer()
            and self:GetState() == ArcCW.STATE_SIGHTS and !asight.CrosshairInSights then
        return false
    end

    if self:GetNWState() == ArcCW.STATE_SPRINT and !self:CanShootWhileSprint() then return false end
    if self:GetCurrentFiremode().Mode == 0 then return false end
    if self:GetBuff_Hook("Hook_ShouldNotFire") then return false end
    if self:GetNWState() == ArcCW.STATE_CUSTOMIZE then return false end
    if self:GetNWState() == ArcCW.STATE_DISABLE then return false end
    return true
end]]

--owner:KeyDown(IN_ATTACK) or owner:KeyDown(IN_ATTACK2)
function SWEP:Hook_Think_2() end
function SWEP:Hook_Think()
	local fm = self:GetCurrentFiremode().Mode
	if fm == 2 then
		local owner = self:GetOwner()
		if owner:KeyDown(IN_ATTACK) then
			self:SetInUBGL(false)
			self:PrimaryAttack()
		end
		if owner:KeyDown(IN_ATTACK2) then
			self:SecondaryAttack()
		end
	end

	self:Hook_Think_2()
end

function SWEP:SecondaryAttack(isprimaryattack)
	local fm = self:GetCurrentFiremode().Mode
    self.Secondary.Automatic = fm == 2
	self:SetInUBGL(true)

	local owner = self:GetOwner()

    -- Should we not fire? But first.
    if self:GetBuff_Hook("Hook_ShouldNotFireFirst") then return end

    -- We're holstering
    if IsValid(self:GetHolster_Entity()) then return end
    if self:GetHolster_Time() > 0 then return end

    -- Disabled (currently used only by deploy)
    if self:GetState() == ArcCW.STATE_DISABLE then return end

    -- Coostimzing
    if self:GetState() == ArcCW.STATE_CUSTOMIZE then
        if CLIENT and ArcCW.Inv_Hidden then
            ArcCW.Inv_Hidden = false
            gui.EnableScreenClicker(true)
        elseif game.SinglePlayer() then
            -- Kind of ugly hack: in SP this is only called serverside so we ask client to do the same check
            self:CallOnClient("CanPrimaryAttack")
        end
        return
    end

    -- A priority animation is playing (reloading, cycling, firemode etc)
    if self:GetPriorityAnim() and !self:GetReloading() then return end

    -- Inoperable, but internally (burst resetting for example)
    if self:GetWeaponOpDelay() > CurTime() then return end

	local curatt = self:GetNextSecondaryFire()
    if curatt > CurTime() then return end

    -- Safety's on, dipshit
    if self:GetCurrentFiremode().Mode == 0 then
        self:ChangeFiremode(false)
        self:SetNextPrimaryFire(CurTime())
        self.Primary.Automatic = false
        return
    end

    -- If we are an NPC, do our own little methods
    if owner:IsNPC() then self:NPC_Shoot() return end

    -- If we are in a UBGL, shoot the UBGL, not the gun
    --if self:GetInUBGL() then
	self:ShootUBGL()
	local delay = self:GetFiringDelay()

	local curtime = CurTime()
	local diff = curtime - curatt

	if diff > engine.TickInterval() or diff < 0 then
		curatt = curtime
	end
	self:SetNextSecondaryFire(curatt + delay)
	--self:SetNextPrimaryFire(curatt + delay)
	--self:SetNextPrimaryFireSlowdown(curatt + delay) -- shadow for ONLY fire time
	--end
	
	--if isprimaryattack then
	self:SetInUBGL(false)
	--end
end

function SWEP:Reload()
    if IsValid(self:GetHolster_Entity()) then return end
    if self:GetHolster_Time() > 0 then return end

    if !IsFirstTimePredicted() then return end

    if self:GetOwner():IsNPC() then
        return
    end

    if self:GetState() == ArcCW.STATE_CUSTOMIZE then
        return
    end

    -- Switch to UBGL
    if self:GetBuff_Override("UBGL") and self:GetOwner():KeyDown(IN_USE) then
        if self:GetInUBGL() then
            --net.Start("arccw_ubgl")
            --net.WriteBool(false)
            --net.SendToServer()

            self:DeselectUBGL()
        else
            --net.Start("arccw_ubgl")
            --net.WriteBool(true)
            --net.SendToServer()

            self:SelectUBGL()
        end

        return
    end

    if self:GetInUBGL() then
        if self:GetNextSecondaryFire() > CurTime() then return end
        self:ReloadUBGL()
        return
    end

    if self:GetNextPrimaryFire() >= CurTime() then return end
    -- if !game.SinglePlayer() and !IsFirstTimePredicted() then return end


    if self.Throwing then return end
    if self.PrimaryBash then return end

    -- with the lite 3D HUD, you may want to check your ammo without reloading
    local Lite3DHUD = self:GetOwner():GetInfo("arccw_hud_3dfun") == "1"
    if self:GetOwner():KeyDown(IN_WALK) and Lite3DHUD then
        return
    end

    if self:GetMalfunctionJam() then
        local r = self:MalfunctionClear()
        if r then return end
    end

    if !self:GetMalfunctionJam() and self:Ammo1() <= 0 and !self:HasInfiniteAmmo() then
        return end

    if self:HasBottomlessClip() then return end

    if self:GetBuff_Hook("Hook_PreReload") then return end

    -- if we must dump our clip when reloading, our reserve ammo should be more than our clip
    local dumpclip = self:GetBuff_Hook("Hook_ReloadDumpClip")
    if dumpclip and !self:HasInfiniteAmmo() and self:Clip1() >= self:Ammo1() then
        return
    end

    self.LastClip1 = self:Clip1()

    local reserve = self:Ammo1()

    reserve = reserve + self:Clip1()
    if self:HasInfiniteAmmo() then reserve = self:GetCapacity() + self:Clip1() end

    local clip = self:GetCapacity()

    local chamber = math.Clamp(self:Clip1(), 0, self:GetChamberSize())
    if self:GetNeedCycle() then chamber = 0 end

    local load = math.Clamp(clip + chamber, 0, reserve)

    if !self:GetMalfunctionJam() and load <= self:Clip1() then return end

    self:SetBurstCount(0)

    local shouldshotgunreload = self:GetBuff_Override("Override_ShotgunReload")
    local shouldhybridreload = self:GetBuff_Override("Override_HybridReload")

    if shouldshotgunreload == nil then shouldshotgunreload = self.ShotgunReload end
    if shouldhybridreload == nil then shouldhybridreload = self.HybridReload end

    if shouldhybridreload then
        shouldshotgunreload = self:Clip1() != 0
    end

    if shouldshotgunreload and self:GetShotgunReloading() > 0 then return end

    local mult = self:GetBuff_Mult("Mult_ReloadTime")
    if shouldshotgunreload then
        local anim = "sgreload_start"
        local insertcount = 0

        local empty = self:Clip1() == 0 --or self:GetNeedCycle()

        if self.Animations.sgreload_start_empty and empty then
            anim = "sgreload_start_empty"
            empty = false
            if (self.Animations.sgreload_start_empty or {}).ForceEmpty == true then
                empty = true
            end

            insertcount = (self.Animations.sgreload_start_empty or {}).RestoreAmmo or 1
        else
            insertcount = (self.Animations.sgreload_start or {}).RestoreAmmo or 0
        end

        anim = self:GetBuff_Hook("Hook_SelectReloadAnimation", anim) or anim

        local time = self:GetAnimKeyTime(anim)
        local time2 = self:GetAnimKeyTime(anim, true)

        if time2 >= time then
            time2 = 0
        end

        if insertcount > 0 then
            self:SetMagUpCount(insertcount)
            self:SetMagUpIn(CurTime() + time2 * mult)
        end
        self:PlayAnimation(anim, mult, true, 0, true, nil, true, nil, {SyncWithClient = true})

        self:SetReloading(CurTime() + time * mult)

        self:SetShotgunReloading(empty and 4 or 2)
    else
        local anim = self:SelectReloadAnimation()

        if !self.Animations[anim] then print("Invalid animation \"" .. anim .. "\"") return end
        self:PlayAnimationWithSync(anim, mult, true, self.Animations[anim].StartFrom, false, nil, true, nil)
        --print("reload", self:GetAnimationProgress(), CurTime(), self:GetNextIdle(), !!self:PlayAnimation(anim, mult, true, self.Animations[anim].StartFrom, false, nil, true, nil, {SyncWithClient = true }), self.LastAnimKey)
        local magupin = self.Animations[anim].MagUpIn
        local reloadtime = self:GetAnimKeyTime(anim, true) * mult
        local reload_end_on
        if !self.Animations[anim].ForceEnd then
            reload_end_on = self:GetAnimKeyTime(anim, false) * mult
        else
            reload_end_on = self.Animations[anim].EndReloadOn and self.Animations[anim].EndReloadOn * mult or reloadtime
        end
		print("reload_end_on", reload_end_on)
        self:SetNextPrimaryFire(CurTime() + reload_end_on)
        self:SetReloading(CurTime() + reload_end_on)

        self:SetMagUpCount(0)
        self:SetMagUpIn(CurTime() + (magupin and magupin * mult or reloadtime))
    end

    self:SetClipInfo(load)
    if game.SinglePlayer() then
        self:CallOnClient("SetClipInfo", tostring(load))
    end

    for i, k in pairs(self.Attachments) do
        if !k.Installed then continue end
        local atttbl = ArcCW.AttachmentTable[k.Installed]

        if atttbl.DamageOnReload then
            self:DamageAttachment(i, atttbl.DamageOnReload)
        end
    end

    if !self.ReloadInSights then
        self:ExitSights()
        self.Sighted = false
    end

    self:GetBuff_Hook("Hook_PostReload")
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()

    self.Primary.Automatic = true

    --print("PRE self:CanPrimaryAttack()")

    -- Should we not fire? But first.
    if self:GetBuff_Hook("Hook_ShouldNotFireFirst") then return end

    -- We're holstering
    if IsValid(self:GetHolster_Entity()) then return end
    if self:GetHolster_Time() > 0 then return end

    -- Disabled (currently used only by deploy)
    if self:GetState() == ArcCW.STATE_DISABLE then return end

    -- Coostimzing
    if self:GetState() == ArcCW.STATE_CUSTOMIZE then
        if CLIENT and ArcCW.Inv_Hidden then
            ArcCW.Inv_Hidden = false
            gui.EnableScreenClicker(true)
        elseif game.SinglePlayer() then
            -- Kind of ugly hack: in SP this is only called serverside so we ask client to do the same check
            self:CallOnClient("CanPrimaryAttack")
        end
        return
    end

    -- A priority animation is playing (reloading, cycling, firemode etc)
    if self:GetPriorityAnim() then return end

    -- Inoperable, but internally (burst resetting for example)
    if self:GetWeaponOpDelay() > CurTime() then return end

    -- Safety's on, dipshit
    if self:GetCurrentFiremode().Mode == 0 then
        self:ChangeFiremode(false)
        self:SetNextPrimaryFire(CurTime())
        self.Primary.Automatic = false
        return
    end

    -- If we are an NPC, do our own little methods
    if owner:IsNPC() then self:NPC_Shoot() return end

    -- If we are in a UBGL, shoot the UBGL, not the gun
    --if self:GetInUBGL() then self:ShootUBGL() return end

    -- Too early, come back later.
    if self:GetNextPrimaryFire() >= CurTime() then return end

    -- Gun is locked from heat.
    if self:GetHeatLocked() then return end

    -- Attempting a bash
    if self:GetState() != ArcCW.STATE_SIGHTS and owner:KeyDown(IN_USE) or self.PrimaryBash then self:Bash() return end

    -- Throwing weapon
    if self.Throwing then self:PreThrow() return end

    -- Too close to a wall
    if self:BarrelHitWall() > 0 then return end

    -- Can't shoot while sprinting
    if self:GetNWState() == ArcCW.STATE_SPRINT and !self:CanShootWhileSprint() then return end

    -- Maximum burst shots
    if (self:GetBurstCount() or 0) >= self:GetBurstLength() then return end

    -- We need to cycle
    if self:GetNeedCycle() then return end

    -- If we have a trigger delay, make sure its progress is done
    if self:GetBuff_Override("Override_TriggerDelay", self.TriggerDelay) and ((!self:GetBuff_Override("Override_TriggerCharge", self.TriggerCharge) and self:GetTriggerDelta() < 1)
            or (self:GetBuff_Override("Override_TriggerCharge", self.TriggerCharge) and self:IsTriggerHeld())) then
        return
    end

    -- Should we not fire?
    if self:GetBuff_Hook("Hook_ShouldNotFire") then return end
    --print("POST self:CanPrimaryAttack()")
    local clip = self:Clip1()
    local aps = self:GetBuff("AmmoPerShot")

    if self:HasBottomlessClip() then
        clip = self:Ammo1()
        if self:HasInfiniteAmmo() then
            clip = math.huge
        end
    end

    if clip < aps then
        self:SetBurstCount(0)
        self:DryFire()

        self.Primary.Automatic = false

        return
    end

    local dir = (owner:EyeAngles() + self:GetFreeAimOffset()):Forward() --owner:GetAimVector()
    local src = self:GetShootSrc()

    if bit.band(util.PointContents(src), CONTENTS_WATER) == CONTENTS_WATER and !(self.CanFireUnderwater or self:GetBuff_Override("Override_CanFireUnderwater")) then
        self:DryFire()
        return
    end

    if self:GetMalfunctionJam() then
        self:DryFire()
        return
    end


    -- Try malfunctioning
    local mal = self:DoMalfunction(false)
    if mal == true then
        local anim = "fire_jammed"
        self:PlayAnimation(anim, 1, true, 0, true)
        return
    end

    self:GetBuff_Hook("Hook_PreFireBullets")

    local desync = GetConVar("arccw_desync"):GetBool()
    local desyncnum = (desync and math.random()) or 0
    math.randomseed(math.Round(util.SharedRandom(self:GetBurstCount(), -1337, 1337, !game.SinglePlayer() and self:GetOwner():GetCurrentCommand():CommandNumber() or CurTime()) * (self:EntIndex() % 30241)) + desyncnum)

    self.Primary.Automatic = true

    local spread = ArcCW.MOAToAcc * self:GetBuff("AccuracyMOA")
    local disp = self:GetDispersion() * ArcCW.MOAToAcc / 10

    --dir:Rotate(Angle(0, ArcCW.StrafeTilt(self), 0))
    --dir = dir + VectorRand() * disp

    self:ApplyRandomSpread(dir, disp)

    if (CLIENT or game.SinglePlayer()) and GetConVar("arccw_dev_shootinfo"):GetInt() >= 3 and disp > 0 then
        local dev_tr = util.TraceLine({
            start = src,
            endpos = src + owner:GetAimVector() * 33000,
            mask = MASK_SHOT,
            filter = {self, self:GetOwner()}
        })
        local dist = (dev_tr.HitPos - src):Length()
        local r = dist / (1 / math.tan(disp)) -- had to google "trig cheat sheet to figure this one out"
        local a = owner:GetAimVector():Angle()
        local r_sqrt = r / math.sqrt(2)
        debugoverlay.Line(dev_tr.HitPos - a:Up() * r, dev_tr.HitPos + a:Up() * r, 5, color_white, true)
        debugoverlay.Line(dev_tr.HitPos - a:Right() * r, dev_tr.HitPos + a:Right() * r, 5, color_white, true)
        debugoverlay.Line(dev_tr.HitPos - a:Right() * r_sqrt - a:Up() * r_sqrt, dev_tr.HitPos + a:Right() * r_sqrt + a:Up() * r_sqrt, 5, color_white, true)
        debugoverlay.Line(dev_tr.HitPos - a:Right() * r_sqrt + a:Up() * r_sqrt, dev_tr.HitPos + a:Right() * r_sqrt - a:Up() * r_sqrt, 5, color_white, true)
        debugoverlay.Text(dev_tr.HitPos, math.Round(self:GetDispersion(), 1) .. "MOA (" .. math.Round(disp, 3) .. "°)", 5)
    end

    local delay = self:GetFiringDelay()

    local curtime = CurTime()
    local curatt = self:GetNextPrimaryFire()
    local diff = curtime - curatt

    if diff > engine.TickInterval() or diff < 0 then
        curatt = curtime
    end

    self:SetNextPrimaryFire(curatt + delay)
    self:SetNextPrimaryFireSlowdown(curatt + delay) -- shadow for ONLY fire time

    local num = self:GetBuff("Num")

    num = num + self:GetBuff_Add("Add_Num")

    local tracer = self:GetBuff_Override("Override_Tracer", self.Tracer)
    local tracernum = self:GetBuff_Override("Override_TracerNum", self.TracerNum)
    local lastout = self:GetBuff_Override("Override_TracerFinalMag", self.TracerFinalMag)
    if lastout >= clip then
        tracernum = 1
        tracer = self:GetBuff_Override("Override_TracerFinal", self.TracerFinal) or self:GetBuff_Override("Override_Tracer", self.Tracer)
    end
    local dmgtable = self.BodyDamageMults
    dmgtable = self:GetBuff_Override("Override_BodyDamageMults") or dmgtable

    -- drive by is cool
    src = ArcCW:GetVehicleFireTrace(self:GetOwner(), src, dir) or src

    local bullet      = {}
    bullet.Attacker   = owner
    bullet.Dir        = dir
    bullet.Src        = src
    bullet.Spread     = Vector(0, 0, 0) --Vector(spread, spread, spread)
    bullet.Damage     = 0
    bullet.Num        = num

    local sglove = math.ceil(num / 3)
    bullet.Force      = self:GetBuff("Force", true) or math.Clamp( ( (50 / sglove) / ( (self:GetBuff("Damage") + self:GetBuff("DamageMin")) / (self:GetBuff("Num") * 2) ) ) * sglove, 1, 3 )
                        -- Overperforming weapons get the jerf, underperforming gets boost
    bullet.Distance   = self:GetBuff("Distance", true) or 33300
    -- Setting AmmoType makes the engine look for the tracer effect on the ammo instead of TracerName!
    --bullet.AmmoType   = self.Primary.Ammo
    bullet.HullSize   = self:GetBuff("HullSize")
    bullet.Tracer     = tracernum or 0
    bullet.TracerName = tracer
    bullet.Weapon     = self
    bullet.Callback = function(att, tr, dmg)
        ArcCW:BulletCallback(att, tr, dmg, self)
    end


    local shootent = self:GetBuff("ShootEntity", true) --self:GetBuff_Override("Override_ShootEntity", self.ShootEntity)
    local shpatt   = self:GetBuff_Override("Override_ShotgunSpreadPattern", self.ShotgunSpreadPattern)
    local shpattov = self:GetBuff_Override("Override_ShotgunSpreadPatternOverrun", self.ShotgunSpreadPatternOverrun)

    local extraspread = AngleRand() * self:GetDispersion() * ArcCW.MOAToAcc / 10

    local projectiledata = {}

    if shpatt or shpattov or shootent then
        if shootent then
            projectiledata.ent = shootent
            projectiledata.vel = self:GetBuff("MuzzleVelocity")
        end

        bullet = self:GetBuff_Hook("Hook_FireBullets", bullet)

        if !bullet then return end

        local doent = shootent and num or bullet.Num
        local minnum = shootent and 1 or 0

        if doent > minnum then
            for n = 1, bullet.Num do
                bullet.Num = 1

                local dispers = self:GetBuff_Override("Override_ShotgunSpreadDispersion", self.ShotgunSpreadDispersion)
                local offset  = self:GetShotgunSpreadOffset(n)
                local calcoff = dispers and (offset * self:GetDispersion() * ArcCW.MOAToAcc / 10) or offset

                local ang = owner:EyeAngles() + self:GetFreeAimOffset()
                local ang2 = Angle(ang)
                ang2:RotateAroundAxis(ang:Right(), -1 * calcoff.p)
                ang2:RotateAroundAxis(ang:Up(), calcoff.y)
                ang2:RotateAroundAxis(ang:Forward(), calcoff.r)

                if !self:GetBuff_Override("Override_NoRandSpread", self.NoRandSpread) then -- Needs testing
                    ang2 = ang2 + AngleRand() * spread / 5
                end

                if shootent then
                    projectiledata.ang = ang2

                    self:DoPrimaryFire(true, projectiledata)
                else
                    bullet.Dir = ang2:Forward()

                    self:DoPrimaryFire(false, bullet)
                end
            end
        elseif shootent then
            local ang = owner:EyeAngles() + self:GetFreeAimOffset()

            if !self:GetBuff_Override("Override_NoRandSpread", self.NoRandSpread) then
               -- ang = (dir + VectorRand() * spread / 5):Angle()

                local newdir = Vector(dir)
                self:ApplyRandomSpread(newdir, spread / 5)
                ang = newdir:Angle()
            end

            projectiledata.ang = ang

            self:DoPrimaryFire(true, projectiledata)
        end
    else
        if !bullet then return end
        for n = 1, bullet.Num do
            bullet.Num = 1
            local dirry = Vector(dir.x, dir.y, dir.z)
            math.randomseed(math.Round(util.SharedRandom(n, -1337, 1337, !game.SinglePlayer() and self:GetOwner():GetCurrentCommand():CommandNumber() or CurTime()) * (self:EntIndex() % 30241)) + desyncnum)
            if !self:GetBuff_Override("Override_NoRandSpread", self.NoRandSpread) then
                self:ApplyRandomSpread(dirry, spread)
                bullet.Dir = dirry
            end
            bullet = self:GetBuff_Hook("Hook_FireBullets", bullet) or bullet

            self:DoPrimaryFire(false, bullet)
        end
    end
    self:DoRecoil()

    self:SetNthShot(self:GetNthShot() + 1)

    owner:DoAnimationEvent(self:GetBuff_Override("Override_AnimShoot") or self.AnimShoot)

    local shouldsupp = SERVER and !game.SinglePlayer()

    if shouldsupp then SuppressHostEvents(owner) end

    self:DoEffects()

    self:SetBurstCount(self:GetBurstCount() + 1)

    self:TakePrimaryAmmo(aps)

    self:DoShootSound()
    self:DoPrimaryAnim()

    if self:GetCurrentFiremode().Mode < 0 and self:GetBurstCount() == self:GetBurstLength() then
        local postburst = (self:GetCurrentFiremode().PostBurstDelay or 0)
        self:SetWeaponOpDelay(CurTime() + postburst * self:GetBuff_Mult("Mult_PostBurstDelay") + self:GetBuff_Add("Add_PostBurstDelay"))
    end

    if (self:GetIsManualAction()) and !(self.NoLastCycle and self:Clip1() == 0) then
        local fireanim = self:GetBuff_Hook("Hook_SelectFireAnimation") or self:SelectAnimation("fire")
        local firedelay = self.Animations[fireanim].MinProgress or 0
        self:SetNeedCycle(true)
        self:SetWeaponOpDelay(CurTime() + (firedelay * self:GetBuff_Mult("Mult_CycleTime")))
        self:SetNextPrimaryFire(CurTime() + 0.1)
    end

    self:ApplyAttachmentShootDamage()

    self:AddHeat(self:GetBuff("HeatGain"))

    mal = self:DoMalfunction(true)
    if mal == true then
        local anim = "fire_jammed"
        self:PlayAnimation(anim, 1, true, 0, true)
    end

    if self:GetCurrentFiremode().Mode == 1 then
        self.LastTriggerTime = -1 -- Cannot fire again until trigger released
        self.LastTriggerDuration = 0
    end

    self:GetBuff_Hook("Hook_PostFireBullets")

    if shouldsupp then SuppressHostEvents(nil) end
end