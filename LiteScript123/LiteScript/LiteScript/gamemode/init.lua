----------------------------
-- LiteScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Initialize EVERYTHING
----------------------------
--NEVER EVER FOR HL2LAND.NET SERVERS. DO NOT LET GREYFOX OR RICK D. GET A COPY OF THIS. RAGGLEFRAGGLE--
/*---------------------------------------------------------

 <<<<<Get the party started>>>>>
-------------Ready for some hacky shit?
---------------------------------------------------------*/

DeriveGamemode( "sandbox" );
//ClientSideShit
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "vgui/cl_helpvgui.lua" );
AddCSLuaFile("cl_scoreboard.lua");
//Includes
include( 'adminpowers.lua' )--Give us magical powers!
include( 'animations.lua' )--Give us magical powers!
include( 'resources.lua' )--Give us magical powers!
include( 'player_hooks.lua' )--Give us magical powers!
include( 'commands.lua' )--Set up our regular powers!!!
include( 'combine_sounds.lua' )--Set up our regular powers!!!
include( 'chat.lua' )--Set up our regular powers!!!
include( 'config.lua' )--Set up our variables!!!

local ents_FindInSphere = ents.FindInSphere
GM.Name = "LiteScript";

local PlayerMeta = FindMetaTable("Player")

function GM:Initialize()
	self.BaseClass:Initialize();
end


function GM:ShowHelp(ply)
	umsg.Start("togglehelp",ply) -- pop up box
	umsg.End()
end


function GM:CanPlayerSuicide() --No Kill in console =D Thanks Grey, you faggot.
return false; 
end

/*---------------------------------------------------------
 <<<<<Utility functions>>>>>
---------------------------------------------------------*/

/*---------------------------------------------------------
  Eye Tracing
---------------------------------------------------------*/
function PlayerMeta:TraceFromEyes(dist)
         local trace = {}
         trace.start = self:GetShootPos()
         trace.endpos = trace.start + (self:GetAimVector() * dist)
         trace.filter = self
         return util.TraceLine(trace)
end
/*---------------------------------------------------------
  END Eye Tracing
---------------------------------------------------------*/



/*---------------------------------------------------------
  Custom player messages
---------------------------------------------------------*/
function PlayerMeta:SendMessage(text,duration,color)
         local duration = duration or 3
         local color = color or Color(255,255,255,255)

         umsg.Start("ls_sendmessage",self)
         umsg.String(text)
         umsg.Short(duration)
         umsg.String(color.r..","..color.g..","..color.b..","..color.a)
         umsg.End()
end


/*---------------------------------------------------------
  Range chat - Are people within the distance or sphere?
---------------------------------------------------------*/
function RangeChat(msg, pos, size)
	local sphere = ents_FindInSphere(pos, size)
	for k, v in pairs(sphere) do
		if ( v:IsPlayer() ) then
			v:ChatPrint(msg)
		end
	end
end


function Notify( ply, msgtype, len, msg )--Notify? Find out where this is used, seems un-needed. In Private messaging
	ply:PrintMessage( 2, msg );
	ply:SendLua( "GAMEMODE:AddNotify(\"" .. msg .. "\", " .. msgtype .. ", " .. len .. ")" );
end


function FindPlayer( info )--Push through the list, find one that matches the info.
	for k, v in pairs( player.GetAll() ) do
		if( tonumber( info ) == v:EntIndex() ) then
			return v;
		end
		if( info == v:SteamID() ) then
			return v;
		end
		if( string.find( v:Nick(), info ) ~= nil ) then
			return v;
		end
	end
	return nil;
end


