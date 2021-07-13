require("scripts/tib-map-gen-presets")  -- After other mods have added their resources as part of the data step

local TibBasicScience = {"chemical-plant", "assembling-machine-1", "assembling-machine-2", "assembling-machine-3"}
local TibScience = {"chemical-plant"}

function applyTiberiumValue(item, value)
	if data.raw.item[item] and not data.raw.item[item].tiberium_multiplier then
		data.raw.item[item].tiberium_multiplier = value
	end
end

-- Orbital Ion Cannon
if mods["Orbital Ion Cannon"] then
	LSlib.technology.addPrerequisite("orbital-ion-cannon", "tiberium-military-2")
	if mods["bobwarfare"] then
		LSlib.recipe.editIngredient("orbital-ion-cannon", "bob-laser-turret-5", "tiberium-ion-core", 1)
	else
		LSlib.recipe.editIngredient("orbital-ion-cannon", "laser-turret", "tiberium-ion-core", 1)
	end
end

if mods["Krastorio2"] then
	-- Define ore values
	applyTiberiumValue("raw-imersite", 8)
	applyTiberiumValue("raw-rare-metals", 8)

	-- Crafting machines
	table.insert(TibBasicScience, "kr-advanced-assembling-machine")
	table.insert(TibBasicScience, "kr-advanced-chemical-plant")
	table.insert(TibScience, "kr-advanced-chemical-plant")
	
	-- Balance changes to match Krastorio
	data.raw["electric-turret"]["tiberium-ion-turret"]["energy_source"]["drain"] = "100kW"
	data.raw["electric-turret"]["tiberium-ion-turret"]["attack_parameters"]["cooldown"] = 30 -- Ion Turret to 2 APS
	data.raw["electric-turret"]["tiberium-ion-turret"]["attack_parameters"]["damage_modifier"] = 12 -- Damage to 120
	
	-- Fix our infinites to match
	local techPairs = {{tib = "tiberium-explosives", copy = "stronger-explosives-7", max_level = 4},
					   {tib = "tiberium-energy-weapons-damage", copy = "energy-weapons-damage-7", max_level = 4},
					   {tib = "tiberium-explosives-5", copy = "stronger-explosives-11", max_level = 9},
					   {tib = "tiberium-energy-weapons-damage-5", copy = "energy-weapons-damage-11", max_level = 9},
					   {tib = "tiberium-explosives-10", copy = "stronger-explosives-16", max_level = "infinite"},
					   {tib = "tiberium-energy-weapons-damage-10", copy = "energy-weapons-damage-16", max_level = "infinite"}}
	
	data.raw["technology"]["tiberium-explosives-5"] = table.deepcopy(data.raw["technology"]["tiberium-explosives"])
	data.raw["technology"]["tiberium-explosives-5"].prerequisites = {"tiberium-explosives"}
	data.raw["technology"]["tiberium-explosives-10"] = table.deepcopy(data.raw["technology"]["tiberium-explosives"])
	data.raw["technology"]["tiberium-explosives-10"].prerequisites = {"tiberium-explosives-5"}
	data.raw["technology"]["tiberium-energy-weapons-damage-5"] = table.deepcopy(data.raw["technology"]["tiberium-energy-weapons-damage"])
	data.raw["technology"]["tiberium-energy-weapons-damage-5"].prerequisites = {"tiberium-energy-weapons-damage"}
	data.raw["technology"]["tiberium-energy-weapons-damage-10"] = table.deepcopy(data.raw["technology"]["tiberium-energy-weapons-damage"])
	data.raw["technology"]["tiberium-energy-weapons-damage-10"].prerequisites = {"tiberium-energy-weapons-damage-5"}
	
	for _, techs in pairs(techPairs) do
		local level, _ = string.gsub(techs.tib, "%D", "")
		level = tonumber(level) or 1
		data.raw["technology"][techs.tib].unit.count_formula = "((L-"..tostring(level - 1)..")^2)*3000"
		data.raw["technology"][techs.tib].name = techs.tib
		data.raw["technology"][techs.tib].max_level = techs.max_level
		
		if not data.raw["technology"][techs.copy] then
			log("missing tech "..techs.copy)
		else
			data.raw["technology"][techs.tib].unit.ingredients = table.deepcopy(data.raw["technology"][techs.copy].unit.ingredients)
			table.insert(data.raw["technology"][techs.tib].unit.ingredients, {"tiberium-science", 1})
			data.raw["technology"][techs.tib].effects = table.deepcopy(data.raw["technology"][techs.copy].effects)
		end
	end
	
	-- Make Krastorio stop removing Tiberium Science Packs from our techs
	local science_pack_incompatibilities = {
			["basic-tech-card"] = true,
			["automation-science-pack"] = true,
			["logistic-science-pack"] = true,
			["military-science-pack"] = true,
			["chemical-science-pack"] = true
		}
	for technology_name, technology in pairs(data.raw.technology) do
		if string.sub(technology_name, 1, 9) == "tiberium-" then
			technology.check_science_packs_incompatibilities = false
			-- Do a version of pack incompatibilities
			local ingredients = technology.unit.ingredients
			if ingredients and #ingredients > 1 then
				local has_space = false
				for i = 1, #ingredients do
					if ingredients[i][1] == "space-science-pack" then
						has_space = true
						break
					end
				end
				if has_space then
					for i = #ingredients, 1, -1 do
						if science_pack_incompatibilities[ingredients[i][1]] then
							table.remove(ingredients, i)
						end
					end
				end
			end
		end
	end
	
	-- Make Tiberium Magazines usable with rifles again
	if krastorio.general.getSafeSettingValue("kr-more-realistic-weapon") then
		LSlib.recipe.editIngredient("tiberium-rounds-magazine", "piercing-rounds-magazine", "rifle-magazine", 1)
	end
	local oldTibRounds = data.raw.ammo["tiberium-rounds-magazine"]
	local newTibRounds = table.deepcopy(data.raw.ammo["uranium-rifle-magazine"])
	if newTibRounds then
		--newTibRounds.icon = oldTibRounds.icon  -- I guess we'll keep the Krastorio icon to blend in
		newTibRounds.name = oldTibRounds.name
		newTibRounds.order = oldTibRounds.order
		newTibRounds.subgroup = "a-items"
		local oldProjectile
		for _, action in pairs(newTibRounds.ammo_type.action[1].action_delivery) do -- This is probably bad, but supporting optionally nested tables is annoying
			if action.type == "projectile" then
				oldProjectile = action.projectile
				action.projectile = "tiberium-ammo"
				break
			end
		end
		data.raw.ammo["tiberium-rounds-magazine"] = newTibRounds
		-- Update projectile to do Tiberium damage
		if oldProjectile then
			local tibProjectile = table.deepcopy(data.raw.projectile[oldProjectile])
			tibProjectile.name = "tiberium-ammo"
			local tibRoundsDamage = 0
			for _, effect in pairs(tibProjectile.action.action_delivery.target_effects) do
				if effect.type == "damage" then
					tibRoundsDamage = tibRoundsDamage + effect.damage.amount
					effect.damage.amount = 0
				end
			end
			table.insert(tibProjectile.action.action_delivery.target_effects, {type = "damage", damage = {amount = tibRoundsDamage, type = "tiberium"}})
			data.raw.projectile["tiberium-ammo"] = tibProjectile
		end
	end
