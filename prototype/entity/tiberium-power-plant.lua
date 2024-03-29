data:extend{
	{
		type = "generator",
		name = "tiberium-power-plant",
		icon = tiberiumInternalName.."/graphics/icons/td-power-plant.png",
		icon_size = 64,
		flags = {"placeable-neutral","placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "tiberium-power-plant"},
		max_health = 500,
		corpse = "big-remnants",
		dying_explosion = "big-explosion",
		max_power_output = (200 / 60) .. "MJ",
		effectivity = 2,
		fluid_usage_per_tick = 8 / 60,
		maximum_temperature = 1000,
		burns_fluid = true,
		scale_fluid_usage = true,
		collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
		selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
		drawing_box = {{-2.5, -2.5}, {2.5, 2.5}},
		energy_source = {
			type = "electric",
			usage_priority = "secondary-output",
		},
		horizontal_animation = {
			filename = tiberiumInternalName.."/graphics/entity/tiberium-power-plant/power-plant-256.png",
			width = 256,
			height = 256,
			scale = 0.70,
		},
		vertical_animation = {
			filename = tiberiumInternalName.."/graphics/entity/tiberium-power-plant/power-plant-256.png",
			width = 256,
			height = 256,
			scale = 0.70,
		},
		vehicle_impact_sound =	{filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		working_sound = {
			sound = {
				{
					filename = "__base__/sound/steam-turbine.ogg",
					volume = 0.8
				}
			},
			idle_sound = {filename = "__base__/sound/idle1.ogg", volume = 0.6},
			apparent_volume = 1.5
		},
		smoke = {
			{
				east_position = {-1.2, -1.6},
				frequency = 0.3125,
				name = "turbine-smoke",
				north_position = {-1.2, -1.5},
				slow_down_factor = 1,
				starting_frame_deviation = 60,
				starting_vertical_speed = 0.08
			}
		},
		fluid_box = {
			base_area = 4,
			pipe_connections = {
				{type = "input-output", position = {0, 3}},
				{type = "input-output", position = {0, -3}},
				{type = "input-output", position = {3, 0}},
				{type = "input-output", position = {-3, 0}},
			},
			filter = "liquid-tiberium",
			production_type = "input-output",
			pipe_covers = pipecoverspictures(),
		},
	}
}