/*---------------------------------------------------------
  Private Message - A bitch.
---------------------------------------------------------*/
function PM( ply, args )
	local namepos = string.find( args, " " );--Look for a space that would deperate the name and the message
	if( not namepos ) then return ""; end--No space? You suck.
	local name = string.sub( args, 1, namepos - 1 );--Name is before the space
	local msg = string.sub( args, namepos + 1 );--msg is after the space
	target = FindPlayer( name );--Find dat foo
	if( target ) then--Target exists? Send that shit!
		target:PrintMessage( 2, "[PM] from " .. ply:Nick() .. ": " .. msg );--console
		target:PrintMessage( 3, "[PM] from " .. ply:Nick() .. ": " .. msg );--chat
		ply:PrintMessage( 2, "[PM] to" .. " "..target:Nick() .." : ".. msg );--console
		ply:PrintMessage( 3, "[PM] to" .. " "..target:Nick() .." : ".. msg );--chat
	else--If target doesnt exist, BLAH! NO TARGET!
		Notify( ply, 1, 3, "Could not find player: " .. name );--Notify?
		ply:SendMessage("Could not find player: ".. name ,5,Color(255,255,0,255))--Left fading notify.
	end
	return "";
end
AddChatCommand( "/pm", PM );


/*---------------------------------------------------------
  YELLING
---------------------------------------------------------*/
function Yell( ply, args )
	RangeChat( "[YELL]" .. ply:Nick() .. ": " .. args, ply:GetPos(), 550 );
	return "";
end
AddChatCommand( "/y", Yell );


/*---------------------------------------------------------
 /me
---------------------------------------------------------*/
function Me( ply, args )
	RangeChat( "*** " .. ply:Nick() .. " " .. args, ply:GetPos(), 550 );
	return "";
end
AddChatCommand( "/me", Me );


/*---------------------------------------------------------
 Local OOC
---------------------------------------------------------*/
function LocalOOC( ply, args )
	RangeChat( "[LocalOOC]" .. ply:Nick() .. ": " .. args, ply:GetPos(), 550 );
	return "";
end
AddChatCommand( "[[", LocalOOC );


/*---------------------------------------------------------
  Whispering
---------------------------------------------------------*/
function Whisper( ply, args )
	RangeChat( "[WHISPER]" .. ply:Nick() .. ": " .. args, ply:EyePos(), 90 );
	return "";
end
AddChatCommand( "/w", Whisper );


/*---------------------------------------------------------
  Smileing
---------------------------------------------------------*/
function Smile( ply, args )
	RangeChat( "[Emote]" .. ply:Nick() .. " smiles.", ply:EyePos(), 190 );
	return "";
end
AddChatCommand( ":)", Smile );

/*---------------------------------------------------------
  Frowning
---------------------------------------------------------*/
function Frown( ply, args )
	RangeChat( "[Emote]" .. ply:Nick() .. " frowns.", ply:EyePos(), 190 );
	return "";
end
AddChatCommand( ":(", Frown );


/*---------------------------------------------------------
  Out of Character
---------------------------------------------------------*/
function OOC( ply, args )
	return "[OOC] " .. args;
end
AddChatCommand( "//", OOC, true );
AddChatCommand( "/a ", OOC, true );
AddChatCommand( "/ooc", OOC, true );


/*---------------------------------------------------------
  Flags
---------------------------------------------------------*/
function GoScanner( ply )
	if(ply:GetNWInt("setflag") != 2) then
		if(ply:GetNWInt("allowscanner") == 1) then
			ply:Kill();
			ply:SetNWInt("setflag", 2)
		end
	end
	return ""
end
AddChatCommand( "/scanner", GoScanner );


function GoShieldScanner( ply )
	if(ply:GetNWInt("setflag") != 4) then
		if(ply:GetNWInt("allowshieldscanner") == 1) then
			ply:Kill();
			ply:SetNWInt("setflag", 4)
		end
	end
	return ""
end
AddChatCommand( "/shieldscanner", GoShieldScanner );


function GoCitizen( ply )
	if(ply:GetNWInt("setflag") != 1) then
		ply:Kill();
		ply:SetNWInt("setflag", 1)
	end
	return ""
end
AddChatCommand( "/citizen", GoCitizen );


function GoVort( ply )		
	if(ply:GetNWInt("setflag") != 3) then
		if(ply:GetNWInt("allowvort") == 1) then
			ply:Kill();
			ply:SetNWInt("setflag", 3)
		end
	end
	return ""
end
AddChatCommand( "/vort", GoVort );
