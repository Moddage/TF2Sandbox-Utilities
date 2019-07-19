concommand.Add("tf2sandbox_generate", function()
    if IsMounted("tf") then
        MsgN("Team Fortress 2 Detected!")
        MsgN("Attempting to create \"props-extended.txt\"")

        local propsini = {}
        local _, directories = file.Find("models/*", "tf", "nameasc")
        local filesroot = file.Find("models/*.phy", "tf", "nameasc")

        for i, o in pairs(filesroot) do
            local propname = tf2sb.GetPropName(o)
            local filen = "\"" .. string.Replace(o, ".phy", "") .. "\", \"models/" .. string.Replace(o, ".phy", ".mdl") .. "\", \"prop_dynamic_override\", \"" .. propname .. "\""
            table.insert(propsini, filen)
        end

        for k, v in pairs(directories) do
            if !tf2sb.directoryblacklist[v] then
                for i, o in pairs(file.Find("models/" .. v .. "/*.phy", "tf", "nameasc")) do
                    if !tf2sb.modelblacklist["models/" .. v .. "/" .. string.Replace(o, ".phy", ".mdl")] then
                        local propname = tf2sb.GetPropName(o, v)
                        local filen = "\"" .. string.Replace(o, ".phy", "") .. "\", \"models/" .. v .. "/" .. string.Replace(o, ".phy", ".mdl") .. "\", \"prop_dynamic_override\", \"" .. propname .. "\""

                        propsini[propname] = filen
                    end
                end
            end
        end

        file.CreateDir("tf2sandbox")
        file.Write("tf2sandbox/props-extended.txt", ";; TF2 Sandbox Auto Generated at " .. os.date() .. " ;;\n")

        local propsini2 = table.SortByKey(propsini, true)

        for k, v in pairs(propsini2) do
            file.Append("tf2sandbox/props-extended.txt", "\n" .. propsini[v])
        end

        MsgN("Generated props-extended.txt at " .. os.date() .. "!")
    else
        ErrorNoHalt("Team Fortress 2 was not detected! Please make sure it is mounted!\n")
    end
end)