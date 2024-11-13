flib_table = require("__flib__/table")
require("scripts/tib-map-gen-presets")  -- After other mods have added their resources as part of the data step

require("scripts/compatibility/bobsmods")
require("scripts/compatibility/Krastorio2")
require("scripts/compatibility/Obelisks-of-light")

-- Orbital Ion Cannon
if mods["Orbital Ion Cannon"] or mods["Kux-OrbitalIonCannon"] then
	common.technology.addPrerequisite("orbital-ion-cannon", "tiberium-military-2")
	if mods["bobwarfare"] then
		common.recipe.editIngredient("orbital-ion-cannon", "bob-laser-turret-5", "tiberium-ion-core", 1)
		common.technology.removePrerequisite("orbital-ion-cannon", "bob-laser-turrets-5")
	else
		common.recipe.editIngredient("orbital-ion-cannon", "laser-turret", "tiberium-ion-core", 1)
	end
end

if mods["MoreScience"] then
	for techName, techData in pairs(data.raw.technology) do
		if string.sub(techName, 1, 9) == "tiberium-" and techData.unit then
			-- Most techs have the new science packs added to them
			if (techName ~= "tiberium-mechanical-research") and (techName ~= "tiberium-slurry-centrifuging")
					and (techName ~= "tiberium-military-1") and (techName ~= "tiberium-thermal-research")
					and (techName ~= "tiberium-sludge-processing") and (techName ~= "tiberium-advanced-molten-processing")
					and (techName ~= "tiberium-sludge-recycling") then
				table.insert(techData.unit.ingredients, {"electric-power-science-pack", 1})
			end
			if (techName ~= "tiberium-mechanical-research") and (techName ~= "tiberium-slurry-centrifuging")
					and (techName ~= "tiberium-thermal-research") then
				table.insert(techData.unit.ingredients, {"advanced-automation-science-pack", 1})
			end
			-- Take our repeatable techs and swap them to infused packs
			if techData.max_level and (techData.max_level == "infinite") then
				for key, pack in pairs(techData.unit.ingredients) do
					if data.raw.tool["infused-"..pack[1]] then
						pack[1] = "infused-"..pack[1]
						if data.raw.technology[pack[1]] then
							table.insert(techData.prerequisites, pack[1])
						end
					end
				end
			end
		end
	end
end

if mods["omnimatter"] then
	if omni then
		omni.matter.add_ignore_resource("tiberium-ore")
		omni.matter.add_ignore_resource("tibGrowthNode")
		omni.matter.add_ignore_resource("tibNode_tree")
	end
	common.recipe.editIngredient("tiberium-spike", "pumpjack", "offshore-pump", 1)
end

if mods["pypetroleumhandling"] then
	-- Move Liquid Tiberium recipe to Reformer
	data.raw.recipe["tiberium-liquid-processing"].category = "reformer"
	data.raw.recipe["tiberium-liquid-processing-hot"].category = "reformer"
	-- Move both Molten Tiberium recipes to Light Oil Refinery
	data.raw.recipe["tiberium-molten-processing"].category = "lor"
	data.raw.recipe["tiberium-advanced-molten-processing"].category = "lor"
end

if mods["IndustrialRevolution"] then
	if data.raw["assembling-machine"]["oil-refinery"] then
	    data.raw["assembling-machine"]["oil-refinery"].fixed_recipe = nil
	    data.raw["assembling-machine"]["oil-refinery"].show_recipe_icon = true
	end
end

if mods["angelspetrochem"] then
	-- Replace the vanilla Chemical Plant with one of Angel's, because apparently it's too hard to simply use the vanilla one.
	common.recipe.editIngredient("tiberium-power-plant", "chemical-plant", "angels-chemical-plant-2", 1)
end

if mods["dark-matter-replicators-18"] then
	common.applyTiberiumValue("dmr18-tenemut", 32)
end

if mods["dark-matter-replicators-18-patch"] then
	common.applyTiberiumValue("tenemut", 32)
end

