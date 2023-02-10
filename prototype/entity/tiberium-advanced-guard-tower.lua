data:extend{
	{
		type = "ammo-turret",
		name = "tiberium-advanced-guard-tower",
		alert_when_attacking = true,
		attack_parameters = {
			type = "projectile",
			ammo_category = "rocket",
			cooldown = 120,
			projectile_center = {
				0,
				-0.6
			},
			projectile_creation_distance = 1.39375,
			range = 24,
			sound = {
				{
					filename = "__base__/sound/fight/rocket-launcher.ogg",
					volume = 0.4
				}
			},
		},
		attacking_speed = 0.5,
		automated_ammo_count = 10,
		base_picture = {
			layers = {
				{
					axially_symmetrical = false,
					direction_count = 1,
					filename = tiberiumInternalName.."/graphics/entity/advanced-guard-tower/advanced-guard-tower.png",
					frame_count = 1,
					height = 255,
					width = 126,
					scale = 0.7,
					priority = "high",
					shift = {0, -1.3},
				},
			}
		},
		call_for_help_radius = 40,
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		corpse = "gun-turret-remnants",
		damaged_trigger_effect = {
			damage_type_filters = "fire",
			entity_name = "spark-explosion",
			offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
			offsets = {{0, 1}},
			type = "create-entity"
		},
		dying_explosion = "gun-turret-explosion",
		flags = {
			"placeable-player",
			"player-creation"
		},
		folded_animation = {
			layers = {
				{
					axially_symmetrical = false,
					direction_count = 1,
					filename = tiberiumInternalName.."/graphics/entity/advanced-guard-tower/advanced-guard-tower.png",
					frame_count = 1,
					height = 255,
					width = 126,
					scale = 0.7,
					line_length = 1,
					priority = "medium",
					run_mode = "forward",
					shift = {0, -1.3},
				},
			}
		},
		icon = tiberiumInternalName.."/graphics/entity/advanced-guard-tower/advanced-guard-tower-256.png",
		icon_size = 256,
		inventory_size = 1,
		max_health = 1000,
		minable = {
			mining_time = 0.5,
			result = "tiberium-advanced-guard-tower"
		},
		preparing_speed = 0.08,
		rotation_speed = 0.015,
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		water_reflection = {
			orientation_to_variation = false,
			pictures = {
				filename = "__base__/graphics/entity/gun-turret/gun-turret-reflection.png",
				height = 32,
				priority = "extra-high",
				scale = 5,
				shift = {
					0,
					1.25
				},
				variation_count = 1,
				width = 20
			},
			rotate = false
		}
	}
}