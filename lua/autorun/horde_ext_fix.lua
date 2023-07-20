if engine.ActiveGamemode() != "horde" or GetConVar("horde_external_lua_config"):GetString() == "horde_ext" then return end

hook.Add( "InitPostEntity", "HORDE_EXT_FIX", function()
	function HORDE:LoadSubclassChoices()
        MySelf.Horde_subclass_choices = {}
        if not file.Exists("horde/subclass_choices.txt", "DATA") then
            for class_name, _ in pairs(HORDE.classes_to_subclasses) do
                MySelf.Horde_subclass_choices[class_name] = class_name
            end
            HORDE:SaveSubclassChoices()
        else
            local f = file.Open("horde/subclass_choices.txt", "rb", "DATA")
            if not MySelf.Horde_subclasses then MySelf.Horde_subclasses = {} end
            while not f:EndOfFile() do
                local class_order = f:ReadULong()
                local subclass_order = f:ReadULong()
                local class = HORDE.order_to_class_name[class_order]
                if class then
                    MySelf.Horde_subclass_choices[class] = HORDE.order_to_subclass_name[tostring(subclass_order)]
                    MySelf.Horde_subclasses[class] = HORDE.order_to_subclass_name[tostring(subclass_order)]
                end
            end
            f:Close()
    
            -- Double check that we have all the subclasses we need
            for class_name, _ in pairs(HORDE.classes_to_subclasses) do
                if not MySelf.Horde_subclass_choices[class_name] then
                    MySelf.Horde_subclass_choices[class_name] = class_name
                end
            end
        end
    end
end )

