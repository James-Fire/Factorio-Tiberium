-- Adding Tib Science to all labs
local tibComboPacks = {}  -- List of packs that need to be processed in the same lab as Tib Science
for name, technology in pairs(data.raw.technology) do
	if string.sub(name, 1, 9) == "tiberium-" and technology.unit then
		for _, ingredient in pairs(technology.unit.ingredients) do
			local pack = ingredient[1] and ingredient[1] or ingredient.name
			if (pack ~= "tiberium-science") and data.raw.tool[pack] then -- Don't add Tib Science
				tibComboPacks[pack] = true
			end
		end
	end
end

for labName, labData in pairs(data.raw.lab) do
	local addTib = false
	if not flib_table.find(labData.inputs or {}, "tiberium-science") then -- Must not already allow Tib Science
		for pack in pairs(tibComboPacks) do  -- Must use packs from combo list so we don't hit things like module labs
			if flib_table.find(labData.inputs or {}, pack) then
				addTib = true
				break
			end
		end
	end
	if addTib then table.insert(data.raw.lab[labName].inputs, "tiberium-science") end
end

function removeCollisionMask(type, prototype, mask)
	if type and prototype and mask and data.raw[type] and data.raw[type][prototype]
			and data.raw[type][prototype].collision_mask and data.raw[type][prototype].collision_mask.layers then
		for k,v in pairs(data.raw[type][prototype].collision_mask.layers) do
			if v == mask then
				table.remove(data.raw[type][prototype].collision_mask.layers, k)
				break
			end
		end
	end
end

if mods["alien-biomes"] then  -- Reverting this change so Tiberium can grow on landfill again
	removeCollisionMask("tile", "landfill", "resource")
end

if mods["space-exploration"] then
	local space_collision_layer = data.raw.arrow["collision-mask-space-tile"] and data.raw.arrow["collision-mask-space-tile"].collision_mask.layers[1]
	if space_collision_layer then
		--Since se_allow_in_space isn't respected for alternate miners that don't mine default resources
		for _, drillName in pairs({"tiberium-network-node", "tiberium-node-harvester", "tiberium-aoe-node-harvester", "tiberium-detonation-charge", "tiberium-growth-accelerator-node", "tiberium-spike"}) do
			removeCollisionMask("mining-drill", drillName, space_collision_layer)
		end
	end
end

-- If there is no refinery that can be set to Tiberium processing recipes, allow them to be made at our centrifuges
local openRefinery = false
for assemblerName, assembler in pairs(data.raw["assembling-machine"]) do
	if (flib_table.find(assembler.crafting_categories or {}, "oil-processing") and
			assembler.minable and not assembler.fixed_recipe) then  -- Minable as the simplest proxy for it being a real entity that players can create
		openRefinery = true
		break
	end
end
if not openRefinery then
	for _, recipe in pairs({"tiberium-molten-processing", "tiberium-advanced-molten-processing", "tiberium-liquid-processing", "tiberium-liquid-processing-hot"}) do
		if data.raw.recipe[recipe] then
			data.raw.recipe[recipe].category = "tiberium-centrifuge-1"
			-- Rebalance from refinery to centrifuge to preserve power/pollution amounts
			data.raw.recipe[recipe].emissions_multiplier = (data.raw.recipe[recipe].emissions_multiplier or 1) * 0.75
			data.raw.recipe[recipe].energy_required = (data.raw.recipe[recipe].energy_required or 1) * 2
			data.raw.recipe[recipe].always_show_made_in = true
		end
	end
end

-- Temporary bugfix for issue with LSlib issue #9
for _, ingredient in pairs(data.raw.recipe["tiberium-liquid-processing-hot"].ingredients) do
	if ingredient.name == "steam" then
		ingredient.minimum_temperature = 500
		ingredient.maximum_temperature = 1000
	end
end

require("scripts/DynamicOreRecipes")
require("scripts/compatibility/pumpmod")