if mods["space-exploration"] then
	common.applyTiberiumValue("se-water-ice", 32)
	common.applyTiberiumValue("se-methane-ice", 32)
	common.applyTiberiumValue("se-cryonite", 32)
	common.applyTiberiumValue("se-vulcanite", 32)
	common.applyTiberiumValue("se-vitamelange", 32)
	common.applyTiberiumValue("se-beryllium-ore", 32)
	common.applyTiberiumValue("se-holmium-ore", 32)
	common.applyTiberiumValue("se-iridium-ore", 32)
	common.applyTiberiumValue("se-naquium-ore", 32)
	se_resources["tibGrowthNode"] = {}
	se_resources["tibGrowthNode"].has_starting_area_placement = common.TiberiumInStartingArea

	-- These do nothing other than tiberium-growth-accelerator and tiberium-srf-connector, but I like to pretend
	for _, drillName in pairs({"tiberium-network-node", "tiberium-node-harvester", "tiberium-aoe-node-harvester", "tiberium-detonation-charge", "tiberium-growth-accelerator-node", "tiberium-spike"}) do
		data.raw["mining-drill"][drillName].se_allow_in_space = true
	end
	data.raw.beacon["tiberium-beacon-node"].se_allow_in_space = true
	data.raw["assembling-machine"]["tiberium-growth-accelerator"].se_allow_in_space = true
	data.raw["electric-energy-interface"]["tiberium-sonic-emitter"].se_allow_in_space = true
	data.raw["electric-energy-interface"]["tiberium-sonic-emitter-blue"].se_allow_in_space = true
	data.raw["pipe-to-ground"]["tiberium-srf-connector"].se_allow_in_space = true
	data.raw["electric-energy-interface"]["tiberium-srf-emitter"].se_allow_in_space = true
end

if mods["RampantResources"] then
	for _, name in pairs({"tiberium-ore", "tiberium-ore-blue", "tibGrowthNode", "tibGrowthNode_infinite"}) do
		data.raw.resource[name].exclude_from_rampant_resources = true
	end
end

if mods["deadlock-beltboxes-loaders"] then
	local Items = {
		{"tiberium-ore", "item", "stacked-tiberium-ore", 64, 4},
		{"tiberium-ore-blue", "item", "stacked-tiberium-ore-blue", 64, 4},
		{"tiberium-empty-cell", "item", "stacked-empty-cell", 64, 4},
		{"tiberium-dirty-cell", "item", "stacked-dirty-cell", 64, 4},
		{"tiberium-fuel-cell", "item", "stacked-tiberium-fuel-cell", 64, 4},
		{"tiberium-rounds-magazine", "ammo", "stacked-tiberium-rounds-magazine", 64, 4},
		{"tiberium-data-mechanical", "item", "stacked-tiberium-data-mechanical", 32, 1},
		{"tiberium-data-thermal", "item", "stacked-tiberium-data-thermal", 32, 1},
		{"tiberium-data-chemical", "item", "stacked-tiberium-data-chemical", 32, 1},
		{"tiberium-data-nuclear", "item", "stacked-tiberium-data-nuclear", 32, 1},
		{"tiberium-data-EM", "item", "stacked-tiberium-data-em", 32, 1},
		{"tiberium-science", "tool", "stacked-tacitus", 64, 1},
		{"tiberium-growth-credit", "item", "stacked-growth-credit", 64, 1},
		{"tiberium-primed-reactant", "item", "stacked-tiberium-crate", 128, 1},
		{"tiberium-primed-reactant-blue", "item", "stacked-tiberium-crate-blue", 128, 1},
		{"tiberium-chemical-sprayer-ammo", "ammo", "stacked-chemical-sprayer-ammo", 128, 1},
		{"tiberium-blue-explosives", "item", "stacked-tiberium-brick", 64, 1},
	}

	--Add stacking recipes
	for _, item in pairs(Items) do
		local name = item[1]
		local tech = "deadlock-stacking-1"
		local item_type = item[2] or "item"
		local graphics = string.format(tiberiumInternalName.."/graphics/deadlock/%s.png", item[3])
		local icon_size = item[4]
		local mips_icons = item[5]
		if data.raw[item_type][name] and deadlock then
			log(name.." adding to deadlock prototypes")
			if not data.raw.item["deadlock-stack-" .. name] then
				log(name.." adding to deadlock prototypes 2")
				deadlock.add_stack(name, graphics, tech, icon_size, item_type, mips_icons)
			end
		end
	end
