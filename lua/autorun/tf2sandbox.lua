--[[---
    TF2SANDBOX GENERATOR
    MADE BY LEADKILLER
    RUN "tf2sandbox_generate" IN CONSOLE TO START
    THEN LOOK IN Steam\steamapps\common\GarrysMod\garrysmod\data\tf2sandbox\props-extended.txt
---]]--

tf2sb = {}
tf2sb.directoryblacklist = {}
tf2sb.modelblacklist = {}

--[[---
    CONFIG START
---]]--

tf2sb.directoryblacklist["bots"] = true
tf2sb.directoryblacklist["weapons"] = true
tf2sb.directoryblacklist["player"] = true
tf2sb.directoryblacklist["buildables"] = true

tf2sb.modelblacklist["models/props_halloween/big_top_carts.mdl"] = true
tf2sb.modelblacklist["models/props_halloween/big_top_ripped.mdl"] = true
tf2sb.modelblacklist["models/props_halloween/hwn_kart_track04.mdl"] = true
tf2sb.modelblacklist["models/props_hightower_event/underworld_lava.mdl"] = true

tf2sb.PropSpawnFX = true -- Fancy Spawn Effect when loading a save
tf2sb.ModdageStyleMap = true -- gm_teamcity_sunset_v1 uses Moddage styled sky and lighting

--[[---
    CONFIG END
---]]--

if SERVER then
    include("tf2sandbox/misc.lua")
    include("tf2sandbox/think.lua")
    AddCSLuaFile("tf2sandbox/save.lua")
    AddCSLuaFile("tf2sandbox/generator.lua")
    AddCSLuaFile("tf2sandbox/save_load.lua")
elseif CLIENT then
    include("tf2sandbox/save.lua") -- Under request by TatLead, this will not be included in the public version of TF2Sandbox Utilities.
    include("tf2sandbox/generator.lua")
end

include("tf2sandbox/save_load.lua")

function tf2sb.GetPropName(o, v)
    local strippedmdl = string.Split(o, "/")
    o = strippedmdl[#strippedmdl]
    local propname = string.Replace(string.Replace(string.Replace(o, ".phy", ""), ".mdl", ""), "_", " ")
    propname = string.gsub(" " .. propname, "%W%l", string.upper):sub(2) -- https://stackoverflow.com/a/20285006
    propname = string.Replace(propname, "00", "0")
    propname = string.Replace(propname, "0", " ")
    if v and string.find(propname, "1") and !file.Find("models/" .. v .. "/" .. string.Replace(o, "1", "2"), "tf")[1] then
        propname = string.Replace(propname, " 1", "")
        propname = string.Replace(propname, "1", "")
    end
    propname = string.Replace(propname, "  ", " ")
    if string.sub(propname, string.len(propname)) == " " then
        propname = string.sub(propname, 1, string.len(propname) - 1)
    end

    return propname
end

if SERVER then return end