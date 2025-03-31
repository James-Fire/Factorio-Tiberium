if mods["Krastorio2"] then
	-- Define ore values
	common.applyTiberiumValue("raw-imersite", 8)
	common.applyTiberiumValue("raw-rare-metals", 8)

	-- Fix our infinites to match
	local techPairs = {
		{tib = "tiberium-explosives", copy = "stronger-explosives-7", max_level = 4},
		{tib = "tiberium-energy-weapons-damage", copy = "laser-weapons-damage-7", max_level = 4},
		{tib = "tiberium-explosives-5", copy = "stronger-explosives-11", max_level = 9},
		{tib = "tiberium-energy-weapons-damage-5", copy = "laser-weapons-damage-11", max_level = 9},
		{tib = "tiberium-explosives-10", copy = "stronger-explosives-16", max_level = "infinite"},
		{tib = "tiberium-energy-weapons-damage-10", copy = "laser-weapons-damage-16", max_level = "infinite"}
	}

	data.raw["technology"]["tiberium-explosives-5"] = util.copy(data.raw["technology"]["tiberium-explosives"])
	data.raw["technology"]["tiberium-explosives-5"].prerequisites = {"tiberium-explosives"}
	data.raw["technology"]["tiberium-explosives-10"] = util.copy(data.raw["technology"]["tiberium-explosives"])
	data.raw["technology"]["tiberium-explosives-10"].prerequisites = {"tiberium-explosives-5"}
	data.raw["technology"]["tiberium-energy-weapons-damage-5"] = util.copy(data.raw["technology"]["tiberium-energy-weapons-damage"])
	data.raw["technology"]["tiberium-energy-weapons-damage-5"].prerequisites = {"tiberium-energy-weapons-damage"}
	data.raw["technology"]["tiberium-energy-weapons-damage-10"] = util.copy(data.raw["technology"]["tiberium-energy-weapons-damage"])
	data.raw["technology"]["tiberium-energy-weapons-damage-10"].prerequisites = {"tiberium-energy-weapons-damage-5"}

	for _, techs in pairs(techPairs) do
		local level = tonumber(string.gsub(techs.tib, "%D", "")) or 1
		data.raw["technology"][techs.tib].unit.count_formula = "((L-"..tostring(level - 1)..")^2)*3000"
		data.raw["technology"][techs.tib].name = techs.tib
		data.raw["technology"][techs.tib].max_level = techs.max_level

		if not data.raw["technology"][techs.copy] then
			log("missing tech "..techs.copy)
		else
			data.raw["technology"][techs.tib].unit.ingredients = util.copy(data.raw["technology"][techs.copy].unit.ingredients)
			table.insert(data.raw["technology"][techs.tib].unit.ingredients, {"tiberium-science", 1})
			data.raw["technology"][techs.tib].effects = util.copy(data.raw["technology"][techs.copy].effects)
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
		common.recipe.editIngredient("tiberium-rounds-magazine", "piercing-rounds-magazine", "rifle-magazine")
	end
	local oldTibRounds = data.raw.ammo["tiberium-rounds-magazine"]
	local newTibRounds = util.copy(data.raw.ammo["uranium-rifle-magazine"])
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
			local tibProjectile = util.copy(data.raw.projectile[oldProjectile])
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
