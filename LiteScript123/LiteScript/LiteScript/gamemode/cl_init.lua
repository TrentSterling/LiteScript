----------------------------
-- LiteScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Clientside initialization!
/*---------------------------------------------------------
 <<<<<Get the party started>>>>>
---------------------------------------------------------*/
DeriveGamemode( "sandbox" );
GUIClickerEnabled = false;
GUIClickerCount = 0;
gui.EnableScreenClicker( false );
local PlayerMeta = FindMetaTable("Player")--get the players
//Includes
include( 'vgui/cl_helpvgui.lua' )--HelpGUI!
include( 'cl_hud.lua' )--HUD!
include( 'cl_scoreboard.lua' )--HUD!
include( 'commands.lua' )--Set up our regular powers!!!
include( 'animations.lua' )--Set up our animations!!!
include( 'combine_sounds.lua' )--Set up our regular powers!!!

//Start up the help menu on game start
	F1WINDOW=vgui.Create( "Help" )
	F1WINDOW:SetVisible( true )
	F1WINDOW.On=true
	
//Toggle the help on and off.
function GM.ToggleHelp(um)
	F1WINDOW.On=!F1WINDOW.On
	if F1WINDOW.On then
		gui.EnableScreenClicker(true)
	else
		gui.EnableScreenClicker(false)
	end
end
usermessage.Hook("togglehelp", GM.ToggleHelp)


/*---------------------------------------------------------

  <<<<<Utility functions>>>>>

---------------------------------------------------------*/
/*---------------------------------------------------------
  Info Messages
---------------------------------------------------------*/
GM.InfoMessages = {}
GM.InfoMessageLine = 0
function GM.SendMessage(um)
         local text = um:ReadString()
         local dur = um:ReadShort()
         local col = um:ReadString()
         local str = string.Explode(",",col)
         local col = Color(tonumber(str[1]),tonumber(str[2]),tonumber(str[3]),tonumber(str[4]))

         for k,v in pairs(GAMEMODE.InfoMessages) do
             v.drawline = v.drawline + 1
         end

         local message = {}
         message.Text = text
         message.Col = col
         message.Tab = 5
         message.drawline = 1

         GAMEMODE.InfoMessages[#GAMEMODE.InfoMessages + 1] = message
         GAMEMODE.InfoMessageLine = GAMEMODE.InfoMessageLine + 1
         
         timer.Simple(dur,GAMEMODE.DropMessage,message)
end
usermessage.Hook("ls_sendmessage",GM.SendMessage)


function GM.DrawMessages()
         for k,msg in pairs(GAMEMODE.InfoMessages) do
             local txt = msg.Text
             local line = ScrH() / 2 + (msg.drawline * 20)
             local tab = msg.Tab
             local col = msg.Col
             draw.SimpleTextOutlined(txt,"ScoreboardText",tab,line,col,0,0,0.5,Color(100,100,100,150))
             
             if msg.Fading then
                msg.Tab = msg.Tab - (msg.InitTab - msg.Tab + 0.01)
                
                if msg.Tab < -2000 then--Allow text to go off screen
                   GAMEMODE.RemoveMessage(msg)
                end
             end
         end
end

hook.Add("HUDPaint","ls_drawmessages",GM.DrawMessages)

function GM.DropMessage(msg)
         msg.InitTab = msg.Tab
         msg.Fading = true
end

function GM.RemoveMessage(msg)
         for k,v in pairs(GAMEMODE.InfoMessages) do
             if v == msg then
                GAMEMODE.InfoMessages[k] = nil
                GAMEMODE.InfoMessageLine = GAMEMODE.InfoMessageLine - 1
                table.remove(GAMEMODE.InfoMessages,k)
             end
         end
end
/*---------------------------------------------------------
  END Info Messages
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