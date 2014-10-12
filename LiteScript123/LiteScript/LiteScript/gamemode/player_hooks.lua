----------------------------
-- LiteScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Player configuration and limits
----------------------------
include( 'playersave.lua' )
include( 'flags.lua' )

local meta = FindMetaTable( "Player" );

function GM:PhysgunDrop( ply, ent )--No flinging of objects with the physbeam!!!
	if( ent:IsValid() and not ply:KeyDown( IN_ATTACK2 ) ) then
		ent:GetPhysicsObject():EnableMotion( false );
		timer.Simple( .001, ent:GetPhysicsObject().EnableMotion, ent:GetPhysicsObject(), true );
	end
end


function GM:GravGunPunt( ply, ent )--No punting
	local entphys = ent:GetPhysicsObject()
	if( ply:KeyDown(IN_ATTACK) ) then
		// it was launched
		entphys:EnableMotion( false )
		local curpos = ent:GetPos()
		timer.Simple( .01, entphys.EnableMotion, entphys, true )
		timer.Simple( .01, entphys.Wake, entphys)
		timer.Simple( .01, ent.SetPos, ent, curpos )
	else
		return true
	end
end


function GM:GravGunOnDropped( ply, ent )--NONE! NO PUNTING YOU HOE
	local entphys = ent:GetPhysicsObject()
	if( ply:KeyDown(IN_ATTACK) ) then
		// it was launched
		entphys:EnableMotion( false )
		local curpos = ent:GetPos()
		timer.Simple( .01, entphys.EnableMotion, entphys, true )
		timer.Simple( .01, entphys.Wake, entphys)
		timer.Simple( .01, ent.SetPos, ent, curpos )
	else
		return true
	end
end



local BannedModels =
{
	"models/Combine_Helicopter/helicopter_bomb01.mdl",
	"models/props_combine/CombineTrain02b.mdl",
	"models/props_combine/CombineTrain02b.mdl",
	"models/props_combine/CombineTrain02a.mdl",
	"models/props_combine/CombineTrain01.mdl",
	"models/Cranes/crane_frame.mdl",
	"models/props_wasteland/cargo_container01.mdl",
	"models/props_c17/oildrum001_explosive.mdl"
}

function IsBannedModel( mdl )
	for k, v in pairs( BannedModels ) do
		if( v == mdl ) then
			return true;
		end
	end
	return false;
end

function meta:IsBannedProp()
	if( IsBannedModel( self:GetModel() ) ) then return true; end
	return false;
end

function GM:PlayerSpawnProp( ply, mdl )
	if( not self.BaseClass:PlayerSpawnProp( ply, mdl ) ) then
		return false;
	end
	if( IsBannedModel( mdl ) ) then
		return false;
	end
	return true;
end


CivModels = {
--Males
	          "models/Humans/Group01/Male_01.mdl",
              "models/Humans/Group01/male_02.mdl",
              "models/Humans/Group01/male_03.mdl",
              "models/Humans/Group01/Male_04.mdl",
              "models/Humans/Group01/Male_05.mdl",
              "models/Humans/Group01/male_06.mdl",
              "models/Humans/Group01/male_07.mdl",
              "models/Humans/Group01/male_08.mdl",
              "models/Humans/Group01/male_09.mdl",
              "models/Humans/Group02/Male_01.mdl",
              "models/Humans/Group02/male_02.mdl",
              "models/Humans/Group02/male_03.mdl",
              "models/Humans/Group02/Male_04.mdl",
              "models/Humans/Group02/Male_05.mdl",
              "models/Humans/Group02/male_06.mdl",
              "models/Humans/Group02/male_07.mdl",
              "models/Humans/Group02/male_08.mdl",
              "models/Humans/Group02/male_09.mdl",
--Females
              "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"

}

function GM:PlayerInitialSpawn( ply )
--Add something here to make sure the player is invisible before he/she spawns. Possibly make visible only after a flag has been added.
	self.BaseClass:PlayerInitialSpawn( ply );
	CharCreate(ply);--Run the player creation / player save functions
	ply:GetTable().PlayerModel = CivModels[math.random( 1, #CivModels )];--Set a model to a random civilian until player select is finished.
	ply:SetModel( ply:GetTable().PlayerModel );--set the model to whatever we got from the table.
	ply:PrintMessage( HUD_PRINTTALK, "Welcome to LiteScript v0.4!" ) --Tell em where they are
	ply:PrintMessage( HUD_PRINTTALK, "This gamemode is still in alpha testing. If you are seeing this, you are lucky." ) --And how lucky they are to be here!
end


function GM:PlayerDisconnected( player )
	player:SetNWInt("playeractive", 0)--This fixes any timer bugs from being a cityscanner. 
	--Add a save function here.
end


function GM:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed(ply, 92, 200);--Move this to flags later!
	ply:StripWeapons();--You just spawned, how would you have guns? Oh well, do it anyway.
	PlayerFlags(ply);--Set the mofo's flag!
		if(ply:GetNWInt("setflag") == 2) then--If true, your flag is set to scanner
			UpdateCharacterFlags(ply);--Run the thing to start the looping sounds
		end
		if(ply:GetNWInt("setflag") == 4) then--If true, your flag is set to scanner
			UpdateCharacterFlags(ply);--Run the thing to start the looping sounds
		end
	ply:SetNWInt("playeractive", 1)
end


function UpdateCharacterFlags(ply)--Resets the loop to play again with given parameters
	if(ply:GetNWInt("setflag") == 2) then--If true, your flag is set to scanner
		scansound = CreateSound( ply, Sound("npc/scanner/cbot_fly_loop.wav") )
        DelaySoundStartLoop(ply,scansound,1);
	end
	if(ply:GetNWInt("setflag") == 4) then--If true, your flag is set to scanner
		scansound = CreateSound( ply, Sound("npc/scanner/cbot_fly_loop.wav") )
        DelaySoundStartLoop(ply,scansound,1);
	end
    timer.Simple(3,UpdateCharacterFlags,ply)
end


function LS.PrintMessageAll( type, msg )
	
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( type, msg );
	end

end


function playerDies( victim, weapon, killer )
	if(victim:GetNWInt("setflag") == 2) then--If true, your flag is set to scanner, and need to explode on death
			local pos = victim:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart(pos)
			effectdata:SetOrigin(pos)
			effectdata:SetScale(1.5)
			util.Effect("HelicopterMegaBomb", effectdata)
		 	victim:EmitSound( Sound( "weapons/explode3.wav" ) );
	end
	if(victim:GetNWInt("setflag") == 4) then--If true, your flag is set to scanner, and need to explode on death
			local pos = victim:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart(pos)
			effectdata:SetOrigin(pos)
			effectdata:SetScale(1.5)
			util.Effect("HelicopterMegaBomb", effectdata)
		 	victim:EmitSound( Sound( "weapons/explode3.wav" ) );
	end
	LS.PrintMessageAll( 2,  "KILLED - Player: " .. victim:Nick() .. " was killed by " ..  killer:Nick() .. "with" .. weapon );
	victim:PrintMessage( HUD_PRINTTALK, "NEW LIFE RULE: You have died! You are now a completely new person, and cannot remember anything from before." ) ;--Print NLR info onto chat when you die
end
hook.Add( "PlayerDeath", "playerDeathTest", playerDies ); 
