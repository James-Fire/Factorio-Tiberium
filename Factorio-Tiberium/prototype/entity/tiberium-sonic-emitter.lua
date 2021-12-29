local sonic_sprite = {
	layers = {
		{
			filename = tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png",
			priority = "extra-high",
			frame_count = 1,
			axially_symmetrical = false,
			direction_count = 1,
			width = 128,
			height = 128,
			scale = 0.65,
			shift = {-0.1, -0.5},
		},
		{
			direction_count = 1,
			draw_as_shadow = true,
			filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
			frame_count = 1,
			height = 42,
			hr_version = {
				direction_count = 1,
				draw_as_shadow = true,
				filename = "__base__/graphics/entity/laser-turret/hr-laser-turret-base-shadow.png",
				frame_count = 1,
				height = 82,
				line_length = 1,
				scale = 0.5,
				shift = {
				0.1875,
				0.09375
				},
				width = 132
			},
			line_length = 1,
			shift = {
				0.1875,
				0.09375
			},
			width = 66
		},
		{
			direction_count = 1,
			draw_as_shadow = true,
			filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting-shadow.png",
			frame_count = 1,
			height = 46,
			hr_version = {
			direction_count = 1,
			draw_as_shadow = true,
			filename = "__base__/graphics/entity/laser-turret/hr-laser-turret-shooting-shadow.png",
			frame_count = 1,
			height = 92,
			line_length = 8,
			scale = 0.5,
			shift = {
				1.578125,
				0.078125
			},
			width = 170
			},
			line_length = 8,
			shift = {
			1.59375,
			0.0625
			},
			width = 86
		},
		-- {
		-- 	filename = tiberiumInternalName.."/graphics/sonic wall/node shadow.png",
		-- 	priority = "extra-high",
		-- 	frame_count = 1,
		-- 	axially_symmetrical = false,
		-- 	direction_count = 1,
		-- 	width = 512,
		-- 	height = 512,
		-- 	scale = 0.125,
		-- 	draw_as_shadow = true,
		-- 	shift = {1, 0}
		-- }
	}
}

data:extend{
	{
		type = "assembling-machine",
		name = "tiberium-sonic-emitter-am",
		icon = tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png",
		icon_size = 128,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "tiberium-sonic-emitter"},
		max_health = 250,
		corpse = "flamethrower-turret-remnants",
		dying_explosion = "medium-explosion",
		energy_usage = "1kW",
		crafting_speed = 1,
		fixed_recipe = "tiberium-shatter",
		allowed_effects = {"speed", "consumption"},
		open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.85},
		close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.75},
		working_sound = {
			sound = {
				{
					filename = tiberiumInternalName.."/sound/Accelerator.ogg",
					volume = 1
				}
			},
			audible_distance_modifier = 0.33,
			max_sounds_per_type = 3,
			match_speed_to_activity = true
		},
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		resistances = {
			{
				type = "fire",
				percent = 90
			},
			{
				type = "tiberium",
				percent = 100
			}
		},
		collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
		selection_box = {{-1, -1}, {1, 1}},
		always_draw_idle_animation = true,
		animation = {
			layers = {
				{
					blend_mode = "additive",
					filename = "__base__/graphics/entity/centrifuge/centrifuge-C-light.png",
					frame_count = 64,
					height = 104,
					hr_version = {
						blend_mode = "additive",
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-light.png",
						frame_count = 64,
						height = 207,
						line_length = 8,
						priority = "high",
						scale = 0.5,
						width = 190
					},
					line_length = 8,
					priority = "high",
					width = 96
				},
			},
		},
		idle_animation = {
			layers = {
				acceleratorSprite,
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-C-shadow.png",
					draw_as_shadow = true,
					priority = "high",
					line_length = 8,
					width = 132,
					height = 74,
					frame_count = 64,
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-shadow.png",
						draw_as_shadow = true,
						priority = "high",
						scale = 0.5,
						line_length = 8,
						width = 279,
						height = 152,
						frame_count = 64,
					}
				},
			},
		},
		circuit_wire_max_distance = 7.5,
		circuit_wire_connection_point = {
			shadow = {
				red = {0.56, -0.6},
				green = {0.26, -0.6}
			},
			wire = {
				red = {0.16, -0.9},
				green = {-0.16, -0.9}
			}
		},
		crafting_categories = {"growth"},
		energy_source =	{
			type = "void",
			emissions_per_minute = 2,
		},
	},
	{
		type = "electric-energy-interface",
		name = "tiberium-sonic-emitter",
		icons = common.layeredIcons(tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png", 128,
				tiberiumInternalName.."/graphics/icons/tiberium-ore.png", 64, "ne", 12),
		flags = {"placeable-neutral", "player-creation", "not-blueprintable"},
		collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
		selection_box = {{-1, -1}, {1, 1}},
		minable = {mining_time = 0.5, result = "tiberium-sonic-emitter"},
		max_health = 250,
		corpse = "laser-turret-remnants",
		dying_explosion = "laser-turret-explosion",
		working_sound =	{
			sound = {
			  filename = "__base__/sound/substation.ogg",
			  volume = 0.4
			},
			idle_sound = {
			  filename = "__base__/sound/accumulator-idle.ogg",
			  volume = 0.4
			},
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			fade_in_ticks = 30,
			fade_out_ticks = 40,
			use_doppler_shift = false
		},
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		energy_source = {
			type = "electric",
			buffer_capacity = "2MJ",
			usage_priority = "secondary-input",
			input_flow_limit = "1200kW",
			output_flow_limit = "0W",
			drain = "200kW"
		},
		picture = sonic_sprite,
		resistances = {
			{
				type = "fire",
				percent = 90
			},
			{
				type = "tiberium",
				percent = 100
			}
		},
		radius_visualisation_specification = {
			sprite = {
				filename = "__core__/graphics/shoot-cursor-green.png",
				height = 183,
				width = 258,
			},
			distance = 15, --Need to scale this beyond the range because the circle in the sprite doesn't reach the edge
		},
	},
	{
		type = "fish",
		name = "tiberium-target-dummy",
		flags = {"hidden", "placeable-off-grid", "placeable-neutral"},
		icon = common.blankPicture.filename,
		icon_size = 1,
		pictures = {common.blankPicture},
	},
}

local emitterBlue = flib.copy_prototype(data.raw["electric-energy-interface"]["tiberium-sonic-emitter"], "tiberium-sonic-emitter-blue")
emitterBlue.icons = common.layeredIcons(tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png", 128,
		tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png", 64, "ne", 12)
-- {
-- 	{
-- 		icon  = tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png",
-- 		icon_size = 128,
-- 	},
-- 	{
-- 		icon = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png",
-- 		icon_size = 64,
-- 		icon_mipmaps = 4,
-- 		scale = 0.5,
-- 		shift = {0.25 * 128, 0.25 * 128},
-- 	},
-- }
-- emitterBlue.icon = nil
-- emitterBlue.icon_size = nil

data:extend{emitterBlue}