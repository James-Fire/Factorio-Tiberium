if mods["Obelisks-of-light"] then
	--Item
	for _, property in pairs({"stack_size", "subgroup", "order"}) do
		data.raw.item["obelisk-of-light"][property] = table.deepcopy(data.raw.item["tiberium-obelisk-of-light"][property])
	end
	data.raw.item["tiberium-obelisk-of-light"].place_result = "obelisk-of-light"
	--Recipes: delete/hide his recipes, duplicate my recipe and update outputs
	for _, property in pairs({"energy_required", "subgroup", "ingredients"}) do
		data.raw.recipe["obelisk-of-light"][property] = table.deepcopy(data.raw.recipe["tiberium-obelisk-of-light"][property])
	end
	data.raw.recipe["tiberium-obelisk-of-light"].hidden = true
	--Tech: delete his tech, update recipe unlocks on my tech
	common.technology.addRecipeUnlock("tiberium-military-2", "obelisk-of-light")
	common.technology.removeRecipeUnlock("tiberium-military-2", "tiberium-obelisk-of-light")
	if data.raw.technology["Obelisks-of-light"] then
		data.raw.technology["Obelisks-of-light"].hidden = true
	end
	for technologyName, _ in pairs(data.raw.technology) do
		if string.sub(technologyName, 1, 22) == "Obelisk-weapons-damage" or string.sub(technologyName, 1, 22) == "Obelisk-Shooting-Speed" then
			data.raw.technology[technologyName].hidden = true --Don't need custom weapon category upgrades since we are using default laser group
		end
	end
	--Entity: Translate his sprites/animations but use my sounds
	data.raw["electric-turret"]["tiberium-obelisk-of-light"].minable.result = "obelisk-of-light"
	for _, name in pairs({"obelisk-nw", "obelisk-ne", "obelisk-se", "obelisk-sw", "obelisk-of-light"}) do
		local turret = data.raw["electric-turret"][name]
		if turret then
			for _, property in pairs({"attack_parameters", "max_health", "collision_box", "selection_box", "energy_source", "map_color", "starting_attack_sound"}) do
				turret[property] = table.deepcopy(data.raw["electric-turret"]["tiberium-obelisk-of-light"][property])
			end
		end
	end
	--Fix offsets, since I overwrote his attack parameters
	data.raw["electric-turret"]["obelisk-nw"].attack_parameters.ammo_type.action.action_delivery.source_offset = {-0.35, -2}
	data.raw["electric-turret"]["obelisk-ne"].attack_parameters.ammo_type.action.action_delivery.source_offset = {0.3, -2}
	data.raw["electric-turret"]["obelisk-se"].attack_parameters.ammo_type.action.action_delivery.source_offset = {0.3, -2}
	data.raw["electric-turret"]["obelisk-sw"].attack_parameters.ammo_type.action.action_delivery.source_offset = {-0.3, -2}
	--sprite scaling
	-- local upscale = 1.4
	-- for _, name in pairs({"obelisk-nw", "obelisk-ne", "obelisk-se", "obelisk-sw"}) do
	-- 	for _, property in pairs({"folded_animation", "preparing_animation", "prepared_animation", "folding_animation", "base_picture", "energy_glow_animation"}) do
	-- 		data.raw["electric-turret"][name][property] = common.scaleUpSprite4Way(data.raw["electric-turret"][name][property], upscale)
	-- 	end
	-- end
end
