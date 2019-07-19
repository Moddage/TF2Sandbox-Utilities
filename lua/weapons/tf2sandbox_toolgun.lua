AddCSLuaFile()

SWEP.PrintName = "Toolgun"
SWEP.Slot = 1
SWEP.ViewModel = "models/weapons/v_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
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
SWEP.Primary.Ammo = "Battery"
SWEP.Primary.Automatic = false
SWEP.Secondary.Ammo = "Battery"
SWEP.Secondary.Automatic = false

local beammat
local flashing = GetConVar("tf2sandbox_v4_flashingmsg")
local tgm = {}
tgm[0] = {name = "Remover", mouse1 = "Remove", mouse2 = "Remove", mode = false, primaryattack = function(ent) ent:Remove() end, secondaryattack = nil}
tgm[1] = {name = "Resizer", mouse1 = "Larger", mouse2 = "Smaller", mode = false, primaryattack = function(ent) ent:SetModelScale(math.Clamp(ent:GetModelScale() + 0.1, 0.1, 2.0), 0) end, secondaryattack = function(ent) ent:SetModelScale(math.Clamp(ent:GetModelScale() - 0.1, 0.1, 2.0), 0) end}
tgm[2] = "Set Collision"
tgm[3] = "Duplicator"
tgm[4] = "Set Alpha"
tgm[5] = "Set Color"
tgm[6] = "Set Skin"
tgm[7] = "Render FX"
tgm[8] = "Set Effect"

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("backpack/weapons/c_models/c_frying_pan/c_frying_pan_gold_large")
	beammat = Material("sprites/physbeam")
end

hook.Add("HUDPaint", "TF2Sandbox_ToolGun", function()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	if IsValid(wep) and wep:GetClass() == "tf2sandbox_toolgun" then
		local tab = tgm[wep:GetNWFloat("tf2sb_mode")]
		if !istable(tab) then return end
		local mode = tgm[wep:GetNWFloat("tf2sb_mode")]["name"] or "NIL"
		local mouse1 = tgm[wep:GetNWFloat("tf2sb_mode")]["mouse1"] or "NIL"
		local mouse2 = tgm[wep:GetNWFloat("tf2sb_mode")]["mouse2"] or "NIL"
		if tab["mode"] then
			mouse2 = "dead"
		end

		alpha = math.random(200, 230)
		if !flashing:GetBool() then
			alpha = 200
		end
		local msg = {"TF2HudMSG33", ScrW() * 0.7, ScrH() * 0.5, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP} -- "MODE: %s\n\nObject: %s\nName: %s\nOwner: %N"
		draw.SimpleText("-----------------------", msg[1], ScrW() * 0.7, ScrH() * 0.47, msg[4], msg[5], msg[6])
		draw.SimpleText(string.upper(mode), msg[1], ScrW() * 0.772, ScrH() * 0.502, msg[4], TEXT_ALIGN_CENTER, msg[6])
		draw.SimpleText("-----------------------", msg[1], ScrW() * 0.7, ScrH() * 0.53, msg[4], msg[5], msg[6])
		draw.SimpleText("[MOUSE1] " .. mouse1, msg[1], msg[2], ScrH() * 0.57, msg[4], msg[5], msg[6])
		draw.SimpleText("[MOUSE2] " .. mouse2, msg[1], msg[2], ScrH() * 0.61, msg[4], msg[5], msg[6])
		draw.SimpleText("[RELOAD] Switch Tools (" .. wep:GetNWFloat("tf2sb_mode") .. ")", msg[1], msg[2], ScrH() * 0.65, msg[4], msg[5], msg[6])
	end
end)

function SWEP:Initialize()
	self:SetHoldType("melee")
	if SERVER then
		self:SetNWFloat("tf2sb_mode", 0)
	end
end

function SWEP:Deploy()
	if SERVER and !self.PrintMsg then
		self.PrintMsg = true
		self.Owner:SendLua([[chat.AddText(Color(255, 255, 255), "[", Color(62, 255, 62), "TF2SB", Color(255, 255, 255), "] You have equipped a Tool Gun (Sandbox version)!")]])
	end
end

function SWEP:DrawWorldModel()
	if self:GetNextPrimaryFire() > CurTime() then
		render.SetMaterial(beammat)
		local ent = self.Owner:GetEyeTrace().HitPos
		for i = 1, 2 do
			render.DrawBeam(ent, self:GetPos(), 3, 0, math.random(30), Color(0, 191, 255, 255))
		end
	end

	if self.Owner == LocalPlayer() then
		self:DrawModel()
	end
end

function SWEP:PreDrawViewModel(vm)
	if self:GetNextPrimaryFire() > CurTime() then
		local att = vm:GetAttachment(vm:LookupAttachment("muzzle"))
		local ent = self:GetNWVector("tf2sb_hitpos")

		cam.IgnoreZ(true) -- Call this earlier than the game does, so we can get the beam done. We do not need to call this again with false as the game does it for us!
		render.SetMaterial(beammat)
		for i = 1, 2 do
			render.DrawBeam(att.Pos + att.Ang:Forward() * 15, ent, 3, 0, math.random(30), Color(0, 191, 255, 255))
		end
	end
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:EmitSound("weapons/airboat/airboat_gun_lastshot" .. math.random(1, 2) .. ".wav")

		if IsValid(self.Owner:GetEyeTrace().Entity) then
			local ent = self.Owner:GetEyeTrace().Entity
			tgm[self:GetNWFloat("tf2sb_mode")]["primaryattack"](ent)
		end
	end
end

function SWEP:SecondaryAttack()
	if self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:EmitSound("weapons/airboat/airboat_gun_lastshot" .. math.random(1, 2) .. ".wav")

		if IsValid(self.Owner:GetEyeTrace().Entity) then
			local ent = self.Owner:GetEyeTrace().Entity
			if !tgm[self:GetNWFloat("tf2sb_mode")]["secondaryattack"] then
				tgm[self:GetNWFloat("tf2sb_mode")]["primaryattack"](ent)
				return
			end
			tgm[self:GetNWFloat("tf2sb_mode")]["secondaryattack"](ent)
		end
	end
end

function SWEP:Reload()
end

function SWEP:Think()
	local ply = self.Owner

	if !IsValid(ply) then return end

	if CLIENT then
		self.ViewModelFOV = GetConVar("viewmodel_fov"):GetFloat()
	end

	if SERVER then
		if self:GetNextPrimaryFire() < CurTime() then
			self:SetNWVector("tf2sb_hitpos", self.Owner:GetEyeTrace().HitPos)
		end

		if self.Owner:KeyPressed(IN_RELOAD) and !self.Owner:KeyReleased(IN_RELOAD) then
			self:SetNWFloat("tf2sb_mode", self:GetNWFloat("tf2sb_mode") + 1)
			if self:GetNWFloat("tf2sb_mode") == #tgm + 1 then
				self:SetNWFloat("tf2sb_mode", 0)
			end
			self.Owner:SendLua([[surface.PlaySound("buttons/button15.wav")]])
		end
	end
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture( self.WepSelectIcon )

	-- Draw that mother
	surface.DrawTexturedRect( x, y - 10,  wide, tall + 30 )

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