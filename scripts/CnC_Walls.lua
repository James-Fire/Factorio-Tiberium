-- Basic setup, variables to use. (Might expose to settings sometime? Or perhaps make research allow for longer wall segments?)
local flib_table = require("__flib__.table")
local debugText = settings.global["tiberium-debug-text"].value
local function debugPrint(message)
	if debugText then
		game.print(message or "")
	end
end

---@enum dirs Directions for wall segment graphics variations
local dirs = {
	horz = 1,
	vert = 2,
	both = 3
}
local dir_mods = {
	{x = 1, y = 0, variation = dirs.horz},
	{x = -1, y = 0, variation = dirs.horz},
	{x = 0, y = 1, variation = dirs.vert},
	{x = 0, y = -1, variation = dirs.vert}
}
local node_range = 16

local abs   = math.abs
local floor = math.floor
local ceil  = math.ceil
local max   = math.max
local min   = math.min
-- Functions translplanted + renamed to clarify

--- @class srfNode
--- @field emitter LuaEntity
--- @field position MapPosition

--- @class srfTicklist
--- @field emitter LuaEntity
--- @field position MapPosition
--- @field tick uint

--- @class srfSegment
--- @field direction dirs
--- @field wall LuaEntity

--- @class srfSegmentList
--- @field [string] srfSegment

---Initialize storage lists
function CnC_SonicWall_OnInit()
	storage.SRF_nodes = {}  --[=[@as srfNode[]]=]
	storage.SRF_segments = {}  --[[@as srfSegmentList]]
	storage.SRF_node_ticklist = {}  --[=[@as srfTicklist[]]=]
	storage.SRF_low_power_ticklist = {}  --[=[@as srfTicklist[]]=]
end

---Returns array containing up to 4 entities that could connect to an SRF emitter at the given position
---Assumes node_range, dirs, storage.SRF_nodes
---@param entity LuaEntity
---@param dir dirs
---@return LuaEntity[]
function CnC_SonicWall_FindNodes(entity, dir)
	local force = entity.force_index
	local surf = entity.surface_index
	local pos = entity.position
	local near_nodes = {nil, nil, nil, nil}
	local near_dists = {node_range, node_range * -1, node_range, node_range * -1}
	for _, entry in pairs(storage.SRF_nodes) do
		local emitter = entry.emitter
		if emitter and emitter.valid and force == emitter.force_index and surf == emitter.surface_index then
			local x_diff = entry.position.x - pos.x
			local y_diff = entry.position.y - pos.y
			if (y_diff == 0) and (dir == dirs.horz or dir == dirs.both) then  -- Horizontally aligned
				if x_diff > 0 and x_diff <= near_dists[1] then
					near_nodes[1] = emitter
					near_dists[1] = x_diff
				elseif x_diff < 0 and x_diff >= near_dists[2] then
					near_nodes[2] = emitter
					near_dists[2] = x_diff
				end
			elseif (x_diff == 0) and (dir == dirs.vert or dir == dirs.both) then  -- Vertically aligned
				if y_diff > 0 and y_diff <= near_dists[3] then
					near_nodes[3] = emitter
					near_dists[3] = y_diff
				elseif y_diff < 0 and y_diff >= near_dists[4] then
					near_nodes[4] = emitter
					near_dists[4] = y_diff
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

---Called by on_built_entity in control.lua
---Modifies storage.SRF_nodes, storage.SRF_node_ticklist, storage.SRF_segments
---@param entity LuaEntity
---@param tick uint
function CnC_SonicWall_AddNode(entity, tick)
	table.insert(storage.SRF_nodes, {emitter = entity, position = entity.position})
	table.insert(storage.SRF_node_ticklist, {emitter = entity, position = entity.position, tick = tick + ceil(entity.electric_buffer_size / entity.get_electric_input_flow_limit())})
	CnC_SonicWall_ConnectPowerPoles(entity)
	CnC_SonicWall_DisableNode(entity)  --Destroy any walls that went through where the wall was placed so it can calculate new walls
end

