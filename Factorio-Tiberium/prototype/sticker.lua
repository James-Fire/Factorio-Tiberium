data:extend{
	{
		type = "sticker",
		name = "tiberium-fire-sticker",
		animation = {
			animation_speed = 1,
			blend_mode = "normal",
			filename = tiberiumInternalName.."/graphics/entity/chemsprayer-stream/fire-flame-13.png",
			frame_count = 25,
			height = 118,
			line_length = 8,
			scale = 0.2,
			shift = {
				-0.0078125,
				-0.18125000000000002
			},
			tint = {
				a = 0.17999999999999998,
				b = 0.5,
				g = 0.5,
				r = 0.5
			},
			width = 60
		},
		damage_interval = 10,
		damage_per_tick = {
			amount = 20,
			type = "tiberium"
		},
		duration_in_ticks = 1800,
		fire_spread_cooldown = 30,
		fire_spread_radius = 0.75,
		flags = {
			"not-on-map"
		},
		-- spread_fire_entity = "fire-flame-on-tree",
		target_movement_modifier = 0.8,
	}
}
