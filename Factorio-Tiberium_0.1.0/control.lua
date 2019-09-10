script.on_init(function()
   global.oreList = { }
   global.contaminatedPlayers = { } -- { player reference, ticks }
   global.tickSkip = 18000
   global.tick = 0
   global.isDoneTibGrowth = true
   global.density = 10 --how much ore to place at once
   global.contactDamage = 1 --how much damage should be applied to objects over tiberium?
   global.contactDamageTime = 30 --how long (in ticks) should players be damaged after contacting tiberium?
   global.structureDamage = 1 --how much damage should be applied to adjacent buildings? (excluding electric-mining-drill)
   global.vehicleDamage = 1 --how much damage should be applied to vehicles players are in?
   global.damageForceName = "tiberium"
   global.spreadRateTick = 0
   global.tiberiumLevel = 0 --The level of tiberium; affects growth/damage patterns
   global.levelOneTech = "modules"
   global.levelTwoTech = "rocket-speed-5"
   global.levelThreeTech = "tiberium-control-network-tech"
   global.oreType = "tiberium-ore"
   global.world = game.surfaces[1]
   global.giveStartingItems = true
   global.startingItems = { {name="oil-refinery", count=1}, {name="solar-panel", count=10}, {name="chemical-plant", count=5}, {name="pipe", count=50}
, {name="small-electric-pole", count=10}, {name="electric-mining-drill", count=5}, {name="assembling-machine-2", count=1}, {name="sulfuric-acid-barrel", count=10} }
   global.exemptDamageItems = { "mining-drill", "small-electric-pole", "big-electric-pole", "medium-electric-pole", "pipe",
   "transport-belt", "fast-transport-belt", "express-transport-belt", "underground-belt", "fast-underground-belt", "express-underground-belt",
   "splitter", "fast-splitter", "express-splitter", "stone-wall" }
   global.growUnderItems = { "electric-mining-drill", "small-electric-pole", "big-electric-pole", "medium-electric-pole", "pipe",
   "transport-belt", "fast-transport-belt", "express-transport-belt", "underground-belt", "fast-underground-belt", "express-underground-belt",
   "splitter", "fast-splitter", "express-splitter" }
   global.tiberiumProducts = { "tiberium-brick", global.oreType }
   global.liquidTiberiumProducts = { "liquid-tiberium", "tiberium-sludge", "tiberium-waste" }
   
   game.create_force(global.damageForceName)
end)

local maxRange = 10
local function PlaceOre(entity)
	if not entity.valid then game.print("entity is invalid") return end
	local density = global.density
	local surface = entity.surface
	local position = entity.position
	local totalOre = math.min((maxRange*maxRange)*100000, entity.amount)
	local ore=0
	local size=math.min(math.max(math.sqrt((totalOre-500000)/10000), 5), 20)
	entity.amount = entity.amount+(ore*(size*size))
	for y=-size, size do
		for x=-size, size do
			local a=(size+1-math.abs(x))*10
			local b=(size+1-math.abs(y))*10
			if a<b then
				ore=(math.random(a*density-a*(density-8), a*density+a*(density-8)))*0.1
			end
			if b<a then
				ore=(math.random(b*density-b*(density-8), b*density+b*(density-8)))*0.1
			end
			ore = math.max(ore, 1)
			if not entity.valid then game.print("entity is invalid") return end
			if surface.get_tile(position.x+x, position.y+y).collides_with("ground-tile") then
				local entityToDamage = surface.find_entities({{position.x+x-0.5, position.y+y-0.5},{position.x+x+0.5, position.y+y+0.5}})
				local oreEntity = surface.find_entity("tiberium-ore", {position.x+x, position.y+y})
				local node = surface.find_entity("tibGrowthNode", {position.x+x, position.y+y})
				if entityToDamage[1] and (oreEntity or node) then
					--damage adjacent entities unless it's in the list of exemptDamageItems
					local isExempt = false
					for i=1,#global.exemptDamageItems,1 do
						if global.exemptDamageItems[i] == entityToDamage[1].name then
						isExempt = true
						break
						end
					end
					if not isExempt and entityToDamage[1].prototype.max_health > 0
					then
						entityToDamage[1].damage(global.structureDamage, game.forces.neutral, "acid")
					end
				end
				if node then
				elseif oreEntity then
					oreEntity.amount = oreEntity.amount+ore
				elseif
					surface.create_entity{ name="tiberium-ore", amount=ore, position={position.x+x, position.y+y}}.valid then
				else
				
				end
			end
		end
	end
end

--[[
Sonic Gate
Fix belt exclusions
]]

local function Contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end