---Connect hidden power pole to orthogonal power poles to propagate power to adjacent SRF emitters
---@param emitter LuaEntity
function CnC_SonicWall_ConnectPowerPoles(emitter)
	if emitter.surface.has_global_electric_network then return end
	debugPrint("Trying to connect power pole for "..emitter.gps_tag)
	local orthogonal_nodes = CnC_SonicWall_FindNodes(emitter, dirs.both)
	local pole = emitter.surface.find_entities_filtered{position = emitter.position, name = "tiberium-srf-power-pole"}
	if next(pole) then debugPrint("Found power pole at "..pole[1].gps_tag) end
	if next(pole) and next(orthogonal_nodes) then
		for _, node in pairs(orthogonal_nodes) do
			debugPrint("Found node in range at "..node.gps_tag)
			local pole2 = emitter.surface.find_entities_filtered{position = node.position, name = "tiberium-srf-power-pole"}
			if next(pole2) then
				connect_poles(pole[1], pole2[1])
			end
		end
	end
end

---Connect two poles together
---@param pole1 LuaEntity
---@param pole2 LuaEntity
function connect_poles(pole1, pole2)
	if not (pole1 and pole1.valid and pole2 and pole2.valid) then
		return
	end
	debugPrint("Doing connection from "..pole1.gps_tag.." to "..pole2.gps_tag)
	-- Get the copper wire connection points
	local connector1 = pole1.get_wire_connector(defines.wire_connector_id.pole_copper, true)
	local connector2 = pole2.get_wire_connector(defines.wire_connector_id.pole_copper, true)

	-- Connect the poles
	local success = connector1.connect_to(connector2, false)
	debugPrint("Connnection successful: "..tostring(success))
end

---Destroys walls connected to given SRF emitter
---Modifies storage.SRF_segments
---@param entity LuaEntity
function CnC_SonicWall_DisableNode(entity)
	local surf = entity.surface.index
	local x = floor(entity.position.x)
	local y = floor(entity.position.y)

	for _, dir in pairs(dir_mods) do
		local tx = x + dir.x
		local ty = y + dir.y
		local key = string.format("%g:%g:%g", surf, tx, ty)
		while storage.SRF_segments[key] do
			debugPrint(string.format("disable wall at %g:%g:%g", surf, tx, ty))
			local segment = storage.SRF_segments[key]
			if segment.direction == dir.variation then
				storage.SRF_segments[key].wall.destroy()
				storage.SRF_segments[key] = nil
			elseif segment.direction == dirs.both then
				storage.SRF_segments[key].direction = dirs.both - dir.variation
				storage.SRF_segments[key].wall.graphics_variation = dirs.both - dir.variation
			end
			tx = tx + dir.x
			ty = ty + dir.y
			key = string.format("%g:%g:%g", surf, tx, ty)
		end
	end
	--Also destroy any wall that is on top of the node
	local key = string.format("%g:%g:%g", surf, x, y)
	if storage.SRF_segments[key] then
		storage.SRF_segments[key].wall.destroy()
		storage.SRF_segments[key] = nil
	end
end

