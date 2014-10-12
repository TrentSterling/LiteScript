
DeriveGamemode( "sandbox" );


include( 'shared.lua' )--INCLUDE THE FLAG SYSTEM!
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

local PlayerMeta = FindMetaTable("Player")

function GM:Initialize()
	self.BaseClass:Initialize();
end




function GM:CanPlayerSuicide(ply)
	ply:ChatPrint("No suiciding.")
	return false
end
