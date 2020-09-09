require("scripts/tib-map-gen-presets")  -- After other mods have added their resources as part of the data step

--Orbital Ion Cannon
if mods["Orbital Ion Cannon"] then
	LSlib.technology.addPrerequisite("orbital-ion-cannon", "tiberium-military-2")
	if mods["bobwarfare"] then
		LSlib.recipe.editIngredient("orbital-ion-cannon", "bob-laser-turret-5", "tiberium-ion-core", 1)
	else
		LSlib.recipe.editIngredient("orbital-ion-cannon", "laser-turret", "tiberium-ion-core", 1)
	end
end

if mods["Krastorio2"] then
	-- Balance changes to match Krastorio
	data.raw["electric-turret"]["ion-turret"]["energy_source"]["drain"] = "100kW"
	data.raw["electric-turret"]["ion-turret"]["attack_parameters"]["cooldown"] = 30 -- Ion Turret to 2 APS
	data.raw["electric-turret"]["ion-turret"]["attack_parameters"]["damage_modifier"] = 12 -- Damage to 120
	
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
			if (techName ~= "tiberium-mechanical-research") and (techName ~= "tiberium-separation-tech")
					and (techName ~= "tiberium-military-1") and (techName ~= "tiberium-thermal-research") then
				table.insert(techData.unit.ingredients, {"electric-power-science-pack", 1})
			end
			if (techName ~= "tiberium-mechanical-research") and (techName ~= "tiberium-separation-tech") then
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
	LSlib.recipe.editIngredient("tib-spike", "pumpjack", "offshore-pump", 1)
end

local TibBasicScience = {"chemical-plant", "assembling-machine-1", "assembling-machine-2", "assembling-machine-3"}
local TibScience = {"chemical-plant"}

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
	--Replace the vanilla Chemical Plant with one of Angel's, cause apparently it's too hard to simply use the vanilla one.
	LSlib.recipe.editIngredient("tiberium-plant", "chemical-plant", "angels-chemical-plant-2", 1)
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

-- Below code isn't specific to any single mod

--[[if (mods["Mining_Drones"]) then
	data.raw["assembling-machine"][names.mining_depot].animation = make_4way_animation_from_spritesheet{
    {
      layers =
      {
        {
          filename = tiberiumInternalName.."/graphics/entity/Refinery/Refinery.png",
          width = 450,
          height = 450,
          frame_count = 1,
          --shift = {2.515625, 0.484375},
          hr_version =
          {
            filename = tiberiumInternalName.."/graphics/entity/Refinery/Refinery.png",
            width = 450,
			height = 450,
            frame_count = 1,
          --  shift = util.by_pixel(0, -7.5),
            scale = 0.5
          }
        },
        {
          filename = tiberiumInternalName.."/graphics/entity/Refinery/RefineryShadow.png",
          width = 450,
          height = 450,
          frame_count = 1,
         -- shift = util.by_pixel(82.5, 26.5),
          draw_as_shadow = true,
          hr_version =
          {
            filename = tiberiumInternalName.."/graphics/entity/Refinery/RefineryShadow.png",
			width = 450,
			height = 450,
            frame_count = 1,
           -- shift = util.by_pixel(82.5, 26.5),
            draw_as_shadow = true,
            force_hr_shadow = true,
            scale = 0.5
          }
        }
      }
    }
	}
	--data.raw["unit"][bot_name].icon = 
end]]

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
