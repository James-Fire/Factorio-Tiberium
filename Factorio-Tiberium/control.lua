-- Change when uploading to main/beta version, no underscores for this one
tiberiumInternalName = "Factorio-Tiberium-Beta"

local migration = require("__flib__.migration")
require("scripts/CnC_Walls") --Note, to make SonicWalls work / be passable
require("scripts/informatron/informatron_remote_interface")

local GA_Beacon_Name = "tiberium-growth-accelerator-beacon"
local Speed_Module_Name = "tiberium-growth-accelerator-speed-module"
local TCN_Beacon_Name = "TCN-beacon"
local TCN_affected_entities = {"tiberium-aoe-node-harvester", "tiberium-spike", "tiberium-node-harvester", "tiberium-network-node"}
local tiberiumNodeNames = {"tibGrowthNode", "tibGrowthNode_infinite"}

local TiberiumDamage = settings.startup["tiberium-damage"].value
local TiberiumGrowth = settings.startup["tiberium-growth"].value * 10
local TiberiumMaxPerTile = settings.startup["tiberium-growth"].value * 100 --Force 10:1 ratio with growth
local TiberiumRadius = 20 + settings.startup["tiberium-spread"].value * 0.4 --Translates to 20-60 range
local TiberiumSpread = settings.startup["tiberium-spread"].value
local bitersImmune = settings.startup["tiberium-wont-damage-biters"].value
local ItemDamageScale = settings.global["tiberium-item-damage-scale"].value
local debugText = settings.startup["tiberium-debug-text"].value
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

