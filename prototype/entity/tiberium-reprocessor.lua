-- Crusher cloned from Krastorio 2, but renamed, with different animation speed and crafting category
-- https://mods.factorio.com/mod/Krastorio2
data:extend{
    {
        type = "furnace",
        name = "tiberium-reprocessor",
        icon_size = 64,
        icon = tiberiumInternalName .. "/graphics/icons/crusher.png",
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        minable = {mining_time = 1, result = "tiberium-reprocessor"},
        max_health = 500,
        corpse = "",
        dying_explosion = "big-explosion",
        collision_box = {{-3.25, -3.25}, {3.25, 3.25}},
		selection_box = {{-3.5, -3.5}, {3.5, 3.5}},
		animation = {
			layers = {
				{
					filename = tiberiumInternalName .. "/graphics/entity/crusher/crusher.png",
					priority = "high",
					width = 256,
					height = 256,
					frame_count = 30,
					line_length = 6,
					animation_speed = 0.75 / 4,  -- Crafting speed 8 makes this 8/4 = twice the speed of the K2 animation
					hr_version = {
						filename = tiberiumInternalName .. "/graphics/entity/crusher/hr-crusher.png",
						priority = "high",
						width = 512,
						height = 512,
						frame_count = 30,
						line_length = 6,
						animation_speed = 0.75 / 4,
						scale = 0.5
					}
				},
				{
					filename = tiberiumInternalName .. "/graphics/entity/crusher/crusher-shadow.png",
					priority = "high",
					width = 256,
					height = 256,
					frame_count = 30,
					line_length = 6,
					draw_as_shadow = true,
					hr_version = {
						filename = tiberiumInternalName .. "/graphics/entity/crusher/hr-crusher-shadow.png",
						priority = "high",
						width = 512,
						height = 512,
						frame_count = 30,
						line_length = 6,
						draw_as_shadow = true,
						scale = 0.5
					}
				},
			}
		},
        crafting_categories = {"tiberium-reprocessing"},
		scale_entity_info_icon = true,
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
        working_sound = {
			sound =	{filename = tiberiumInternalName .. "/sound/crusher.ogg", volume = 1.5, speed = 2.0},
			idle_sound = {filename = "__base__/sound/idle1.ogg"},
			apparent_volume = 1.5
        },
		crafting_speed = 8,
		source_inventory_size = 1,
		result_inventory_size = 1,
		return_ingredients_on_change = true,
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input",
			emissions_per_minute = 5 * common.scalePollution(4),
		},
		water_reflection = {
			pictures = {
				filename = tiberiumInternalName .. "/graphics/entity/crusher/crusher-reflection.png",
				priority = "extra-high",
				width = 80,
				height = 60,
				shift = util.by_pixel(0, 40),
				variation_count = 1,
				scale = 5,
			},
			rotate = false,
			orientation_to_variation = false
		},
		energy_usage = "1MW",
		module_specification = {module_slots = 4, module_info_icon_shift = {0, 1.7}, module_info_icon_scale = 1},
		allowed_effects = {"consumption", "speed", "productivity", "pollution"},
    }
}