---Called by on_entity_died in control.lua
---Modifies storage.SRF_nodes, storage.SRF_node_ticklist, storage.SRF_low_power_ticklist
---@param entity LuaEntity?
---@param position MapPosition
---@param tick uint
function CnC_SonicWall_DeleteNode(entity, position, tick)
	local k = find_value_in_table(storage.SRF_nodes, position, "position")
	if k then
		table.remove(storage.SRF_nodes, k)
		if entity and entity.valid then
			local gps = string.format("[gps=%g,%g,%s]", entity.position.x, entity.position.y, entity.surface.name)
			debugPrint("Destroyed SRF at "..gps.." removed from SRF_nodes, "..#storage.SRF_nodes.." entries remain")
		end
	end

	k = find_value_in_table(storage.SRF_node_ticklist, position, "position")
	if k then
		table.remove(storage.SRF_node_ticklist, k)
		if entity and entity.valid then
			local gps = string.format("[gps=%g,%g,%s]", entity.position.x, entity.position.y, entity.surface.name)
			debugPrint("Destroyed SRF at "..gps.." removed from SRF_node_ticklist, "..#storage.SRF_node_ticklist.." entries remain")
		end
	end

	k = find_value_in_table(storage.SRF_low_power_ticklist, position, "position")
	if k then
		table.remove(storage.SRF_low_power_ticklist, k)
		if entity and entity.valid then
			local gps = string.format("[gps=%g,%g,%s]", entity.position.x, entity.position.y, entity.surface.name)
			debugPrint("Destroyed SRF at "..gps.." removed from SRF_low_power_ticklist, "..#storage.SRF_low_power_ticklist.." entries remain")
		end
	end

	if entity and entity.valid then
		CnC_SonicWall_DisableNode(entity)
		--Tell connected walls to reevaluate their connections
		local connected_nodes = CnC_SonicWall_FindNodes(entity, dirs.both)
		for i = 1, #connected_nodes do
			if not find_value_in_table(storage.SRF_node_ticklist, connected_nodes[i].position, "position") then
				table.insert(storage.SRF_node_ticklist, {emitter = connected_nodes[i], position = connected_nodes[i].position, tick = tick + 10})
			end
		end
	end
end

---Returns whether a wall of a given orientation can be placed at a given position
---Assumes storage.SRF_segments, dirs
---@param surf LuaSurface
---@param pos MapPosition
---@param dir uint
---@param force ForceID
---@return boolean
function CnC_SonicWall_TestWall(surf, pos, dir, force)
	local key = string.format("%g:%g:%g", surf.index, floor(pos[1]), floor(pos[2]))
	if not storage.SRF_segments[key] then
		if not surf.can_place_entity{name = "tiberium-srf-wall", position = pos, force = force} then return false end
	elseif storage.SRF_segments[key].direction ~= dirs.both - dir then
		return false --There is already a wall in the direction we want
	end

	return true
end

---Makes a wall of a given orientation can be placed at a given position
---Assumes dirs
---Modifies storage.SRF_segments
---@param surf LuaSurface
---@param pos MapPosition
---@param dir dirs
---@param force ForceID
function CnC_SonicWall_MakeWall(surf, pos, dir, force)
	local key = string.format("%g:%g:%g", surf.index, floor(pos[1]), floor(pos[2]))
	if not storage.SRF_segments[key] then
		local wall = surf.create_entity{name = "tiberium-srf-wall", position = pos, force = force}
		if not wall then error("Wall creation failed!") end
		wall.destructible = false
		wall.graphics_variation = dir
		storage.SRF_segments[key] = {direction = dir, wall = wall}
	elseif storage.SRF_segments[key].direction == dirs.both - dir then
		storage.SRF_segments[key].direction = dirs.both
		storage.SRF_segments[key].wall.graphics_variation = dirs.both
	end
end

---Makes a wall connecting two given emitters if an uninterupted wall is possible
---Assumes node_range, dirs
---Modifies storage.SRF_segments
---@param node1 LuaEntity
---@param node2 LuaEntity
function tryCnC_SonicWall_MakeWall(node1, node2)
	local x1 = node1.position.x
	local y1 = node1.position.y
	local x2 = node2.position.x
	local y2 = node2.position.y
	local surf = node1.surface
	local force = node1.force_index
	if x1 == x2 and y1 ~= y2 then
		local diff = abs(y2 - y1)
		if diff <= node_range and diff > 1 then
			local sy, ty
			sy = min(y1, y2) + 1
			ty = max(y1, y2) - 1
			for y = sy, ty do
				if not CnC_SonicWall_TestWall(surf, {x1, y}, dirs.vert, force) then return end
			end
			for y = sy, ty do
				CnC_SonicWall_MakeWall(surf, {x1, y}, dirs.vert, force)
			end
		end
	elseif x1 ~= x2 and y1 == y2 then
		local diff = abs(x2 - x1)
		if diff <= node_range and diff > 1 then
			local sx, tx
			sx = min(x1, x2) + 1
			tx = max(x1, x2) - 1
			for x = sx, tx do
				if not CnC_SonicWall_TestWall(surf, {x, y1}, dirs.horz, force) then return end
			end
			for x = sx, tx do
				CnC_SonicWall_MakeWall(surf, {x, y1}, dirs.horz, force)
			end
		end
	end
end

-- That's the end of the functions.
-- Below are things that used to be called in scripts, moved over here to clean things up

---OnTick used to be in script.on_event(defines.events.on_tick, function(event), for example.
---@param event EventData.on_tick
function CnC_SonicWall_OnTick(event)
	local cur_tick = event.tick

	if not storage.SRF_nodes then  --Set up renamed storage if they don't exist yet
		CnC_SonicWall_OnInit()
	end

	for i = #storage.SRF_node_ticklist, 1, -1 do  -- Loop in reverse order so we can safely remove
		local charging = storage.SRF_node_ticklist[i]
		if not charging.emitter.valid then
			table.remove(storage.SRF_node_ticklist, i)
		elseif charging.tick <= cur_tick then
			local emitter = charging.emitter
			local charge_rem = emitter.electric_buffer_size - emitter.energy
			if charge_rem <= 0 then
				local connected_nodes = CnC_SonicWall_FindNodes(emitter, dirs.both)
				for _, node in pairs(connected_nodes) do
					if node.energy > 0 then  --Doesn't need to be fully powered as long as it was once fully powered
						if not find_value_in_table(storage.SRF_node_ticklist, node.position, "position") then
							tryCnC_SonicWall_MakeWall(emitter, node)
						end
					end
				end
				table.remove(storage.SRF_node_ticklist, i)
				local low_power_key = find_value_in_table(storage.SRF_low_power_ticklist, emitter.position, "position")
				if low_power_key then
					table.remove(storage.SRF_low_power_ticklist, low_power_key)
				end
			else
				charging.tick = cur_tick + ceil(charge_rem / emitter.get_electric_input_flow_limit())
			end
		end
	end

	if cur_tick % 60 == 0 then --Check for all emitters for low power once per second
		for i = #storage.SRF_nodes, 1, -1 do
			local entry = storage.SRF_nodes[i]
			if entry.emitter.valid then
				local ticks_rem = entry.emitter.energy / entry.emitter.electric_drain
				if ticks_rem > 5 and ticks_rem <= 65 then
					if not find_value_in_table(storage.SRF_low_power_ticklist, entry.emitter.position, "position") then
						table.insert(storage.SRF_low_power_ticklist, {emitter = entry.emitter, position = entry.position, tick = cur_tick + ceil(ticks_rem)})
					end
				end
			else
				debugPrint("Removed invalid SRF emitter from storage.SRF_nodes at position x="..tostring(entry.position.x).." y="..tostring(entry.position.y))
				table.remove(storage.SRF_nodes, i)
			end
		end
	end

	for i = #storage.SRF_low_power_ticklist, 1, -1 do --Regularly check low power emitters to disable when their power runs out
		local low = storage.SRF_low_power_ticklist[i]
		if not low.emitter.valid then
			table.remove(storage.SRF_low_power_ticklist, i)
		elseif low.tick <= cur_tick and low.emitter then
			local ticks_rem = low.emitter.energy / low.emitter.electric_drain
			if ticks_rem <= 5 then
				CnC_SonicWall_DeleteNode(low.emitter, low.position, cur_tick)  --Removes it from low power ticklist as well
				CnC_SonicWall_AddNode(low.emitter, cur_tick)
			else
				low.tick = cur_tick + ceil(ticks_rem)
			end
		end
	end
end

---Helper function
---Returns the key for a given value in a given table or false if it doesn't exist
---Optional subscript argument for when the list contains other lists (LSlib doesn't have this, otherwise I would use their version)
---@param list table Haystack
---@param value any Needle
---@param subscript? any Instead of top-level values, check the value associated with this subscript in each value
---@return any? key
function find_value_in_table(list, value, subscript)
	if not list then return nil end
	if not value then return nil end
	for k, v in pairs(list) do
		if subscript then
			if flib_table.deep_compare(v[subscript], value) then return k end
		else
			if v == value then return k end
		end
	end
	return nil
end
