data:extend{
	{
		type = "mining-drill",
		name = "tiberium-detonation-charge",
		icon = "__base__/graphics/icons/crash-site-chest.png",
		icon_mipmaps = 4,
		icon_size = 64,
		flags = {"placeable-neutral", "player-creation"},
		minable = {mining_time = 1, result = "tiberium-detonation-charge"},
		placeable_by = {count = 1, item = "tiberium-detonation-charge"},
		animations = {
			north = {
				layers = {
					{
						filename = "__base__/graphics/entity/crash-site-chests/crash-site-chest-1.png",
						height = 39,
						width = 61,
						priority = "extra-high",
						shift = {0.0625, 0.25},
						hr_version = {
							filename = "__base__/graphics/entity/crash-site-chests/hr-crash-site-chest-1.png",
							height = 76,
							width = 120,
							priority = "extra-high",
							scale = 0.5,
							shift = {0.0625, 0.25},
						},
					},
					{
						draw_as_shadow = true,
						filename = "__base__/graphics/entity/crash-site-chests/crash-site-chest-1-shadow.png",
						height = 67,
						width = 99,
						priority = "extra-high",
						shift = {-0.25, 0.0625},
						hr_version = {
							draw_as_shadow = true,
							filename = "__base__/graphics/entity/crash-site-chests/hr-crash-site-chest-1-shadow.png",
							height = 128,
							width = 210,
							priority = "extra-high",
							scale = 0.5,
							shift = {-0.0625, 0.09375},
						},
					}
				}
		  }
		},
		vector_to_place_result = {0, 0},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		collision_mask = {"water-tile", "player-layer"},
		corpse = "medium-scorchmark",
		dying_explosion = "medium-explosion",
		create_ghost_on_death = false,
		mining_speed = 1,
		energy_usage = "1W",
		energy_source = {type = "void"},
		resource_categories = {"advanced-liquid-tiberium", "advanced-solid-tiberium"},
		resource_searching_radius = 0.49,
		order = "g[tiberium-spike]",
		subgroup = "a-buildings",
	}
}