if tf2sb.ModdageStyleMap and game.GetMap() == "gm_teamcity_sunset_v1" then
    RunConsoleCommand("sv_skyname", "sky_upward")
    engine.LightStyle(0, "s")
end

concommand.Add("sm_del", function(ply)
    local entity = ply:GetEyeTrace().Entity
    if IsValid(entity) and !entity:IsPlayer() and entity:GetClass() == "prop_physics" then
        if !entity.CPPIGetOwner then ply:SendLua([[chat.AddText("You need FPP installed to use this!") steamworks.ViewFile("133537219")]]) return end
        if entity:CPPIGetOwner() == ply then
            ply:SendLua("achievements.Remover() surface.PlaySound(\"ui/panel_close.wav\")")
            entity:SetName("dissolveme")
            local dissolver = ents.Create("env_entity_dissolver")
            dissolver:SetKeyValue("dissolvetype", 3)
            dissolver:Spawn()
            dissolver:Fire("Dissolve", "dissolveme", 0)
            timer.Simple(1, function()
                dissolver:Remove()
            end)
        end
    end
end)

concommand.Add("sm_spawnprop", function(ply, _, args)
    ply:ConCommand("gm_spawn " .. args[1])
end)