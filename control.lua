-- Change when uploading to main/beta version, no underscores for this one
tiberiumInternalName = "Factorio-Tiberium"
storage = {}

local migration = require("__flib__.migration")
local flib_table = require("__flib__/table")
require("scripts/CnC_Walls") --Note, to make SonicWalls work / be passable
require("scripts/informatron/informatron_remote_interface")

local GA_Beacon_Name = "tiberium-growth-accelerator-beacon"
local Speed_Module_Name = "tiberium-growth-accelerator-speed-module"
local TCN_Beacon_Name = "TCN-beacon"
local TCN_affected_entities = {"tiberium-aoe-node-harvester", "tiberium-spike", "tiberium-node-harvester", "tiberium-network-node"}
local tiberiumNodeNames = {"tibGrowthNode", "tibGrowthNode_infinite"}

local TiberiumDamage = settings.global["tiberium-damage"].value
local TiberiumGrowth = settings.startup["tiberium-growth"].value * 10
local TiberiumMaxPerTile = settings.startup["tiberium-growth"].value * 100 --Force 10:1 ratio with growth
local TiberiumRadius = settings.startup["tiberium-radius"].value
local TiberiumSpreadNodes = settings.global["tiberium-spread-nodes"].value
local BlueTargetEvo = settings.global["tiberium-blue-target-evo"].value
local BlueTiberiumSaturation = settings.global["tiberium-blue-saturation-point"].value / 100
local BlueTiberiumSaturationGrowth = settings.global["tiberium-blue-saturation-slowdown"].value / 100
local bitersImmune = settings.global["tiberium-wont-damage-biters"].value
local ItemDamageScale = settings.global["tiberium-item-damage-scale"].value
local easyMode = settings.startup["tiberium-easy-recipes"].value
local burnerTier = settings.startup["tiberium-tier-zero"].value
local performanceMode = settings.global["tiberium-auto-scale-performance"].value
local debugText = settings.global["tiberium-debug-text"].value
-- Starting items, if the option is ticked.
local tiberium_start = {
	["assembling-machine-2"] = 5,
	["tiberium-centrifuge-3"] = 3,
	["iron-plate"] = 92,
	["copper-plate"] = 100,
	["transport-belt"] = 100,
	["underground-belt"] = 10,
	["splitter"] = 10,
	["burner-inserter"] = 20,
	["wooden-chest"] = 10,
	["small-electric-pole"] = 50,
	["stone-furnace"] = 1,
	["burner-mining-drill"] = 5,
	["boiler"] = 1,
	["steam-engine"] = 2,
	["pipe-to-ground"] = 40,
	["pipe"] = 50,
	["offshore-pump"] = 1
}
if easyMode then
	tiberium_start["chemical-plant"] = 10
end
if burnerTier then
	tiberium_start = {}
	tiberium_start["tiberium-centrifuge-0"] = 3
end

script.on_init(function()
	register_with_picker()
	storage.tibGrowthNodeListIndex = 0
	storage.tibGrowthNodeList = {}
	storage.tibMineNodeListIndex = 0
	storage.tibMineNodeList = {}
	storage.tibDrills = {}
	storage.tibSonicEmitters = {}
	storage.tibOnEntityDestroyed = {}

	-- Each node should spawn tiberium once every 5 minutes (give or take a handful of ticks rounded when dividing)
	-- Currently allowing this to potentially update every tick but to keep things under control minUpdateInterval
	-- can be set to something greater than 1. When minUpdateInterval is reached the global tiberium growth rate
	-- will stagnate instead of increasing with each new node found but updates will continue to happen for all fields.
	storage.minUpdateInterval = 1
	storage.intervalBetweenNodeUpdates = 18000
	storage.lastRescan = 0
	storage.tibPerformanceMultiplier = 1
	storage.tibFastForward = 1
	storage.tibGrowing = true
	storage.tiberiumTerrain = nil --"dirt-4" --Performance is awful, disabling this
	storage.blueProgress = {}
	for _, surface in pairs(game.surfaces) do
		storage.blueProgress[surface.index] = 0
	end
	storage.rocketTime = false
	storage.oreTypes = {"tiberium-ore", "tiberium-ore-blue"}
	storage.tiberiumProducts = storage.oreTypes
	storage.damageForceName = "tiberium"
	if not game.forces[storage.damageForceName] then
		game.create_force(storage.damageForceName)
	end

	storage.exemptDamagePrototypes = {  -- List of prototypes that should not be damaged by growing Tiberium
		["mining-drill"] = true,
		["transport-belt"] = true,
		["underground-belt"] = true,
		["splitter"] = true,
		["wall"] = true,
		["pipe"] = true,
		["pipe-to-ground"] = true,
		["electric-pole"] = true,
		["inserter"] = true,
		["legacy-straight-rail"] = true,
		["legacy-curved-rail"] = true,
		["straight-rail"] = true,
		["curved-rail-a"] = true,
		["curved-rail-b"] = true,
		["half-diagonal-rail"] = true,
		["rail-ramp"] = true,
		["elevated-straight-rail"] = true,
		["elevated-curved-rail-a"] = true,
		["elevated-curved-rail-b"] = true,
		["elevated-half-diagonal-rail"] = true,
		["rail-chain-signal"] = true,
		["rail-signal"] = true,
		["rail-support"] = true,
		["unit-spawner"] = true,  --Biters immune until both performance and evo factor are fixed
		["turret"] = true
	}
	-- Immunity for Mining Drones
	storage.exemptDamageNames = {
		["mining-depot"] = true,
	}
	for _, oreName in pairs(storage.oreTypes) do
		for i = 1,100 do
			storage.exemptDamageNames[oreName.."mining-drone"..i] = true
			storage.exemptDamageNames[oreName.."-mining-drone-"..i] = true --MD2R formatting
		end
	end
	-- Immunity for AAI Miners
	for _, name in pairs({"vehicle-miner", "vehicle-miner-mk2", "vehicle-miner-mk3", "vehicle-miner-mk4", "vehicle-miner-mk5"}) do
		storage.exemptDamageNames[name] = true
	end

	storage.tiberiumDamageTakenMulti = {}
	storage.technologyTimes = {}
	for _, force in pairs(game.forces) do
		initializeForce(force)
	end

	-- Use interface to give starting items if possible
	if (settings.startup["tiberium-advanced-start"].value or settings.startup["tiberium-ore-removal"].value)
			and remote.interfaces["freeplay"] then
		local freeplayStartItems = remote.call("freeplay", "get_created_items") or {}
		for name, count in pairs(tiberium_start) do
			freeplayStartItems[name] = (freeplayStartItems[name] or 0) + count
		end
		remote.call("freeplay", "set_created_items", freeplayStartItems)
	end

	-- CnC SonicWalls Init
	CnC_SonicWall_OnInit()

	-- For drills that were present before Tiberium mod was added or converting from Beta save
	for _, surface in pairs(game.surfaces) do
		for _, drill in pairs(surface.find_entities_filtered{type = "mining-drill"}) do
			local fakeEvent = {}
			fakeEvent.entity = drill
			on_new_entity(fakeEvent)
		end
		local namedEntities = {"tiberium-srf-emitter", "tiberium-node-harvester", "tiberium-spike", "tiberium-growth-accelerator-node", "tiberium-growth-accelerator"}
		for _, entity in pairs(surface.find_entities_filtered{name = namedEntities}) do
			local fakeEvent = {}
			fakeEvent.entity = entity
			fakeEvent.tick = game.tick
			on_new_entity(fakeEvent)
		end
		for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
			addNodeToGrowthList(node)
		end
		for _, wall in pairs(surface.find_entities_filtered{name = "tiberium-srf-wall"}) do
			wall.destroy()  --Wipe out all lingering SRF so we can rebuild them
		end
	end

	-- Define pack color for DiscoScience
	if remote.interfaces["DiscoScience"] and remote.interfaces["DiscoScience"]["setIngredientColor"] then
		remote.call("DiscoScience", "setIngredientColor", "tiberium-science", {r = 0.0, g = 1.0, b = 0.0})
	end
end)