end

if mods["MoreScience"] then
	for techName, techData in pairs(data.raw.technology) do
		if string.sub(techName, 1, 9) == "tiberium-" then
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
	omni.matter.add_ignore_resource("tiberium-ore")
    omni.matter.add_ignore_resource("tibGrowthNode")
    omni.matter.add_ignore_resource("tibNode_tree")
	LSlib.recipe.editIngredient("tiberium-spike", "pumpjack", "offshore-pump", 1)
end

if mods["pypetroleumhandling"] then
	-- Move Liquid Tiberium recipe to Reformer
	LSlib.recipe.setCraftingCategory("tiberium-liquid-processing", "reformer")
	-- Move both Molten Tiberium recipes to Light Oil Refinery
	LSlib.recipe.setCraftingCategory("tiberium-molten-processing", "lor")
	LSlib.recipe.setCraftingCategory("tiberium-advanced-molten-processing", "lor")
end

if mods["IndustrialRevolution"] then
	if data.raw["assembling-machine"]["oil-refinery"] then
	    data.raw["assembling-machine"]["oil-refinery"].fixed_recipe = nil
	    data.raw["assembling-machine"]["oil-refinery"].show_recipe_icon = true
	end
end

if mods["angelspetrochem"] then	
	table.insert(TibBasicScience, "angels-chemical-plant")
	table.insert(TibBasicScience, "angels-chemical-plant-2")
	table.insert(TibBasicScience, "angels-chemical-plant-3")
	table.insert(TibBasicScience, "angels-chemical-plant-4")
	table.insert(TibBasicScience, "advanced-chemical-plant")
	table.insert(TibBasicScience, "advanced-chemical-plant-2")
	
	table.insert(TibScience, "angels-chemical-plant")
	table.insert(TibScience, "angels-chemical-plant-2")
	table.insert(TibScience, "angels-chemical-plant-3")
	table.insert(TibScience, "angels-chemical-plant-4")
	table.insert(TibScience, "advanced-chemical-plant")
	table.insert(TibScience, "advanced-chemical-plant-2")
	-- Replace the vanilla Chemical Plant with one of Angel's, cause apparently it's too hard to simply use the vanilla one.
	LSlib.recipe.editIngredient("tiberium-power-plant", "chemical-plant", "angels-chemical-plant-2", 1)