script.on_init(function()
	register_with_picker()
	global.tibGrowthNodeListIndex = 0
	global.tibGrowthNodeList = {}
	global.tibMineNodeListIndex = 0
	global.tibMineNodeList = {}
	global.tibDrills = {}
	global.tibSonicEmitters = {}
	global.tibOnEntityDestroyed = {}

	-- Each node should spawn tiberium once every 5 minutes (give or take a handful of ticks rounded when dividing)
	-- Currently allowing this to potentially update every tick but to keep things under control minUpdateInterval
	-- can be set to something greater than 1. When minUpdateInterval is reached the global tiberium growth rate
	-- will stagnate instead of increasing with each new node found but updates will continue to happen for all fields.
	global.minUpdateInterval = 1
	global.intervalBetweenNodeUpdates = 18000
	global.tibPerformanceMultiplier = 1
	global.tiberiumTerrain = nil --"dirt-4" --Performance is awful, disabling this
	global.wildBlue = false
	global.oreTypes = {"tiberium-ore", "tiberium-ore-blue"}
	global.tiberiumProducts = global.oreTypes
	global.damageForceName = "tiberium"
	if not game.forces[global.damageForceName] then
		game.create_force(global.damageForceName)
	end

	global.exemptDamagePrototypes = {  -- List of prototypes that should not be damaged by growing Tiberium
		["mining-drill"] = true,
		["transport-belt"] = true,
		["underground-belt"] = true,
		["splitter"] = true,
		["wall"] = true,
		["pipe"] = true,
		["pipe-to-ground"] = true,
		["electric-pole"] = true,
		["inserter"] = true,
		["straight-rail"] = true,
		["curved-rail"] = true,
		["rail-chain-signal"] = true,
		["rail-signal"] = true,
		["unit-spawner"] = true,  --Biters immune until both performance and evo factor are fixed
		["turret"] = true
	}
	global.exemptDamageNames = {
		["mining-depot"] = true,
	}
	for i = 1,100 do 
		global.exemptDamageNames["tiberium-oremining-drone"..i] = true
	end

	global.tiberiumDamageTakenMulti = {}
	for _, force in pairs(game.forces) do
		global.tiberiumDamageTakenMulti[force.name] = 1
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
	CnC_SonicWall_OnInit(event)
	
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
	local performanceInterval = math.max(global.tibPerformanceMultiplier / 10, 1)  -- For performance multis over 10, space out the growth ticks more
	global.intervalBetweenNodeUpdates = math.max(math.floor(18000 * performanceInterval / (#global.tibGrowthNodeList or 1)), global.minUpdateInterval)
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
	if upgradingToVersion(data, tiberiumInternalName, "1.0.0") then
		game.print("Successfully ran conversion for "..tiberiumInternalName.." version 1.0.0")
		for _, surface in pairs(game.surfaces) do
			-- Registering entities for the base 0.18.28 change
			for _, entity in pairs(surface.find_entities_filtered{type = "mining-drill"}) do
				script.register_on_entity_destroyed(entity)
			end
			for _, entity in pairs(surface.find_entities_filtered{name = {"tiberium-srf-emitter", "tiberium-spike"}}) do
				script.register_on_entity_destroyed(entity)
			end
			-- Place Blossom trees on all the now bare nodes.
			for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
				createBlossomTree(surface, node.position)
			end
			-- Add invisible beacons for new growth accelerator speed researches
			for _, beacon in pairs(surface.find_entities_filtered{name = GA_Beacon_Name}) do
				beacon.destroy()
			end
			for _, accelerator in pairs(surface.find_entities_filtered{name = "tiberium-growth-accelerator"}) do
				local beacon = accelerator.surface.create_entity{name = GA_Beacon_Name, position = accelerator.position, force = accelerator.force}
				beacon.destructible = false
				beacon.minable = false
				local module_count = accelerator.force.technologies["tiberium-growth-acceleration-acceleration"].level - 1
				UpdateBeaconSpeed(beacon, module_count)
			end
		end
		-- Unlock technologies that were split
		for _, force in pairs(game.forces) do
			if force.technologies["tiberium-processing-tech"] and force.technologies["tiberium-processing-tech"].researched then
				force.technologies["tiberium-sludge-processing"].researched = true
			end
			if force.technologies["tiberium-power-tech"] and force.technologies["tiberium-power-tech"].researched then
				force.technologies["tiberium-sludge-recycling"].researched = true
			end
		end
	end
	
	if upgradingToVersion(data, tiberiumInternalName, "1.0.2") then
		if not global.tibOnEntityDestroyed then global.tibOnEntityDestroyed = {} end
		local entityNames = {"tiberium-srf-emitter", "tiberium-spike", "tiberium-growth-accelerator-node", "tiberium-growth-accelerator"}
		for _, surface in pairs(game.surfaces) do
			-- Registering entities correctly this time
			for _, entity in pairs(surface.find_entities_filtered{type = "mining-drill"}) do
				registerEntity(entity)
			end
			for _, entity in pairs(surface.find_entities_filtered{name = entityNames}) do
				registerEntity(entity)
			end
		end
		--Convert globals
		if not global.tibDrills then global.tibDrills = {} end
		for _, drill in pairs(global.drills or {}) do
			if drill.valid then
				table.insert(global.tibDrills, {entity = drill, name = drill.name, position = drill.position})
			end
		end
		global.drills = nil
		for _, charging in pairs(global.SRF_node_ticklist or {}) do
			charging.position = charging.emitter.position
		end
		for _, low in pairs(global.SRF_low_power_ticklist or {}) do
			low.position = low.emitter.position
		end
		local new_SRF_nodes = {}
		for _, node in pairs(global.SRF_nodes or {}) do
			local emitter = node.emitter or node  --Prevent issues when converting from Beta and changing versions
			table.insert(new_SRF_nodes, {emitter = emitter, position = emitter.position})
		end
		global.SRF_nodes = new_SRF_nodes
	end
	
	if upgradingToVersion(data, tiberiumInternalName, "1.0.5") then
		-- Define pack color for DiscoScience
		if remote.interfaces["DiscoScience"] and remote.interfaces["DiscoScience"]["setIngredientColor"] then
			remote.call("DiscoScience", "setIngredientColor", "tiberium-science", {r = 0.0, g = 1.0, b = 0.0})
		end
	end
	
	if upgradingToVersion(data, tiberiumInternalName, "1.0.7") then
		global.tiberiumProducts = {global.oreType}
	end
	
	if upgradingToVersion(data, tiberiumInternalName, "1.0.9") then
		local treeBlockers = {"tibNode_tree", "tiberium-node-harvester", "tiberium-growth-accelerator"}
		for _, surface in pairs(game.surfaces) do
			-- Destroy Blossom Trees with no nodes
			for _, blossom in pairs(surface.find_entities_filtered{name = "tibNode_tree"}) do
				if surface.count_entities_filtered{area = areaAroundPosition(blossom.position), name = "tibGrowthNode"} == 0 then
					if debugText then game.print("destroyed tree at x: "..blossom.position.x.." y: "..blossom.position.y) end
					blossom.destroy()
				end
			end
			-- Place Blossom Trees on all bare nodes
			for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
				if surface.count_entities_filtered{area = areaAroundPosition(node.position), name = treeBlockers} == 0 then
					createBlossomTree(surface, node.position)
					if debugText then game.print("created tree at x: "..node.position.x.." y: "..node.position.y) end
				end
			end
		end
	end
	
	if upgradingToVersion(data, tiberiumInternalName, "1.1.0") then
		if not global.tiberiumDamageTakenMulti then
			global.tiberiumDamageTakenMulti = {}
			for _, force in pairs(game.forces) do
				global.tiberiumDamageTakenMulti[force.name] = 1
			end
		end
		for _, force in pairs(game.forces) do
			if force.technologies["tiberium-military-3"].researched then
				global.tiberiumDamageTakenMulti[force.name] = 0
			elseif force.technologies["tiberium-military-1"].researched then
				global.tiberiumDamageTakenMulti[force.name] = 0.2
			end
		end
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.1") then
		for _, surface in pairs(game.surfaces) do
			-- Add connectors to existing SRF Emitters
			for _, emitter in pairs(surface.find_entities_filtered{name = "tiberium-srf-emitter"}) do
				if surface.count_entities_filtered{position = emitter.position, name = "tiberium-srf-connector"} == 0 then
					surface.create_entity{
						name = "tiberium-srf-connector",
						position = emitter.position,
						force = emitter.force
					}
				end
			end
		end
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.2") then
		-- Unlock technologies that were split
		for _, force in pairs(game.forces) do
			if force.technologies["tiberium-control-network-tech"].researched then
				force.technologies["tiberium-advanced-containment-tech"].researched = true
			end
			if force.technologies["tiberium-chemical-research"].researched then
				force.technologies["tiberium-advanced-molten-processing"].researched = true
			end
			--Disable deprecated recipes
			if force.recipes["tiberium-armor"].enabled then
				force.recipes["tiberium-armor"].enabled = false
			end
			if force.recipes["tiberium-power-armor"].enabled then
				force.recipes["tiberium-power-armor"].enabled = false
			end
			UpdateRecipeUnlocks(force)
		end
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.13") then
		for _, surface in pairs(game.surfaces) do
			-- Register Growth Nodes for deletion detection
			for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
				registerEntity(node)
			end
		end
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.15") then
		global.tibPerformanceMultiplier = 1
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.16") then
		-- Changed global name
		global.exemptDamagePrototypes = {
			["mining-drill"] = true,
			["transport-belt"] = true,
			["underground-belt"] = true,
			["splitter"] = true,
			["wall"] = true,
			["pipe"] = true,
			["pipe-to-ground"] = true,
			["electric-pole"] = true,
			["inserter"] = true,
			["straight-rail"] = true,
			["curved-rail"] = true,
			["rail-chain-signal"] = true,
			["rail-signal"] = true,
			["unit-spawner"] = true,
			["turret"] = true
		}
		-- New global
		global.exemptDamageNames = {
			["mining-depot"] = true,
		}
		for i = 1,100 do 
			global.exemptDamageNames["tiberium-oremining-drone"..i] = true
		end
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.17") then
		for _, surface in pairs(game.surfaces) do
			-- Make existing Blossom Trees indestructible
			for _, blossomTree in pairs(surface.find_entities_filtered{name = "tibNode_tree"}) do
				blossomTree.destructible = false
			end
		end
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.18") then
		for _, surface in pairs(game.surfaces) do
			-- Register nodes that were missed
			for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
				local needToRegister = true
				for _, registeredEntity in pairs(global.tibOnEntityDestroyed) do
					if table.compare(node.position, registeredEntity.position) and (node.name == registeredEntity.name) then
						needToRegister = false
						break
					end
				end
				if needToRegister then
					registerEntity(node)
				end
			end
			-- Clean up trees that weren't properly removed by the script
			for _, blossomTree in pairs(surface.find_entities_filtered{name = "tibNode_tree"}) do
				if surface.count_entities_filtered{name = "tibGrowthNode", position = blossomTree.position} == 0 then
					blossomTree.destroy()
				end
			end
		end
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.19") then
		global.oreTypes = {"tiberium-ore", "tiberium-ore-blue"}
		global.tiberiumProducts = global.oreTypes
		global.tibSonicEmitters = {}
		for _, force in pairs(game.forces) do
			if force.technologies["tiberium-control-network-tech"] and force.technologies["tiberium-control-network-tech"].researched then
				force.technologies["tiberium-mutation"].researched = true
			end
		end
	end

	if upgradingToVersion(data, tiberiumInternalName, "1.1.20") then
		global.wildBlue = false
	end

	if (data["mod_changes"]["Factorio-Tiberium"] and data["mod_changes"]["Factorio-Tiberium"]["new_version"]) and
			(data["mod_changes"]["Factorio-Tiberium-Beta"] and data["mod_changes"]["Factorio-Tiberium-Beta"]["old_version"]) then
		game.print("[Factorio-Tiberium] Successfully converted save from Beta Tiberium mod to Main Tiberium mod")
		game.print("> Found " .. #global.tibGrowthNodeList .. " nodes")
		game.print("> Found " .. #global.SRF_nodes .. " SRF hubs")
		game.print("> Found " .. #global.tibDrills .. " drills")
	end
end)

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

function AddOre(surface, position, growthRate, oreName)
	if not oreName then
		local evo = game.forces.enemy.evolution_factor
		if evo > 0.4 and (math.random() < 0.03 * (evo - 0.4) ^ 2) then  -- Random <1% chance to spawn Blue Tiberium at high evolution factors
			oreName = "tiberium-ore-blue"
			if not global.wildBlue then
				global.wildBlue = true
				TiberiumSeedMissile(surface, position, 4 * TiberiumMaxPerTile, oreName)
				game.print("The first wild mutation of [img=item.tiberium-ore-blue] Blue Tiberium has occurred at [gps="..math.floor(position.x)..","..math.floor(position.y).."]")
				return false  -- We'll just say that this event can't spawn 
			end
		elseif surface.count_entities_filtered{area = areaAroundPosition(position, 1), name = "tiberium-ore-blue"} > 0 then  -- Blue will infect neighbors
			oreName = "tiberium-ore-blue"
		else
			oreName = "tiberium-ore"
		end
	end
	local area = areaAroundPosition(position)
	local oreEntity = surface.find_entities_filtered{area = area, name = global.oreTypes}[1]
	local tile = surface.get_tile(position)
	growthRate = math.min(growthRate, TiberiumMaxPerTile)

	if oreEntity and (oreEntity.name == oreName or oreEntity.name == "tiberium-blue-ore") then
		-- Grow existing tib except for the case where blue needs to replace green instead of growing it
		if oreEntity.amount < TiberiumMaxPerTile then --Don't reduce ore amount when growing node
			oreEntity.amount = math.min(oreEntity.amount + growthRate, TiberiumMaxPerTile)
		end
	elseif surface.count_entities_filtered{area = area, name = tiberiumNodeNames} > 0 then
		return false --Don't place ore on top of nodes
	elseif tile.collides_with("resource-layer") then
		return false  -- Don't place on invalid tiles
	else
		--Tiberium destroys all other non-Tiberium resources as it spreads
		local otherResources = surface.find_entities_filtered{area = area, type = "resource"}
		for _, entity in pairs(otherResources) do
			if (entity.name ~= oreName) and (entity.name ~= "tibGrowthNode") and (entity.name ~= "tibGrowthNode_infinite") then
				if entity.amount and entity.amount > 0 then
					if LSlib.utils.table.hasValue(global.oreTypes, entity.name) then
						growthRate = math.min(growthRate + entity.amount, TiberiumMaxPerTile)
					else
						growthRate = math.min(growthRate + (0.5 * entity.amount), TiberiumMaxPerTile)
					end
				end
				entity.destroy()
			end
		end
		if (surface.count_entities_filtered{area = area, type = "tree"} > 0)
				and (surface.count_entities_filtered{position = position, radius = TiberiumRadius * 0.8, name = tiberiumNodeNames} == 0)
				and (math.random() < (TiberiumSpread / 100) ^ 4) then  -- Around 1% chance to turn a tree into a Blossom Tree
			CreateNode(surface, position)
		else
			oreEntity = surface.create_entity{name = oreName, amount = growthRate, position = position, enable_cliff_removal = false}
			if global.tiberiumTerrain then
				surface.set_tiles({{name = global.tiberiumTerrain, position = position}}, true, false)
			end
			surface.destroy_decoratives{position = position} --Remove decoration on tile on spread.
		end
	end
	
	--Damage adjacent entities unless it's in the list of exemptDamagePrototypes
	for _, entity in pairs(surface.find_entities(area)) do
		if entity.valid and not global.exemptDamagePrototypes[entity.type] and not global.exemptDamageNames[entity.name] then
			if entity.type == "tree" then
				safeDamage(entity, 9999)
			else
				safeDamage(entity, TiberiumDamage)
			end
		end
	end

	return oreEntity
end

function CheckPoint(surface, position, lastValidPosition, growthRate)
	-- These checks are in roughly the order of guessed expense
	local tile = surface.get_tile(position)
	
	if not tile or not tile.valid then
		AddOre(surface, lastValidPosition, growthRate)
		return true
	end
	
	if tile.collides_with("resource-layer") then
		AddOre(surface, lastValidPosition, growthRate)
		return true  --Hit edge of water, add to previous ore
	end

	local area = areaAroundPosition(position)
	local entitiesBlockTiberium = {"tiberium-srf-wall", "cliff", "tibGrowthNode_infinite"}
	if surface.count_entities_filtered{area = area, name = entitiesBlockTiberium} > 0 then
		AddOre(surface, lastValidPosition, growthRate * 0.5)  --50% lost
		return true  --Hit fence or cliff or spiked node, add to previous ore
	end
	
	local emitterHubs = surface.find_entities_filtered{area = area, name = "tiberium-srf-emitter"}
	for _, emitter in pairs(emitterHubs) do
		if emitter.valid then
			local emitterPowered = true
			for _, entry in pairs(global.SRF_node_ticklist or {}) do
				if emitter == entry.emitter then
					emitterPowered = false  -- Exclude nodes that haven't charged
					break
				end
			end
			if emitterPowered then  -- Only block if the SRF is powered
				AddOre(surface, lastValidPosition, growthRate * 0.5)  --50% lost
				return true  --Hit powered SRF emitter hub
			end
		end
	end
	
	if surface.count_entities_filtered{area = area, name = "tibGrowthNode"} > 0 then
		return false  --Don't grow on top of active node, keep going
	end
	
	if surface.count_entities_filtered{area = area, name = global.oreTypes} == 0 then
		AddOre(surface, position, growthRate)
		return true  --Reached edge of patch, place new ore
	else
		return false  --Not at edge of patch, keep going
	end
end

function PlaceOre(entity, howmany)
	--local timer = game.create_profiler()

	if not entity.valid then return end
	
	howmany = howmany or 1
	local surface = entity.surface
	local position = entity.position

	-- Scale growth rate based on distance from spawn
	local growthRate = TiberiumGrowth * global.tibPerformanceMultiplier * math.max(1, TiberiumSpread / 50)
			* math.max(1, math.sqrt(math.abs(position.x) + math.abs(position.y)) / 20)
	-- Scale size based on distance from spawn, separate from density in case we end up wanting them to scale differently
	local size = TiberiumRadius * math.max(1, math.sqrt(math.abs(position.x) + math.abs(position.y)) / 30)

	local accelerator = surface.find_entity("tiberium-growth-accelerator", position)
	if accelerator then
		-- Divide by tibPerformanceMultiplier to keep ore per credit constant
		local extraAcceleratorOre = math.floor(accelerator.products_finished / global.tibPerformanceMultiplier)
		if extraAcceleratorOre > 0 then
			howmany = howmany + extraAcceleratorOre
			surface.create_entity{
				name = "tiberium-growth-accelerator-text",
				position = {x = position.x - 1.5, y = position.y - 1},
				text = "Grew "..math.floor(extraAcceleratorOre * growthRate).." extra ore",
				color = {r = 0, g = 204, b = 255},
			}
			-- Only subtract for the whole ore increments that were used
			accelerator.products_finished = math.fmod(accelerator.products_finished, global.tibPerformanceMultiplier)
		end
	end
	
	-- Spill excess growth amounts into extra ore tiles
	if growthRate > TiberiumMaxPerTile then
		howmany = math.floor(howmany * growthRate / TiberiumMaxPerTile)
	end

	for n = 1, howmany do
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
			placedOre = CheckPoint(surface, newPosition, lastValidPosition, growthRate)
			lastValidPosition = newPosition
			step = step - 1
		until placedOre or (step < 0)

		--Walked all the way to the end of the line, placing ore at the last valid position
		if not placedOre then
			local oreEntity = AddOre(surface, lastValidPosition, growthRate)
			--Spread setting makes spawning new nodes more likely
			if oreEntity and (TiberiumSpread > 0) and (math.random() < ((oreEntity.amount / TiberiumMaxPerTile) + (TiberiumSpread / 50 - 0.9))) then
				if (surface.count_entities_filtered{position = lastValidPosition, radius = TiberiumRadius * 0.8, name = tiberiumNodeNames} == 0) then
					CreateNode(surface, lastValidPosition)  --Use standard function to also remove overlapping ore
				end
			end
		end
	end

	-- Tell all mining drills to wake up
	for i, drill in pairs(global.tibDrills) do
		if drill.entity and drill.entity.valid then
			drill.entity.active = false
			drill.entity.active = true
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

function CreateNode(surface, position)
	local area = areaAroundPosition(position, 0.9)
	-- Avoid overlapping with other nodes
	if surface.count_entities_filtered{area = area, name = tiberiumNodeNames} == 0 then
		-- Check if another entity would block the node
		local blocked = false
		for _, entity in pairs(surface.find_entities_filtered{area = area, collision_mask = {"object-layer"}}) do
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
		if global.tiberiumTerrain then
			local newTiles = {}
			local oldTiles = surface.find_tiles_filtered{area = area, collision_mask = "ground-tile"}
			for i, tile in pairs(oldTiles) do
				newTiles[i] = {name = global.tiberiumTerrain, position = tile.position}
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
						AddOre(surface, placePos, intensity, oreName)
					end
				end
			end
		end
	end
	local center = {x = math.floor(position.x) + 0.5, y = math.floor(position.y) + 0.5}
	local oreEntity = surface.find_entity(oreName, center)
	if oreEntity and (oreEntity.amount >= TiberiumMaxPerTile) then
		CreateNode(surface, center)
	end
end

function TiberiumDestructionMissile(surface, position, radius, names)
	for _, ore in pairs(surface.find_entities_filtered{position = position, radius = radius, name = names}) do
		ore.destroy()
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
	elseif event.effect_id == "ore-destruction-blue-small" then
		TiberiumDestructionMissile(game.surfaces[event.surface_index], event.target_position, 5, "tiberium-ore-blue")
	elseif event.effect_id == "ore-destruction-blue-large" then
		TiberiumDestructionMissile(game.surfaces[event.surface_index], event.target_position, 12, "tiberium-ore-blue")
	elseif event.effect_id == "ore-destruction-all-small" then
		TiberiumDestructionMissile(game.surfaces[event.surface_index], event.target_position, 5, {"tiberium-ore", "tiberium-ore-blue"})
	elseif event.effect_id == "ore-destruction-all-large" then
		TiberiumDestructionMissile(game.surfaces[event.surface_index], event.target_position, 12, {"tiberium-ore", "tiberium-ore-blue"})
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
		game.player.print("There are " .. #global.tibGrowthNodeList .. " nodes in the list")
		for i = 1, #global.tibGrowthNodeList do
			if global.tibGrowthNodeList[i].valid then
				game.player.print("#"..i.." x:" .. global.tibGrowthNodeList[i].position.x .. " y:" .. global.tibGrowthNodeList[i].position.y)
			else
				game.player.print("Invalid node in global at position #"..i)
			end
		end
	end
)
commands.add_command("tibRebuildLists",
	"Update lists of mining drills and Tiberium nodes",
	function()
		global.tibGrowthNodeList = {}
		global.tibMineNodeList = {}
		global.SRF_nodes = {}
		global.tibDrills = {}
		global.tibSonicEmitter = {}
		for _, surface in pairs(game.surfaces) do
			for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
				addNodeToGrowthList(node)
			end
			for _, srf in pairs(surface.find_entities_filtered{name = "tiberium-srf-emitter"}) do
				table.insert(global.SRF_nodes, {emitter = srf, position = srf.position})
			end
			for _, drill in pairs(surface.find_entities_filtered{type = "mining-drill"}) do
				table.insert(global.tibDrills, {entity = drill, name = drill.name, position = drill.position})
			end
			for _, sonic in pairs(surface.find_entities_filtered{name = "tiberium-sonic-emitter"}) do
				table.insert(global.tibSonicEmitter, sonic.position)
			end
		end
		game.player.print("Found " .. #global.tibGrowthNodeList .. " nodes")
		game.player.print("Found " .. #global.SRF_nodes .. " SRF hubs")
		game.player.print("Found " .. #global.tibDrills .. " drills")
		game.player.print("Found " .. #global.tibSonicEmitter .. " drills")
	end
)
commands.add_command("tibGrowAllNodes",
	"Forces multiple immediate Tiberium ore growth cycles at every node",
	function(invocationdata)
		local timer = game.create_profiler()
		local placements = tonumber(invocationdata["parameter"]) or math.ceil(300 / global.tibPerformanceMultiplier)
		game.player.print("There are " .. #global.tibGrowthNodeList .. " nodes in the list")
		for i = 1, #global.tibGrowthNodeList, 1 do
			if global.tibGrowthNodeList[i].valid then
				if debugText then
					game.player.print("Growing node x:" .. global.tibGrowthNodeList[i].position.x .. " y:" .. global.tibGrowthNodeList[i].position.y)
				end
				PlaceOre(global.tibGrowthNodeList[i], placements)
			end
		end
		if game.active_mods["Mining-Drones-Tiberium"] then
			remote.call("mining_drones", "rescan_all_depots")
		end
		game.player.print({"", timer, " end of tibGrowAllNodes"})
	end
)
commands.add_command("tibDeleteOre",
	"Deletes all the Tiberium ore on the map. May take a long time on maps with large amounts of Tiberium. Parameter is the max number of entity updates (10,000 by default)",
	function(invocationdata)
		local oreLimit = tonumber(invocationdata["parameter"]) or 10000
		for _, surface in pairs(game.surfaces) do
			local deletedOre = 0
			for _, ore in pairs(surface.find_entities_filtered{name = global.oreTypes}) do
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
				if tile.collides_with("resource-layer") then
					removeBlossomTree(surface, node.position)
					removeNodeFromGrowthList(node)
					node.destroy()
				end
			end
		end
	end
)
commands.add_command("tibChangeTerrain",
	"Changes terrain under Tiberium growths, can use internal name of any tile. Awful performance",
	function(invocationdata)
		local terrain = invocationdata["parameter"] or "dirt-4"
		--if not terrain then game.print("Not a valid tile name: "..terrain) break end
		global.tiberiumTerrain = terrain
		--Ore
		for _, surface in pairs(game.surfaces) do
			for _, ore in pairs(surface.find_entities_filtered{name = global.oreTypes}) do
				ore.surface.set_tiles({{name = terrain, position = ore.position}}, true, false)
			end
		end
		--Nodes
		for _, node in pairs(global.tibGrowthNodeList) do
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
)
commands.add_command("tibPerformanceMultiplier",
	"Reduces the number of updates made by Tiberium growth at the cost of Tiberium fields being uglier. Set the parameter to 1 to return to default growth behavior.",
	function(invocationdata)
		local multi = tonumber(invocationdata["parameter"]) or 10
		global.tibPerformanceMultiplier = math.max(multi, 1)  -- Don't let them put the multiplier below 1
		updateGrowthInterval()
		game.player.print("Performance multiplier set to "..global.tibPerformanceMultiplier)
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
		if global.tiberiumTerrain then
			local newTiles = {}
			local oldTiles = surface.find_tiles_filtered{area = tileArea, collision_mask = "ground-tile"}
			for i, tile in pairs(oldTiles) do
				newTiles[i] = {name = global.tiberiumTerrain, position = tile.position}
			end
			surface.set_tiles(newTiles, true, false)
		end
	end
end)

script.on_event(defines.events.on_tick, function(event)
	-- Update SRF Walls
	CnC_SonicWall_OnTick(event)
	-- Sonic Emitters
	for i, location in pairs(global.tibSonicEmitters) do
		if i % 60 == event.tick % 60 then
			local emitter = location.surface.find_entities_filtered{name = {"tiberium-sonic-emitter", "tiberium-sonic-emitter-blue"}, position = location.position}[1]
			if emitter and emitter.energy >= emitter.electric_buffer_size then
				local targetOres = (emitter.name == "tiberium-sonic-emitter-blue") and "tiberium-ore-blue" or global.oreTypes
				local ore = location.surface.find_entities_filtered{name = targetOres, position = location.position, radius = 12}
				if #ore > 0 then
					local targetOre = ore[math.random(1, #ore)]
					local dummy = location.surface.create_entity{name ="tiberium-target-dummy", position = targetOre.position}
					location.surface.create_entity{name = "tiberium-sonic-emitter-projectile", position = location.position, speed = 0.2, target = dummy}
					dummy.destroy()
					emitter.energy = 0
				end
			end
		end
	end
			
	-- Spawn ore check
	if (event.tick % global.intervalBetweenNodeUpdates == 0) then
		-- Step through the list of growth nodes, one each update
		local tibGrowthNodeCount = #global.tibGrowthNodeList
		global.tibGrowthNodeListIndex = global.tibGrowthNodeListIndex + 1
		if (global.tibGrowthNodeListIndex > tibGrowthNodeCount) then
			global.tibGrowthNodeListIndex = 1
		end
		if tibGrowthNodeCount >= 1 then
			local node = global.tibGrowthNodeList[global.tibGrowthNodeListIndex]
			if node.valid then
				local oreCount = math.max(math.floor(10 / global.tibPerformanceMultiplier), 1)
				PlaceOre(node, oreCount)
				local position = node.position
				local surface = node.surface
				local treeBlockers = {"tibNode_tree", "tiberium-node-harvester", "tiberium-spike", "tiberium-growth-accelerator"}
				if surface.count_entities_filtered{area = areaAroundPosition(position), name = treeBlockers} == 0 then
					createBlossomTree(surface, position)
				end
				if game.active_mods["Mining-Drones-Tiberium"] then
					remote.call("mining_drones", "rescan_all_depots")
				end
			else
				removeNodeFromGrowthList(node)
			end
		end
	end
	if not bitersImmune then
		local i = (event.tick % 60) + 1  --Loop through 1/60th of the nodes every tick
		while i <= #global.tibGrowthNodeList do
			local node = global.tibGrowthNodeList[i]
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

script.on_nth_tick(10, function(event) --Player damage 6 times per second
	for _, player in pairs(game.connected_players) do
		if player.valid and player.character and player.character.valid then
			--MARV ore deletion
			if player.vehicle and (player.vehicle.name == "tiberium-marv") and (player.vehicle.get_driver() == player.character) then
				for _, oreName in pairs(global.oreTypes) do
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
			local nearby_ore_count = player.surface.count_entities_filtered{name = global.oreTypes, position = player.position, radius = 1.5}
			if nearby_ore_count > 0 and not player.character.vehicle and player.character.name ~= "jetpack-flying" then
				safeDamage(player, nearby_ore_count * TiberiumDamage * 0.1)
			end
			--Damage players with unsafe Tiberium products in their inventory
			local damagingItems = 0
			for _, inventory in pairs({player.get_inventory(defines.inventory.character_main), player.get_inventory(defines.inventory.character_trash)}) do
				if inventory and inventory.valid then
					for _, dangerousItem in pairs(global.tiberiumProducts) do
						damagingItems = damagingItems + inventory.get_item_count(dangerousItem)
					end
				end
			end
			if damagingItems > 0 then
				if ItemDamageScale then
					safeDamage(player, math.ceil(damagingItems / 50) * TiberiumDamage * 0.3)	
				else
					safeDamage(player, TiberiumDamage * 0.3)
				end
			end
		end
	end
end)

function safeDamage(entityOrPlayer, damageAmount)
	if not entityOrPlayer.valid then return end
	if damageAmount <= 0 then return end
	local entity = entityOrPlayer
	local damageMulti = 1
	if entityOrPlayer.is_player() then
		entity = entityOrPlayer.character  -- Need to damage character instead of player
		if entity and entity.valid then  -- Reduce/prevent growth damage for players with immunity technologies
			damageMulti = global.tiberiumDamageTakenMulti[entity.force.name] or 1
			if (damageMulti == 0) and not entity.grid then
				damageMulti = 0.2
			end
		else
			return
		end
	end
	
	if entity.valid and entity.health and entity.health > 0 and damageMulti > 0 then
		entity.damage(damageAmount * damageMulti, game.forces.tiberium, "tiberium")
	end
end

function addNodeToGrowthList(newNode)
	for _, node in pairs(global.tibGrowthNodeList) do
		if newNode == node then
			return false
		end
	end
	table.insert(global.tibGrowthNodeList, newNode)
	updateGrowthInterval()  -- Move call to here so we always update when node count changes
	return true
end

function removeNodeFromGrowthList(node)
	for i = 1, #global.tibGrowthNodeList do
		if global.tibGrowthNodeList[i] == node then
			table.remove(global.tibGrowthNodeList, i)
			updateGrowthInterval()  -- Move call to here so we always update when node count changes
			if global.tibGrowthNodeListIndex >= i then
				global.tibGrowthNodeListIndex = global.tibGrowthNodeListIndex - 1
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

script.on_nth_tick(60 * 300, function(event) --Global integrity check
	if event.tick == 0 then return end
	local nodeCount = 0
	for _, surface in pairs(game.surfaces) do
		nodeCount = nodeCount + surface.count_entities_filtered{name = "tibGrowthNode"}
	end
	if nodeCount ~= #global.tibGrowthNodeList then
		if debugText then
			game.print("!!!Warning: "..nodeCount.." Tiberium nodes exist while there are "..#global.tibGrowthNodeList.." nodes growing.")
			game.print("Rebuilding Tiberium node growth list.")
		end
		global.tibGrowthNodeList = {}
		for _, surface in pairs(game.surfaces) do
			for _, node in pairs(surface.find_entities_filtered{name = "tibGrowthNode"}) do
				addNodeToGrowthList(node)
			end
		end
	end
end)

script.on_event(defines.events.on_trigger_created_entity, function(event)
	CnC_SonicWall_OnTriggerCreatedEntity(event)
	if debugText and event.entity.valid and (event.entity.name == "tiberium-srf-wall-damage") then  --Checking when this is actually called
		game.print("SRF Wall damaged at "..event.entity.position.x..", "..event.entity.position.y)
	end
end)

function registerEntity(entity)  -- Cache relevant information to global and register
	local entityInfo = {}
	for _, property in pairs({"name", "type", "position", "surface", "force"}) do
		entityInfo[property] = entity[property]
	end
	local registration_number = script.register_on_entity_destroyed(entity)
	global.tibOnEntityDestroyed[registration_number] = entityInfo
end

function on_new_entity(event)
	local new_entity = event.created_entity or event.entity --Handle multiple event types
	local surface = new_entity.surface
	local position = new_entity.position
	local force = new_entity.force
	if (new_entity.type == "mining-drill") then
		registerEntity(new_entity)
		local duplicate = false
		for _, drill in pairs(global.tibDrills) do
			if drill.entity == new_entity then
				duplicate = true
				break
			end
		end
		if not duplicate then table.insert(global.tibDrills, {entity = new_entity, name = new_entity.name, position = position}) end
	end
	if (new_entity.name == "tiberium-srf-connector") then
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
		local tcnAOE = areaAroundPosition(position, TiberiumRadius * 0.5)
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
			local module_count = force.technologies["tiberium-growth-acceleration-acceleration"].level - 1
			UpdateBeaconSpeed(beacon, module_count)
		end
	elseif (new_entity.name == "tibGrowthNode") then
		registerEntity(new_entity)
		addNodeToGrowthList(new_entity)
		createBlossomTree(surface, position)
	elseif (new_entity.name == "tiberium-sonic-emitter") or (new_entity.name == "tiberium-sonic-emitter-blue") then
		registerEntity(new_entity)
		table.insert(global.tibSonicEmitters, {position = new_entity.position, surface = surface})
	end
end

script.on_event(defines.events.on_built_entity, on_new_entity)
script.on_event(defines.events.on_robot_built_entity, on_new_entity)
script.on_event(defines.events.script_raised_built, on_new_entity)
script.on_event(defines.events.script_raised_revive, on_new_entity)

function on_remove_entity(event)
	local entity = global.tibOnEntityDestroyed[event.registration_number]
	if not entity then return end
	local surface = entity.surface
	local position = entity.position
	local force = entity.force
	if (entity.type == "mining-drill") then
		for i, drill in pairs(global.tibDrills) do
			if table.compare(drill.position, position) and (drill.name == entity.name) then
				table.remove(global.tibDrills, i)
				break
			end
		end
	end
	if (entity.name == "tiberium-srf-emitter") or (entity.name == "CnC_SonicWall_Hub") then
		if surface and surface.valid then
			for _, connector in pairs(surface.find_entities_filtered{name = "tiberium-srf-connector", position = position}) do
				connector.destroy()
			end
		end
		CnC_SonicWall_DeleteNode(entity, event.tick)
	elseif (entity.name == "tiberium-beacon-node") then
		--Remove Beacon for Tiberium Control Network
		if surface and surface.valid then
			local tcnAOE = areaAroundPosition(position, TiberiumRadius * 0.5)
			for _, beacon in pairs(surface.find_entities_filtered{area = tcnAOE, name = TCN_Beacon_Name, force = force}) do
				ManageTCNBeacon(surface, beacon.position, force)
			end
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
	elseif (entity.name == "tibGrowthNode") then
		removeBlossomTree(surface, position)
		removeNodeFromGrowthList(entity)
	elseif (entity.name == "tiberium-sonic-emitter") or (entity.name == "tiberium-sonic-emitter-blue") then
		for i = 1, #global.tibSonicEmitters do
			if LSlib.utils.table.areEqual(global.tibSonicEmitters[i].position, entity.position) then
				table.remove(global.tibSonicEmitters, i)
				break
			end
		end
	end
	global.tibOnEntityDestroyed[event.registration_number] = nil  -- Avoid this global growing forever
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
		local blossomTree = surface.create_entity{
			name = "tibNode_tree",
			position = position,
			force = game.forces.neutral,
			raise_built = false
		}
		blossomTree.destructible = false
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

script.on_event(defines.events.on_entity_destroyed, on_remove_entity)

function on_pre_mined(event)
	local entity = event.entity
	if entity and entity.fluidbox then
		local rawTibOreEquivalent = 0
		local fluidContents = entity.get_fluid_contents()
		local oreValueMulti = 10 / settings.startup["tiberium-value"].value
		rawTibOreEquivalent = rawTibOreEquivalent + (fluidContents["tiberium-slurry"] or 0)
		rawTibOreEquivalent = rawTibOreEquivalent + 2 * (fluidContents["molten-tiberium"] or 0)
		rawTibOreEquivalent = rawTibOreEquivalent + 4 * (fluidContents["liquid-tiberium"] or 0)
		rawTibOreEquivalent = rawTibOreEquivalent * oreValueMulti
		if rawTibOreEquivalent > 0 then
			if debugText then game.print("Created "..tostring(rawTibOreEquivalent).." ore") end
			TiberiumSeedMissile(entity.surface, entity.position, rawTibOreEquivalent)
		end
	end
end

script.on_event(defines.events.on_pre_player_mined_item, on_pre_mined)
script.on_event(defines.events.on_robot_pre_mined, on_pre_mined)
script.on_event(defines.events.on_entity_died, on_pre_mined)

-- Set modules in hidden beacons for Tiberium Control Network speed bonus
function ManageTCNBeacon(surface, position, force)
	for _, entity in pairs(surface.find_entities_filtered{name = TCN_affected_entities, position = position, force = force}) do
		if entity.valid then
			local hiddenBeacon = surface.find_entities_filtered{name = TCN_Beacon_Name, position = position}
			local tcnCount = surface.count_entities_filtered{area = areaAroundPosition(position, TiberiumRadius * 0.5), name = "tiberium-beacon-node"}
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
			local tcnAOE = areaAroundPosition(beacon.position, TiberiumRadius * 0.5)
			tcnCount = beacon.surface.count_entities_filtered{area = tcnAOE, name = "tiberium-beacon-node"}
		end
		local tcnMulti = math.min(tcnCount, 3)
		local force = beacon.force
		local module_count = (force.technologies["tiberium-control-network-speed"].level + 5) * tcnMulti
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

function OnResearchFinished(event)
	-- TODO: delay execution when event.by_script == true
	local force = event.research.force
	if force and force.get_entity_count(GA_Beacon_Name) > 0 then -- only update when beacons exist for force
		local module_count = force.technologies["tiberium-growth-acceleration-acceleration"].level - 1
		for _, surface in pairs(game.surfaces) do
			local beacons = surface.find_entities_filtered{name = GA_Beacon_Name, force = force}
			for _, beacon in pairs(beacons) do
				UpdateBeaconSpeed(beacon, module_count)
			end
		end
	end
	if force and force.get_entity_count(TCN_Beacon_Name) > 0 then -- only update when beacons exist for force
		for _, surface in pairs(game.surfaces) do
			local beacons = surface.find_entities_filtered{name = TCN_Beacon_Name, force = force}
			for _, beacon in pairs(beacons) do
				TCNModules(beacon)
			end
		end
	end
	if event.research.name == "tiberium-military-1" then  --Caching this so we don't check it constantly
		global.tiberiumDamageTakenMulti[event.research.force.name] = 0.2
	elseif event.research.name == "tiberium-military-3" then
		global.tiberiumDamageTakenMulti[event.research.force.name] = 0
	end
end

script.on_event({defines.events.on_research_finished}, OnResearchFinished)

function OnForceReset(event)
	local force = event.force or event.destination
	if force and force.get_entity_count(GA_Beacon_Name) > 0 then -- only update when beacons exist for force
		local module_count = force.technologies["tiberium-growth-acceleration-acceleration"].level - 1
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

script.on_event({defines.events.on_technology_effects_reset, defines.events.on_forces_merging}, OnForceReset)

script.on_event(defines.events.on_player_created, function(event)
	local player = game.players[event.player_index]

	if settings.startup["tiberium-advanced-start"].value or settings.startup["tiberium-ore-removal"].value then
		if not remote.interfaces["freeplay"] then
			for name, count in pairs(tiberium_start) do
				player.insert{name = name, count = count}
			end
		end
		UnlockTechnologyAndPrereqs(player.force, "tiberium-mechanical-research")
		UnlockTechnologyAndPrereqs(player.force, "tiberium-slurry-centrifuging")
	end
end)

function UnlockTechnologyAndPrereqs(force, techName)
	if not force.technologies[techName].researched then
		force.technologies[techName].researched = true
		for techPrereq in pairs(game.technology_prototypes[techName].prerequisites) do
			UnlockTechnologyAndPrereqs(force, techPrereq)
		end
	end
end
