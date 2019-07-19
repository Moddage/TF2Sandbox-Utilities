hook.Add("Think", "TF2Sandbox", function()
    if SERVER then
        for k, v in pairs(ents.FindByClass("prop_physics")) do
            local ply = Entity(1)
            if v:GetModel() == "models/props_spytech/security_camera.mdl" and IsValid(ply) then
                --[[if ply:GetPos():Distance(v:GetPos()) <= 150 then]]
                    local ang = (ply:GetShootPos() - v:GetPos()):Angle()
                    v:SetAngles(Angle(0, ang.y - 90, -ang.p))
                --end
            end
        end
    end
end)