data:extend{
	{
		type = "electric-turret",
		name = "tiberium-obelisk-of-light",
		icon = tiberiumInternalName.."/graphics/entity/obelisk-of-light/obelisk-of-light-222.png",
		icon_size = 222,
		flags = {"placeable-player", "placeable-enemy", "player-creation"},
		minable = {mining_time = 0.5, result = "tiberium-obelisk-of-light"},
		max_health = 1000,
		collision_box = {{-1.2, -1.7}, {1.2, 1.7}},
		selection_box = {{-1.5, -2}, {1.5, 2}},
		rotation_speed = 0.01,
		dying_explosion = "medium-explosion",
		corpse = "laser-turret-remnants",
		folding_speed = 0.05,
		energy_source = {
			type = "electric",
			buffer_capacity = "20000kJ",
			input_flow_limit = "20000kW",
			drain = "24kW",
			usage_priority = "primary-input"
		},
		folded_animation = {
			layers = {
				{
					filename = tiberiumInternalName.."/graphics/entity/obelisk-of-light/obelisk-of-light.png",
					priority = "high",
					width = 114,
					height = 222,
					direction_count = 1,
					frame_count = 1,
					scale = 0.8
				}
			}
		},
		energy_glow_animation = laser_turret_shooting_glow(),
		glow_light_intensity = 0.5, -- defaults to 0
		base_picture = {
			layers = {
				{
					filename = tiberiumInternalName.."/graphics/entity/obelisk-of-light/obelisk-of-light.png",
					priority = "high",
					width = 114,
					height = 222,
					direction_count = 1,
					frame_count = 1,
					scale = 0.8
				}
			}
		},
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		starting_attack_sound = {
			filename = tiberiumInternalName.."/sound/Obelisk.ogg",
			volume = 0.4
		},
		attack_parameters = {
			type = "beam",
			cooldown = 30,
			range = 40,
			source_direction_count = 64,
			source_offset = {0, 0},
			damage_modifier = 12,
			warmup = 120,
			ammo_type = {
				category = "laser",
				energy_consumption = "2000kJ",
				action = {
					type = "direct",
					action_delivery = {
						type = "beam",
						beam = "laser-beam",
						max_length = 48,
						duration = 10,
						source_offset = {-0.4, -2.7}
					}
				}
			},
		},
		call_for_help_radius = 40
	}
}