end

-- Below code isn't specific to any single mod
table.insert(data.raw.character.character.mining_categories, "basic-solid-tiberium")

for _, drill in pairs(data.raw["mining-drill"]) do
	if flib_table.find(drill.resource_categories, "basic-solid") then
		table.insert(drill.resource_categories, "basic-solid-tiberium")
	end
end

-- Add Tiberium resistance to armors
for name, armor in pairs(data.raw.armor) do
	for _, resistance in pairs (armor.resistances or {}) do
		if resistance.type == "acid" then
			table.insert(armor.resistances, {type = "tiberium", decrease = resistance.decrease, percent = resistance.percent})
		end
	end
end

-- Add Obelisk damage upgrade to laser techs
for _, techData in pairs(data.raw.technology) do
	for _, effect in pairs(techData.effects or {}) do
		if effect.type == "ammo-damage" and effect.ammo_category == "laser" then
			table.insert(techData.effects, {type = "ammo-damage", ammo_category = "obelisk", modifier = effect.modifier})
			break
		end
	end
end

-- Desaturate uranium map color to make it not look like Tiberium
if data.raw.resource["uranium-ore"] then
	data.raw.resource["uranium-ore"]["map_color"] = {0.0, 0.5, 0.0}
	common.applyTiberiumValue("uranium-ore", 8)
end

-- Flag any item as being convertible to sludge for centrifuging recipes by setting the tiberium_sludge property to true
if data.raw.item.stone then
	data.raw.item.stone.tiberium_sludge = true
end

-- Flag items as empty barrels for detecting un-barreling recipes in data-final-fixes
if data.raw.item["barrel"] then
	data.raw.item["barrel"].tiberium_empty_barrel = true
end

-- Enable Tiberium Science recipes at all assemblers that meet certain category requirements
for name, assembler in pairs(data.raw["assembling-machine"]) do
	local categories = assembler.crafting_categories or {}
	if flib_table.find(categories, "chemistry") and not flib_table.find(categories, "tiberium-science") then
		table.insert(data.raw["assembling-machine"][name].crafting_categories, "basic-tiberium-science")
		table.insert(data.raw["assembling-machine"][name].crafting_categories, "tiberium-science")
	elseif flib_table.find(categories, "crafting") and not flib_table.find(categories, "basic-tiberium-science") then
		table.insert(data.raw["assembling-machine"][name].crafting_categories, "basic-tiberium-science")
	end
end

-- Fix some research triggers making Tiberium Only worlds unplayable
if settings.startup["tiberium-advanced-start"].value or settings.startup["tiberium-ore-removal"].value then
	local minableResorces = {}
	for resourceName, resourceData in pairs(data.raw.resource) do
		if resourceData.autoplace then  -- Is an autoplace resource
			local autoplaceControl = data.raw["autoplace-control"][resourceName]
			if autoplaceControl and autoplaceControl.category == "resource" then -- That shows up on the resource tab of map gen settings
				if data.raw.planet.nauvis.map_gen_settings.autoplace_settings.entity.settings[resourceName] then -- And is present on Nauvis
					for result in pairs(common.minableResultsTable(resourceData)) do
						minableResorces[result] = true
					end
				end
			end
		end
	end
	for techName, tech in pairs(data.raw.technology) do
		if tech.research_trigger and tech.research_trigger.type == "mine-entity" then
			local resource = tech.research_trigger.entity
			if not string.find(resource, "tiberium") and minableResorces[resource] then
				-- Change the unlock to science pack and copy cost from prereq
				local ingredientCount = 0
				local copyFrom = nil
				for _, prereq in pairs(tech.prerequisites or {}) do
					if data.raw.technology[prereq] and data.raw.technology[prereq].unit then
						local unit = data.raw.technology[prereq].unit
						if flib_table.size(unit.ingredients) > ingredientCount then
							ingredientCount = flib_table.size(unit)
							copyFrom = prereq
						end
					end
				end
				if copyFrom then
					tech.research_trigger = nil
					tech.unit = util.copy(data.raw.technology[copyFrom].unit)
				else
					tech.research_trigger.entity = "tiberium-ore"  -- No prereqs with unit costs, default to mining tiberium
				end
			end
		end
	end
end