end

if mods["bobassembly"] then
	table.insert(TibBasicScience, "chemical-plant-2")
	table.insert(TibBasicScience, "chemical-plant-3")
	table.insert(TibBasicScience, "chemical-plant-4")
	
	table.insert(TibBasicScience, "assembling-machine-4")
	table.insert(TibBasicScience, "assembling-machine-5")
	table.insert(TibBasicScience, "assembling-machine-6")
	
	table.insert(TibScience, "chemical-plant-2")
	table.insert(TibScience, "chemical-plant-3")
	table.insert(TibScience, "chemical-plant-4")
end

for _, assembler in pairs(TibBasicScience) do
	LSlib.entity.addCraftingCategory("assembling-machine", assembler, "basic-tiberium-science")
end
for _, assembler in pairs(TibScience) do
	LSlib.entity.addCraftingCategory("assembling-machine", assembler, "tiberium-science")
end

if mods["bobores"] then
	applyTiberiumValue("thorium-ore", 8)
end

if mods["dark-matter-replicators-18"] then
	applyTiberiumValue("dmr18-tenemut", 32)
end

if mods["dark-matter-replicators-18-patch"] then
	applyTiberiumValue("tenemut", 32)
end

if mods["bobplates"] then
	if data.raw.item["gas-canister"] then
		data.raw.item["gas-canister"].tiberium_empty_barrel = true
	end
end

