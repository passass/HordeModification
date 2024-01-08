net.Receive("Horde_SyncMaxWeight", function ()
    local ply = net.ReadEntity()
    local max_weight = net.ReadUInt(5)
    ply.Horde_max_weight = max_weight
end)