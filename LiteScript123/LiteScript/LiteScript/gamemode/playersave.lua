----------------------------
-- LiteScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Save the player's shit!
----------------------------

function CharCreate(player)
--Allow flags set to 0
	player:SetNWInt("allowscanner", 0)
	player:SetNWInt("allowshieldscanner", 0)
	player:SetNWInt("allowvort", 0)
--Set citizen flag
	player:SetNWInt("setflag", 1)
local IDSteam = string.gsub(player:SteamID(), ":", "")

	if not file.Exists("LiteScript/playerinfo/" .. IDSteam .. ".txt") then
		file.Write( "LiteScript/playerinfo/" .. IDSteam .. ".txt","BEGINCHARACTER \n Steam ID ")
	end
	
end
