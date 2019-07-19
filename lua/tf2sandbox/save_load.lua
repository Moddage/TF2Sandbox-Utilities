concommand.Add("tf2sandbox_load", function(ply, _, args)
    if !ply:IsSuperAdmin() then return end
    if CLIENT then return end

    local save = file.Read("tf2sandbox/save.txt", "DATA")

    if args[1] then
        save = file.Read("tf2sandbox/saves/" .. args[1], "DATA")
    end

    if !save or save == "" then
        if !save then
            file.CreateDir("tf2sandbox")
            file.Write("tf2sandbox/save.txt", "")
        end

        ErrorNoHalt("No save was detected! Make sure to put a save into \"garrysmod/data/tf2sandbox/save.txt\"!\n")
        return
    end

    save = string.Split(save, "\n")

    for _, l in pairs(save) do
        if string.sub(l, 1, 3) == "ent" then
            local v = string.Split(l, " ")
            local class = nil
            local model = nil
            local x = nil
            local y = nil
            local z = nil
            local p = nil
            local yaw = nil
            local r = nil
            local coll = nil
            local scale = nil
            local col = nil
            local renderfx = nil
            local skinp = nil
            local name = nil
            local prop = nil

            print(v[16])

            if v[10] and !v[18] and !v[16] then -- Bruh
                class = v[2]
                model = v[3]
                x = v[4]
                y = v[5]
                z = v[6]
                p = v[7]
                yaw = v[8]
                r = v[9]
                coll = 0
                scale = 1
                col = Color(255, 255, 255, 255)
                renderfx = 0
                skinp = 00
                name = v[10]
            elseif v[18] then
                class = v[2]
                model = v[3]
                x = v[4]
                y = v[5]
                z = v[6]
                p = v[7]
                yaw = v[8]
                r = v[9]
                coll = v[10]
                scale = v[11]
                col = Color(v[12], v[13], v[14], v[15])
                renderfx = v[16] - 1
                skinp = v[17]
                name = v[18]
            elseif v[16] then
                class = v[2]
                model = v[3]
                x = v[4]
                y = v[5]
                z = v[6]
                p = v[7]
                yaw = v[8]
                r = v[9]
                coll = v[10]
                scale = v[11]
                col = Color(v[12], v[13], v[14], v[15])
                renderfx = v[16] - 1
                name = v[17]
                skinp = 00
            end

            if model == "models/props_2fort/lightbulb001.mdl" then
                if skinp == 00 then
                    skinp = 7
                end
                prop = ents.Create("gmod_light")
                prop:SetName(name)
                prop:SetColor(col)
                prop:SetRenderMode(RENDERMODE_TRANSALPHA)
                prop:SetBrightness(skinp)
                prop:SetLightSize(500)
                prop:SetOn(true)
                prop.lightr = col.r
                prop.lightg = col.g
                prop.lightb = col.b
                prop.Brightness = skinp
                prop.Size = 500
                prop:SetRenderFX(renderfx)
                prop:SetCollisionGroup(coll)
                prop:SetModelScale(scale)
                prop:SetSpawnEffect(tf2sb.PropSpawnFX)
                prop:Spawn()
                prop:Activate()
                prop:SetModel(model)
                prop:SetPos(Vector(x, y, z))
                prop:SetAngles(Angle(p, yaw, r))

                undo.Create("Light")
                    undo.SetPlayer(ply)
                    undo.AddEntity(prop)
                undo.Finish("Light (" .. tostring( model ) .. ")")

                ply:AddCleanup("lights", prop)
                ply:AddCount("lights", prop)
            else
                prop = ents.Create("prop_physics")
                prop:SetModel(model)
                prop:SetPos(Vector(x, y, z))
                prop:SetAngles(Angle(p, yaw, r))
                prop:SetName(name)
                prop:SetColor(col)
                prop:SetRenderMode(RENDERMODE_TRANSALPHA)
                prop:SetSkin(skinp)
                prop:SetRenderFX(renderfx)
                prop:SetCollisionGroup(coll)
                prop:SetModelScale(scale)
                prop:SetSpawnEffect(tf2sb.PropSpawnFX)
                prop:Spawn()
                prop:Activate()

                undo.Create("Prop")
                    undo.SetPlayer(ply)
                    undo.AddEntity(prop)
                undo.Finish("Prop (" .. tostring( model ) .. ")")

                ply:AddCleanup("props", prop)
                ply:AddCount("props", prop)
            end

            prop:SetNWBool("TF2SBProp", true)

            if name == "" or name == nil then
                name = tf2sb.GetPropName(prop:GetModel())
            end

            prop:SetNWString("Name", name)

            local physobj = prop:GetPhysicsObject()

            if IsValid(physobj) then
                physobj:EnableMotion(false)
            end

            if prop.CPPISetOwner then
                prop:CPPISetOwner(ply)
            end
        end
    end
end, function(cmd, stringargs)
    stringargs = string.Trim(string.lower(stringargs))
    local ret = {}
    for _, f in pairs(file.Find("tf2sandbox/saves/*.tf2sb", "DATA")) do
        if string.find(f, stringargs) then
            table.insert(ret, "tf2sandbox_load \"" .. f .. "\"")
        end
    end
    return ret
end)