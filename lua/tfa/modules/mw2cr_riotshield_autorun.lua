local function BlockDamageRiotShield( ent, dmginfo )
	--replacing the entire function like a dumbass cause i cant code for shit and dont know who to ask for help
		if not ent:IsPlayer() then return end
		if dmginfo:IsDamageType( DMG_DROWNRECOVER ) or dmginfo:IsDamageType(DMG_DIRECT) then return end
		local wep
		wep = ent:GetActiveWeapon()

		if (wep.IsTFAWeapon and wep.RiotShieldDamageTypes and wep.RiotShield == true) then
		local RiotShield = false
		for _,v in ipairs(wep.RiotShieldDamageTypes) do
			if dmginfo:IsDamageType(v) then RiotShield = true end
		end
		if RiotShield then
			local damageinflictor, blockthreshold
			damageinflictor = dmginfo:GetInflictor()

			if (not IsValid(damageinflictor)) then
				damageinflictor = dmginfo:GetAttacker()
			end

			blockthreshold = ( wep.RiotShieldCone or 135 ) / 2
			if angle_mult_cv then
				blockthreshold = blockthreshold * angle_mult_cv:GetFloat()
			end

			if (IsValid(damageinflictor) and ( math.abs(math.AngleDifference( ent:EyeAngles().y, ( damageinflictor:GetPos() - ent:GetPos() ):Angle().y )) <= blockthreshold)) then
				if wep.RiotShieldPreHook and wep:RiotShieldPreHook() then
                    return
                end
                
                local dmgscale
                
				if ( not timed_blocking_cv ) or timed_blocking_cv:GetBool() then
					dmgscale = wep.RiotShieldMaximum
				else
					dmgscale = wep.RiotShieldMaximum
				end
				local olddmg = dmginfo:GetDamage()
				dmgscale = math.min( dmgscale, wep.RiotShieldDamageCap / dmginfo:GetDamage() )

				dmginfo:ScaleDamage(dmgscale)
				dmginfo:SetDamagePosition(vector_origin)
				dmginfo:SetDamageType( bit.bor( dmginfo:GetDamageType(), DMG_DROWNRECOVER ) )
				wep:EmitSound(wep.RiotShieldImpact or "")

				if deflect_cv and deflect_cv:GetInt() == 2 then
					DeflectBullet( ent, dmginfo, olddmg )
				end

                local result
				
				if dmginfo:GetDamage() < 1 then
					if deflect_cv and deflect_cv:GetInt() == 1 and wep.RiotShieldCanDeflect then
						DeflectBullet( ent, dmginfo, olddmg )
					end
					result = true
				end

                local hook_result = wep.RiotShieldPostHook and wep:RiotShieldPostHook(dmginfo, olddmg)
                if hook_result then return end
                return result
			end
		end
	end
end

hook.Add("EntityTakeDamage", "mw2cr_riotshield", function( ent, dmginfo )
	return BlockDamageRiotShield( ent, dmginfo )
end) --Cancel
hook.Add("ScalePlayerDamage", "mw2cr_riotshield", function( ent, _, dmginfo ) --Cancel
	return BlockDamageRiotShield( ent, dmginfo )
end)
