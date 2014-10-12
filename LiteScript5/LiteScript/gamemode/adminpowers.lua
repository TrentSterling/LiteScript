----------------------------
-- LiteScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Give admins magical powers!
----------------------------

include( 'adminsetflag.lua' )--INCLUDE THE FLAG SYSTEM!

function Klik(ply, cmd, args)
	umsg.Start("KlickJoo", ply)
	umsg.End()
end
concommand.Add( "rp_klik", Klik )

function SeeAll(ply, cmd, args)
	umsg.Start("ToggleSeeAll", ply)
	umsg.End()
end
concommand.Add( "rp_seeall", SeeAll );

/*---------------------------------------------------------
  SWEP Spawning
---------------------------------------------------------*/
//Override SWEP spawning. --Later, add a code so that admins CAN spawn sweps.
function CCSpawnSWEP( ply, command, arguments )
	ply:SendMessage("You can't do that you faggot!",3,Color(255,0,0,255))
end
concommand.Add( "gm_giveswep", CCSpawnSWEP )
 
//Find players by name.
function GetPlayerByName(name)--This lets us type in a player name without being exact, and if the player doesnt exist, return nil.
	if(name != nil) then
		for k, v in pairs(player.GetAll()) do
			if(string.find(v:Nick(), name) != nil) then
				return v
			end
		end
	end
	return nil
end

/*---------------------------------------------------------
Admin like abilites!
---------------------------------------------------------*/
//Explode the motherfucker
function AdminExplode(ply, cmd, args)
	--if !ply:IsAdmin() then 
	--	ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	--return end
	local target = GetPlayerByName(args[1])
	if(target != nil) then
		local pos = target:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(pos)
		effectdata:SetOrigin(pos)
		effectdata:SetScale(1.5)
		util.Effect("HelicopterMegaBomb", effectdata)
		target:EmitSound( Sound( "vo/citadel/br_ohshit.wav" ) );
		target:EmitSound( Sound( "weapons/explode3.wav" ) );
		target:Kill()
	end
	if(target == nil) then
		ply:PrintMessage( 2, "Failed" );
	end
end
concommand.Add("rp_explode", AdminExplode)

//Teleport yourself!
function GM.TeleportSelf(ply)
	local GM = GAMEMODE
	if !ply:IsAdmin() then 
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	local tr = ply:TraceFromEyes(10000)
	ply:SetPos(tr.HitPos + Vector(0,0,30))
	ply:SendMessage("Teleported!",3,Color(0,255,255,255))
	ply:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
end
concommand.Add("rp_teleport",GM.TeleportSelf)

function GM.TestKill(ply)
	local GM = GAMEMODE
	ply:Kill();
end
concommand.Add("rp_kill",GM.TestKill)

//Spectator Mode--Basically noclip, still buggy.
function GM.SpectateAdmin(ply)
			ply:SetMoveType(MOVETYPE_NOCLIP)
end
concommand.Add("rp_spec",GM.SpectateAdmin)

//UNSpectator--Get out of noclip, again, buggy.
function GM.UnSpectateAdmin(ply)
			ply:SetMoveType(MOVETYPE_WALK)
end
concommand.Add("rp_unspec",GM.UnSpectateAdmin)

function GM.GiveToolAdmin(ply)--Give a toolgun to a player
		ply:Give( "gmod_tool" );
end
concommand.Add("rp_tool",GM.GiveToolAdmin)

function GM.GivePhysAdmin(ply)--Give a physics gun to a player
		ply:Give( "weapon_physgun" );
end
concommand.Add("rp_phys",GM.GivePhysAdmin)


