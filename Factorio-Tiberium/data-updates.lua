require("scripts/tib-map-gen-presets")  -- After other mods have added their resources as part of the data step

require("scripts/compatibility/bobsmods")
require("scripts/compatibility/Krastorio2")
require("scripts/compatibility/Obelisks-of-light")

-- Orbital Ion Cannon
if mods["Orbital Ion Cannon"] or mods["Kux-OrbitalIonCannon"] then
	LSlib.technology.addPrerequisite("orbital-ion-cannon", "tiberium-military-2")
	if mods["bobwarfare"] then
		LSlib.recipe.editIngredient("orbital-ion-cannon", "bob-laser-turret-5", "tiberium-ion-core", 1)
		LSlib.technology.removePrerequisite("orbital-ion-cannon", "bob-laser-turrets-5")
	else
		LSlib.recipe.editIngredient("orbital-ion-cannon", "laser-turret", "tiberium-ion-core", 1)
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
	-- Replace the vanilla Chemical Plant with one of Angel's, because apparently it's too hard to simply use the vanilla one.
	LSlib.recipe.editIngredient("tiberium-power-plant", "chemical-plant", "angels-chemical-plant-2", 1)
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
end

if mods["RampantResources"] then
	for _, name in pairs({"tiberium-ore", "tiberium-ore-blue", "tibGrowthNode", "tibGrowthNode_infinite"}) do
		data.raw.resource[name].exclude_from_rampant_resources = true
	end
end

-- Below code isn't specific to any single mod
table.insert(data.raw.character.character.mining_categories, "basic-solid-tiberium")

for _, drill in pairs(data.raw["mining-drill"]) do
	if LSlib.utils.table.hasValue(drill.resource_categories, "basic-solid") then
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
if data.raw.item["empty-barrel"] then
	data.raw.item["empty-barrel"].tiberium_empty_barrel = true
end

-- Enable Tiberium Science recipes at all assemblers that meet certain category requirements
for name, assembler in pairs(data.raw["assembling-machine"]) do
	local categories = assembler.crafting_categories or {}
	if LSlib.utils.table.hasValue(categories, "chemistry") and not LSlib.utils.table.hasValue(categories, "tiberium-science") then
		LSlib.entity.addCraftingCategory("assembling-machine", name, "basic-tiberium-science")
		LSlib.entity.addCraftingCategory("assembling-machine", name, "tiberium-science")
	elseif LSlib.utils.table.hasValue(categories, "crafting") and not LSlib.utils.table.hasValue(categories, "basic-tiberium-science") then
		LSlib.entity.addCraftingCategory("assembling-machine", name, "basic-tiberium-science")
	end
end
