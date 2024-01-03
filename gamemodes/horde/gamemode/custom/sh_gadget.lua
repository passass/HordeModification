if SERVER then
    function HORDE:UseGadget(ply)
        local gadget = ply:Horde_GetGadget()
        if gadget and HORDE.gadgets[gadget] and HORDE.gadgets[gadget].Active and ply:Horde_GetGadgetInternalCooldown() <= 0 and ply:Alive() and
        !hook.Run("Horde_UseActiveGadget", ply) then -- also can try HORDE.gadgets[ply:Horde_GetGadget()].Hooks and HORDE.gadgets[ply:Horde_GetGadget()].Hooks.Horde_UseActiveGadget and !HORDE.gadgets[ply:Horde_GetGadget()].Hooks.Horde_UseActiveGadget(ply)
            ply:Horde_SetGadgetInternalCooldown(ply:Horde_GetGadgetCooldown())
            net.Start("Horde_GadgetStartCooldown")
                net.WriteEntity(ply)
                net.WriteUInt(ply:Horde_GetGadgetCooldown(), 8)
            net.Broadcast()

            if HORDE.gadgets[gadget].Once then
                ply:Horde_UnsetGadget()
                ply:Horde_SyncEconomy()
            end
        end
    end
end