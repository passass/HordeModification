if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS("tfa_gun_base")
local hudhangtime_cvar = GetConVar("cl_tfa_hud_hangtime")
local hudfade_cvar = GetConVar("cl_tfa_hud_ammodata_fadein")
function SWEP:DoDrawCrosshair() end
function SWEP:DrawHUDAmmo()
	local self2 = self:GetTable()
	local stat = self2.GetStatus(self)

	if self2.GetStatL(self, "BoltAction") then
		if stat == TFA.Enum.STATUS_SHOOTING then
			if not self2.LastBoltShoot then
				self2.LastBoltShoot = l_CT()
			end
		elseif self2.LastBoltShoot then
			self2.LastBoltShoot = nil
		end
	end

	fm = self:GetFireMode()
	targbool = (not TFA.Enum.HUDDisabledStatus[stat]) or fm ~= lfm
	targbool = targbool or (stat == TFA.Enum.STATUS_SHOOTING and self2.LastBoltShoot and l_CT() > self2.LastBoltShoot + self2.BoltTimerOffset)
	targbool = targbool or (self2.GetStatL(self, "PumpAction") and (stat == TFA.Enum.STATUS_PUMP or (stat == TFA.Enum.STATUS_SHOOTING and self:Clip1() == 0)))
	targbool = targbool or (stat == TFA.Enum.STATUS_FIDGET)

	targ = targbool and 1 or 0
	lfm = fm

	if targ == 1 then
		lactive = RealTime()
	elseif RealTime() < lactive + hudhangtime_cvar:GetFloat() then
		targ = 1
	elseif self:GetOwner():KeyDown(IN_RELOAD) then
		targ = 1
	end

	self2.CLAmmoProgress = math.Approach(self2.CLAmmoProgress, targ, (targ - self2.CLAmmoProgress) * RealFrameTime() * 2 / hudfade_cvar:GetFloat())

	local myalpha = 225 * self2.CLAmmoProgress
	if myalpha < 1 then return end
	local amn = self2.GetStatL(self, "Primary.Ammo")
	if not amn then return end
	if amn == "none" or amn == "" then return end
	local mzpos = self:GetMuzzlePos()

	if self2.GetStatL(self, "IsAkimbo") then
		self2.MuzzleAttachmentRaw = self2.MuzzleAttachmentRaw2 or 1
	end

	if self2.GetHidden(self) then return end

	local xx, yy

	if mzpos and mzpos.Pos then
		local pos = mzpos.Pos
		local textsize = self2.textsize and self2.textsize or 1
		local pl = IsValid(self:GetOwner()) and self:GetOwner() or LocalPlayer()
		local ang = pl:EyeAngles() --(angpos.Ang):Up():Angle()
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
		ang:RotateAroundAxis(ang:Forward(), 0)
		pos = pos + ang:Right() * (self2.textupoffset and self2.textupoffset or -2 * (textsize / 1))
		pos = pos + ang:Up() * (self2.textfwdoffset and self2.textfwdoffset or 0 * (textsize / 1))
		pos = pos + ang:Forward() * (self2.textrightoffset and self2.textrightoffset or -1 * (textsize / 1))
		cam.Start3D()
		local postoscreen = pos:ToScreen()
		cam.End3D()
		xx = postoscreen.x
		yy = postoscreen.y
	else -- fallback to pseudo-3d if no muzzle
		xx, yy = ScrW() * .65, ScrH() * .6
	end

	local v, newx, newy, newalpha = hook.Run("TFA_DrawHUDAmmo", self, xx, yy, myalpha)
	if v ~= nil then
		if v then
			xx = newx or xx
			yy = newy or yy
			myalpha = newalpha or myalpha
		else
			return
		end
	end

	if self:GetInspectingProgress() < 0.01 and self2.GetStatL(self, "Primary.Ammo") ~= "" and self2.GetStatL(self, "Primary.Ammo") ~= 0 then
		local str, clipstr

		if self2.GetStatL(self, "Primary.ClipSize") and self2.GetStatL(self, "Primary.ClipSize") ~= -1 then
			clipstr = language.GetPhrase("tfa.hud.ammo.clip1")

			if self2.GetStatL(self, "IsAkimbo") and self2.GetStatL(self, "EnableAkimboHUD") ~= false then
				str = clipstr:format(math.ceil(self:Clip1() / 2))

				if (self:Clip1() > self2.GetStatL(self, "Primary.ClipSize")) then
					str = clipstr:format(math.ceil(self:Clip1() / 2) - 1 .. " + " .. (math.ceil(self:Clip1() / 2) - math.ceil(self2.GetStatL(self, "Primary.ClipSize") / 2)))
				end
			else
				str = clipstr:format(self:Clip1())

				if (self:Clip1() > self2.GetStatL(self, "Primary.ClipSize")) then
					str = clipstr:format(self2.GetStatL(self, "Primary.ClipSize") .. " + " .. (self:Clip1() - self2.GetStatL(self, "Primary.ClipSize")))
				end
			end

			draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			str = language.GetPhrase("tfa.hud.ammo.reserve1"):format(self2.Ammo1(self))
			yy = yy + TFA.Fonts.SleekHeight
			xx = xx - TFA.Fonts.SleekHeight / 3
			draw.DrawText(str, "TFASleekMedium", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleekMedium", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			yy = yy + TFA.Fonts.SleekHeightMedium
			xx = xx - TFA.Fonts.SleekHeightMedium / 3
		else
			str = language.GetPhrase("tfa.hud.ammo1"):format(self2.Ammo1(self))
			draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
			draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			yy = yy + TFA.Fonts.SleekHeightMedium
			xx = xx - TFA.Fonts.SleekHeightMedium / 3
		end

--[[str = string.upper(self:GetFireModeName() .. (#self2.GetStatL(self, "FireModes") > 2 and " | +" or ""))

		if self:IsJammed() then
			str = str .. "\n" .. language.GetPhrase("tfa.hud.jammed")
		end

		draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
		draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)]]
		yy = yy + TFA.Fonts.SleekHeightSmall
		xx = xx - TFA.Fonts.SleekHeightSmall / 3

		if self2.GetStatL(self, "IsAkimbo") and self2.GetStatL(self, "EnableAkimboHUD") ~= false then
			local angpos2 = self:GetOwner():ShouldDrawLocalPlayer() and self:GetAttachment(2) or self2.OwnerViewModel:GetAttachment(2)

			if angpos2 then
				local pos2 = angpos2.Pos
				local ts2 = pos2:ToScreen()

				xx, yy = ts2.x, ts2.y
			else
				xx, yy = ScrW() * .35, ScrH() * .6
			end

			if self2.GetStatL(self, "Primary.ClipSize") and self2.GetStatL(self, "Primary.ClipSize") ~= -1 then
				clipstr = language.GetPhrase("tfa.hud.ammo.clip1")

				str = clipstr:format(math.floor(self:Clip1() / 2))

				if (math.floor(self:Clip1() / 2) > math.floor(self2.GetStatL(self, "Primary.ClipSize") / 2)) then
					str = clipstr:format(math.floor(self:Clip1() / 2) - 1 .. " + " .. (math.floor(self:Clip1() / 2) - math.floor(self2.GetStatL(self, "Primary.ClipSize") / 2)))
				end

				draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				str = language.GetPhrase("tfa.hud.ammo.reserve1"):format(self2.Ammo1(self))
				yy = yy + TFA.Fonts.SleekHeight
				xx = xx - TFA.Fonts.SleekHeight / 3
				draw.DrawText(str, "TFASleekMedium", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekMedium", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				yy = yy + TFA.Fonts.SleekHeightMedium
				xx = xx - TFA.Fonts.SleekHeightMedium / 3
			else
				str = language.GetPhrase("tfa.hud.ammo1"):format(self2.Ammo1(self))
				draw.DrawText(str, "TFASleek", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleek", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				yy = yy + TFA.Fonts.SleekHeightMedium
				xx = xx - TFA.Fonts.SleekHeightMedium / 3
			end
		end

		if self2.GetStatL(self, "Secondary.Ammo") and self2.GetStatL(self, "Secondary.Ammo") ~= "" and self2.GetStatL(self, "Secondary.Ammo") ~= "none" and self2.GetStatL(self, "Secondary.Ammo") ~= 0 and not self2.GetStatL(self, "IsAkimbo") then
			if self2.GetStatL(self, "Secondary.ClipSize") and self2.GetStatL(self, "Secondary.ClipSize") ~= -1 then
				clipstr = language.GetPhrase("tfa.hud.ammo.clip2")
				str = (self:Clip2() > self2.GetStatL(self, "Secondary.ClipSize")) and clipstr:format(self2.GetStatL(self, "Secondary.ClipSize") .. " + " .. (self:Clip2() - self2.GetStatL(self, "Primary.ClipSize"))) or clipstr:format(self:Clip2())
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
				str = language.GetPhrase("tfa.hud.ammo.reserve2"):format(self2.Ammo2(self))
				yy = yy + TFA.Fonts.SleekHeightSmall
				xx = xx - TFA.Fonts.SleekHeightSmall / 3
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			else
				str = language.GetPhrase("tfa.hud.ammo2"):format(self2.Ammo2(self))
				draw.DrawText(str, "TFASleekSmall", xx + 1, yy + 1, ColorAlpha(self2.TextColContrast, myalpha), TEXT_ALIGN_RIGHT)
				draw.DrawText(str, "TFASleekSmall", xx, yy, ColorAlpha(self2.TextCol, myalpha), TEXT_ALIGN_RIGHT)
			end
		end
	end
end
function SWEP:GenerateInspectionDerma() end
local cv_forcemult = GetConVar("sv_tfa_force_multiplier")
local sv_tfa_bullet_penetration_power_mul = GetConVar("sv_tfa_bullet_penetration_power_mul")
local sv_tfa_recoil_legacy = GetConVar("sv_tfa_recoil_legacy")

local function BallisticFirebullet(ply, bul, ovr, angPreserve)
	local wep = ply:GetActiveWeapon()

	if TFA.Ballistics and TFA.Ballistics:ShouldUse(wep) then
		if ballistics_distcv:GetInt() == -1 or util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 0x7fff, ply).HitPos:Distance(ply:GetShootPos()) > (ballistics_distcv:GetFloat() * TFA.Ballistics.UnitScale) then
			bul.SmokeParticle = bul.SmokeParticle or wep.BulletTracer or wep.TracerBallistic or wep.BallisticTracer or wep.BallisticsTracer

			if ovr then
				TFA.Ballistics:FireBullets(wep, bul, angPreserve or angle_zero, true)
			else
				TFA.Ballistics:FireBullets(wep, bul, angPreserve)
			end
		else
			ply:FireBullets(bul)
		end
	else
		ply:FireBullets(bul)
	end
end


function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone, disablericochet, bulletoverride)
	if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
	num_bullets = num_bullets or 1
	aimcone = aimcone or 0

	self:SetLastGunFire(CurTime())

	if self:GetStatL("Primary.Projectile") then
		if CLIENT then return end

		for _ = 1, num_bullets do
			local ent = ents.Create(self:GetStatL("Primary.Projectile"))

			local ang = self:GetOwner():GetAimVector():Angle()

			if not sv_tfa_recoil_legacy:GetBool() then
				ang.p = ang.p + self:GetViewPunchP()
				ang.y = ang.y + self:GetViewPunchY()
			end

			ang:RotateAroundAxis(ang:Right(), -aimcone / 2 + math.Rand(0, aimcone))
			ang:RotateAroundAxis(ang:Up(), -aimcone / 2 + math.Rand(0, aimcone))

			ent:SetPos(self:GetOwner():GetShootPos())
			ent:SetOwner(self:GetOwner())
			ent:SetAngles(ang)
			ent.damage = self:GetStatL("Primary.Damage")
			ent.mydamage = self:GetStatL("Primary.Damage")
			
			local dir = ang:Forward()
			dir:Mul(self:GetStatL("Primary.ProjectileVelocity"))

			if self:GetStatL("Primary.ProjectileModel") then
				ent:SetModel(self:GetStatL("Primary.ProjectileModel"))
			end
			
			ent.CurVel = dir
			ent.SpawnTime = CurTime()

			self:PreSpawnProjectile(ent)

			ent:Spawn()

			

			ent:SetVelocity(dir)
			local phys = ent:GetPhysicsObject()
			
			if IsValid(phys) then
				phys:SetVelocity(dir)
			end
			
			if self.ProjectileModel then
				ent:SetModel(self:GetStatL("Primary.ProjectileModel"))
			end

			ent:SetOwner(self:GetOwner())

			self:PostSpawnProjectile(ent)
		end
		-- Source
		-- Dir of self.MainBullet
		-- Aim Cone X
		-- Aim Cone Y
		-- Show a tracer on every x bullets
		-- Amount of force to give to phys objects

		return
	end

	if self.Tracer == 1 then
		TracerName = "Ar2Tracer"
	elseif self.Tracer == 2 then
		TracerName = "AirboatGunHeavyTracer"
	else
		TracerName = "Tracer"
	end

	self.MainBullet.PCFTracer = nil

	if self:GetStatL("TracerName") and self:GetStatL("TracerName") ~= "" then
		if self:GetStatL("TracerPCF") then
			TracerName = nil
			self.MainBullet.PCFTracer = self:GetStatL("TracerName")
			self.MainBullet.Tracer = 0
		else
			TracerName = self:GetStatL("TracerName")
		end
	end

	local owner = self:GetOwner()

	self.MainBullet.Attacker = owner
	self.MainBullet.Inflictor = self
	self.MainBullet.Src = owner:GetShootPos()

	self.MainBullet.Dir = self:GetAimVector()
	self.MainBullet.HullSize = self:GetStatL("Primary.HullSize") or 0
	self.MainBullet.Spread.x = 0
	self.MainBullet.Spread.y = 0

	self.MainBullet.Num = 1

	if num_bullets == 1 then
		local dYaw, dPitch = self:ComputeBulletDeviation(1, 1, aimcone)

		local ang = self.MainBullet.Dir:Angle()
		local up, right = ang:Up(), ang:Right()

		ang:RotateAroundAxis(up, dYaw)
		ang:RotateAroundAxis(right, dPitch)

		self.MainBullet.Dir = ang:Forward()
	end

	self.MainBullet.Wep = self

	if self.TracerPCF then
		self.MainBullet.Tracer = 0
	else
		self.MainBullet.Tracer = self:GetStatL("TracerCount") or 3
	end

	self.MainBullet.TracerName = TracerName
	self.MainBullet.PenetrationCount = 0
	self.MainBullet.PenetrationPower = self:GetStatL("Primary.PenetrationPower") * sv_tfa_bullet_penetration_power_mul:GetFloat(1)
	self.MainBullet.InitialPenetrationPower = self.MainBullet.PenetrationPower
	self.MainBullet.AmmoType = self:GetPrimaryAmmoType()
	self.MainBullet.Force = self:GetStatL("Primary.Force") * cv_forcemult:GetFloat() * self:GetAmmoForceMultiplier()
	self.MainBullet.Damage = damage
	self.MainBullet.InitialDamage = damage
	self.MainBullet.InitialForce = self.MainBullet.Force
	self.MainBullet.InitialPosition = Vector(self.MainBullet.Src)
	self.MainBullet.HasAppliedRange = false

	if self.CustomBulletCallback then
		self.MainBullet.Callback2 = self.CustomBulletCallback
	else
		self.MainBullet.Callback2 = nil
	end

	if num_bullets > 1 then
		local ang_ = self.MainBullet.Dir:Angle()
		local up, right = ang_:Up(), ang_:Right()

		-- single callback per multiple bullets fix
		for i = 1, num_bullets do
			local bullet = table.Copy(self.MainBullet)

			local ang = Angle(ang_)

			local dYaw, dPitch = self:ComputeBulletDeviation(i, num_bullets, aimcone)
			ang:RotateAroundAxis(up, dYaw)
			ang:RotateAroundAxis(right, dPitch)

			bullet.Dir = ang:Forward()

			function bullet.Callback(attacker, trace, dmginfo)
				if not IsValid(self) then return end

				dmginfo:SetInflictor(self)
				dmginfo:SetDamage(dmginfo:GetDamage() * bullet:CalculateFalloff(trace.HitPos))

				if bullet.Callback2 then
					bullet.Callback2(attacker, trace, dmginfo)
				end

				self:CallAttFunc("CustomBulletCallback", attacker, trace, dmginfo)

				bullet:Penetrate(attacker, trace, dmginfo, self, {})
				self:PCFTracer(bullet, trace.HitPos or vector_origin)
			end

			BallisticFirebullet(owner, bullet, nil, ang)
		end

		return
	end

	function self.MainBullet.Callback(attacker, trace, dmginfo)
		if not IsValid(self) then return end

		dmginfo:SetInflictor(self)
		dmginfo:SetDamage(dmginfo:GetDamage() * self.MainBullet:CalculateFalloff(trace.HitPos))

		if self.MainBullet.Callback2 then
			self.MainBullet.Callback2(attacker, trace, dmginfo)
		end

		self:CallAttFunc("CustomBulletCallback", attacker, trace, dmginfo)

		self.MainBullet:Penetrate(attacker, trace, dmginfo, self, {})
		self:PCFTracer(self.MainBullet, trace.HitPos or vector_origin)
	end

	BallisticFirebullet(owner, self.MainBullet)
end