if mods["Obelisks-of-light"] then
	--Item
	for _, name in pairs({"obelisk-left", "obelisk-right"}) do
		for _, property in pairs({"stack_size", "subgroup", "order"}) do
			data.raw.item[name][property] = table.deepcopy(data.raw.item["tiberium-obelisk-of-light"][property])
		end
	end
	data.raw.item["tiberium-obelisk-of-light"].place_result = "obelisk-right"
	--Recipes: delete/hide his recipes, duplicate my recipe and update outputs
	for _, name in pairs({"obelisk-left", "obelisk-right"}) do
		for _, property in pairs({"energy_required", "subgroup", "ingredients"}) do
			data.raw.recipe[name][property] = table.deepcopy(data.raw.recipe["tiberium-obelisk-of-light"][property])
		end
	end
	data.raw.recipe["tiberium-obelisk-of-light"].hidden = true
	for _, side in pairs({"left", "right"}) do
		local recipe = table.deepcopy(data.raw.recipe["obelisk-"..side])
		recipe.name = "obelisk-flip-to-"..side
		recipe.energy_required = 0.1
		recipe.order = "f[tiberium-obelisk-of-light]-b[flipped]"
		recipe.ingredients = {{"obelisk-"..((side == "left") and "right" or "left"), 1}}
		data.raw.recipe["obelisk-flip-to-"..side] = recipe
	end
	--Tech: delete his tech, update recipe unlocks on my tech
	LSlib.technology.addRecipeUnlock("tiberium-military-2", "obelisk-left")
	LSlib.technology.addRecipeUnlock("tiberium-military-2", "obelisk-right")
	LSlib.technology.addRecipeUnlock("tiberium-military-2", "obelisk-flip-to-left")
	LSlib.technology.addRecipeUnlock("tiberium-military-2", "obelisk-flip-to-right")
	LSlib.technology.removeRecipeUnlock("tiberium-military-2", "tiberium-obelisk-of-light")
	LSlib.technology.setHidden("Obelisks-of-light")
	--Entity: Translate his sprites/animations but use my sounds
	data.raw["electric-turret"]["tiberium-obelisk-of-light"].minable.result = "obelisk-right"
	for _, name in pairs({"obelisk-left", "obelisk-right"}) do
		for _, property in pairs({"attack_parameters", "max_health", "collision_box", "selection_box", "energy_source", "map_color", "starting_attack_sound"}) do
			data.raw["electric-turret"][name][property] = table.deepcopy(data.raw["electric-turret"]["tiberium-obelisk-of-light"][property])
		end
	end
	data.raw["electric-turret"]["obelisk-left"].attack_parameters.ammo_type.action.action_delivery.source_offset = {-0.4, -2.1}
	data.raw["electric-turret"]["obelisk-right"].attack_parameters.ammo_type.action.action_delivery.source_offset = {0.6, -2.1}
	--sprite scaling
	local upscale = 1.4
	for _, name in pairs({"obelisk-left", "obelisk-right"}) do
		for _, property in pairs({"folded_animation", "preparing_animation", "prepared_animation", "folding_animation", "base_picture", "energy_glow_animation"}) do
			data.raw["electric-turret"][name][property] = common.scaleUpSprite4Way(data.raw["electric-turret"][name][property], upscale)
		end
	end
end

-- Below code isn't specific to any single mod
for _, drill in pairs(data.raw["mining-drill"]) do
	if LSlib.utils.table.hasValue(drill.resource_categories, "basic-solid") then
		table.insert(drill.resource_categories, "basic-solid-tiberium")
	end
end

-- Add Tiberium resistance to armors
for name, armor in pairs(data.raw.armor) do
	if (name ~= "tiberium-armor") and (name ~= "tiberium-power-armor") then
		for _, resistance in pairs (armor.resistances or {}) do
			if resistance.type == "acid" then
				table.insert(armor.resistances, {type= "tiberium", decrease = resistance.decrease, percent = resistance.percent})
			end
		end
	end
end

if data.raw.resource["uranium-ore"] then  -- Desaturate uranium map color to make it not look like Tiberium
	data.raw.resource["uranium-ore"]["map_color"] = {0.0, 0.5, 0.0}
	applyTiberiumValue("uranium-ore", 8)
end

-- Flag any item as being convertible to sludge for centrifuging recipes by setting the tiberium_sludge property to true
if data.raw.item.stone then
	data.raw.item.stone.tiberium_sludge = true
end

-- Flag items as empty barrels for detecting un-barreling recipes in data-final-fixes
if data.raw.item["empty-barrel"] then
	data.raw.item["empty-barrel"].tiberium_empty_barrel = true
end
