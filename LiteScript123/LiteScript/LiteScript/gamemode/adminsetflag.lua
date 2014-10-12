----------------------------
-- LiteScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--This is where we give admins the ability to allow flags to players. Made external from 'adminpowers.lua' so we can stay organized.
----------------------------
include( 'adminsettemps.lua' )--Looping sounds

/*---------------------------------------------------------
  Allow the player to have a flag or class
---------------------------------------------------------*/

function SetAllowVort(ply, cmd, args)
		local target = GetPlayerByName(args[1])
		if(target != nil) then
            target:SendMessage("You have been allowed the Vortigaunt flag!",7,Color(0,255,0,255))
	target:SetNWInt("allowvort", 1)
		ply:PrintMessage( 2, "Sucessfully added flag to player *** " .. target:Nick() .. " *** ." );
		end
		
		if(target == nil) then
		ply:PrintMessage( 2, "Failed to find player." );
		end
		
end
concommand.Add("rp_allowvort", SetAllowVort)


function SetAllowScanner(ply, cmd, args)
		local target = GetPlayerByName(args[1])
		if(target != nil) then
            target:SendMessage("You have been allowed the City Scanner flag!",7,Color(0,255,0,255))
	target:SetNWInt("allowscanner", 1)
		ply:PrintMessage( 2, "Sucessfully added flag to player *** " .. target:Nick() .. " *** ." );
		end
		
		if(target == nil) then
		ply:PrintMessage( 2, "Failed to find player." );
		end
		
end
concommand.Add("rp_allowscanner", SetAllowScanner)


function SetAllowShieldScanner(ply, cmd, args)
		local target = GetPlayerByName(args[1])
		if(target != nil) then
            target:SendMessage("You have been allowed the Shield Scanner flag!",7,Color(0,255,0,255))
	target:SetNWInt("allowshieldscanner", 1)
		ply:PrintMessage( 2, "Sucessfully added flag to player *** " .. target:Nick() .. " *** ." );
		end
		
		if(target == nil) then
		ply:PrintMessage( 2, "Failed to find player." );
		end
		
end
concommand.Add("rp_allowshieldscanner", SetAllowShieldScanner)

