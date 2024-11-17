local function initsync()
    local class = MySelf:Horde_GetClass()
    if !class then
        net.Start("Horde_InitClass")
        net.WriteString(HORDE.Class_Survivor)
        net.SendToServer()
    end
end

timer.Simple(1, function()
    initsync()
end)