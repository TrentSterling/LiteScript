
--------------------------
---- Garry's Mod Lua Testing Bullshit and Various Other Nonessentials
---- V 0.1
---- Elijah T.
--------------------------

local clicker = false --Variable used to toggle the screen cursor
function EnableClicker( pl, key )
	if SERVER then return end
	if key == 131072 then
		if clicker == false then
			gui.EnableScreenClicker(true)
			clicker = true
		else
			gui.EnableScreenClicker(false)
			clicker = false
		end
	end
end

function testpanel()
	if SERVER then return end
	
	ops = { ["prop_physics"] = {},
	        ["prop_vehicle_jeep"] = {}, ["player"] = {} } --This is the table for all the options.
			
		ops.prop_physics = { ["t"] = "Physics Prop",
		                     ["o"] = {} }
							 
			ops.prop_physics.o.op1 = { ["n"] = "This is a prop!",
			                           ["p"] = "Clicked on option 1\n" }
									   
			ops.prop_physics.o.op2 = { ["n"] = "A physics prop!",
									   ["p"] = "Clicked on option 2\n" }
									   
									   
									   
									   
									   
									   
									   
									   
									   
									   		ops.player = { ["t"] = "A PLAYER!",
		                     ["o"] = {} }
							 
			ops.player.o.op1 = { ["n"] = "This is a PLAYER!",
			                           ["p"] = "Clicked on option 1\n" }
									   
			ops.player.o.op2 = { ["n"] = "A FUCKING PLAYER!",
									   ["p"] = "Clicked on option 2\n" }
									   
									   
									   
									   
									   
									   
									   
									   
									   
				
		ops.prop_vehicle_jeep = { ["t"] = "Jeep",
								  ["o"] = {} }
		
			ops.prop_vehicle_jeep.o.op1 = { ["n"] = "Beep Beep",
		                                    ["p"] = "This works\n" }
										
			ops.prop_vehicle_jeep.o.op2 = { ["n"] = "I'm a Jeep!",
		                                    ["p"] = "So does this\n" }

	
	--// Trace Stuff ////////////////////
	local player = LocalPlayer()
	local pos = player:GetShootPos()
	local ang = gui.ScreenToVector( gui.MousePos() )
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ang*1000)
	tracedata.filter = player
	local trace = util.TraceLine(tracedata)
	
	if trace.HitNonWorld then
		target = trace.Entity --Store the entity it hit
		
		if ops[target:GetClass()] == nil then
			return
		else
			local menu123 = DermaMenu() -- create a derma menu
			menu123:SetPos(gui.MousePos()) --put it wherever the cursor is at the time
			menu123:AddOption( ops[target:GetClass()].t, function() gui.EnableScreenClicker(false) clicker=false end ) --This is the "title." If clicked it closes the clicker
			menu123:AddSpacer()
			for k, v in pairs( ops[target:GetClass()].o ) do
				menu123:AddOption( v.n, function() Msg(v.p) gui.EnableScreenClicker(false) clicker=false end ) -- adding options from the table.  When clicked, removes the clicker and sets the clicker var so it can be reopened.
			end
		end
	end
	--/////////////////////////////////
	
end

function GUIMousePressed( btn )
	if SERVER then return end
	
	if (btn == MOUSE_LEFT) then --If you left click on nothing, the cursor disappears.
		gui.EnableScreenClicker(false)
		clicker = false
	elseif (btn == MOUSE_RIGHT) then --Right click and the menu pops up
		testpanel()
	end
end

--TO DO LIST:
-----Pick up/drop objects

concommand.Add("menutest", testpanel) -- adding the console command (allows players to bind)
hook.Add( "KeyPress", "KeyPress", EnableClicker )
hook.Add("GUIMousePressed", "GuiMousePressed", GUIMousePressed)
