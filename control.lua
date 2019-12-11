require "scripts/CnC_Walls" --Note, to make SonicWalls work / be passable, 

script.on_init(
  function()
    global.tibGrowthNodeListIndex = 0
    global.tibGrowthNodeList = {}
    global.drills = {}

    -- Does not appear to be currently used so commenting out for now
    --global.contaminatedPlayers = { } -- { player reference, ticks }

    -- Each node should spawn tiberium once every 5 minutes (give or take a handful of ticks rounded when dividing)
    -- Currently allowing this to potentially update every tick but to keep things under control minUpdateInterval
    -- can be set to something greater than 1. When minUpdateInterval is reached the global tiberium growth rate
    -- will stagnate instead of increasing with each new node found but updates will continue to happen for all fields.
    global.minUpdateInterval = 1
    global.intervalBetweenNodeUpdates =
      math.floor(math.max(18000 / (#global.tibGrowthNodeList or 1), global.minUpdateInterval))

    global.baseGrowthRate = 50 -- how much ore to place at once
    global.baseSize = 10 -- The maximum radius of the field
    global.contactDamage = 1 --how much damage should be applied to objects over tiberium?
    global.contactDamageTime = 30 --how long (in ticks) should players be damaged after contacting tiberium?
    global.structureDamage = 1 --how much damage should be applied to adjacent buildings? (excluding electric-mining-drill)
    global.vehicleDamage = 1 --how much damage should be applied to vehicles players are in?
    global.damageForceName = "tiberium"
    global.tiberiumLevel = 0 --The level of tiberium; affects growth/damage patterns
    global.oreType = "tiberium-ore"
    global.world = game.surfaces[1]
    global.giveStartingItems = true
    global.startingItems = {
      {name = "oil-refinery", count = 1},
      {name = "solar-panel", count = 10},
      {name = "chemical-plant", count = 5},
      {name = "pipe", count = 50},
      {name = "small-electric-pole", count = 10},
      {name = "electric-mining-drill", count = 5},
      {name = "assembling-machine-2", count = 1},
      {name = "sulfuric-acid-barrel", count = 10}
    }

    -- This is a list of prototypes that should not be damaged by growing tiberium
    global.exemptDamageItems = {
      ["mining-drill"] = true,
      ["small-electric-pole"] = true,
      ["big-electric-pole"] = true,
      ["medium-electric-pole"] = true,
      ["pipe"] = true,
      ["transport-belt"] = true,
      ["fast-transport-belt"] = true,
      ["express-transport-belt"] = true,
      ["underground-belt"] = true,
      ["fast-underground-belt"] = true,
      ["express-underground-belt"] = true,
      ["splitter"] = true,
      ["fast-splitter"] = true,
      ["express-splitter"] = true,
      ["stone-wall"] = true
    }

    global.growUnderItems = {
      "electric-mining-drill",
      "small-electric-pole",
      "big-electric-pole",
      "medium-electric-pole",
      "pipe",
      "transport-belt",
      "fast-transport-belt",
      "express-transport-belt",
      "underground-belt",
      "fast-underground-belt",
      "express-underground-belt",
      "splitter",
      "fast-splitter",
      "express-splitter"
    }
    global.tiberiumProducts = {"tiberium-brick", global.oreType}
    global.liquidTiberiumProducts = {"liquid-tiberium", "tiberium-sludge", "tiberium-waste"}

    if not game.forces[global.damageForceName] then
      game.create_force(global.damageForceName)
    end
	
	-- CnC SonicWalls Init
	 CnC_SonicWall_OnInit(event) 
	
  end
)

function AddOre(surface, position, growthRate)
  local area = {
    {x = math.floor(position.x), y = math.floor(position.y)},
    {x = math.ceil(position.x), y = math.ceil(position.y)}
  }
  local entities = surface.find_entities_filtered({area = area, name = {"tiberium-ore"}})

  if (#entities > 1) then
    game.print("ERROR multiple entities | " .. math.random())
    entities[1].destroy()
  elseif (#entities == 1) then
    --game.print(string.format("x:%.2f y:%.2f update | %f", position.x, position.y, math.random()))
    entities[1].amount = math.min(entities[1].amount + growthRate, 50000)
  else
    --game.print(string.format("x:%.2f y:%.2f new | %f", position.x, position.y, math.random()))
    oreEntity = surface.create_entity {name = "tiberium-ore", amount = growthRate, position = position}
  end

  --damage adjacent entities unless it's in the list of exemptDamageItems
  local entitiesToDamage = surface.find_entities(area)
  for i = 1, #entitiesToDamage, 1 do
    printTable(global.exemptDamageItems)
    if global.exemptDamageItems[entitiesToDamage[i].type] == nil then
      if entitiesToDamage[i].prototype.max_health > 0 then
        entitiesToDamage[i].damage(global.structureDamage, game.forces.neutral, "acid")
      end
    end
  end

  --game.print(string.format("amount=%d growthRate = %d | %f", oreEntity.amount, growthRate, math.random( )))
end

function CheckPoint(surface, position, lastValidPosition, growthRate)
  -- if (position.x == nil or position.y == nil) then
  --   game.print("x or y is nil in CheckPoint " .. math.random())
  --   return
  -- end

  -- These checks are in roughly the order of guessed expense
  local tile = surface.get_tile(position)
  if (not tile.collides_with("ground-tile")) then
    --game.print("Found a non-ground tile, placing ore at the last valid position" .. math.random())
    AddOre(surface, lastValidPosition, growthRate)
    return true
  end

  local area = {
    {x = math.floor(position.x), y = math.floor(position.y)},
    {x = math.ceil(position.x), y = math.ceil(position.y)}
  }

  if (#surface.find_entities_filtered({area = area, name = "tiberium-wall"}) > 0) then
    --game.print("Found tiberium wall, placing ore at the last valid position" .. math.random())
    AddOre(surface, lastValidPosition, growthRate * .50)
    return true
  end

  -- If the current tile is an ore entity keep walking the line (return false for not done)
  -- If we hit the end of the line without returning true ore is placed by a fallthrough check
  -- in the line walk.

  local oreEntity = surface.find_entities_filtered({area = area, name = {"tiberium-ore"}})
  if (#oreEntity > 0) then
    return false
  else
    -- game.print(
    --   "Found a non-ore tile, placing ore here." .. position.x .. " " .. position.y .. " " .. math.random()
    -- )
    AddOre(surface, position, growthRate)
    return true
  end
end

function PlaceOre(entity, howmany)
  local timer = game.create_profiler()

  if not entity.valid then
    game.print("entity is invalid")
    return
  end

  local surface = entity.surface
  local position = entity.position

  -- Scale growth rate based on distance from spawn
  local growthRate = global.baseGrowthRate * math.max(1, math.sqrt(position.x + position.y) / 10)
  -- Scale size based on distance from spawn, separate from density in case we end up wanting them to
  -- scale differently
  local size = global.baseSize * math.max(1, math.sqrt(position.x + position.y) / 100)

  howmany = howmany or 1
  --game.print("Placing " .. growthRate .. " ore " .. howmany .. " times " .. math.random())

  for howmanycount = 1, howmany, 1 do
    local direction = math.random() * 2 * math.pi
    local length = 2.2 + math.random() * size -- A little over 2 to avoid putting too much on the node itself
    --game.print("placement: " .. howmanycount .. " radians: " .. direction .. " length: " .. length .. " | " .. math.random())

    local lastValidPosition = position

    local x1 = position.x
    local y1 = position.y
    local x2 = position.x + length * math.cos(direction)
    local y2 = position.y + length * math.sin(direction)

    dx = (x2 - x1)
    dy = (y2 - y1)
    if (math.abs(dx) >= math.abs(dy)) then
      step = math.abs(dx)
    else
      step = math.abs(dy)
    end

    dx = dx / step
    dy = dy / step
    x = x1
    y = y1
    i = 1
    while (i < step) do
      newPosition = {x = x, y = y}
      done = CheckPoint(surface, newPosition, lastValidPosition, growthRate)
      if (done) then
        break
      end
      lastValidPosition = newPosition
      x = x + dx
      y = y + dy
      i = i + 1
    end
    
    if (not done) then
      --game.print("Walked all the way to the end of the line, placing ore at the last valid position" .. math.random())
      AddOre(surface, lastValidPosition, growthRate)
    end
  end -- End of "howmany" loop

  --game.print({"", timer, " end of placement loop"})

  -- Tell any mining drills in the area to wake up
  -- 2.5 is default mining drill radius, should check drill prototypes for largest radius
  -- local drills = surface.find_entities_filtered({radius = math.sqrt(size ^ 2 * 2) + 2.5, type = "mining-drill"})
  --local drills = surface.find_entities_filtered({type = "mining-drill"})
  --game.print({"", timer, " end of find_entities_filtered({type = \"mining-drill\"}) ", #drills})

  if global.drills == nil then
    global.drills = {}
  end

  for i = 1, #global.drills, 1 do
    local drill = global.drills[i]
    if (drill == nil or drill.valid == false) then
      table.remove(drill)
    else
      drill.active = false
      drill.active = true
    end
  end

  --game.print({"", timer, " end of updating mining drills ", #drills})
end

--[[
Nodes spawn like oil
Fix mining drill exclusions
Sonic Gate
Fix belt exclusions
]]
commands.add_command(
  "setTibTickRate",
  "Sets how often Tiberium should attempt to grow. (default: 20)",
  function(list)
    global.tickSkip = tonumber(list["parameter"])
    game.player.print(global.tickSkip)
  end
)
commands.add_command(
  "dumpTiberiumNodeList",
  "Print the list of known tiberium nodes",
  function()
    game.print("There are " .. #global.tibGrowthNodeList .. " nodes in the list")
    for i = 1, #global.tibGrowthNodeList, 1 do
      game.print("x:" .. global.tibGrowthNodeList[i].position.x .. " y:" .. global.tibGrowthNodeList[i].position.y)
    end
  end
)
commands.add_command(
  "tibRebuildNodeAndDrillLists",
  "update lists of mining drills and tiberium nodes",
  function()
    local allnodes = game.surfaces[1].find_entities_filtered {name = "tibGrowthNode"}
    global.tibGrowthNodeList = {}
    for i = 1, #allnodes, 1 do
      table.insert(global.tibGrowthNodeList, allnodes[i])
    end
    game.print("Found " .. #global.tibGrowthNodeList .. " nodes")

    local alldrills = game.surfaces[1].find_entities_filtered {type = "mining-drill"}
    global.drills = {}
    for i = 1, #alldrills, 1 do
      table.insert(global.drills, alldrills[i])
    end
    game.print("Found " .. #global.drills .. " drills")
  end
)
commands.add_command(
  "tibSetbaseGrowthRate",
  "Sets how many Tiberum spread per tiberium tick",
  function(list)
    global.baseGrowthRate = tonumber(list["parameter"])
    game.player.print(global.baseGrowthRate)
  end
)

commands.add_command(
  "tibGrowAllNodes",
  "Forces the mod to grow ore at every node",
  function()
    local timer = game.create_profiler()
    game.print("There are " .. #global.tibGrowthNodeList .. " nodes in the list")
    for i = 1, #global.tibGrowthNodeList, 1 do
      -- game.print(
      --   "Growing node x:" .. global.tibGrowthNodeList[i].position.x .. " y:" .. global.tibGrowthNodeList[i].position.y
      -- )
      PlaceOre(global.tibGrowthNodeList[i], 300)
    end
    game.print({"", timer, " end of tibGrowAllNodes"})
  end
)

function printTable(table)
  if (table ~= nil) then
    for i = 1, #table, 1 do
      game.print(table[i])
    end
  end
end

commands.add_command(
  "tibDumpGlobals",
  "Dumps mod global variables (and may reset some if dev code in place)",
  function()
    global.exemptDamageItems = {
      ["mining-drill"] = true,
      ["electric-pole"] = true,
      ["transport-belt"] = true,
      ["underground-belt"] = true,
      ["splitter"] = true,
    }

    printTable(global.exemptDamageItems)
  end
)

commands.add_command(
  "tibFixBrokenThings",
  "Deletes all the tib ore on the map",
  function()
    local tibOres = global.tibGrowthNodeList[1].surface.find_entities_filtered({name = "tiberium-ore"})
    for i = 1, #tibOres, 1 do
      tibOres[i].destroy()
    end
  end
)

--gives incoming players some starting items
--script.on_event(defines.events.on_player_joined_game, function(event)
--  if global.giveStartingItems then
--    local playerInventory = game.players[event.player_index].get_inventory(defines.inventory.player_main)
--	game.players[event.player_index].force.technologies["fluid-handling"].researched = true
--	for i=1,#global.startingItems,1 do
--	  playerInventory.insert({name=global.startingItems[i].name, count=global.startingItems[i].count})
--	end
--  end
--end)

--initial chunk scan
script.on_event(
  defines.events.on_chunk_generated,
  function(event)
    local entities = game.surfaces[1].find_entities_filtered {area = event.area, name = "tibGrowthNode"}

    for i = 1, #entities, 1 do
      table.insert(global.tibGrowthNodeList, entities[i])
      PlaceOre(entities[i], 300)
    end

    global.intervalBetweenNodeUpdates =
      math.floor(math.max(18000 / (#global.tibGrowthNodeList or 1), global.minUpdateInterval))
  end
)

script.on_event(
  defines.events.on_research_finished,
  function(event)
    --advance tiberium level when certain techs are researched
    -- Maybe use tiberium level to influence growth rate
    if (event.research.name == "somelowleveltibtech") then
      global.tiberiumLevel = 2
    elseif (event.research.name == "somemidleveltibtech") then
      global.tiberiumLevel = 3
    elseif (event.research.name == "somehighleveltibtech") then
      global.tiberiumLevel = 4
    end
  end
)

-- Double check here XX, I think using only on_built_entity might mean that robot-placed drills don't add to the list.
-- Gotta test, that.
script.on_event(
  defines.events.on_built_entity,
  function(event)
    if (event.created_entity.type == "mining-drill") then
      table.insert(global.drills, event.created_entity)
	end
	
	if (event.created_entity.name == "CnC_SonicWall_Hub") then 
		CnC_SonicWall_AddNode(event.created_entity, event.tick) 
	end
	
  end
)



script.on_event(
  defines.events.on_tick,
  function(event)
    -- Print some stats every 5 minutes (development stuff)

    if (event.tick % (60 * 60 * 5) == 0) then
      local alldrills = game.surfaces[1].find_entities_filtered {type = "mining-drill"}
      global.drills = {}
      for i = 1, #alldrills, 1 do
        table.insert(global.drills, alldrills[i])
      end
      game.print("Updated drill list and found " .. #global.drills .. " drills")

      game.print(
        "node count=" ..
          #global.tibGrowthNodeList .. " intervalBetweenNodeUpdates " .. global.intervalBetweenNodeUpdates
      )
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
        PlaceOre(global.tibGrowthNodeList[global.tibGrowthNodeListIndex], 300)
      end
    end

    --check if players are over tiberium, damage them if they are unarmored
    for i, player in pairs(game.players) do
      local playerPositionOre =
        global.world.find_entities_filtered {name = global.oreType, position = game.players[i].position}
      if
        #playerPositionOre > 0 and game.players[i] and game.players[i].valid and game.players[i].character and
          not game.players[i].character.vehicle
       then
        game.players[i].character.damage(global.contactDamage, game.forces.tiberium, "acid")
      end

      --if player is holding tiberium products, add damage
      local inventory = game.players[i].get_inventory(defines.inventory.item_main)
      if inventory then
        for p = 1, #global.tiberiumProducts, 1 do
          if inventory.get_item_count(global.tiberiumProducts[p]) > 0 then
            game.players[i].character.damage(0.1, game.forces.tiberium, "acid")
            break
          end
        end
      end
    end
	
	--[[	-- No need to poll the SonicWall tick script if there aren't any present in the world.
	if (table_size(global.hexi_hardlight_nodes) > 0)
		then CnC_SonicWall_OnTick(event) end ]]--
		
		CnC_SonicWall_OnTick(event) 
		--[[ I'll just let this poll for now, otherwise it would crash, trying to reference a nil table on non-fresh, post-sonicwall games.
		]]--
		
	end
)

script.on_event(defines.events.on_trigger_created_entity, function(event)
    CnC_SonicWall_OnTriggerCreatedEntity(event)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
    if (event.created_entity.name == "CnC_SonicWall_Hub") then 
	CnC_SonicWall_AddNode(event.created_entity, event.tick) 
	end
end)

script.on_event(defines.events.on_pre_player_mined_item, function(event)
    if (event.entity.name == "CnC_SonicWall_Hub") then 
	CnC_SonicWall_DeleteNode(event.entity) 
	end
end)

script.on_event(defines.events.on_robot_pre_mined, function(event)
    if (event.entity.name == "CnC_SonicWall_Hub") then 
	CnC_SonicWall_DeleteNode(event.entity) 
	end
end)

script.on_event(defines.events.on_entity_died, function(event)
    if (event.entity.name == "CnC_SonicWall_Hub") then 
	CnC_SonicWall_DeleteNode(event.entity) 
	end
end)