data:extend{
	{
		type = "fire",
		name = "tiberium-chemical-sprayer-flame",
		add_fuel_cooldown = 10,
		burnt_patch_alpha_default = 0.4,
		burnt_patch_alpha_variations = {
			{
				alpha = 0.26000000000000001,
				tile = "stone-path"
			},
			{
				alpha = 0.23999999999999999,
				tile = "concrete"
			}
		},
		burnt_patch_lifetime = 1800,
		burnt_patch_pictures = {
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 0,
				y = 0
			},
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 115,
				y = 0
			},
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 230,
				y = 0
			},
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 0,
				y = 56
			},
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 115,
				y = 56
			},
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 230,
				y = 56
			},
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 0,
				y = 112
			},
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 115,
				y = 112
			},
			{
				filename = "__base__/graphics/entity/fire-flame/burnt-patch.png",
				height = 56,
				width = 115,
				x = 230,
				y = 112
			}
		},
		damage_multiplier_decrease_per_tick = 0.005,
		damage_multiplier_increase_per_added_fuel = 1,
		damage_per_tick = {
			amount = 0.3,
			type = "tiberium"
		},
		delay_between_initial_flames = 10,
		emissions_per_second = 0.005,
		fade_in_duration = 30,
		fade_out_duration = 30,
		flags = {
			"placeable-off-grid",
			"not-on-map"
		},
		flame_alpha = 0.35,
		flame_alpha_deviation = 0.05,
		initial_lifetime = 120,
		lifetime_increase_by = 150,
		lifetime_increase_cooldown = 4,
		light = {
			intensity = 1,
			size = 20
		},
		maximum_damage_multiplier = 6,
		maximum_lifetime = 1800,
		maximum_spread_count = 100,
		pictures = {
			{
				animation_speed = 1,
				axially_symmetrical = false,
				blend_mode = "normal",
				direction_count = 1,
				filename = tiberiumInternalName.."/graphics/entity/chemsprayer-stream/fire-flame-13.png",
				frame_count = 25,
				height = 118,
				line_length = 8,
				scale = 0.5,
				shift = {
					-0.01953125,
					-0.453125
				},
				tint = {
					a = 1,
					b = 1,
					g = 1,
					r = 1
				},
				width = 60
			},
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-12.png",
			-- 	frame_count = 25,
			-- 	height = 116,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		-0.0078125,
			-- 		-0.45703250000000004
			-- 	},
			-- 	tint = 0,
			-- 	width = 63
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-11.png",
			-- 	frame_count = 25,
			-- 	height = 122,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		-0.00390625,
			-- 		-0.453125
			-- 	},
			-- 	tint = 0,
			-- 	width = 61
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-10.png",
			-- 	frame_count = 25,
			-- 	height = 108,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		-0.03125,
			-- 		-0.32422
			-- 	},
			-- 	tint = 0,
			-- 	width = 65
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-09.png",
			-- 	frame_count = 25,
			-- 	height = 101,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		-0.015625,
			-- 		-0.3476575
			-- 	},
			-- 	tint = 0,
			-- 	width = 64
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-08.png",
			-- 	frame_count = 32,
			-- 	height = 98,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		-0.02734375,
			-- 		-0.38672000000000001
			-- 	},
			-- 	tint = 0,
			-- 	width = 50
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-07.png",
			-- 	frame_count = 32,
			-- 	height = 84,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		0.0078125,
			-- 		-0.3203125
			-- 	},
			-- 	tint = 0,
			-- 	width = 54
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-06.png",
			-- 	frame_count = 32,
			-- 	height = 92,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		0,
			-- 		-0.41797000000000004
			-- 	},
			-- 	tint = 0,
			-- 	width = 65
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-05.png",
			-- 	frame_count = 32,
			-- 	height = 103,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		0.015625,
			-- 		-0.44140750000000004
			-- 	},
			-- 	tint = 0,
			-- 	width = 59
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-04.png",
			-- 	frame_count = 32,
			-- 	height = 130,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		0.0078125,
			-- 		-0.5546875
			-- 	},
			-- 	tint = 0,
			-- 	width = 67
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-03.png",
			-- 	frame_count = 32,
			-- 	height = 117,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		0.0234375,
			-- 		-0.4921875
			-- 	},
			-- 	tint = 0,
			-- 	width = 74
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-02.png",
			-- 	frame_count = 32,
			-- 	height = 114,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		0.00390625,
			-- 		-0.484375
			-- 	},
			-- 	tint = 0,
			-- 	width = 74
			-- },
			-- {
			-- 	animation_speed = 1,
			-- 	axially_symmetrical = false,
			-- 	blend_mode = "normal",
			-- 	direction_count = 1,
			-- 	filename = "__base__/graphics/entity/fire-flame/fire-flame-01.png",
			-- 	frame_count = 32,
			-- 	height = 119,
			-- 	line_length = 8,
			-- 	scale = 0.5,
			-- 	shift = {
			-- 		-0.03515625,
			-- 		-0.51953249999999995
			-- 	},
			-- 	tint = 0,
			-- 	width = 66
			-- }
		},
		spawn_entity = "fire-flame-on-tree",
		spread_delay = 300,
		spread_delay_deviation = 180,
		working_sound = {
			match_volume_to_activity = true,
			sound = {
				{
					filename = "__base__/sound/fire-1.ogg",
					volume = 0.7
				},
				{
					filename = "__base__/sound/fire-2.ogg",
					volume = 0.7
				}
			}
		}
	}
}