commands.add_command("setTibTickRate","Sets how often Tiberium should attempt to grow. (default: 20)",
  function(list)
    global.tickSkip = tonumber(list["parameter"])
	game.player.print(global.tickSkip)
  end
)
commands.add_command("setTibSpreadRate","Sets how many Tiberum spread per tiberium tick",
  function(list)
    global.spreadRate = tonumber(list["parameter"])
	game.player.print(global.spreadRate)
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
script.on_event(defines.events.on_chunk_generated, function(event)
    local entities = game.surfaces[1].find_entities_filtered{area = event.area, name = "tibGrowthNode"}

    for i=1,#entities,1
    do
      table.insert(global.oreList, entities[i])
	  rand = math.random(3,5)
	  global.density = global.density*rand
	  PlaceOre(entities[i])
	  global.density = global.density/rand
    end
end)

script.on_event(defines.events.on_research_finished, function(event)
  --advance tiberium level when certian techs are researched
  if event.research.name == global.levelOneTech or event.research.name == global.levelTwoTech or event.research.name == global.levelThreeTech then
     global.tiberiumLevel = global.tiberiumLevel + 1 

    --destroys walls, grows faster
     if event.research.name == global.levelOneTech or global.tiberiumLevel == 1 then
       global.exemptDamageItems = { "mining-drill", "small-electric-pole", "big-electric-pole", "medium-electric-pole", "pipe",
   "transport-belt", "fast-transport-belt", "express-transport-belt", "underground-belt", "fast-underground-belt", "express-underground-belt",
   "splitter", "fast-splitter", "express-splitter" }
     end
  
     --destroys everything, grows even faster
     if event.research.name == global.levelTwoTech or global.tiberiumLevel == 2 then
       global.exemptDamageItems = { }
	   global.density = global.density * 1.25
     end
	 
     --growth slows, tiberium eventually runs out
     if event.research.name == global.levelThreeTech or global.tiberiumLevel == 3 then
       -- global.tickSkip = 20
	   global.density = global.density * 1.5
     end	 
  end

end)
script.on_event(defines.events.on_tick, function(event)

	--return until ticks accumulate
    global.tick = global.tick + 1
    if global.tick >= global.tickSkip
    then
	  --game.print("spread")
      global.tick = 0
	  global.isDoneTibGrowth = false
    end
	--[[local ticksBetweenChecks = 5
	if not global.isDoneTibGrowth and global.tick % ticksBetweenChecks == 0 then
		local i = (global.tick/ticksBetweenChecks) + 1
		if global.oreList[i] then
			PlaceOre(global.oreList[i])
		else
			global.isDoneTibGrowth = true
		end
	end]]
	--check if players are over tiberium, damage them if they are unarmored
	for i, player in pairs (game.players) do
      local playerPositionOre = global.world.find_entities_filtered{name = global.oreType, position = game.players[i].position}
	  if #playerPositionOre > 0 and game.players[i] and game.players[i].valid and game.players[i].character and not game.players[i].character.vehicle then
	    game.players[i].character.damage(global.contactDamage, game.forces.tiberium, "acid")
	  end
	  
	  --if player is holding tiberium products, add damage
	  local inventory = game.players[i].get_inventory(defines.inventory.item_main)
	   if inventory then
         for p=1,#global.tiberiumProducts,1 do
           if inventory.get_item_count(global.tiberiumProducts[p]) > 0 then
		    game.players[i].character.damage(0.1, game.forces.tiberium, "acid")
            break
           end
         end
       end
    end
end)

--script.on_event(defines.events.on_entity_died, function(event)
   --if entity contained tiberium products, add ore to its position

--   if event.force and event.force == game.forces.tiberium then
  --   local newOre = global.world.create_entity{name = global.oreType, position = event.entity.position, amount = 10}
    -- table.insert(global.oreList, newOre)
     --return
  -- end
   
 --  local inventory = event.entity.get_inventory(defines.inventory.chest)
--   if not inventory then inventory = event.entity.get_inventory(defines.inventory.furnace_source) end
 --  if not inventory then inventory = event.entity.get_inventory(defines.inventory.furnace_source) end
 --  if not inventory then inventory = event.entity.get_inventory(defines.inventory.furnace_result) end
 --  if not inventory then inventory = event.entity.get_inventory(defines.inventory.item_main) end
 --  if not inventory then inventory = event.entity.get_inventory(defines.inventory.cargo_wagon) end
 --  if not inventory then inventory = event.entity.get_inventory(defines.inventory.assembling_machine_input) end
 --  if not inventory then inventory = event.entity.get_inventory(defines.inventory.assembling_machine_output) end
  
 --  if inventory then
  --   for i=1,#global.tiberiumProducts,1 do
  --     if inventory.get_item_count(global.tiberiumProducts[i]) > 0 then
        --create new ores
  --      local newOre = global.world.create_entity{name = global.oreType, position = event.entity.position, amount = 10}
  --      table.insert(global.oreList, newOre)
  --     return
  --    end
  --  end
 --  end
   
   --[[if event.entity.fluidbox and #event.entity.fluidbox > 0 then
      for i=1,#event.entity.fluidbox,1 do
       for l=1,#global.liquidTiberiumProducts,1 do
         if event.entity.fluidbox[i].type == global.liquidTiberiumProducts[l] and event.entity.fluidbox[i].amount > 1 then
          --create new ores
          local newOre = global.world.create_entity{name = global.oreType, position = event.entity.position, amount = 10}
          table.insert(global.oreList, newOre)
          return
		  end
       end
      end
   end--]]
   
--end)

--script.on_event(defines.events.on_player_died, function(event)

   
--end)


--[[periodic scan
script.on_event(defines.events.on_tick, function(event)
 	--check if players are over tiberium, damage them if they are unarmored
	for i, player in pairs (game.players) do
      local playerPositionOre = global.world.find_entities_filtered{name = global.oreType, position = game.players[i].position}
	  if #playerPositionOre > 0 and game.players[i] and game.players[i].valid and game.players[i].character and not game.players[i].character.vehicle then
	    game.players[i].character.damage(global.contactDamage, game.forces.tiberium, "acid")
	  end
	  
	  --if player is holding tiberium products, add damage
	  local inventory = game.players[i].get_inventory(defines.inventory.item_main)
	   if inventory then
         for p=1,#global.tiberiumProducts,1 do
           if inventory.get_item_count(global.tiberiumProducts[p]) > 0 then
		    game.players[i].character.damage(0.1, game.forces.tiberium, "acid")
            break
           end
         end
       end
    end	

	--return until ticks accumulate
    global.tick = global.tick + 1
    if global.tick >= global.tickSkip
    then
	  --game.print("spread")
      global.tick = 0
    else
      return
    end
	
	
	if #global.oreList == 0
	then
	return
	end
    
    --for i=1,global.spreadRate,1
	do
		--decrement ore list index to work on the next ore piece
		global.oreListIndex = global.oreListIndex - 1
		if global.oreListIndex < 1
		then global.oreListIndex = #global.oreList
		end

		local ore = global.oreList[global.oreListIndex]

		--perform null check on the selected index
		if not ore or not ore.valid or not ore.position then
		table.remove(global.oreList, global.oreListIndex)
		--global.oreListIndex = global.oreListIndex - 1
		  if global.oreListIndex == #global.oreList then
			global.oreListIndex = 1
		  end
		return
		end
		
		
	for i in global.oreList
	do 
		local entities = game.surfaces[1].count_entities_filtered{area = event.area, name = "tiberium-ore"}
		end
	
		--add new ores to empty adjacent squares
		orePositions = {{ ore.position.x + 1, ore.position.y }, { ore.position.x - 1, ore.position.y }, 
	{ ore.position.x, ore.position.y + 1 }, { ore.position.x, ore.position.y - 1 }}

		for i=1,4,1
		do
		   --check if adjacent square is a water tile
		   local tile = global.world.get_tile(orePositions[i][1], orePositions[i][2])
		   if tile.valid and not tile.collides_with("player-layer") then

		   local adjacentEntities = global.world.find_entities_filtered{position = orePositions[i]}
		   
		   if #adjacentEntities == 0 then
		   --add new ore here
		   local newOre = global.world.create_entity{name = global.oreType, position = orePositions[i], amount = global.spreadAmount}
		   table.insert(global.oreList, newOre)
		   end
		   
		   if #adjacentEntities > 0 then
		   --increase ore amount
		   if ore.amount < global.maxOreAmount
			then 
			 local oldAmount = ore.amount
			 ore.amount = oldAmount + global.growthRate
		   end
		   
		   --damage adjacent entities unless it's in the list of exemptDamageItems
		   for x=1,#adjacentEntities,1 do
			 local isExempt = false
			 for y=1,#global.exemptDamageItems,1 do
			   if global.exemptDamageItems[y] == adjacentEntities[x].name then
			   isExempt = true
			   break
			   end
			 end
			 --if adjacentEntities[x].name ~= "electric-mining-drill" and adjacentEntities[x].prototype.max_health > 0
			 if not isExempt and adjacentEntities[x].prototype.max_health > 0
			 then
			   adjacentEntities[x].damage(global.structureDamage, game.forces.neutral, "acid")
			 end
		   end
		   
		   --if the adjacent entity includes other tiberium, don't add another ore piece there
		   local oreExists = false
		   for y=1,#adjacentEntities,1 do
			   if adjacentEntities[y].valid and adjacentEntities[y].name == global.oreType then
			   oreExists = true
			   break
			   end
		   end
		   
		   if not oreExists then
			 --check if the adjacent entity should allow tiberium to grow under it
			 for x=1,#adjacentEntities,1 do
			   local growAnyway = false
			   for y=1,#global.growUnderItems,1 do
				 if adjacentEntities[x].valid and global.growUnderItems[y] == adjacentEntities[x].name then
				 growAnyway = true
				 break
				 end
			   end
			   if growAnyway
			   then
				 --add new ore here
				 local newOre = global.world.create_entity{name = global.oreType, position = orePositions[i], amount = global.spreadAmount}
				 table.insert(global.oreList, newOre)
			   end
			 end
		   end
		   end
		end
	end
end
	
end)]]