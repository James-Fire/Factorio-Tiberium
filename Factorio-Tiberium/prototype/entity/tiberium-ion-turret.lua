data:extend{
	{
		type = "electric-turret",
		name = "tiberium-ion-turret",
		icon = "__base__/graphics/icons/laser-turret.png",
		icon_size = 64,
		flags = {"placeable-player", "placeable-enemy", "player-creation"},
		minable = {mining_time = 0.5, result = "tiberium-ion-turret"},
		max_health = 1000,
		collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
		selection_box = {{-1, -1}, {1, 1}},
		rotation_speed = 0.01,
		preparing_speed = 0.05,
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
				laser_turret_extension{frame_count=1, line_length = 1},
				laser_turret_extension_shadow{frame_count=1, line_length=1},
				laser_turret_extension_mask{frame_count=1, line_length=1}
			}
		},
		preparing_animation = {
			layers = {
				laser_turret_extension{},
				laser_turret_extension_shadow{},
				laser_turret_extension_mask{}
			}
		},
		prepared_animation = {
			layers = {
				laser_turret_shooting(),
				laser_turret_shooting_shadow(),
				laser_turret_shooting_mask()
			}
		},
		--attacking_speed = 0.1,
		energy_glow_animation = laser_turret_shooting_glow(),
		glow_light_intensity = 0.5, -- defaults to 0
		folding_animation = {
			layers = {
				laser_turret_extension{run_mode = "backward"},
				laser_turret_extension_shadow{run_mode = "backward"},
				laser_turret_extension_mask{run_mode = "backward"}
			}
		},
		base_picture = {
			layers = {
				{
					filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
					priority = "high",
					width = 70,
					height = 52,
					direction_count = 1,
					frame_count = 1,
					shift = util.by_pixel(0, 2),
					hr_version = {
						filename = "__base__/graphics/entity/laser-turret/hr-laser-turret-base.png",
						priority = "high",
						width = 138,
						height = 104,
						direction_count = 1,
						frame_count = 1,
						shift = util.by_pixel(-0.5, 2),
						scale = 0.5
					}
				},
				{
					filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
					line_length = 1,
					width = 66,
					height = 42,
					draw_as_shadow = true,
					direction_count = 1,
					frame_count = 1,
					shift = util.by_pixel(6, 3),
					hr_version = {
						filename = "__base__/graphics/entity/laser-turret/hr-laser-turret-base-shadow.png",
						line_length = 1,
						width = 132,
						height = 82,
						draw_as_shadow = true,
						direction_count = 1,
						frame_count = 1,
						shift = util.by_pixel(6, 3),
						scale = 0.5
					}
				}
			}
		},
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		attack_parameters = {
			type = "beam",
			cooldown = 120,
			range = 40,
			source_direction_count = 64,
			source_offset = {0, -3.423489 / 4},
			damage_modifier = 8,
			ammo_type = {
				category = "laser-turret",
				energy_consumption = "2000kJ",
				action = {
					type = "direct",
					action_delivery = {
						type = "beam",
						beam = "laser-beam",
						max_length = 48,
						duration = 40,
						source_offset = {0, -1.31439}
					}
				}
			}
		},
		call_for_help_radius = 40
	}
}
