local detCharge = flib.copy_prototype(data.raw["mining-drill"]["pumpjack"], "tiberium-detonation-charge")
detCharge.icon_size = 128
detCharge.icon = tiberiumInternalName.."/graphics/icons/tiberium-spike.png"
detCharge.icon_mipmaps = nil
detCharge.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
detCharge.mining_speed = 5
detCharge.subgroup = "a-buildings"
detCharge.order = "g[tiberium-spike]"
detCharge.resource_categories = {}
detCharge.resource_searching_radius = 0.49
detCharge.collision_mask = {"water-tile", "player-layer"}
table.insert(detCharge.resource_categories, "advanced-liquid-tiberium")
table.insert(detCharge.resource_categories, "advanced-solid-tiberium")
detCharge.energy_source = {
	type = "void",
	usage_priority = "secondary-input",
	emissions_per_minute = 20
}
detCharge.next_upgrade = nil
detCharge.fast_replaceable_group = nil

data:extend{
	detCharge,
	{
		type = "electric-energy-interface",
		name = "tiberium-detonation-timer",
		localised_name = {"entity-name.tiberium-detonation-charge"},
		localised_description = {"entity-description.tiberium-detonation-charge"},
		icon = tiberiumInternalName.."/graphics/technology/growth-accelerator.png",
		icon_size = 128,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 1, result = "tiberium-detonation-charge"},
		--placeable_by = {item = "tiberium-detonation-charge", count = 1},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		max_health = 50,
		dying_explosion = "medium-explosion",
		corpse = "wall-remnants",
		create_ghost_on_death = false,
		mined_sound = {filename = "__base__/sound/deconstruct-bricks.ogg"},
		vehicle_impact_sound = {filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
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
		energy_production = "1W",
		energy_source = {
			type = "electric",
			buffer_capacity = "3J", -- 3 second fuse
			usage_priority = "secondary-output",
			input_flow_limit = "0kW",
			output_flow_limit = "0W",
			render_no_network_icon = false
		},
		picture = {
			filename = "__base__/graphics/entity/cliff-explosives/cliff-explosives.png",
			priority = "extra-high",
			frame_count = 1,
			axially_symmetrical = false,
			direction_count = 1,
			width = 26,
			height = 30,
			scale = 2
		},
	}
}