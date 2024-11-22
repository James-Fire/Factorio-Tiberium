--Sonic Projection Walls
local srf_sprite = {
	layers = {
		{
			filename = tiberiumInternalName.."/graphics/sonic wall/node.png",
			priority = "extra-high",
			frame_count = 1,
			direction_count = 1,
			width = 256,
			height = 384,
			scale = 0.25
		},
		{
			filename = tiberiumInternalName.."/graphics/sonic wall/node shadow.png",
			priority = "extra-high",
			frame_count = 1,
			direction_count = 1,
			width = 512,
			height = 512,
			scale = 0.125,
			draw_as_shadow = true,
			shift = {1, 0}
		}
	}
}

data:extend{
	{
		type = "electric-energy-interface",
		name = "tiberium-srf-emitter",
		icon = tiberiumInternalName.."/graphics/sonic wall/node icon.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation", "not-blueprintable"},
		collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		minable = {mining_time = 0.5, result = "tiberium-srf-emitter"},
		placeable_by = {item = "tiberium-srf-emitter", count = 1},
		max_health = 200,
		repair_speed_modifier = 1.5,
		corpse = "wall-remnants",
		repair_sound = {filename = "__base__/sound/manual-repair-simple.ogg"},
		mined_sound = {filename = "__base__/sound/deconstruct-bricks.ogg"},
		impact_category = "metal",
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
		energy_source = {
			type = "electric",
			buffer_capacity = "5MJ",
			usage_priority = "primary-input",
			input_flow_limit = "1500kW",
			output_flow_limit = "0W",
			drain = "500kW"
		},
		picture = srf_sprite,
		resistances = {
			{
				type = "physical",
				decrease = 3,
				percent = 20
			},
			{
				type = "impact",
				decrease = 45,
				percent = 60
			},
			{
				type = "explosion",
				decrease = 10,
				percent = 30
			},
			{
				type = "fire",
				percent = 30
			},
			{
				type = "laser",
				percent = 80
			},
			{
				type = "tiberium",
				percent = 100
			}
		}
	},
	{
		type = "simple-entity",
		name = "tiberium-srf-wall",
		icon = tiberiumInternalName.."/graphics/sonic wall/wall icon.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation", "not-repairable"},
		subgroup = "remnants",
		order = "a[remnants]",
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		selection_priority = 1,
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		collision_mask = common.makeCollisionMask({}), -- Trying to avoid collisions with other mods using custom collision masks
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				source_effects = {
					type = "play-sound",
					sound = {
						filename = "__base__/sound/spidertron/spidertron-activate.ogg",
						-- "__base__/sound/fight/laser-2.ogg",
						-- "__base__/sound/nightvision-on.ogg",
						-- "__base__/sound/lamp-activate.ogg",
						-- "__base__/sound/spidertron/spidertron-activate.ogg",
						volume = 0.2,
						speed = 1.2,
						aggregation = {
							max_count = 3,
							remove = true,
						},
					},
				},
			},
		},
		pictures = {
			{
				filename = tiberiumInternalName.."/graphics/sonic wall/wall horz.png",
				priority = "extra-high",
				frame_count = 1,
				direction_count = 1,
				width = 256,
				height = 256,
				scale = 0.188
			},
			{
				filename = tiberiumInternalName.."/graphics/sonic wall/wall vert.png",
				priority = "extra-high",
				frame_count = 1,
				direction_count = 1,
				width = 192,
				height = 640,
				scale = 0.125
			},
			{
				filename = tiberiumInternalName.."/graphics/sonic wall/wall cross.png",
				priority = "extra-high",
				frame_count = 1,
				direction_count = 1,
				width = 256,
				height = 640,
				scale = 0.125
			}
		}
	},
	{
		type = "pipe-to-ground",
		name = "tiberium-srf-connector",
		localised_name = {"entity-name.tiberium-srf-emitter"},
		localised_description = {"entity-description.tiberium-srf-emitter"},
		icon = tiberiumInternalName.."/graphics/sonic wall/node icon.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation", "not-deconstructable"},
		collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
		collision_mask = common.makeCollisionMask({"item", "object", "water_tile"}), -- disable collision
		placeable_by = {item = "tiberium-srf-emitter", count = 1},
		fluid_box = {
			filter = "fluid-unknown",
			volume = 1,
			pipe_connections = {
				{
					direction = defines.direction.south,
					position = {0, 0},
					connection_type = "underground",
					max_underground_distance = 16,
				},
				{
					direction = defines.direction.north,
					position = {0, 0},
					connection_type = "underground",
					max_underground_distance = 16,
				},
				{
					direction = defines.direction.east,
					position = {0, 0},
					connection_type = "underground",
					max_underground_distance = 16,
				},
				{
					direction = defines.direction.west,
					position = {0, 0},
					connection_type = "underground",
					max_underground_distance = 16,
				},
			},
		},
		pictures = {
			north = srf_sprite,
			east = srf_sprite,
			south = srf_sprite,
			west = srf_sprite,
		},
	}
}
