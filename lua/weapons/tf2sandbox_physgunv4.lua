AddCSLuaFile()

SWEP.PrintName = "Physics Gun V4"
SWEP.Slot = 1
SWEP.ViewModel = "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.Category = "Team Fortress 2 Sandbox"
SWEP.Author = "LeadKiller, ✅TatLead"
SWEP.DrawWeaponInfoBox = true
SWEP.Spawnable = true
SWEP.m_WeaponDeploySpeed = 150
SWEP.SwayScale = 0
SWEP.BobScale = 0.8
SWEP.BounceWeaponIcon = false
SWEP.DrawAmmo = false
SWEP.m_bPlayPickupSound = false
SWEP.AutoSwitchFrom = false

local beammat = nil
local flashing = CreateClientConVar("tf2sandbox_v4_flashingmsg", "1", true, true, "Enable flashing hud bug")

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("backpack/weapons/c_models/c_saxxy/c_saxxy_large")
	surface.CreateFont("TF2HudMSG33", {font = "Trebuchet MS", size = 40, weight = 900, antialias = true})
	beammat = Material("sprites/physbeam")
end

local function HasHeldEntity(ent) -- fucking let me set it nil in future update
	if IsValid(ent) and ent:IsWeapon() then
		return IsValid(ent:GetNWEntity("tf2sb_heldentity")) and ent:GetNWEntity("tf2sb_heldentity") ~= ent
	elseif IsValid(ent) then
		return IsValid(ent) and ent:GetClass() ~= "tf2sandbox_physgunv4"
	end
end

