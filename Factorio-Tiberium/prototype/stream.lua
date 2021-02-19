data:extend{
	{
		type = "stream",
		name = "tiberium-chemical-sprayer-stream",
		action = {
			{
				action_delivery = {
					target_effects = {
						{
							show_in_tooltip = true,
							sticker = "tiberium-fire-sticker",
							type = "create-sticker"
						},
						{
							apply_damage_to_trees = false,
							damage = {
								amount = 5,
								type = "tiberium"
							},
							type = "damage"
						}
					},
					type = "instant"
				},
				radius = 2.5,
				type = "area"
			},
			{
				action_delivery = {
					target_effects = {
						{
							entity_name = "tiberium-chemical-sprayer-flame",
							show_in_tooltip = true,
							type = "create-fire"
						}
					},
					type = "instant"
				},
				type = "direct"
			}
		},
		flags = {
			"not-on-map"
		},
		ground_light = {
			intensity = 0.8,
			size = 4
		},
		particle = {
			filename = tiberiumInternalName.."/graphics/entity/chemsprayer-stream/flamethrower-explosion.png",
			frame_count = 32,
			height = 64,
			line_length = 8,
			priority = "extra-high",
			width = 64
		},
		particle_buffer_size = 90,
		particle_end_alpha = 1,
		particle_fade_out_threshold = 0.9,
		particle_horizontal_speed = 0.22500000000000004,
		particle_horizontal_speed_deviation = 0.0035,
		particle_loop_exit_threshold = 0.25,
		particle_loop_frame_count = 3,
		particle_spawn_interval = 2,
		particle_spawn_timeout = 8,
		particle_start_alpha = 0.5,
		particle_start_scale = 0.2,
		particle_vertical_acceleration = 0.003,
		shadow = {
			filename = "__base__/graphics/entity/acid-projectile/projectile-shadow.png",
			frame_count = 33,
			height = 16,
			line_length = 5,
			priority = "high",
			shift = {
				-0.09,
				0.39500000000000002
			},
			width = 28
		},
		-- smoke_sources = {
		--	 {
		--		 frequency = 0.05,
		--		 name = "soft-fire-smoke",
		--		 position = {
		--			 0,
		--			 0
		--		 },
		--		 starting_frame_deviation = 60
		--	 }
		-- },
		spine_animation = {
			animation_speed = 2,
			axially_symmetrical = false,
			blend_mode = "additive",
			direction_count = 1,
			filename = tiberiumInternalName.."/graphics/entity/chemsprayer-stream/flamethrower-fire-stream-spine.png",
			frame_count = 32,
			height = 18,
			line_length = 4,
			shift = {
				0,
				0
			},
			width = 32
		},
		stream_light = {
			intensity = 1,
			size = 4
		},
	},
}
