----------------------------
-- LiteScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--This is just the help menu. Dear god we need some optimization.
/*---------------------------------------------------------
 <<<<<Get the party started>>>>>
---------------------------------------------------------*/
local Panel = {}
// Init
function Panel:Init()
	//TitleBar
	self.Title = vgui.Create("Label", self)
	self.Title:SetText("LiteScript RP Help - (Use the mouse wheel to scroll. Press F1 to close)")
	// Backer and info
	self.Backer = vgui.Create("Panel", self)
	self.Info = vgui.Create("Panel", self.Backer)
	// Height
	self.Height = 16
	// Categories
	self.Backer = vgui.Create("Panel", self)
	self.Info = vgui.Create("Panel", self.Backer)
	// Scroll
	self.Scroll = 0
	self.DestinationScroll = 0
	// Input
	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
	//Opacity
	self.Alphap=0
	// Y
	//Offset vertical by 16.
	local Y = 16
	//STUPID FAGGOT AIDS
			//Text entries--FUCKING SHIT! AUTOMATE ALL OF THIS!!!!
			self.TextArea1 = vgui.Create("Label", self.Info)
			self.TextArea1:SetText("--Welcome! LiteScript 0.3 Alpha by John '[MT]OMalley' Dorian--")
			self.TextArea1:SetPos(16, Y)
			Y = Y+16
			
			self.TextArea2 = vgui.Create("Label", self.Info)
			self.TextArea2:SetText("If you're here now, you're most likely a member of [MT] or friend of [MT]OMalley, or of [HL2Land]John Dorian.")
			self.TextArea2:SetPos(16, Y)
			self.TextArea1:SetFont("Default")--Makes it normal
			Y = Y+16
			
			self.TextArea3 = vgui.Create("Label", self.Info)
			self.TextArea3:SetText("We'll I'm the same guy, for those who are crap at making connections.")
			self.TextArea3:SetPos(16, Y)
			self.TextArea1:SetFont("Default")--Makes it normal
			Y = Y+32
			
			self.TextArea4 = vgui.Create("Label", self.Info)
			self.TextArea4:SetText("Well let's see here. What can we say about the gamemode today?")
			self.TextArea4:SetPos(16, Y)
			self.TextArea1:SetFont("Default")--Makes it normal
			Y = Y+16
			
			self.TextArea5 = vgui.Create("Label", self.Info)
			self.TextArea5:SetText("First off, HUD is changed to make it more realistic. When you're badly injured, your screen is blurry and red.")
			self.TextArea5:SetPos(16, Y)
			self.TextArea1:SetFont("Default")--Makes it normal
			Y = Y+16
			
			self.TextArea6 = vgui.Create("Label", self.Info)
			self.TextArea6:SetText("Other than the simple chat commands, nothing really works. TADA!")
			self.TextArea6:SetPos(16, Y)
			self.TextArea1:SetFont("Default")--Makes it normal
			Y = Y+16
		//MORE AIDS TO FIX RESOLUTION AIDS
			// Text
			// Increase Y
			Y = Y + 3200
			// Increase height
			self.Height = self.Height + 3200
		Y = Y + 1600
		self.Height = self.Height + 1600
end
// Perform layout--Sizes shit according to the screen size, and how much text is in the area.
function Panel:PerformLayout()
	// Size
	self:SetSize(ScrW() - 16, ScrH() - 64)
	// Backer
	self.Backer:SetPos(8, 32)
	self.Backer:SetSize(self:GetWide() - 16, self:GetTall() - 40)
	// Info
	self.Info:SetSize(self.Backer:GetWide(), self.Height)
	// Text--AUTOMATE THIS SHIT LATER
	self.TextArea1:SizeToContents()
	self.TextArea2:SizeToContents()
	self.TextArea3:SizeToContents()
	self.TextArea4:SizeToContents()
	self.TextArea5:SizeToContents()
	self.TextArea6:SizeToContents()
	self.Info:SizeToContents()
	// Title
	self.Title:SetPos(16, 8)
	self.Title:SizeToContents()
end
// Mouse wheeled
function Panel:OnMouseWheeled(Delta)
    self.DestinationScroll = self.Scroll + (Delta * FrameTime() * 2000)
end
// Paint
function Panel:Paint()
	if self.On then
		if self.Alphap<1 then
			self.Alphap=math.Clamp(self.Alphap+0.1,0,1)
		end
	else
		if self.Alphap>0 then
			self.Alphap=math.Clamp(self.Alphap-0.05,0,1)
		end
	end
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(75, 75, 75, 150*self.Alphap))
	draw.RoundedBox(4, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color(25, 25, 25, 150*self.Alphap))
	draw.RoundedBox(4, self.Backer.X, self.Backer.Y, self.Backer:GetWide(), self.Backer:GetTall(), Color(135, 135, 135, 150*self.Alphap))
	// Y
	local Maximum = self.Backer:GetTall()
	local Division = self.Info:GetTall() - (self:GetTall() + 88)
	local Current = self.Backer.Y - self.Scroll
	local Percentage = (Maximum / Division) * Current
	local Final = math.Clamp(Percentage, self.Backer.Y + 4, Maximum)
	// Scroll
	draw.RoundedBox(4, self.Backer:GetWide() - 12, self.Backer.Y + 4, 12, self.Backer:GetTall() - 12, Color(125, 125, 125, 150*self.Alphap))
	draw.RoundedBox(4, self.Backer:GetWide() - 10, self.Backer.Y + 6, 8, self.Backer:GetTall() - 16, Color(150, 150, 150, 150*self.Alphap))
	draw.RoundedBox(4, self.Backer:GetWide() - 12, Final, 12, 24, Color(150, 150, 150, 150*self.Alphap))
	draw.RoundedBox(4, self.Backer:GetWide() - 10, Final + 2, 8, 20, Color(100, 100, 100, 150*self.Alphap))
	//Titlebar color
	self.Title:SetFGColor(Color(255, 255, 255, 255*self.Alphap))
	//D-D-D-D-DICKS IN MY MOUTH!
	//Fading Text areas --AUTOMATE THIS SHIT TOO
			self.TextArea1:SetFGColor(Color(0, 255, 255, 255*self.Alphap))
			self.TextArea2:SetFGColor(Color(255, 255, 255, 255*self.Alphap))
			self.TextArea3:SetFGColor(Color(255, 255, 255, 255*self.Alphap))
			self.TextArea4:SetFGColor(Color(255, 255, 255, 255*self.Alphap))
			self.TextArea5:SetFGColor(Color(255, 255, 255, 255*self.Alphap))
			self.TextArea6:SetFGColor(Color(255, 255, 255, 255*self.Alphap))
	// Return true
	return true
end
// Apply scheme settings--Not really needed, seeing as PAINT overwrites this anyway.
function Panel:ApplySchemeSettings()
	self.Title:SetFont("ChatFont")
			self.TextArea1:SetFont("ChatFont")--Makes it bold
	self.Title:SetFGColor(Color(255, 255, 255, 255)) 	
end
// Think
function Panel:Think()
	self:SetPos(8, 48)
	// Clicker
	if self.On then
		gui.EnableScreenClicker(true)
	else
		gui.EnableScreenClicker(false)
	end
	// Scroll
    self.Scroll = self.Scroll + (self.DestinationScroll - self.Scroll) * 0.5
    self.Scroll = math.Clamp(self.Scroll, -(self.Info:GetTall() - (self:GetTall() + 88)), 0)
	// Position
	self.Info:SetPos(0, self.Scroll)
end
// Register
vgui.Register("Help", Panel, "Panel")