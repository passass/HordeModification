local function addToBlackList(attname)
    if ArcCW.AttachmentTable[attname] then
        ArcCW.AttachmentBlacklistTable[attname] = true
    end
end

addToBlackList("go_perk_diver")
addToBlackList("go_perk_light")
addToBlackList("go_perk_quickdraw")
addToBlackList("go_perk_cowboy")
addToBlackList("perk_fastreload")
addToBlackList("go_perk_rapidfire")
addToBlackList("go_perk_burst")
addToBlackList("go_perk_fastreload")
addToBlackList("perk_headshot")
addToBlackList("perk_fastreload")