function updateGrowthInterval()
	if performanceMode and #storage.tibGrowthNodeList and #storage.tibGrowthNodeList > 50 then
		storage.tibPerformanceMultiplier = #storage.tibGrowthNodeList / 50
	end
	local performanceInterval = math.max(storage.tibPerformanceMultiplier / 10, 1)  -- For performance multis over 10, space out the growth ticks more
	storage.intervalBetweenNodeUpdates = math.max(math.floor(18000 * performanceInterval / (#storage.tibGrowthNodeList or 1) / storage.tibFastForward), storage.minUpdateInterval)
end

function initializeForce(force)
	if not storage.tiberiumDamageTakenMulti[force.name] then
		updateResistanceLevel(force)
	end
	if not storage.technologyTimes[force.name] then
		storage.technologyTimes[force.name] = {}
		for name, tech in pairs(force.technologies) do
			if tech.researched and string.sub(name, 1, 9) == "tiberium-" then
				table.insert(storage.technologyTimes[force.name], {name, -1})
			end
		end
	end
end

script.on_load(function()
	register_with_picker()
end)

function register_with_picker()
	--register to PickerExtended
	if remote.interfaces["picker"] and remote.interfaces["picker"]["dolly_moved_entity_id"] then
		script.on_event(remote.call("picker", "dolly_moved_entity_id"), OnEntityMoved)
	end
	--register to PickerDollies
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["dolly_moved_entity_id"] then
		script.on_event(remote.call("PickerDollies", "dolly_moved_entity_id"), OnEntityMoved)
	end
end

function OnEntityMoved(event)
	local entity = event.moved_entity
	if entity and (entity.name == "tiberium-growth-accelerator") then
		local beacons = entity.surface.find_entities_filtered{name = GA_Beacon_Name, position = event.start_pos}
		for _, beacon in pairs(beacons) do
			beacon.teleport(entity.position)
		end
	end
end

script.on_configuration_changed(function(data)
	if not script.active_mods["informatron"] then
		game.print({"tiberium-strings.informatron-reminder"})
	end

	if data["mod_changes"][tiberiumInternalName] and data["mod_changes"][tiberiumInternalName]["new_version"] then
		doUpgradeConversions(data)
	end

	-- Apply new settings
	storageIntegrityChecks()
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(data)
	if data.setting == "tiberium-item-damage-scale" then
		ItemDamageScale = settings.global["tiberium-item-damage-scale"].value
	elseif data.setting == "tiberium-spread-nodes" then
		TiberiumSpreadNodes = settings.global["tiberium-spread-nodes"].value
	elseif data.setting == "tiberium-damage" then
		TiberiumDamage = settings.global["tiberium-damage"].value
	elseif data.setting == "tiberium-blue-saturation-point" then
		BlueTiberiumSaturation = settings.global["tiberium-blue-saturation-point"].value / 100
	elseif data.setting == "tiberium-blue-saturation-slowdown" then
		BlueTiberiumSaturationGrowth = settings.global["tiberium-blue-saturation-slowdown"].value / 100
	elseif data.setting == "tiberium-wont-damage-biters" then
		bitersImmune = settings.global["tiberium-wont-damage-biters"].value
	elseif data.setting == "tiberium-auto-scale-performance" then
		performanceMode = settings.global["tiberium-auto-scale-performance"].value
	elseif data.setting == "tiberium-blue-target-evo" then
		BlueTargetEvo = settings.global["tiberium-blue-target-evo"].value
	elseif data.setting == "tiberium-debug-text" then
		debugText = settings.global["tiberium-debug-text"].value
	end
end)

function doUpgradeConversions(data)
	if upgradingToVersion(data, tiberiumInternalName, "2.0.0") then
		game.print("Unable to convert 1.1 saves into 2.0 saves. If you want to continue playing your save with Tiberium, try version 1.1.30")
	end

	if (data["mod_changes"]["Factorio-Tiberium"] and data["mod_changes"]["Factorio-Tiberium"]["new_version"]) and
			(data["mod_changes"]["Factorio-Tiberium-Beta"] and data["mod_changes"]["Factorio-Tiberium-Beta"]["old_version"]) then
		game.print("[Factorio-Tiberium] Successfully converted save from Beta Tiberium mod to Main Tiberium mod")
		game.print("> Found " .. #storage.tibGrowthNodeList .. " nodes")
		game.print("> Found " .. #storage.SRF_nodes .. " SRF hubs")
		game.print("> Found " .. #storage.tibDrills .. " drills")
	end
end

function upgradingToVersion(data, modName, version)
	if data["mod_changes"][modName] and data["mod_changes"][modName]["new_version"] then
		local otherModName  -- Can't use normal flib migration, because we want to support going from beta to main mod
		if modName == "Factorio-Tiberium" then
			otherModName = "Factorio-Tiberium-Beta"
		elseif modName == "Factorio-Tiberium-Beta" then
			otherModName = "Factorio-Tiberium"
		end
		local oldVersion = data["mod_changes"][modName]["old_version"] or
				(data["mod_changes"][otherModName] and data["mod_changes"][otherModName]["old_version"])
		if not oldVersion then return false end
		local newVersion = data["mod_changes"][modName]["new_version"]
		oldVersion = migration.format_version(oldVersion, "%04d")
		newVersion = migration.format_version(newVersion, "%04d")
		version = migration.format_version(version, "%04d")
		return (oldVersion < version) and (newVersion >= version)
	end
	return false
end

function UpdateRecipeUnlocks(force)
	for _, tech in pairs(force.technologies) do
		if string.sub(tech.name, 1, 9) == "tiberium-" then
			for _, effect in pairs(tech.effects) do
				if effect.type == "unlock-recipe" and string.sub(effect.recipe, 1, 9) == "tiberium-" then
					force.recipes[effect.recipe].enabled = tech.researched
				end
			end
		end
	end
end

local interface = {}
-- Flag entities with specific names to not take damage from growing Tiberium
interface.add_tiberium_immunity = function(entity_name) if entity_name then storage.exemptDamageNames[entity_name] = true end end
-- Flag prototypes with specific names to not take damage from growing Tiberium
interface.add_tiberium_immunity_prototype = function(prototype_name) if prototype_name then storage.exemptDamagePrototypes[prototype_name] = true end end

remote.add_interface("Tiberium", interface)

function BlueSpawnProbability(evoFactor)
	local maxRate = 0.01
	local lower = BlueTargetEvo - 0.1
	if evoFactor < lower then return 0 end
	local upper = math.min(BlueTargetEvo + 0.4, 1)
	if evoFactor > upper then return maxRate end
	return maxRate * (evoFactor - lower) / (upper-lower)
end

function AddOre(surface, position, amount, oreName, cascaded)
	local overrideOre = (oreName ~= nil)
	if not oreName then
		local blueSlowdown = storage.blueProgress[surface.index] == 2 and BlueTiberiumSaturationGrowth or 1  -- If surface has reached saturation, use saturation rate multiplier
		if math.random() < (blueSlowdown * BlueSpawnProbability(game.forces.enemy.get_evolution_factor())) then  -- Random <1% chance to spawn Blue Tiberium at high evolution factors
			oreName = "tiberium-ore-blue"
			if storage.blueProgress[surface.index] == 0 then
				storage.blueProgress[surface.index] = 1
				if not storage.wildBlue then storage.wildBlue = math.floor(game.tick / 3600) end
				TiberiumSeedMissile(surface, position, 4 * TiberiumMaxPerTile, oreName)
				game.print({"tiberium-strings.wild-blue-notification", "[img=item.tiberium-ore-blue]", "[gps="..math.floor(position.x)..","..math.floor(position.y).."]"})
				return false  -- We'll just say that this event can't spawn
			end
		elseif surface.count_entities_filtered{area = areaAroundPosition(position, 1), name = "tiberium-ore-blue"} > 0 and
				(math.random() <= blueSlowdown) then  -- Blue will infect neighbors
			oreName = "tiberium-ore-blue"
		else
			oreName = "tiberium-ore"
		end
	end
	local area = areaAroundPosition(position)
	local oreEntity = surface.find_entities_filtered{area = area, name = storage.oreTypes}[1]
	local tile = surface.get_tile(position)
	local growthRate = math.min(amount, TiberiumMaxPerTile)

	if oreEntity and (oreEntity.name == oreName or (oreEntity.name == "tiberium-ore-blue" and not overrideOre)) then
		-- Grow existing tib except for the case where it needs to be replaced instead of growing it
		if oreEntity.amount < TiberiumMaxPerTile then --Don't reduce overgrown ore patch amounts
			oreEntity.amount = math.min(oreEntity.amount + growthRate, TiberiumMaxPerTile)
		end
	elseif surface.count_entities_filtered{area = area, name = tiberiumNodeNames} > 0 then
		return false --Don't place ore on top of nodes
	elseif tile.collides_with("resource")
			or tile.collides_with("water_tile") then
		return false  -- Don't place on invalid tiles
	else
		--Tiberium destroys all other non-Tiberium resources as it spreads
		local otherResources = surface.find_entities_filtered{area = area, type = "resource"}
		local doCascade = false
		for _, entity in pairs(otherResources) do
			if (entity.name ~= oreName) and (entity.name ~= "tibGrowthNode") and (entity.name ~= "tibGrowthNode_infinite") then
				if entity.amount and entity.amount > 0 then
					doCascade = true  -- If we are consuming an ore
					if flib_table.find(storage.oreTypes, entity.name) then
						growthRate = math.min(growthRate + entity.amount, TiberiumMaxPerTile)
					else
						growthRate = math.min(growthRate + (0.5 * entity.amount), TiberiumMaxPerTile)
					end
				end
				entity.destroy()
			end
		end
		if TiberiumSpreadNodes and (surface.count_entities_filtered{area = area, type = "tree"} > 0) and (math.random() < 0.05) then
			CreateNode(surface, position)  -- Rarely turn trees into blossom trees
		else
			oreEntity = surface.create_entity{name = oreName, amount = growthRate, position = position, enable_cliff_removal = false}
			if storage.tiberiumTerrain then
				surface.set_tiles({{name = storage.tiberiumTerrain, position = position}}, true, false)
			end
			surface.destroy_decoratives{position = position} --Remove decoration on tile on spread.
		end

		if doCascade and not cascaded then
			for _, entity in pairs(surface.find_entities_filtered{area = areaAroundPosition(position, 1), type = "resource"}) do
				if entity.valid and (entity.name ~= oreName) and (entity.name ~= "tiberium-ore-blue") and (entity.name ~= "tibGrowthNode")
						and (entity.name ~= "tibGrowthNode_infinite") then
					AddOre(surface, entity.position, amount, oreName, true)
				end
			end
		end
	end

	--Damage adjacent entities unless it's in the list of exemptDamagePrototypes
	for _, entity in pairs(surface.find_entities(area)) do
		if entity.valid and not storage.exemptDamagePrototypes[entity.type] and not storage.exemptDamageNames[entity.name] then
			if entity.type == "tree" then
				safeDamage(entity, 9999)
			else
				safeDamage(entity, TiberiumDamage * 4)
			end
		end
	end

	return oreEntity
end

function CheckPoint(surface, position, lastValidPosition, growthRate, oreName)
	-- These checks are in roughly the order of guessed expense
	local tile = surface.get_tile(position)
	if not tile or not tile.valid then
		AddOre(surface, lastValidPosition, growthRate, oreName, false)
		return true
	end

	if tile.collides_with("resource") or tile.collides_with("water_tile") then
		AddOre(surface, lastValidPosition, growthRate, oreName, false)
		return true  --Hit edge of water, add to previous ore
	end

	local area = areaAroundPosition(position)
	local entitiesBlockTiberium = {"tiberium-srf-wall", "cliff", "tibGrowthNode_infinite"}
	if surface.count_entities_filtered{area = area, name = entitiesBlockTiberium} > 0 then
		AddOre(surface, lastValidPosition, growthRate * 0.5, oreName, false)  --50% lost
		return true  --Hit fence or cliff or spiked node, add to previous ore
	end

	local emitterHubs = surface.find_entities_filtered{area = area, name = "tiberium-srf-emitter"}
	for _, emitter in pairs(emitterHubs) do
		if emitter.valid then
			local emitterPowered = true
			for _, entry in pairs(storage.SRF_node_ticklist or {}) do
				if emitter == entry.emitter then
					emitterPowered = false  -- Exclude nodes that haven't charged
					break
				end
			end
			if emitterPowered then  -- Only block if the SRF is powered
				AddOre(surface, lastValidPosition, growthRate * 0.5, oreName, false)  --50% lost
				return true  --Hit powered SRF emitter hub
			end
		end
	end

	if surface.count_entities_filtered{area = area, name = "tibGrowthNode"} > 0 then
		return false  --Don't grow on top of active node, keep going
	end

	if surface.count_entities_filtered{area = area, name = storage.oreTypes} == 0 then
		AddOre(surface, position, growthRate, oreName, false)
		return true  --Reached edge of patch, place new ore
	else
		return false  --Not at edge of patch, keep going
	end
end

function PlaceOre(entity, howMany)
	if not entity.valid then return end
	local timer = debugText and game.create_profiler() or 0

	howMany = howMany and math.max(math.floor(howMany / storage.tibPerformanceMultiplier), 1) or 1
	local surface = entity.surface
	local position = entity.position

	-- Check for powered monoculture structures
	local oreName
	local monoGreen = surface.find_entity("tiberium-monoculture-green", position)
	local monoBlue = surface.find_entity("tiberium-monoculture-blue", position)
	if monoGreen and monoGreen.valid and (monoGreen.energy > (0.5 * monoGreen.electric_buffer_size)) then
		oreName = "tiberium-ore"
	elseif monoBlue and monoBlue.valid and (monoBlue.energy > (0.5 * monoBlue.electric_buffer_size)) then
		oreName = "tiberium-ore-blue"
	end

	-- Scale growth rate based on distance from spawn
	local growthRate = TiberiumGrowth * storage.tibPerformanceMultiplier * math.max(1, math.sqrt(math.abs(position.x) + math.abs(position.y)) / 20)
	-- Scale size based on distance from spawn, separate from density in case we end up wanting them to scale differently
	local size = TiberiumRadius * math.max(1, math.sqrt(math.abs(position.x) + math.abs(position.y)) / 30)

	local accelerator = surface.find_entity("tiberium-growth-accelerator", position)
	if accelerator then
		-- Divide by tibPerformanceMultiplier to keep ore per credit constant
		local extraAcceleratorOre = math.floor(accelerator.products_finished / storage.tibPerformanceMultiplier)
		if extraAcceleratorOre > 0 then
			howMany = howMany + extraAcceleratorOre
			for _, player in pairs(game.connected_players) do
				if player.surface == surface then
					game.player.create_local_flying_text({
						text = {"tiberium-strings.growth-accelerator-gains", math.floor(extraAcceleratorOre * growthRate)},
						position = {x = position.x, y = position.y - 1},
						color = {r = 0, g = 204, b = 255},
						time_to_live = 300,
						speed = 1 / 60
					})
				end
			end
			-- Only subtract for the whole ore increments that were used
			accelerator.products_finished = math.fmod(accelerator.products_finished, storage.tibPerformanceMultiplier)
		end
	end

	-- Spill excess growth amounts into extra ore tiles
	if growthRate > TiberiumMaxPerTile then
		howMany = math.floor(howMany * growthRate / TiberiumMaxPerTile)
	end

	for n = 1, howMany do
		--Use polar coordinates to find a random angle and radius
		local angle = math.random() * 2 * math.pi
		local radius = 2.2 + math.sqrt(math.random()) * size -- A little over 2 to avoid putting too much on the node itself

		--Convert to cartesian and determine roughly how many tiles we travel through
		local dx = radius * math.cos(angle)
		local dy = radius * math.sin(angle)
		local step = math.max(math.abs(dx), math.abs(dy))
		dx = dx / step
		dy = dy / step

		local lastValidPosition = position
		local placedOre = false
		--Check each tile along the line and stop when we've added ore one time
		repeat
			local newPosition = {x = lastValidPosition.x + dx, y = lastValidPosition.y + dy}
			placedOre = CheckPoint(surface, newPosition, lastValidPosition, growthRate, oreName)
			lastValidPosition = newPosition
			step = step - 1
		until placedOre or (step < 0)

		--Walked all the way to the end of the line, placing ore at the last valid position
		if not placedOre then
			local oreEntity = AddOre(surface, lastValidPosition, growthRate, oreName)
			--Spread setting makes spawning new nodes more likely
			if oreEntity and oreEntity.valid and TiberiumSpreadNodes and (math.random() < ((oreEntity.amount / TiberiumMaxPerTile) - 0.6)) then
				CreateNode(surface, lastValidPosition)  --Use standard function to also remove overlapping ore
			end
		end
	end

	-- Tell all mining drills to wake up
	for i, drill in pairs(storage.tibDrills) do
		if drill.entity and drill.entity.valid then
			drill.entity.rotate{}
			drill.entity.rotate{reverse = true}
			local control = drill.entity.get_control_behavior()
			if control then  --Toggle control behavior to force update to circuit network
				if control.resource_read_mode == defines.control_behavior.mining_drill.resource_read_mode.this_miner then
					control.resource_read_mode = defines.control_behavior.mining_drill.resource_read_mode.entire_patch
					control.resource_read_mode = defines.control_behavior.mining_drill.resource_read_mode.this_miner
				else
					control.resource_read_mode = defines.control_behavior.mining_drill.resource_read_mode.this_miner
					control.resource_read_mode = defines.control_behavior.mining_drill.resource_read_mode.entire_patch
				end
			end
		end
	end

	if debugText then
		game.print({"", timer, " end of place ore at ", position.x, ", ", position.y, "|", math.random()})
	end
end

function CreateNode(surface, position, displayError)
	-- Enforce minimum distance between nodes
	if surface.count_entities_filtered{position = position, radius = TiberiumRadius * 0.8, name = tiberiumNodeNames} > 0 then
		if displayError then
			for _, player in pairs(game.connected_players) do
				if player.surface == surface then
					player.create_local_flying_text({
						position = {x = position.x, y = position.y - 1},
						text = {"tiberium-strings.node-placement-error"},
						color = {r = 255, g = 20, b = 20},
						time_to_live = 300,
						speed = 1 / 60
					})
				end
			end
		end
		return
	end

	-- Avoid overlapping with other nodes
	local area = areaAroundPosition(position, 0.9)
	if surface.count_entities_filtered{area = area, name = tiberiumNodeNames} == 0 then
		-- Check if another entity would block the node
		local blocked = false
		for _, entity in pairs(surface.find_entities_filtered{area = area, collision_mask = {"object"}}) do
			if entity.type ~= "tree" then
				blocked = true
				break
			end
		end
		if blocked then return end

		-- Clear other resources
		for _, entity in pairs(surface.find_entities_filtered{area = area, type = {"resource", "tree"}}) do
			if entity.valid then
				entity.destroy()
			end
		end
		-- Aesthetic changes
		if storage.tiberiumTerrain then
			local newTiles = {}
			local oldTiles = surface.find_tiles_filtered{area = area, collision_mask = "ground-tile"}
			for i, tile in pairs(oldTiles) do
				newTiles[i] = {name = storage.tiberiumTerrain, position = tile.position}
			end
			surface.set_tiles(newTiles, true, false)
		end
		surface.destroy_decoratives{area = area}
		-- Actual node creation
		surface.create_entity{name = "tibGrowthNode", position = position, amount = 15000, raise_built = true}
	end
end

--Code for making the Liquid Seed spread tib
function TiberiumSeedMissile(surface, position, amount, oreName)
	oreName = oreName or "tiberium-ore"
	local radius = math.floor(amount^0.3)
	for x = position.x - radius, position.x + radius do
		for y = position.y - radius, position.y + radius do
			if ((x - position.x)^2 + (y - position.y)^2) < radius then
				local intensity = math.floor(amount^0.57 - (position.x - x)^2 - (position.y - y)^2)
				if intensity > 0 then
					local placePos = {x = math.floor(x) + 0.5, y = math.floor(y) + 0.5}
					local spike = surface.find_entity("tibGrowthNode_infinite", placePos)
					local node = surface.find_entity("tibGrowthNode", placePos)
					if spike then
					elseif node then
						node.amount = node.amount + intensity
					else
						AddOre(surface, placePos, intensity, oreName, true) -- It doesn't make much of a difference, but lets not cascade seed missiles
					end
				end
			end
		end
	end
	local center = {x = math.floor(position.x) + 0.5, y = math.floor(position.y) + 0.5}
	local oreEntity = surface.find_entity(oreName, center)
	if oreEntity and (oreEntity.amount >= TiberiumMaxPerTile) then
		CreateNode(surface, center, true)
	end
end

function TiberiumDestructionMissile(surface, position, radius, names)
	local green = 0
	local blue = 0
	for _, ore in pairs(surface.find_entities_filtered{position = position, radius = radius, name = names}) do
		if ore.name == "tiberium-ore" then
			green = green + 1
		else
			blue = blue + 1
		end
		ore.destroy()
	end
	if green + blue > 0 then
		-- Scorchmark
		surface.create_entity{name = "small-scorchmark-tintable", position = position}
		surface.create_entity{name = "wall-explosion", position = position}
		-- Tinted explosion
		if green > blue then
			surface.create_entity{name = "tiberium-explosion-green", position = position}
		else
			surface.create_entity{name = "tiberium-explosion-blue", position = position}
		end
		-- Destroy decoratives
		surface.destroy_decoratives{area = areaAroundPosition(position, radius)}
		-- AOE damage scaling off amount of tib destroyed
		for _, entity in pairs(surface.find_entities(areaAroundPosition(position, radius))) do
			safeDamage(entity, TiberiumDamage * (green + blue))
		end
	end
end

script.on_event(defines.events.on_script_trigger_effect, function(event)
	--Liquid Seed trigger
	if event.effect_id == "seed-launch" then
		TiberiumSeedMissile(game.surfaces[event.surface_index], event.target_position, 4 * TiberiumMaxPerTile)
	elseif event.effect_id == "seed-launch-blue" then
		TiberiumSeedMissile(game.surfaces[event.surface_index], event.target_position, 4 * TiberiumMaxPerTile, "tiberium-ore-blue")
	elseif event.effect_id == "ore-destruction-sonic-emitter" then
		TiberiumDestructionMissile(game.surfaces[event.surface_index], event.target_position, 1.5, {"tiberium-ore", "tiberium-ore-blue"})
	elseif event.effect_id == "ore-destruction-blue" then
		TiberiumDestructionMissile(game.surfaces[event.surface_index], event.target_position, 3, "tiberium-ore-blue")
	elseif event.effect_id == "ore-destruction-all" then
		TiberiumDestructionMissile(game.surfaces[event.surface_index], event.target_position, 3, {"tiberium-ore", "tiberium-ore-blue"})
	elseif event.effect_id == "ore-destruction-nuke" then
		TiberiumDestructionMissile(game.surfaces[event.surface_index], event.target_position, 37, {"tiberium-ore", "tiberium-ore-blue"})
	elseif event.effect_id == "node-destruction" then
		for _, node in pairs(game.surfaces[event.surface_index].find_entities_filtered{area = areaAroundPosition(event.target_position), name = "tibGrowthNode"}) do
			removeNodeFromGrowthList(node)
			node.destroy{raise_destroy = true}
		end
	end
end)

script.on_event(defines.events.on_resource_depleted, function(event)
	if event.entity.name == "tibGrowthNode" then
		--Remove tree entity when node is mined out
		removeBlossomTree(event.entity.surface, event.entity.position)
		removeNodeFromGrowthList(event.entity)
	end
end)

commands.add_command("tibNodeList",
	"Print the list of known Tiberium nodes",
	function()
		game.player.print("There are " .. #storage.tibGrowthNodeList .. " nodes in the list")
		for i = 1, #storage.tibGrowthNodeList do
			if storage.tibGrowthNodeList[i].valid then
				game.player.print("#"..i.." x:" .. storage.tibGrowthNodeList[i].position.x .. " y:" .. storage.tibGrowthNodeList[i].position.y)
			else
				game.player.print("Invalid node in storage at position #"..i)
			end
		end
	end
)
commands.add_command("tibRebuildLists",
	"Update lists of mining drills and Tiberium nodes",
	function()
		storage.tibGrowthNodeList = {}
		storage.tibMineNodeList = {}
		storage.SRF_nodes = {}
		storage.tibDrills = {}
		storage.tibSonicEmitters = {}
		for _, surface in pairs(game.surfaces) do
			for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
				addNodeToGrowthList(node)
			end
			for _, srf in pairs(surface.find_entities_filtered{name = "tiberium-srf-emitter"}) do
				table.insert(storage.SRF_nodes, {emitter = srf, position = srf.position})
			end
			for _, drill in pairs(surface.find_entities_filtered{type = "mining-drill"}) do
				table.insert(storage.tibDrills, {entity = drill, name = drill.name, position = drill.position})
			end
			for _, sonic in pairs(surface.find_entities_filtered{name = {"tiberium-sonic-emitter", "tiberium-sonic-emitter-blue"}}) do
				table.insert(storage.tibSonicEmitters, {position = sonic.position, surface = surface})
			end
		end
		game.player.print("Found " .. #storage.tibGrowthNodeList .. " nodes")
		game.player.print("Found " .. #storage.SRF_nodes .. " SRF hubs")
		game.player.print("Found " .. #storage.tibDrills .. " drills")
		game.player.print("Found " .. #storage.tibSonicEmitters .. " sonic emitters")
	end
)
commands.add_command("tibGrowAllNodes",
	"Forces multiple immediate Tiberium ore growth cycles at every node",
	function(invocationdata)
		local timer = game.create_profiler()
		local placements = tonumber(invocationdata["parameter"]) or math.ceil(300 / storage.tibPerformanceMultiplier)
		game.player.print("There are " .. #storage.tibGrowthNodeList .. " nodes in the list")
		for i = 1, #storage.tibGrowthNodeList, 1 do
			if storage.tibGrowthNodeList[i].valid then
				if debugText then
					game.player.print("Growing node x:" .. storage.tibGrowthNodeList[i].position.x .. " y:" .. storage.tibGrowthNodeList[i].position.y)
				end
				PlaceOre(storage.tibGrowthNodeList[i], placements)
			end
		end
		if remote.interfaces["mining_drones"] and remote.interfaces["mining_drones"]["rescan_all_depots"] then
			remote.call("mining_drones", "rescan_all_depots")
			storage.lastRescan = game.tick
		end
		game.player.print({"", timer, " end of tibGrowAllNodes"})
	end
)
commands.add_command("tibDeleteOre",
	"Deletes all the Tiberium ore on the map. May take a long time on maps with large amounts of Tiberium. Parameter is the max number of entity updates (10,000 by default)",
	function(invocationdata)
		local oreLimit = tonumber(invocationdata["parameter"]) or 1000
		for _, surface in pairs(game.surfaces) do
			local deletedOre = 0
			for _, ore in pairs(surface.find_entities_filtered{name = storage.oreTypes}) do
				if deletedOre >= oreLimit then
					game.player.print("Too much Tiberium, only deleting "..oreLimit.." ore tiles on this pass")
					break
				end
				ore.destroy()
				deletedOre = deletedOre + 1
			end
			-- Also destroy nodes if they aren't on valid terrain
			for _, node in pairs(surface.find_entities_filtered{name = tiberiumNodeNames}) do
				local tile = surface.find_tiles_filtered{position = node.position}[1]
				if tile.collides_with("water_tile") or tile.collides_with("resource") then
					removeBlossomTree(surface, node.position)
					removeNodeFromGrowthList(node)
					node.destroy()
				end
			end
		end
	end
)
commands.add_command("tibDeleteOre2",
	"Deletes all the Tiberium ore on the map. May take a long time on maps with large amounts of Tiberium. Parameter is the max number of entity updates (10,000 by default)",
	function(invocationdata)
		local oreLimit = tonumber(invocationdata["parameter"]) or 10000
		local timer = game.create_profiler()
		for _, surface in pairs(game.surfaces) do
			-- Also destroy nodes if they aren't on valid terrain
			for _, node in pairs(surface.find_entities_filtered{name = tiberiumNodeNames}) do
				local tile = surface.find_tiles_filtered{position = node.position}[1]
				if tile.collides_with("water_tile") or tile.collides_with("resource") then
					removeBlossomTree(surface, node.position)
					removeNodeFromGrowthList(node)
					node.destroy()
				end
			end
			game.player.print({"", timer, "finished node culling for", surface.name})
			local chunkCnt = 0
			for chunk in surface.get_chunks() do
				local deletedOre = 0
				chunkCnt = chunkCnt + 1
				local oreCnt = surface.count_entities_filtered{name = storage.oreTypes, area = chunk.area}
				if oreCnt > 0 then
					game.player.print({"", "In chunk ", chunkCnt, " found ", oreCnt, " ore"})
					for _, ore in pairs(surface.find_entities_filtered{name = storage.oreTypes, area = chunk.area}) do
						if deletedOre >= oreLimit then
							game.player.print("Too much Tiberium, only deleting "..oreLimit.." ore tiles on this pass")
							break
						end
						ore.destroy()
						deletedOre = deletedOre + 1
					end
					game.player.print({"", timer, "Surface", surface.name, "chunk #", chunkCnt, "deleted ore", deletedOre})
				end
			end
		end
	end
)
commands.add_command("tibChangeTerrain",
	"Changes terrain under Tiberium patches. Parameter is the internal name of the tile you want. Can impact UPS on larger saves. To turn off type '/tibChangeTerrain nil'",
	function(invocationdata)
		local terrain = invocationdata["parameter"] or "dirt-4"
		if terrain == "nil" then
			storage.tiberiumTerrain = nil
			game.print("Disabled Tiberium terrain texture.")
		else
			storage.tiberiumTerrain = terrain
			game.print("Changed Tiberium terrain texture to "..terrain..". If UPS drops, you can use '/tibChangeTerrain nil' to disable this feature.")
			--Ore
			for _, surface in pairs(game.surfaces) do
				for _, ore in pairs(surface.find_entities_filtered{name = storage.oreTypes}) do
					ore.surface.set_tiles({{name = terrain, position = ore.position}}, true, false)
				end
			end
			--Nodes
			for _, node in pairs(storage.tibGrowthNodeList) do
				if node.valid then
					local position = node.position
					local area = areaAroundPosition(position, 1)
					local newTiles = {}
					local oldTiles = node.surface.find_tiles_filtered{area = area, collision_mask = "ground-tile"}
					for i, tile in pairs(oldTiles) do
						newTiles[i] = {name = terrain, position = tile.position}
					end
					node.surface.set_tiles(newTiles, true, false)
				end
			end
		end
	end
)
commands.add_command("tibPerformanceMultiplier",
	"Reduces the number of updates made by Tiberium growth at the cost of Tiberium fields being uglier. Set the parameter to 1 to return to default growth behavior.",
	function(invocationdata)
		local multi = tonumber(invocationdata["parameter"]) or 10
		storage.tibPerformanceMultiplier = math.max(multi, 1)  -- Don't let them put the multiplier below 1
		updateGrowthInterval()
		game.player.print("Performance multiplier set to "..storage.tibPerformanceMultiplier)
	end
)
commands.add_command("tibPauseGrowth",
	"Toggle natural Tiberium growth for cases where you are overwhelmed or UPS issues couldn't be resolved using tibPerformanceMultiplier. Use the command a second time to unpause.",
	function()
		storage.tibGrowing = not storage.tibGrowing
		game.print(game.player.name.." has turned Tiberium growth "..(storage.tibGrowing and "back on." or "off."))
	end
)
commands.add_command("tibShareStats",
	"Generate a string of data with stats your current Factorio game to share with Tiberium mod developers.",
	function(invocationdata)
		local fileName = "Tiberium Stats.txt"
		game.write_file(fileName, "", false, game.player.index)
		-- General game state
		local str = ""
		str = str .. "version," .. script.active_mods[tiberiumInternalName] .. "|"
		str = str .. "submitted by," .. game.player.name .. "|"
		str = str .. "# players," .. #game.players .. "|"
		str = str .. "time," .. math.floor(game.tick / 3600) .. "|"
		str = str .. "rocket," .. tostring(storage.rocketTime) .. "|"
		str = str .. "blue spawn," .. tostring(storage.wildBlue) .. "|"
		str = str .. "evo factor," .. game.forces.enemy.get_evolution_factor() .. "|"
		game.write_file(fileName, str, true, game.player.index)
		-- Mod list
		str = "\n"
		for name, version in pairs(script.active_mods) do
			str = str .. name .. "," .. version .. "|"
		end
		game.write_file(fileName, str, true, game.player.index)
		-- Mod settings
		str = "\n"
		local playerSettings = {}
		for _,source in pairs({settings.get_player_settings(game.player.index), settings.startup, settings.global}) do
			for k,v in pairs(source) do
				playerSettings[k] = v.value
			end
		end
		for name, _ in pairs(game.get_filtered_mod_setting_prototypes{{filter="mod", mod=tiberiumInternalName}}) do
			str = str..name..","..tostring(playerSettings[name]).."|"
		end
		game.write_file(fileName, str, true, game.player.index)
		-- Entities
		str = "\n"
		for name, _ in pairs(game.get_filtered_entity_prototypes{{filter="name", name="test", invert=true}}) do
			if string.sub(name, 1, 3) == "tib" then
				str = str..name..","..game.surfaces[1].count_entities_filtered{name = name}.."|"
			end
		end
		game.write_file(fileName, str, true, game.player.index)
		-- Recipes
		local recipeTable = {}
		for _, surface in pairs(game.surfaces) do
			for _, entity in pairs(surface.find_entities_filtered{type={"assembling-machine", "rocket-silo"}} or {}) do
				local speed = entity.crafting_speed or 1
				local recipe = entity.get_recipe()
				if recipe and recipe.name then
					if recipeTable[recipe.name] then
						recipeTable[recipe.name] = recipeTable[recipe.name] + speed
					else
						recipeTable[recipe.name] = speed
					end
				end
			end
		end
		str = "\n"
		for name, speed in pairs(recipeTable) do
			str = str..name..","..speed.."|"
		end
		game.write_file(fileName, str, true, game.player.index)
		-- Technologies
		str = "\n"
		table.sort(storage.technologyTimes[game.player.force.name], function(a,b) return (a[2] == b[2]) and (a[1] < b[1]) or (a[2] < b[2]) end)
		for _, tech in pairs(storage.technologyTimes[game.player.force.name]) do
			str = str .. tech[1] .. "," .. tech[2] .. "|"
		end
		game.write_file(fileName, str, true, game.player.index)
		game.player.print("Saved stats to %AppData%/Roaming/Factorio/script-output/"..fileName)
		game.player.print("You can share your stats with Tiberium mods here: https://discord.gg/ed4pNP3KrH")
	end
)
commands.add_command("tibFastForward",
	"Define a speed multiplier for Tiberium growth rate for testing/debugging purposes. Default is 100. Use command with value 1 to go back to normal.",
	function(invocationdata)
		local multi = tonumber(invocationdata["parameter"]) or 100
		if multi > 0 then
			storage.tibFastForward = multi
			updateGrowthInterval()
		end
	end
)

--initial chunk scan
script.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface
	local area = {  -- Extra illegal, please don't report to Wube
		{event.area.left_top.x + 1, event.area.left_top.y + 1},
		{event.area.right_bottom.x - 1, event.area.right_bottom.y - 1}
	}
	for _, newNode in pairs(surface.find_entities_filtered{area = area, name = "tibGrowthNode"}) do
		local position = newNode.position
		registerEntity(newNode)
		addNodeToGrowthList(newNode)
		createBlossomTree(surface, position)
		--Clear trees
		for _, tree in pairs(surface.find_entities_filtered{area = areaAroundPosition(position, 0.9), type = "tree"}) do
			if tree.valid then
				tree.destroy()
			end
		end
		local howManyOre = math.min(math.max(10, (math.abs(position.x) + math.abs(position.y)) / 25), 200) --Start further nodes with more ore
		PlaceOre(newNode, howManyOre)
		--Cosmetic stuff
		local tileArea = areaAroundPosition(position, 0.9)
		surface.destroy_decoratives{area = tileArea}
		if storage.tiberiumTerrain then
			local newTiles = {}
			local oldTiles = surface.find_tiles_filtered{area = tileArea, collision_mask = "ground-tile"}
			for i, tile in pairs(oldTiles) do
				newTiles[i] = {name = storage.tiberiumTerrain, position = tile.position}
			end
			surface.set_tiles(newTiles, true, false)
		end
	end
end)

script.on_event(defines.events.on_tick, function(event)
	-- Update SRF Walls
	CnC_SonicWall_OnTick(event)
	-- Sonic Emitters
	for i, location in pairs(storage.tibSonicEmitters) do
		if (i % 60) == (event.tick % 60) then
			local emitter = location.surface.find_entities_filtered{name = {"tiberium-sonic-emitter", "tiberium-sonic-emitter-blue"}, position = location.position}[1]
			if emitter and (emitter.energy >= emitter.electric_buffer_size) then
				local targetOreTypes = (emitter.name == "tiberium-sonic-emitter-blue") and "tiberium-ore-blue" or storage.oreTypes
				local ore = location.surface.find_entities_filtered{name = targetOreTypes, position = location.position, radius = 12}
				if #ore > 0 then
					local targetOre = ore[math.random(1, #ore)]
					local dummy = location.surface.create_entity{name = "tiberium-target-dummy", position = targetOre.position}
					location.surface.create_entity{name = "tiberium-sonic-emitter-projectile", position = location.position, speed = 0.2, target = dummy}
					dummy.destroy()
					emitter.energy = 0
				end
			end
		end
	end

	-- Spawn ore check
	if storage.tibGrowing and (event.tick % storage.intervalBetweenNodeUpdates == 0) then
		-- Step through the list of growth nodes, one each update
		local tibGrowthNodeCount = #storage.tibGrowthNodeList
		storage.tibGrowthNodeListIndex = storage.tibGrowthNodeListIndex + 1
		if (storage.tibGrowthNodeListIndex > tibGrowthNodeCount) then
			storage.tibGrowthNodeListIndex = 1
		end
		if tibGrowthNodeCount >= 1 then
			local node = storage.tibGrowthNodeList[storage.tibGrowthNodeListIndex]
			if node.valid then
				PlaceOre(node, 10)
				local position = node.position
				local surface = node.surface
				local treeBlockers = {"tibNode_tree", "tiberium-node-harvester", "tiberium-spike", "tiberium-growth-accelerator", "tiberium-detonation-charge", "tiberium-monoculture-green", "tiberium-monoculture-blue"}
				if surface.count_entities_filtered{area = areaAroundPosition(position), name = treeBlockers} == 0 then
					createBlossomTree(surface, position)
				end
				-- 10 second cooldown on API call to avoid spam once you get to 100+ nodes
				if (storage.lastRescan + 600 < game.tick) and remote.interfaces["mining_drones"] and remote.interfaces["mining_drones"]["rescan_all_depots"] then
					remote.call("mining_drones", "rescan_all_depots")
					storage.lastRescan = game.tick
				end
			else
				removeNodeFromGrowthList(node)
			end
		end
	end
	if not bitersImmune then
		local i = (event.tick % 60) + 1  --Loop through 1/60th of the nodes every tick
		while i <= #storage.tibGrowthNodeList do
			local node = storage.tibGrowthNodeList[i]
			if node.valid then
				local enemies = node.surface.find_entities_filtered{position = node.position, radius = TiberiumRadius, force = game.forces.enemy}
				for _, enemy in pairs(enemies) do
					safeDamage(enemy, TiberiumDamage * 6)
				end
			else
				removeNodeFromGrowthList(node)
			end
			i = i + 60
		end
	end
end
)

script.on_nth_tick(20, function(event) --Player damage 3 times per second
	for _, player in pairs(game.connected_players) do
		if player.valid and player.character and player.character.valid then
			--MARV ore deletion
			if player.vehicle and (player.vehicle.name == "tiberium-marv") and (player.vehicle.get_driver() == player.character) then
				for _, oreName in pairs(storage.oreTypes) do
					local deleted_ore = player.surface.find_entities_filtered{name = oreName, position = player.position, radius = 4}
					local harvested_amount = 0
					for _, ore in pairs(deleted_ore) do
						harvested_amount = harvested_amount + ore.amount * 0.01
						ore.destroy()
					end
					if harvested_amount >= 1 then
						player.vehicle.insert{name = oreName, count = math.floor(harvested_amount)}
					end
				end
			end
			--Damage players that are standing on Tiberium Ore and not in vehicles
			local nearby_ore_count = player.surface.count_entities_filtered{name = storage.oreTypes, position = player.position, radius = 1.5}
			if nearby_ore_count > 0 and not player.character.vehicle and player.character.name ~= "jetpack-flying" then
				safeDamage(player, nearby_ore_count * TiberiumDamage * 0.2)
			end
			--Damage players with unsafe Tiberium products in their inventory
			local damagingItems = 0
			for _, inventory in pairs({player.get_inventory(defines.inventory.character_main), player.get_inventory(defines.inventory.character_trash)}) do
				if inventory and inventory.valid then
					for _, dangerousItem in pairs(storage.tiberiumProducts) do
						damagingItems = damagingItems + inventory.get_item_count(dangerousItem)
					end
				end
			end
			if damagingItems > 0 then
				if ItemDamageScale then
					safeDamage(player, math.ceil(damagingItems / 50) * TiberiumDamage * 0.6)
				else
					safeDamage(player, TiberiumDamage * 0.6)
				end
			end
		end
	end
end)

function safeDamage(entityOrPlayer, damageAmount)
	if damageAmount <= 0 then return end
	if not entityOrPlayer or not entityOrPlayer.valid then return end
	local damageMulti = 1
	local entity = entityOrPlayer
	local player = nil
	if entityOrPlayer and entityOrPlayer.is_player() then
		player = entityOrPlayer
		entity = entityOrPlayer.character  -- Need to damage character instead of player
	end
	if entity and entity.valid and entity.health and entity.health > 0 then
		-- Reduce/prevent growth damage for forces with immunity technologies
		damageMulti = storage.tiberiumDamageTakenMulti[entity.force.name] or 1
		if (damageMulti == 0) and not entity.grid then  -- Immunity requires power armor
			damageMulti = 0.25
		end

		if damageMulti > 0 then
			entity.damage(damageAmount * damageMulti, game.forces.tiberium, "tiberium")
			-- Alert player about Tiberium damage
			if player and entity.valid then
				player.add_custom_alert(
					entity,
					{type = "virtual", name = "tiberium-radiation"},
					{"tiberium-strings.taking-tiberium-radiation-damage"},
					false
				)
			end
		end
	end
end

function addNodeToGrowthList(newNode)
	for _, node in pairs(storage.tibGrowthNodeList) do
		if newNode == node then
			return false
		end
	end
	table.insert(storage.tibGrowthNodeList, newNode)
	updateGrowthInterval()  -- Move call to here so we always update when node count changes
	return true
end

function removeNodeFromGrowthList(node)
	for i = 1, #storage.tibGrowthNodeList do
		if storage.tibGrowthNodeList[i] == node then
			table.remove(storage.tibGrowthNodeList, i)
			updateGrowthInterval()  -- Move call to here so we always update when node count changes
			if storage.tibGrowthNodeListIndex >= i then
				storage.tibGrowthNodeListIndex = storage.tibGrowthNodeListIndex - 1
			end
			return true
		end
	end
	return false
end

function areaAroundPosition(position, extraRange)  --Eventually add more checks to this
	if type(extraRange) ~= "number" then extraRange = 0 end
	return {
		{x = math.floor(position.x) - extraRange,     y = math.floor(position.y) - extraRange},
		{x = math.floor(position.x) + 1 + extraRange, y = math.floor(position.y) + 1 + extraRange}
	}
end

function validpairs(table, subscript)
	local function nextvalid(table, k)
		while true do
			k = next(table, k)
			if not k or not table[k] then
				return nil
			else
				if subscript and (type(table[k]) == "table") and table[k][subscript] then
					if table[k][subscript].valid then
						return k, table[k]
					end
				else
					if table[k].valid then
						return k, table[k]
					end
				end
			end
		end
	end
	return nextvalid, table, nil
end

script.on_nth_tick(60 * 300, function(event)
	if event.tick > 0 then  -- Have to skip inital tick
		storageIntegrityChecks()
	end
end)

function storageIntegrityChecks()
	local nodeCount = 0
	for _, surface in pairs(game.surfaces) do
		nodeCount = nodeCount + surface.count_entities_filtered{name = "tibGrowthNode"}
	end
	if nodeCount ~= #storage.tibGrowthNodeList then
		if debugText then
			game.print("!!!Warning: "..nodeCount.." Tiberium nodes exist while there are "..#storage.tibGrowthNodeList.." nodes growing.")
			game.print("Rebuilding Tiberium node growth list.")
		end
		storage.tibGrowthNodeList = {}
		for _, surface in pairs(game.surfaces) do
			for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
				addNodeToGrowthList(node)
			end
		end
	end
	-- Update blue tiberium progress
	for _, surface in pairs(game.surfaces) do
		local resources = surface.get_resource_counts()
		local blue = resources["tiberium-ore-blue"] or 0
		local green = resources["tiberium-ore"] or 1
		if blue > ((blue + green) * BlueTiberiumSaturation) then
			storage.blueProgress[surface.index] = 2
		elseif blue > 0 then
			storage.blueProgress[surface.index] = 1
		else
			storage.blueProgress[surface.index] = 0
		end
	end
end

function registerEntity(entity)  -- Cache relevant information to storage and register
	local entityInfo = {}
	for _, property in pairs({"name", "type", "position", "surface", "force"}) do
		entityInfo[property] = entity[property]
	end
	local registration_number = script.register_on_object_destroyed(entity)
	storage.tibOnEntityDestroyed[registration_number] = entityInfo
end

function on_new_entity(event)
	local new_entity = event.created_entity or event.entity --Handle multiple event types
	local surface = new_entity.surface
	local position = new_entity.position
	local force = new_entity.force
	if (new_entity.type == "mining-drill") then
		registerEntity(new_entity)
		local duplicate = false
		for _, drill in pairs(storage.tibDrills) do
			if drill.entity == new_entity then
				duplicate = true
				break
			end
		end
		if not duplicate then table.insert(storage.tibDrills, {entity = new_entity, name = new_entity.name, position = position}) end
	end
	if (new_entity.name == "tiberium-srf-connector") then
		new_entity.destructible = false
		local emitter = surface.create_entity{
			name = "tiberium-srf-emitter",
			position = position,
			force = force,
			raise_built = true
		}
		registerEntity(emitter)
		CnC_SonicWall_AddNode(emitter, event.tick)
	elseif (new_entity.name == "tiberium-node-harvester") then
		registerEntity(new_entity)
		--Remove tree entity when node is covered
		removeBlossomTree(surface, position)
		--Place Beacon for Tiberium Control Network
		ManageTCNBeacon(surface, position, force)
	elseif (new_entity.name == "tiberium-network-node") then
		registerEntity(new_entity)
		--Place Beacon for Tiberium Control Network
		ManageTCNBeacon(surface, position, force)
	elseif (new_entity.name == "tiberium-aoe-node-harvester") then
		registerEntity(new_entity)
		--Place Beacon for Tiberium Control Network
		ManageTCNBeacon(surface, position, force)
	elseif (new_entity.name == "tiberium-beacon-node") then
		registerEntity(new_entity)
		--Place Beacon for Drills in range of Tiberium Control Network
		local tcnAOE = areaAroundPosition(position, TiberiumRadius * 0.5 + 1)
		for _, entity in pairs(surface.find_entities_filtered{area = tcnAOE, name = TCN_affected_entities, force = force}) do
			ManageTCNBeacon(surface, entity.position, force)
		end
	elseif (new_entity.name == "tiberium-spike") then
		registerEntity(new_entity)
		--Remove tree entity when node is covered
		removeBlossomTree(surface, position)
		local nodes = surface.find_entities_filtered{area = areaAroundPosition(position), name = "tibGrowthNode"}
		for _, node in pairs(nodes) do
			--Remove spiked node from growth list
			removeNodeFromGrowthList(node)
			local nodeRichness = node.amount
			node.destroy()
			surface.create_entity{
				name = "tibGrowthNode_infinite",
				position = position,
				force = game.forces.neutral,
				amount = nodeRichness * 10,
				raise_built = true
			}
		end
		--Make spike look for newly created infinite node
		new_entity.rotate{}
		new_entity.rotate{reverse = true}
		local control = new_entity.get_control_behavior()
		if control then  --Toggle control behavior to force update to circuit network
			if control.resource_read_mode == defines.control_behavior.mining_drill.resource_read_mode.this_miner then
				control.resource_read_mode = defines.control_behavior.mining_drill.resource_read_mode.entire_patch
				control.resource_read_mode = defines.control_behavior.mining_drill.resource_read_mode.this_miner
			else
				control.resource_read_mode = defines.control_behavior.mining_drill.resource_read_mode.this_miner
				control.resource_read_mode = defines.control_behavior.mining_drill.resource_read_mode.entire_patch
			end
		end
		--Place Beacon for Tiberium Control Network
		ManageTCNBeacon(surface, position, force)
	elseif (new_entity.name == "tiberium-growth-accelerator-node") then
		new_entity.destroy()
		surface.create_entity{
			name = "tiberium-growth-accelerator",
			position = position,
			force = force,
			raise_built = true
		}
	elseif (new_entity.name == "tiberium-growth-accelerator") then
		registerEntity(new_entity)
		--Remove tree entity when node is covered
		removeBlossomTree(surface, position)
		if surface.count_entities_filtered{name = GA_Beacon_Name, position = position} == 0 then
			local beacon = surface.create_entity{name = GA_Beacon_Name, position = position, force = force}
			beacon.destructible = false
			beacon.minable = false
			local module_count = upgradeLevel(force, "tiberium-growth-acceleration-acceleration")
			UpdateBeaconSpeed(beacon, module_count)
		end
	elseif (new_entity.name == "tiberium-monoculture-green-node") then
		new_entity.destroy()
		surface.create_entity{
			name = "tiberium-monoculture-green",
			position = position,
			force = force,
			raise_built = true
		}
	elseif (new_entity.name == "tiberium-monoculture-green") then
		registerEntity(new_entity)
		--Remove tree entity when node is covered
		removeBlossomTree(surface, position)
	elseif (new_entity.name == "tiberium-monoculture-blue-node") then
		new_entity.destroy()
		surface.create_entity{
			name = "tiberium-monoculture-blue",
			position = position,
			force = force,
			raise_built = true
		}
	elseif (new_entity.name == "tiberium-monoculture-blue") then
		registerEntity(new_entity)
		--Remove tree entity when node is covered
		removeBlossomTree(surface, position)
	elseif (new_entity.name == "tibGrowthNode") then
		registerEntity(new_entity)
		addNodeToGrowthList(new_entity)
		createBlossomTree(surface, position)
	elseif (new_entity.name == "tiberium-sonic-emitter") or (new_entity.name == "tiberium-sonic-emitter-blue") then
		registerEntity(new_entity)
		table.insert(storage.tibSonicEmitters, {position = new_entity.position, surface = surface})
	elseif (new_entity.name == "tiberium-detonation-charge") then
		registerEntity(new_entity)
		--Remove tree entity when node is covered
		removeBlossomTree(surface, position)
	end
end

script.on_event(defines.events.on_built_entity, on_new_entity)
script.on_event(defines.events.on_robot_built_entity, on_new_entity)
script.on_event(defines.events.script_raised_built, on_new_entity)
script.on_event(defines.events.script_raised_revive, on_new_entity)

function on_remove_entity(event)
	local entity = storage.tibOnEntityDestroyed[event.registration_number]
	storage.tibOnEntityDestroyed[event.registration_number] = nil  -- Avoid storage growing forever
	if not entity then return end
	local surface = entity.surface
	local position = entity.position
	local force = entity.force
	if (entity.type == "mining-drill") then
		for i, drill in pairs(storage.tibDrills) do
			if flib_table.deep_compare(drill.position, position) and (drill.name == entity.name) then
				table.remove(storage.tibDrills, i)
				break
			end
		end
	end
	if (entity.name == "tiberium-sonic-emitter") or (entity.name == "tiberium-sonic-emitter-blue") then
		for i = 1, #storage.tibSonicEmitters do
			if flib_table.deep_compare(storage.tibSonicEmitters[i].position, entity.position) then
				table.remove(storage.tibSonicEmitters, i)
				break
			end
		end
	end
	if not surface or not surface.valid then return end
	if (entity.name == "tiberium-srf-emitter") or (entity.name == "CnC_SonicWall_Hub") then
		local ghost = surface.find_entities_filtered{position = entity.position, ghost_name = entity.name}[1]
		for _, connector in pairs(surface.find_entities_filtered{name = "tiberium-srf-connector", position = position, force = force}) do
			if ghost then
				connector.destructible = true
				connector.die()
			else
				connector.destroy()
			end
		end
		if ghost then
			ghost.destroy()
		end
		CnC_SonicWall_DeleteNode(entity, event.tick)
	elseif (entity.name == "tiberium-beacon-node") then
		--Remove Beacon for Tiberium Control Network
		local tcnAOE = areaAroundPosition(position, TiberiumRadius * 0.5 + 1)
		for _, beacon in pairs(surface.find_entities_filtered{area = tcnAOE, name = TCN_Beacon_Name, force = force}) do
			ManageTCNBeacon(surface, beacon.position, force)
		end
	elseif (entity.name == "tiberium-spike") then
		convertUnspikedNode(surface, position)
		removeHiddenBeacon(surface, position, TCN_Beacon_Name)
	elseif (entity.name == "tiberium-node-harvester") then
		--Spawn tree entity when node is uncovered
		createBlossomTree(surface, position)
		removeHiddenBeacon(surface, position, TCN_Beacon_Name)
	elseif (entity.name == "tiberium-network-node") then
		removeHiddenBeacon(surface, position, TCN_Beacon_Name)
	elseif (entity.name == "tiberium-aoe-node-harvester") then
		removeHiddenBeacon(surface, position, TCN_Beacon_Name)
	elseif (entity.name == "tiberium-growth-accelerator") then
		--Spawn tree entity when node is uncovered
		createBlossomTree(surface, position)
		removeHiddenBeacon(surface, position, GA_Beacon_Name)
	elseif (entity.name == "tiberium-monoculture-green") then
		createBlossomTree(surface, position)
	elseif (entity.name == "tiberium-monoculture-blue") then
		createBlossomTree(surface, position)
	elseif (entity.name == "tibGrowthNode") then
		removeBlossomTree(surface, position)
		removeNodeFromGrowthList(entity)
	elseif (entity.name == "tiberium-detonation-charge") then
		createBlossomTree(surface, position)
	end
end

function convertUnspikedNode(surface, position)
	if surface and surface.valid then
		local area = areaAroundPosition(position)
		local nodes = surface.find_entities_filtered{area = area, name = "tibGrowthNode_infinite"}
		for _, node in pairs(nodes) do
			local spikedNodeRichness = node.amount
			node.destroy()
			local newNode = surface.create_entity{
				name = "tibGrowthNode",
				position = position,
				force = game.forces.neutral,
				amount = math.floor(spikedNodeRichness / 10),
				raise_built = true
			}
		end
	end
end

function createBlossomTree(surface, position)
	if surface and surface.valid and surface.count_entities_filtered{area = areaAroundPosition(position), name = "tibGrowthNode"} > 0 then
		surface.create_entity{
			name = "tibNode_tree",
			position = position,
			force = game.forces.neutral,
			raise_built = false
		}
	end
end

function removeBlossomTree(surface, position)
	if surface and surface.valid then
		for _, tree in pairs(surface.find_entities_filtered{area = areaAroundPosition(position), name = "tibNode_tree"}) do
			tree.destroy()
		end
	end
end

function removeHiddenBeacon(surface, position, name)
	-- Remove Beacon for Tiberium Control Network
	if surface and surface.valid then
		for _, beacon in pairs(surface.find_entities_filtered{name = name, position = position}) do
			beacon.destroy()
		end
	end
end

script.on_event(defines.events.on_object_destroyed, on_remove_entity)

function on_pre_mined(event)
	local entity = event.entity
	if entity and entity.fluidbox then
		local greenTibOre = 0
		local fluidContents = entity.get_fluid_contents()
		local oreValueMulti = 10 / settings.startup["tiberium-value"].value
		greenTibOre = greenTibOre + (fluidContents["tiberium-slurry"] or 0)
		greenTibOre = greenTibOre + 2 * (fluidContents["molten-tiberium"] or 0)
		greenTibOre = greenTibOre + 4 * (fluidContents["liquid-tiberium"] or 0)
		greenTibOre = greenTibOre * oreValueMulti
		if greenTibOre > 0 then
			if debugText then game.print("Created "..tostring(greenTibOre).." green Tiberium ore") end
			TiberiumSeedMissile(entity.surface, entity.position, greenTibOre)
		end
		local blueTibOre = (fluidContents["tiberium-slurry-blue"] or 0)
		if blueTibOre > 0 then
			if debugText then game.print("Created "..tostring(blueTibOre).." blue Tiberium ore") end
			TiberiumSeedMissile(entity.surface, entity.position, blueTibOre, "tiberium-ore-blue")
		end
	end
end

script.on_event(defines.events.on_pre_player_mined_item, on_pre_mined)
script.on_event(defines.events.on_robot_pre_mined, on_pre_mined)

function on_entity_died(event)
	local entity = event.entity
	-- Need to handle detonation charges down here because on_object_destroyed can't distinguish between dying and mining
	if entity and (entity.name == "tiberium-detonation-charge") then
		for _, node in pairs(entity.surface.find_entities_filtered{area = areaAroundPosition(entity.position), name = "tibGrowthNode"}) do
			removeNodeFromGrowthList(node)
			node.destroy{raise_destroy = true}
		end
	end
	-- Still do spillage for dying entities
	on_pre_mined(event)
end

script.on_event(defines.events.on_entity_died, on_entity_died)

-- Set modules in hidden beacons for Tiberium Control Network speed bonus
function ManageTCNBeacon(surface, position, force)
	for _, entity in pairs(surface.find_entities_filtered{name = TCN_affected_entities, position = position, force = force}) do
		if entity.valid then
			local hiddenBeacon = surface.find_entities_filtered{name = TCN_Beacon_Name, position = position}
			local tcnCount = surface.count_entities_filtered{area = areaAroundPosition(position, TiberiumRadius * 0.5 + 1), name = "tiberium-beacon-node"}
			if tcnCount >= 1 then
				if next(hiddenBeacon) then
					TCNModules(hiddenBeacon[1], tcnCount)
				else
					local newHiddenBeacon = surface.create_entity{name = TCN_Beacon_Name, position = position, force = force}
					newHiddenBeacon.destructible = false
					newHiddenBeacon.minable = false
					TCNModules(newHiddenBeacon, tcnCount)
				end
			elseif tcnCount == 0 then
				for _, beacon in pairs(hiddenBeacon) do
					beacon.destroy()
				end
			end
		end
	end
end

function TCNModules(beacon, tcnCount)
	if beacon.valid then
		if not tcnCount then
			local tcnAOE = areaAroundPosition(beacon.position, TiberiumRadius * 0.5	+ 1)
			tcnCount = beacon.surface.count_entities_filtered{area = tcnAOE, name = "tiberium-beacon-node"}
		end
		local tcnMulti = math.min(tcnCount, 3)
		local force = beacon.force
		local module_count = (upgradeLevel(force, "tiberium-control-network-speed") + 6) * tcnMulti
		UpdateBeaconSpeed(beacon, module_count)
	end
end

-- Set modules in hidden beacons for TCN and Growth Accelerator speed bonus
function UpdateBeaconSpeed(beacon, total_modules)
	local module_inventory = beacon.get_module_inventory()
	if module_inventory then
		local added_modules = total_modules - module_inventory.get_item_count(Speed_Module_Name)
		if added_modules >= 1 then
			module_inventory.insert{name = Speed_Module_Name, count = added_modules}
		elseif added_modules <= -1 then
			module_inventory.remove{name = Speed_Module_Name, count = math.abs(added_modules)}
		end
	end
end

script.on_event({defines.events.on_technology_effects_reset, defines.events.on_forces_merged, defines.events.on_force_reset}, function(event)
	updateBeacons(event.force or event.destination)
	updateResistanceLevel(event.force or event.destination)
end)

script.on_event({defines.events.on_research_finished, defines.events.on_research_reversed}, function(event)
	local tech = event.research
	updateBeacons(tech.force)
	updateResistanceLevel(tech.force)
	if string.sub(tech.name, 1, 9) == "tiberium-" and tech.researched then
		table.insert(storage.technologyTimes[tech.force.name], {tech.name, math.floor(game.tick / 3600)})
	end
end)

function updateResistanceLevel(force)
	local level = upgradeLevel(force, "tiberium-military")
	if level >= 3 then
		storage.tiberiumDamageTakenMulti[force.name] = 0
	elseif level >= 1 then
		storage.tiberiumDamageTakenMulti[force.name] = 0.25
	else
		storage.tiberiumDamageTakenMulti[force.name] = 1
	end
end

function upgradeLevel(force, techName)
	local best = 0
	if not (force and force.valid and techName) then return best end

	while true do
		local upgrade = force.technologies[techName.."-"..(best + 1)] or ((best == 0) and force.technologies[techName])
		if not upgrade then
			return best
		end
		if upgrade.researched then
			best = upgrade.prototype.max_level
		else
			return upgrade.level - 1
		end
	end
end

function updateBeacons(force)
	if force and force.get_entity_count(GA_Beacon_Name) > 0 then -- only update when beacons exist for force
		local module_count = upgradeLevel(force, "tiberium-growth-acceleration-acceleration")
		for _, surface in pairs(game.surfaces) do
			for _, beacon in pairs(surface.find_entities_filtered{name = GA_Beacon_Name, force = force}) do
				UpdateBeaconSpeed(beacon, module_count)
			end
		end
	end
	if force and force.get_entity_count(TCN_Beacon_Name) > 0 then -- only update when beacons exist for force
		for _, surface in pairs(game.surfaces) do
			for _, beacon in pairs(surface.find_entities_filtered{name = TCN_Beacon_Name, force = force}) do
				TCNModules(beacon)
			end
		end
	end
end

script.on_event(defines.events.on_rocket_launched, function(event)
	if not storage.rocketTime then
		storage.rocketTime = math.floor(event.tick / 3600)
	end
end)

script.on_event(defines.events.on_force_created, function(event)
	initializeForce(event.force)
end)

script.on_event(defines.events.on_player_created, function(event)
	local player = game.players[event.player_index]
	if settings.startup["tiberium-advanced-start"].value or settings.startup["tiberium-ore-removal"].value then
		if not remote.interfaces["freeplay"] then
			for name, count in pairs(tiberium_start) do
				player.insert{name = name, count = count}
			end
		end
		if burnerTier then
			UnlockTechnologyAndPrereqs(player.force, "tiberium-ore-centrifuging")
			UnlockRecipePrereqs(player.force, "tiberium-centrifuge-0")
		else
			UnlockTechnologyAndPrereqs(player.force, "tiberium-mechanical-research")
			UnlockTechnologyAndPrereqs(player.force, "tiberium-slurry-centrifuging")
		end
		if easyMode then
			UnlockTechnologyAndPrereqs(player.force, "tiberium-easy-transmutation-tech")
		end
	end
	-- Optional Informatron reminder
	if player and player.connected and not script.active_mods["informatron"] then
		player.print({"tiberium-strings.informatron-reminder"})
	end
end)

function UnlockTechnologyAndPrereqs(force, techName)
	if not force.technologies[techName].researched then
		force.technologies[techName].researched = true
		for techPrereq in pairs(prototypes.technology[techName].prerequisites) do
			UnlockTechnologyAndPrereqs(force, techPrereq)
		end
	end
end

function TechPrereqList(force, techName)
	local techList = {}
	if not force.technologies[techName].researched then
		techList[techName] = true
		for techPrereq in pairs(prototypes.technology[techName].prerequisites) do
			for k,v in pairs(TechPrereqList(force, techPrereq)) do
				techList[k] = v
			end
		end
	end
	return techList
end

function FindRecipeTech(force, recipeName)
	for techName, tech in pairs(force.technologies) do
		for _, effect in pairs(tech.effects) do
			if effect.type == "unlock-recipe" and effect.recipe == recipeName then
				return techName
			end
		end
	end
	return false
end

function UnlockRecipePrereqs(force, recipeName)
	if not force or not force.valid then return end
	if not force.recipes[recipeName] then return end
	local ingredientTechs = {}
	for _, ingredient in pairs(force.recipes[recipeName].ingredients) do
		ingredientTechs[ingredient.name] = {}
	end
	for recipeName, recipe in pairs(force.recipes) do
		for _, product in pairs(recipe.products) do
			if ingredientTechs[product.name] then
				-- I'm not bothering with checking all structures' crafting categories but this should work most of the time
				if recipe.enabled and (recipe.category == "crafting" or recipe.category == "smelting") and not recipe.hidden then
					ingredientTechs[product.name] = nil
				else
					local tech = FindRecipeTech(force, recipeName)
					if tech then
						table.insert(ingredientTechs[product.name], tech)
					end
				end
			end
		end
	end
	for ingredient, techs in pairs(ingredientTechs) do
		local best = math.huge
		local unlockTech = nil
		for _, tech in pairs(techs) do
			local score = flib_table.size(TechPrereqList(force, tech))
			game.print(tech.." requires "..tostring(score).." prereqs to provide us with "..ingredient)
			if score < best then
				best = score
				unlockTech = tech
			end
		end
		if unlockTech then
			UnlockTechnologyAndPrereqs(force, unlockTech)
		end
		if debugText then game.print("Unlocking "..tostring(best).." technologies to allow access to "..tostring(ingredient)) end
	end
end

-- script.on_event(defines.events.on_marked_for_deconstruction , function(event) -- Something for autodeconstruct that doesn't fully work
-- 	if script.active_mods["AutoDeconstruct"] and not event.player_index then
-- 		if (event.entity.prototype.type == "mining-drill") and event.entity.prototype.resource_categories and event.entity.prototype.resource_categories["basic-solid-tiberium"] then
-- 			if event.entity.surface.count_entities_filtered({position=event.entity.position, radius=TiberiumRadius + event.entity.prototype.mining_drill_radius, name="tibGrowthNode"}) then
-- 				event.entity.cancel_deconstruction(event.entity.force)
-- 			end
-- 		end
-- 	end
-- end)
