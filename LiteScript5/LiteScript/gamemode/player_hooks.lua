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
		ply:SendMessage("No punting!",3,Color(255,255,0,255));
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
	"models/props_junk/gascan001a.mdl",
	"models/props_junk/propane_tank001a.mdl",
	"models/props_c17/oildrum001_explosive.mdl",
	"models/props_c17/canister02a.mdl",
	"models/props_wasteland/cargo_container01c.mdl"
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
	if( ply:Alive() ) then
		if( not self.BaseClass:PlayerSpawnProp( ply, mdl ) ) then
			return false;
		end
		if( IsBannedModel( mdl ) ) then
			ply:SendMessage("This prop is banned.",3,Color(255,255,0,255));
			return false;
		end
		return true;
	end
end

function GM:PlayerInitialSpawn( ply )
--Add something here to make sure the player is invisible before he/she spawns. Possibly make visible only after a flag has been added.
	self.BaseClass:PlayerInitialSpawn( ply );
	CharCreate(ply);--Run the player creation / player save functions
	ply:PrintMessage( HUD_PRINTTALK, "Welcome to LiteScript v0.5!" ) --Tell em where they are
	ply:PrintMessage( HUD_PRINTTALK, "This gamemode is still in alpha testing. If you are seeing this, you are lucky." ) --And how lucky they are to be here!
	ply:SetNWInt("playeractive", 1)
	CheckFalling(ply)--Are you falling like a mofo?
	RegenHealth(ply)
end

function GM:PlayerDisconnected( player )
	SaveInfo(player)
	player:SetNWInt("playeractive", 0)--This fixes any timer bugs from being a cityscanner. 
	--Add a save function here.
end

function GM:PlayerSpawn( ply )
	GAMEMODE:SetPlayerSpeed(ply, 92, 200);--Move this to flags later!
	ply:StripWeapons();--You just spawned, how would you have guns? Oh well, do it anyway.
	PlayerFlags(ply);--Set the mofo's flag!
	CheckScannerPlayer(ply);--You a scanner?
	ply:SetNWInt("playeractive", 1)
	ply:PrintMessage( HUD_PRINTTALK,   "SPAWNED - Player: " .. ply:Nick() .. "."  ) ;--Print NLR info onto chat when you die
end

function CheckScannerPlayer(ply)--Hoe, are you a scanner?
	if(ply:GetNWInt("setflag") == 2) then--If true, your flag is set to scanner
		ScannerSoundLoop(ply);--Run the thing to start the looping sounds
	end
	if(ply:GetNWInt("setflag") == 4) then--If true, your flag is set to scanner
		ScannerSoundLoop(ply);--Run the thing to start the looping sounds
	end
end

function ScannerSoundLoop(ply)--Resets the loop to play again with given parameters
	if(ply:GetNWInt("setflag") == 2) then--If true, your flag is set to scanner
		scansound = CreateSound( ply, Sound("npc/scanner/cbot_fly_loop.wav") )
        DelaySoundStartLoop(ply,scansound,1);
	end
	if(ply:GetNWInt("setflag") == 4) then--If true, your flag is set to scanner
		scansound = CreateSound( ply, Sound("npc/scanner/cbot_fly_loop.wav") )
        DelaySoundStartLoop(ply,scansound,1);
	end
    timer.Simple(3,ScannerSoundLoop,ply)
end

function CheckFalling(ply)--Resets the loop to play again with given parameters
	if(ply:GetNWInt("playeractive") == 1) then--If true, you are active
	
	if(ply:GetNWInt("setflag") == 2) then--If true, your flag is set to scanner
	return
	end
	if(ply:GetNWInt("setflag") == 4) then--If true, your flag is set to scanner
	return
	end
		local fallSpeed = ply:GetVelocity().z;
		--ply:PrintMessage( HUD_PRINTTALK,   "Z-AXIS-VELOCITY: " .. ply:GetVelocity().z ) ;
		--if ( fallSpeed !=0 ) then
		--end
		if ( fallSpeed < -300 or fallSpeed > 300 ) then
			local health = ply:Health()
			ply:SetHealth( health - 3 )
				if( ply:Alive() ) then
			if( ply:Health() <= 0 ) then
					ply:Kill();
				end
		end
		end
		if ( fallSpeed < -1000 or fallSpeed > 800 ) then
				if( ply:Alive() ) then
					ply:Kill();
				end
			end
    timer.Simple(0.05,CheckFalling,ply)
	end
end
	
function RegenHealth(ply)--Resets the loop to play again with given parameters

	if(ply:GetNWInt("playeractive") == 1) then--If true, you are active
		if( ply:Alive() ) then
			if ( ply:Health() < 25 ) then
				local health = ply:Health()
				ply:SetHealth( health - 1 )
			end
			if ( ply:Health() < 40 ) then
				local health = ply:Health()
				ply:SetHealth( health + 1 )
			end
			if ( ply:Health() < 50 ) then
				local health = ply:Health()
				ply:SetHealth( health + 1 )
			end
		end
	timer.Simple(2,RegenHealth,ply)
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
	victim:PrintMessage( HUD_PRINTTALK, "NEW LIFE RULE: You have died! You are now a completely new person, and cannot remember anything from before." ) ;--Print NLR info onto chat when you die
end
hook.Add( "PlayerDeath", "playerDeathTest", playerDies ); 
