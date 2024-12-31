if SERVER then
    function HORDE:UseGadget(ply)
        local gadget = ply:Horde_GetGadget()
        if gadget and HORDE.gadgets[gadget] and HORDE.gadgets[gadget].Active and ply:Horde_GetGadgetInternalCooldown() <= 0 and ply:Alive() and
        !hook.Run("Horde_UseActiveGadget", ply) then -- also can try HORDE.gadgets[ply:Horde_GetGadget()].Hooks and HORDE.gadgets[ply:Horde_GetGadget()].Hooks.Horde_UseActiveGadget and !HORDE.gadgets[ply:Horde_GetGadget()].Hooks.Horde_UseActiveGadget(ply)
            ply:Horde_SetGadgetInternalCooldown(ply:Horde_GetGadgetCooldown())
            net.Start("Horde_GadgetStartCooldown")
                net.WriteUInt(ply:Horde_GetGadgetCooldown(), 8)
            net.Send(ply)

            if HORDE.gadgets[gadget].Once then
                ply:Horde_UnsetGadget()
                ply:Horde_SyncEconomy()
            end
        end
    end
end

function plymeta:Horde_UnsetGadget()
    if self.Horde_Gadget == nil then return end
    if SERVER then
        local item = HORDE.items[self.Horde_Gadget]
        if item then
            self:Horde_AddWeight(item.weight)
        end
        if not self.has_used_consumable_gadget then
            self:Horde_AddMoney(math.floor(HORDE.sell_item_mult * item.price))
        end
    end
    hook.Run("Horde_OnUnsetGadget", self, self.Horde_Gadget)
    if SERVER then
        net.Start("Horde_Gadget")
            net.WriteUInt(HORDE.NET_PERK_UNSET, HORDE.NET_PERK_BITS)
            net.WriteEntity(self)
        net.Broadcast()
    end
    self.Horde_Gadget = nil
end