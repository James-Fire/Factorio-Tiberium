-- Basic setup, variables to use. (Might expose to settings sometime? Or perhaps make research allow for longer wall segments?)
require("__LSlib__/LSlib")
local debugText = settings.startup["tiberium-debug-text"].value

local horz_wall, vert_wall = 1, 2
local dir_mods = {{x = 1, y = 0, variation = horz_wall}, {x = -1, y = 0, variation = horz_wall},
				  {x = 0, y = 1, variation = vert_wall}, {x = 0, y = -1, variation = vert_wall}}
local wall_health = 10000
local joules_per_hitpoint = 400
local node_range = 16

local abs   = math.abs
local floor = math.floor
local ceil  = math.ceil
local max   = math.max
local min   = math.min
-- Functions translplanted + renamed to clarify

--Returns array containing up to 4 entities that could connect to an SRF emitter at the given position
--Assumes node_range, horz_wall, vert_wall, global.SRF_nodes
function CnC_SonicWall_FindNodes(surf, pos, force, dir)
	local near_nodes = {nil, nil, nil, nil}
	local near_dists = {node_range, node_range * -1, node_range, node_range * -1}
	for _, entry in pairs(global.SRF_nodes) do
		if entry.emitter.valid then
			if not force or force.name == entry.emitter.force.name then
				if surf.index == entry.emitter.surface.index then
					local x_diff = entry.position.x - pos.x
					local y_diff = entry.position.y - pos.y
					if (y_diff == 0) and (dir == horz_wall or dir == horz_wall + vert_wall) then  -- Horizontally aligned
						if x_diff > 0 and x_diff <= near_dists[1] then
							near_nodes[1] = entry.emitter
							near_dists[1] = x_diff
						elseif x_diff < 0 and x_diff >= near_dists[2] then
							near_nodes[2] = entry.emitter
							near_dists[2] = x_diff
						end
					elseif (x_diff == 0) and (dir == vert_wall or dir == horz_wall + vert_wall) then  -- Vertically aligned
						if y_diff > 0 and y_diff <= near_dists[3] then
							near_nodes[3] = entry.emitter
							near_dists[3] = y_diff
						elseif y_diff < 0 and y_diff >= near_dists[4] then
							near_nodes[4] = entry.emitter
							near_dists[4] = y_diff
						end
					end
				end
			end
		end
	end
	
	local connected_nodes = {}
	for _, node in pairs(near_nodes) do  -- Removes nils
		table.insert(connected_nodes, node)
	end
	return connected_nodes
end

--Called by on_built_entity in control.lua
--Modifies global.SRF_nodes, global.SRF_node_ticklist, global.SRF_segments
function CnC_SonicWall_AddNode(entity, tick)
	table.insert(global.SRF_nodes, {emitter = entity, position = entity.position})
	table.insert(global.SRF_node_ticklist, {emitter = entity, position = entity.position, tick = tick + ceil(entity.electric_buffer_size / entity.electric_input_flow_limit)})
	CnC_SonicWall_DisableNode(entity)  --Destroy any walls that went through where the wall was placed so it can calculate new walls
end

--Destroys walls connected to given SRF emitter
--Modifies global.SRF_segments
function CnC_SonicWall_DisableNode(entity)
	local surf = entity.surface
	local x = floor(entity.position.x)
	local y = floor(entity.position.y)
	
	for _, dir in pairs(dir_mods) do
		local tx = x + dir.x
		local ty = y + dir.y
		while global.SRF_segments[surf.index] and global.SRF_segments[surf.index][tx] and global.SRF_segments[surf.index][tx][ty] do
			local wall = global.SRF_segments[surf.index][tx][ty]
			if wall[1] == dir.variation then
				global.SRF_segments[surf.index][tx][ty][2].destroy()
				global.SRF_segments[surf.index][tx][ty] = nil
			elseif wall[1] == horz_wall + vert_wall then
				global.SRF_segments[surf.index][tx][ty][1] = horz_wall + vert_wall - dir.variation
				global.SRF_segments[surf.index][tx][ty][2].graphics_variation = horz_wall + vert_wall - dir.variation
			end
			tx = tx + dir.x
			ty = ty + dir.y
		end
	end
	--Also destroy any wall that is on top of the node
	if global.SRF_segments[surf.index] and global.SRF_segments[surf.index][x] and global.SRF_segments[surf.index][x][y] then
		global.SRF_segments[surf.index][x][y][2].destroy()
		global.SRF_segments[surf.index][x][y] = nil
	end