hook.Add("HUDPaint", "TF2Sandbox_PhysgunV4", function()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	if IsValid(wep) and (wep:GetClass() == "tf2sandbox_physgunv4" or wep:GetClass() == "tf2sandbox_toolgun") then
		local trace = ply:GetEyeTrace()

		if IsValid(trace.Entity) and trace.Entity:GetClass() == "prop_physics" then
			local ent = trace.Entity
			local name = ent:GetNWString("Name")
			local owner = ply:Nick()
			local alpha = math.random(100, 200)
			if name == "" then
				name = tf2sb.GetPropName(ent:GetModel())
			end
			if !flashing:GetBool() then
				alpha = 175
			end
			if ent.CPPIGetOwner then
				owner = ent:CPPIGetOwner():Nick()
			end
			draw.SimpleText(name, "TF2HudMSG33", ScrW() * 0.5, ScrH() * 0.55, Color(255, 25, 25, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("built by " .. owner, "TF2HudMSG33", ScrW() * 0.5, ScrH() * 0.58, Color(255, 25, 25, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local alpha = math.random(100, 200)
		if !flashing:GetBool() then
			alpha = 175
		end

		local tophudc = Color(0, 245, 255, alpha)
		draw.SimpleText("Press TAB or say !build", "TF2HudMSG33", ScrW() * 0.5, ScrH() * 0.015, tophudc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Current Props: " .. ply:GetCount("props") .. "/" .. GetConVar("sbox_maxprops"):GetFloat(), "TF2HudMSG33", ScrW() * 0.5, ScrH() * 0.042, tophudc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if wep:GetClass() == "tf2sandbox_physgunv4" then
			local mode = "TF2Sandbox"
			local ent = wep:GetNWEntity("tf2sb_heldentity")
			if wep:GetNWBool("tf2sb_mode") then
				mode = "Garry's Mod"
			end

			alpha = math.random(200, 230)
			if !flashing:GetBool() then
				alpha = 200
			end
			local msg = {"TF2HudMSG33", ScrW() * 0.75, ScrH() * 0.45, Color(0, 220, 235, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP} -- "MODE: %s\n\nObject: %s\nName: %s\nOwner: %N"
			local keys = {}
			keys[1] = input.LookupBinding("+attack2") or "UNBOUND"
			keys[2] = input.LookupBinding("+attack") or "UNBOUND"
			keys[3] = input.LookupBinding("+zoom") or "UNBOUND"
			keys[4] = input.LookupBinding("+reload") or "UNBOUND"
			keys[5] = input.LookupBinding("+duck") or "UNBOUND"
			keys[6] = input.LookupBinding("impulse 201") or "UNBOUND"

			draw.SimpleText("MODE: " .. mode, msg[1], msg[2], ScrH() * 0.45, msg[4], msg[5], msg[6])

			for k, v in pairs(keys) do -- fps loss? probably!
				keys[k] = string.upper(v)
			end

			if input.LookupKeyBinding(MOUSE_FIRST) == "+attack" then -- why the fuck is enter bound to attack automatically?!
				keys[2] = "MOUSE1"
			end

			if !HasHeldEntity(ent) then
				draw.SimpleText("[" .. keys[1] .. "] Change Mode", msg[1], msg[2], ScrH() * 0.525, msg[4], msg[5], msg[6])
				draw.SimpleText("[" .. keys[2] .. "] Grab", msg[1], msg[2], ScrH() * 0.56, msg[4], msg[5], msg[6])
				draw.SimpleText("[" .. keys[3] .. "] Pull/Push", msg[1], msg[2], ScrH() * 0.595, msg[4], msg[5], msg[6])
				draw.SimpleText("[" .. keys[4] .. "] Rotate", msg[1], msg[2], ScrH() * 0.63, msg[4], msg[5], msg[6])
				draw.SimpleText("[" .. keys[4] .. "]+[" .. keys[5] .. "] Rotate 45*", msg[1], msg[2], ScrH() * 0.665, msg[4], msg[5], msg[6])
				draw.SimpleText("[" .. keys[6] .. "] Smart Copy", msg[1], msg[2], ScrH() * 0.7, msg[4], msg[5], msg[6])
			else
				draw.SimpleText("Object: " .. ent:GetClass(), msg[1], msg[2], ScrH() * 0.56, msg[4], msg[5], msg[6])
				draw.SimpleText("Name: " .. tf2sb.GetPropName(ent:GetModel()), msg[1], msg[2], ScrH() * 0.6, msg[4], msg[5], msg[6])
				if ent.CPPIGetOwner then
					draw.SimpleText("Owner: " .. ent:CPPIGetOwner():Nick(), msg[1], msg[2], ScrH() * 0.64, msg[4], msg[5], msg[6])
				end
			end
		end
	end
end)

hook.Add("PreDrawHalos", "TF2Sandbox_PhysgunV4", function()
	for k, v in pairs(ents.FindByClass("tf2sandbox_physgunv4")) do
		local ent = v:GetNWEntity("tf2sb_heldentity")

		if HasHeldEntity(ent) then
			halo.Add({ent}, Color(0, 235, 230, 255), 0.5, 0.5, 4, true, true)
		end
	end
end)

function SWEP:Initialize()
	self:SetHoldType("melee")
	if SERVER then
		self:SetNWBool("tf2sb_mode", true) -- false = tf2sb true = gmod
		self:SetNWEntity("tf2sb_heldentity", self) -- held entity
		self:SetNWEntity("tf2sb_grabentity", self.GrabEntity)
	end
end

function SWEP:OnRemove()
	if SERVER then
		if IsValid(self:GetNWEntity("tf2sb_heldentity")) then
			self:GetNWEntity("tf2sb_heldentity"):SetParent(nil)
		end

		self.GrabEntity:Remove()
	end
end

function SWEP:Deploy()
	if SERVER and !self.PrintMsg then
		self.PrintMsg = true
		self.Owner:SendLua([[chat.AddText(Color(255, 255, 255), "[", Color(62, 255, 62), "TF2SB", Color(255, 255, 255), "] You have equipped a Physics Gun (Sandbox version)!")]])
	end
end

function SWEP:DrawWorldModel()
	if self:GetNWBool("tf2sb_beam") then
		render.SetMaterial(beammat)
		local ent = self.Owner:GetEyeTrace().HitPos
		if HasHeldEntity(self) and IsValid(self:GetNWEntity("tf2sb_grabentity")) then
			ent = LerpVector(0.1, ent, self:GetNWEntity("tf2sb_grabentity"):GetPos())
		end

		render.DrawBeam(ent, self:GetPos(), 3, 0, 1, Color(0, 191, 255, 255))
	end

	if self.Owner == LocalPlayer() then
		self:SetSkin(1)
		self:DrawModel()
	end
end

function SWEP:PreDrawViewModel(vm)
	if self:GetNWBool("tf2sb_beam") then
		local att = vm:GetAttachment(vm:LookupAttachment("muzzle"))
		local ent = util.QuickTrace(self.Owner:EyePos(), self.Owner:EyeAngles():Forward() * 250, self.Owner).HitPos
		if HasHeldEntity(self) and IsValid(self:GetNWEntity("tf2sb_grabentity")) then
			ent = LerpVector(0.1, ent, self:GetNWEntity("tf2sb_grabentity"):GetPos())
		end

		render.SetMaterial(beammat)
		cam.IgnoreZ(true) -- Call this earlier than the game does, so we can get the beam done. We do not need to call this again with false as the game does it for us!
		for i = 0, 2 do
			render.DrawBeam(ent, att.Pos, 2, 0, math.random(30), Color(0, 191, 255, 255))
		end
	end
end

local rotatey = 0
local rotatep = 0
local rotateya = 0
local rotatepa = 0

if SERVER then
	hook.Add("StartCommand", "TF2Sandbox_PhysgunV4", function(ply, cmd)
		rotatey = cmd:GetMouseX() / 6.0
		rotatep = cmd:GetMouseY() / 6.0
		rotateya = cmd:GetMouseX() / 0.6
		rotatepa = cmd:GetMouseY() / 0.6
	end)
end

function SWEP:Think()
	local ply = self.Owner

	if !IsValid(ply) then return end

	if SERVER and !IsValid(self.GrabEntity) then
		self.GrabEntity = ents.Create("prop_dynamic")
		self.GrabEntity:SetModel("models/weapons/w_physics.mdl")
		self.GrabEntity:SetModelScale(0, 0)
		self.GrabEntity:Spawn()

		self:SetNWEntity("tf2sb_grabentity", self.GrabEntity)
	end

	if CLIENT then
		self.ViewModelFOV = GetConVar("viewmodel_fov"):GetFloat()
	end

	if SERVER then
		local ent = self:GetNWEntity("tf2sb_heldentity")
		self:SetNWBool("tf2sb_beam", self.Owner:KeyDown(IN_ATTACK))

		if !HasHeldEntity(self) then
			if self.Owner:KeyDown(IN_ATTACK) then
				local trace = self.Owner:GetEyeTrace()
				ent = trace.Entity
				if IsValid(ent) and ent:GetClass() == "prop_physics" then
					self:SetNWEntity("tf2sb_heldentity", ent)
					self.HitPropPos = ent:GetPos() - trace.HitPos
					self.HitPropPos2 = ent:GetPos() - trace.HitPos
					self.HitPropPosDis = trace.HitPos:Distance(trace.StartPos)
					self.GrabEntity:SetPos(trace.HitPos)
					ent:SetParent(self.GrabEntity)
				end
			elseif self.Owner:KeyPressed(IN_ATTACK2) and !self.Owner:KeyReleased(IN_ATTACK2) then
				self:SetNWBool("tf2sb_mode", !self:GetNWBool("tf2sb_mode"))
				self.Owner:SendLua("surface.PlaySound(\"buttons/button15.wav\")")
			end
		elseif HasHeldEntity(self) then
			if IsValid(ent:GetPhysicsObject()) then
				ent:GetPhysicsObject():EnableMotion(false)
			end

			local trace = util.QuickTrace(ply:EyePos(), ((self.Owner:GetEyeTrace().HitPos) - self.Owner:GetShootPos()):Angle():Forward() * self.HitPropPosDis, {ent, self, self.Owner})

			if self.Owner:KeyDown(IN_RELOAD) then
				self.Owner:SetEyeAngles((self.GrabEntity:GetPos() - self.Owner:GetShootPos()):Angle())
				local tf2sba = Angle(rotatep, rotatey, 0)
				local gmoda = Angle(rotatep, rotatey, 0)
				tf2sba:Normalize()
				gmoda:Normalize()

				if self.Owner:KeyDown(IN_DUCK) then
					gmoda:SnapTo("y", 45)
					gmoda:SnapTo("p", 45)
					tf2sba:SnapTo("y", 45)
					tf2sba:SnapTo("p", 45)
				end

				if !self:GetNWBool("tf2sb_mode") then -- VIRGIN TF2SB
					tf2sba:Normalize()
					local angles = (self.GrabEntity:GetAngles() + tf2sba)
					self.GrabEntity:SetAngles(angles)
				else -- CHAD GMOD
					local fangles = self.GrabEntity:GetAngles() + gmoda --Get Grab point angles
					fangles:Normalize() --Normalize
					self.GrabEntity:SetAngles(fangles) --Set Grab point angles
					ent:SetParent(nil) --Unstick
					self.GrabEntity:SetAngles(Angle(0, ply:EyeAngles().y, 0)) --Reset angles
					ent:SetParent(self.GrabEntity) --Stick
				end
			elseif self.Owner:KeyDown(IN_ATTACK) then
				self.GrabEntity:SetPos(LerpVector(0.5, self.GrabEntity:GetPos(), trace.HitPos))
				if self:GetNWBool("tf2sb_mode") then
					self.GrabEntity:SetAngles(self.GrabEntity:GetAngles() + Angle(0, -rotatey, 0))
				end
			elseif !self.Owner:KeyDown(IN_ATTACK) then
				ent:SetParent(nil)
				self:SetNWEntity("tf2sb_heldentity", self)
			end
		end
	end
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture( self.WepSelectIcon )

	-- Draw that mother
	surface.DrawTexturedRect( x, y,  wide, tall + 30 )

	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end

function SWEP:PrintWeaponInfo( x, y, alpha )
	if ( self.DrawWeaponInfoBox == false ) then return end

	if (self.InfoMarkup == nil ) then
		local str
		local title_color = "<color=230,230,230,255>"
		local text_color = "<color=150,150,150,255>"
		local att_color = "<color=153,204,255,255>"

		str = "<font=HudSelectionText>"
		if ( self.Author ~= "" ) then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if ( self.Contact ~= "" ) then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if ( self.Purpose ~= "" ) then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		str = str .. title_color .. "Level:</color>\t" .. text_color .. 99-128 .. "</color>\n\n"
		str = str .. att_color .. "Imbued with an ancient power</color>\n\n"
		if ( self.Instructions ~= "" ) then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
		str = str .. "</font>"

		self.InfoMarkup = markup.Parse( str, 250 )
	end

	surface.SetDrawColor( 60, 60, 60, alpha )
	surface.SetTexture( self.SpeechBubbleLid )

	surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 )
	draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )

	self.InfoMarkup:Draw( x + 5, y + 5, nil, nil, alpha )
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end