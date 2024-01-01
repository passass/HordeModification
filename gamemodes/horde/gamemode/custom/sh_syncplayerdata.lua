if game.SinglePlayer() then return end
if SERVER then
    util.AddNetworkString("SyncPlayersData")
    timer.Create("SyncPlayersData", .2, 0, function()
        local allplayers = player.GetAll()
        for _, ply in pairs(allplayers) do
            if !ply:Alive() then continue end
            local wpn = ply:GetActiveWeapon()
            if !IsValid(wpn) then continue end
            local data = {}
            local ammo_type = wpn.ArcCW and wpn.Primary.Ammo or wpn:GetPrimaryAmmoType()
            local has_ammo
            if isnumber(ammo_type) then
                has_ammo = ammo_type > 0
            else
                has_ammo = !!ammo_type
            end
            if has_ammo then
                data["ammo"] = ply:GetAmmoCount(ammo_type)
            end

            if wpn:GetMaxClip1() > 0 then
                data["clip"] = wpn:Clip1()
            end
            for _, ply2 in pairs(allplayers) do
                if ply2 == ply then continue end
                net.Start("SyncPlayersData")
                --net.WriteEntity(ply)
                net.WriteEntity(wpn)
                net.WriteTable(data)
                net.Send(ply2)
            end
        end
    end)
else
    net.Receive("SyncPlayersData", function()
        --local ply = net.ReadEntity()
        local wpn = net.ReadEntity()
        local data = net.ReadTable()
        if data.ammo then
            wpn.CLIENT_AMMO = data.ammo
        end
        if data.clip then
            wpn.CLIENT_CLIP = data.clip
        end
    end)
end