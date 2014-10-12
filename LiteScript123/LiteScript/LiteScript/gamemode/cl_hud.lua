----------------------------
-- LiteScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--HUD modificaitons and drawing
/*---------------------------------------------------------
 <<<<<Get the party started>>>>>
---------------------------------------------------------*/
//Hurt so we get blurry vision
local function DrawDamagedDisplay()
	if( not LocalPlayer():Alive() ) then return; end
	if( LocalPlayer():Health() <= 50 ) then
		if( LocalPlayer():Health() <= 40 ) then
			local blurmul = 0;
			local cutoff = 50;
			if( LocalPlayer():Health() <= 30 ) then
				cutoff = 120;
			end
			if( LocalPlayer():Health() <= 20 ) then
				cutoff = 200;
			end	
			blurmul = 1 - math.Clamp( LocalPlayer():Health() / cutoff, 0, 1 );
			-- .149
			-- .955
			-- .068
			DrawMotionBlur( .149 * blurmul, .955 * blurmul, .068 * blurmul );
		end
		surface.SetDrawColor( 135, 0, 0, 160 * ( 1 - math.Clamp( LocalPlayer():Health() / 50, 0, 1 ) ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
	end
end

//HudPaint
function GM:HUDPaint()
	DrawDamagedDisplay();
	if( ply:SteamID() == "STEAM_0:0:9047412" ) then
		for k, v in pairs( player.GetAll() ) do
			if( v ~= LocalPlayer() ) then
				local pos = v:GetPos():ToScreen();
				draw.DrawText( v:Nick(), "ChatFont", pos.x, pos.y-40, Color( 0, 255, 255, 255 ) );
			end
		end
	end
end
 

function GM:HUDShouldDraw( name )
	local nodraw = 
	{
		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery"
	}
	for k, v in pairs( nodraw ) do
		if( name == v ) then return false; end
	end
	return true;
end
