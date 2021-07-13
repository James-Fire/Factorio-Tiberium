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