end

--Called by on_entity_died in control.lua
--Modifies global.SRF_nodes, global.SRF_node_ticklist, global.SRF_low_power_ticklist
function CnC_SonicWall_DeleteNode(entity, tick)
	local k = find_value_in_table(global.SRF_nodes, entity.position, "position")
	if k then
		table.remove(global.SRF_nodes, k)
		if debugText then game.print("Destroyed SRF at x: "..entity.position.x.." y: "..entity.position.y.." removed from SRF_nodes, "..#global.SRF_nodes.." entries remain") end
	end
	
	k = find_value_in_table(global.SRF_node_ticklist, entity.position, "position")
	if k then
		table.remove(global.SRF_node_ticklist, k)
		if debugText then game.print("Destroyed SRF at x: "..entity.position.x.." y: "..entity.position.y.." removed from SRF_node_ticklist, "..#global.SRF_node_ticklist.." entries remain") end
	end

	k = find_value_in_table(global.SRF_low_power_ticklist, entity.position, "position")
	if k then
		table.remove(global.SRF_low_power_ticklist, k)
		if debugText then game.print("Destroyed SRF at x: "..entity.position.x.." y: "..entity.position.y.." removed from SRF_low_power_ticklist, "..#global.SRF_low_power_ticklist.." entries remain") end
	end

	CnC_SonicWall_DisableNode(entity)
	--Tell connected walls to reevaluate their connections
	local connected_nodes = CnC_SonicWall_FindNodes(entity.surface, entity.position, entity.force, horz_wall + vert_wall)
	for i = 1, #connected_nodes do
		if not find_value_in_table(global.SRF_node_ticklist, connected_nodes[i], "emitter") then
			table.insert(global.SRF_node_ticklist, {emitter = connected_nodes[i], position = connected_nodes[i].position, tick = tick + 10})
		end
	end
end

--Currently unused?
function CnC_SonicWall_WallDamage(surf, pos, tick)
	local x = floor(pos.x)
	local y = floor(pos.y)
	if global.SRF_segments[surf.index] and global.SRF_segments[surf.index][x] and global.SRF_segments[surf.index][x][y] then
		local mark_death = false
		local force = nil
		
		local wall = global.SRF_segments[surf.index][x][y]
		local damage_amt = wall_health - wall[2].health
		wall[2].health = wall_health
		local joule_cost = damage_amt * joules_per_hitpoint
		
		local connected_nodes = CnC_SonicWall_FindNodes(surf, pos, nil, wall[1], true) --What did the extra arg originally do?
		local shared_cost = joule_cost / #connected_nodes
		for _, node in pairs(connected_nodes) do
			if not force then force = node.force end
			local energy = node.energy - shared_cost * joules_per_hitpoint
			if energy < 0 then energy = 0 end
			node.energy = energy
			
			if energy == 0 then
				if not mark_death then
					CnC_SonicWall_SendAlert(node.force, defines.alert_type.entity_destroyed, wall[2])
					mark_death = true
				end
				CnC_SonicWall_DisableNode(node)
				table.insert(global.SRF_node_ticklist, {emitter = node, position = node.position, tick = tick + ceil(node.electric_buffer_size / node.electric_input_flow_limit)})
			end
		end
		if not mark_death then
			CnC_SonicWall_SendAlert(force, defines.alert_type.entity_under_attack, wall[2])
		end
	end
end

--Currently unused?
function CnC_SonicWall_SendAlert(force, alert_type, entity)
	for k, v in pairs(force.players) do
		v.add_alert(entity, alert_type)
	end
end

--Returns whether a wall of a given orientation can be placed at a given position
--Assumes global.SRF_segments, horz_wall, vert_wall
function CnC_SonicWall_TestWall(surf, pos, dir, node)
	local x = floor(pos[1])
	local y = floor(pos[2])
	if not global.SRF_segments[surf.index] then global.SRF_segments[surf.index] = {} end
	if not global.SRF_segments[surf.index][x] then global.SRF_segments[surf.index][x] = {} end
	
	if not global.SRF_segments[surf.index][x][y] then
		if not surf.can_place_entity{name = "CnC_SonicWall_Wall", position=pos, force = node.force} then return false end
	else
		local wall = global.SRF_segments[surf.index][x][y]
		if wall[1] ~= horz_wall + vert_wall - dir then return false end --There is already a wall in the direction we want
	end
	
	return true
end

--Makes a wall of a given orientation can be placed at a given position
--Assumes horz_wall, vert_wall
--Modifies global.SRF_segments
function CnC_SonicWall_MakeWall(surf, pos, dir, node)
	local x = floor(pos[1])
	local y = floor(pos[2])
	if not global.SRF_segments[surf.index] then global.SRF_segments[surf.index] = {} end
	if not global.SRF_segments[surf.index][x] then global.SRF_segments[surf.index][x] = {} end
	
	if not global.SRF_segments[surf.index][x][y] then
		local wall = surf.create_entity{name="CnC_SonicWall_Wall", position=pos, force=node.force}
		if not wall then error("Wall creation failed!") end
		wall.graphics_variation = dir
		global.SRF_segments[surf.index][x][y] = {dir, wall}
	else
		local wall = global.SRF_segments[surf.index][x][y]
		if wall[1] == horz_wall + vert_wall - dir then wall[1] = horz_wall + vert_wall end
		wall[2].graphics_variation = horz_wall + vert_wall
	end
end

--Makes a wall connecting two given emitters if an uninterupted wall is possible
--Assumes node_range, horz_wall, vert_wall
--Modifies global.SRF_segments
function tryCnC_SonicWall_MakeWall(node1, node2)
	local that_pos = node2.position
	if node1.position.x == that_pos.x and node1.position.y ~= that_pos.y then
		local diff = abs(that_pos.y - node1.position.y)
		if diff <= node_range and diff > 1 then
			local sy, ty
			sy = min(node1.position.y, that_pos.y) + 1
			ty = max(node1.position.y, that_pos.y) - 1
			for y = sy, ty do
				if not CnC_SonicWall_TestWall(node1.surface, {node1.position.x, y}, vert_wall, node1) then return end
			end
			for y = sy, ty do
				CnC_SonicWall_MakeWall(node1.surface, {node1.position.x, y}, vert_wall, node1)
			end
		end
	elseif node1.position.x ~= that_pos.x and node1.position.y == that_pos.y then
		local diff = abs(that_pos.x - node1.position.x)
		if diff <= node_range and diff > 1 then
			local sx, tx
			sx = min(node1.position.x, that_pos.x) + 1
			tx = max(node1.position.x, that_pos.x) - 1
			for x = sx, tx do
				if not CnC_SonicWall_TestWall(node1.surface, {x, node1.position.y}, horz_wall, node1) then return end
			end
			for x = sx, tx do
				CnC_SonicWall_MakeWall(node1.surface, {x, node1.position.y}, horz_wall, node1)
			end
		end
	end
end

-- That's the end of the functions.
-- Below are things that used to be called in scripts, moved over here to clean things up
-- OnTick used to be in script.on_event(defines.events.on_tick, function(event), for example.

function CnC_SonicWall_OnTick(event)
	local cur_tick = event.tick
	
	if not global.SRF_damage then  --Set up renamed globals if they don't exist yet
		convertSrfGlobals()
	end
	
	while #global.SRF_damage > 0 do
		CnC_SonicWall_WallDamage(global.SRF_damage[1][1], global.SRF_damage[1][2], event.tick)
		table.remove(global.SRF_damage, 1)
	end
	
	for i = #global.SRF_node_ticklist, 1, -1 do
		local charging = global.SRF_node_ticklist[i]
		if not charging.emitter.valid then
			table.remove(global.SRF_node_ticklist, i)
		elseif charging.tick <= cur_tick then
			local charge_rem = charging.emitter.electric_buffer_size - charging.emitter.energy
			if charge_rem <= 0 then
				local connected_nodes = CnC_SonicWall_FindNodes(charging.emitter.surface, charging.emitter.position,
																charging.emitter.force, horz_wall + vert_wall)
				for _, node in pairs(connected_nodes) do
					if node.energy > 0 then  --Doesn't need to be fully powered as long as it was once fully powered
						if not find_value_in_table(global.SRF_node_ticklist, node, "emitter") then
							tryCnC_SonicWall_MakeWall(charging.emitter, node)
						end
					end
				end
				table.remove(global.SRF_node_ticklist, i)
			else
				charging.tick = cur_tick + ceil(charge_rem / charging.emitter.electric_input_flow_limit)
			end
		end
	end
	
	if cur_tick % 60 == 0 then --Check for all emitters for low power once per second
		for _, entry in pairs(global.SRF_nodes) do
			local ticks_rem = entry.emitter.energy / entry.emitter.electric_drain
			if ticks_rem > 5 and ticks_rem <= 65 then
				if not find_value_in_table(global.SRF_low_power_ticklist, entry.emitter, "emitter") then
					table.insert(global.SRF_low_power_ticklist, {emitter = entry.emitter, position = entry.position, tick = cur_tick + ceil(ticks_rem)})
				end
			end
		end
	end
	
	for i = #global.SRF_low_power_ticklist, 1, -1 do --Regularly check low power emitters to disable when their power runs out
		local low = global.SRF_low_power_ticklist[i]
		if not low.emitter.valid then
			table.remove(global.SRF_low_power_ticklist, i)
		elseif low.tick <= cur_tick and low.emitter then
			local ticks_rem = low.emitter.energy / low.emitter.electric_drain
			if ticks_rem <= 5 then
				CnC_SonicWall_DeleteNode(low.emitter, cur_tick)  --Removes it from low power ticklist as well
				CnC_SonicWall_AddNode(low.emitter, cur_tick)
			else
				low.tick = cur_tick + ceil(ticks_rem)
			end
		end
	end
end

function CnC_SonicWall_OnTriggerCreatedEntity(event)
	if event.entity.name == "CnC_SonicWall_Wall-damage" then
		table.insert(global.SRF_damage, {event.entity.surface, event.entity.position})
		event.entity.destroy()
	end
end

--Helper function
--Returns the key for a given value in a given table or false if it doesn't exist
--Optional subscript argument for when the list contains other lists (LSlib doesn't have this, otherwise I would use their version)
function find_value_in_table(list, value, subscript)
	if not list then return false end
	if not value then return false end
	for k, v in pairs(list) do
		if subscript then
			if LSlib.utils.table.areEqual(v[subscript], value) then return k end
		else
			if v == value then return k end
		end
	end
	return false
end

function CnC_SonicWall_OnInit(event)
	global.SRF_nodes = {}
	global.SRF_node_ticklist = {}
	global.SRF_segments = {}
	global.SRF_damage = {}
	global.SRF_low_power_ticklist = {}
end

function convertSrfGlobals()
	if global.hexi_hardlight_nodes then
		global.SRF_nodes = global.hexi_hardlight_nodes
	elseif not global.SRF_nodes then
		global.SRF_nodes = {}
	end
	
	if global.hexi_hardlight_node_ticklist then
		global.SRF_node_ticklist = {}
		for _, v in pairs(global.hexi_hardlight_node_ticklist) do
			table.insert(global.SRF_node_ticklist, {emitter = v[1], position = v[1].position, tick = v[2]})
		end
	elseif not global.SRF_node_ticklist then
		global.SRF_node_ticklist = {}
	end
	
	if global.hexi_hardlight_segments then
		global.SRF_segments = global.hexi_hardlight_segments
	elseif not global.SRF_segments then
		global.SRF_segments = {}
	end
	
	if global.hexi_hardlight_damage then
		global.SRF_damage = global.hexi_hardlight_damage
	elseif not global.SRF_damage then
		global.SRF_damage = {}
	end
	
	if not global.SRF_low_power_ticklist then
		global.SRF_low_power_ticklist = {}
	end
end
