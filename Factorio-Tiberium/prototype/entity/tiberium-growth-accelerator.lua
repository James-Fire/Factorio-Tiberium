require("prototype/entity/tiberium-node-harvester")

local acceleratorSprite = {
	-- Centrifuge C
	filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
	priority = "high",
	line_length = 8,
	width = 119,
	height = 107,
	frame_count = 64,
	hr_version = {
		filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C.png",
		priority = "high",
		scale = 0.5,
		line_length = 8,
		width = 237,
		height = 214,
		frame_count = 64,
	}
}

local growthAcceleratorNode = table.deepcopy(data.raw["mining-drill"]["tiberium-node-harvester"])
growthAcceleratorNode.name = "tiberium-growth-accelerator-node"
growthAcceleratorNode.animations = acceleratorSprite
growthAcceleratorNode.base_picture = {}
growthAcceleratorNode.base_picture.sheet = acceleratorSprite
growthAcceleratorNode.graphics_set = nil
growthAcceleratorNode.integration_patch = nil
growthAcceleratorNode.wet_mining_graphics_set = nil
growthAcceleratorNode.mining_speed = settings.startup["tiberium-growth"].value * 10 / 15
growthAcceleratorNode.vector_to_place_result = {0, 0}
growthAcceleratorNode.energy_usage = "1kW"
growthAcceleratorNode.collision_mask = {"water-tile", "player-layer"}
growthAcceleratorNode.energy_source = {
	type = "void",
	emissions_per_minute = 2,
}

data:extend{growthAcceleratorNode,
	{
		type = "assembling-machine",
		name = "tiberium-growth-accelerator",
		icon = tiberiumInternalName.."/graphics/technology/growth-accelerator.png",
		icon_size = 128,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "tiberium-growth-accelerator"},
		placeable_by = {item = "tiberium-growth-accelerator", count = 1},
		max_health = 250,
		corpse = "centrifuge-remnants",
		dying_explosion = "medium-explosion",
		energy_usage = "1kW",
		crafting_speed = 1,
		fixed_recipe = "tiberium-growth",
		allowed_effects = {"speed", "consumption"},
		open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.85},
		close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.75},
		working_sound = {
			fade_in_ticks = 4,
			fade_out_ticks = 20,
			sound = {
				{
					filename = tiberiumInternalName.."/sound/Accelerator.ogg",
					volume = 0.2
				}
			},
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
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
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
	--Floating text for displaying growth amount
	{
		type = "flying-text",
		name = "tiberium-growth-accelerator-text",
		flags = {"not-on-map", "placeable-off-grid"},
		time_to_live = 300,
		speed = 1 / 60,
		text_alignment = "center",
	}
}

--Invisible beacons for Growth Accelerator speed research
data:extend{
	{
		type = "beacon",
		name = "tiberium-growth-accelerator-beacon",
		energy_usage = "10W",
		flags = {
			"hide-alt-info",
			"not-blueprintable",
			"not-deconstructable",
			"placeable-off-grid",
			"not-on-map",
			"no-automated-item-removal",
			"no-automated-item-insertion"
		},
		collision_mask = {"resource-layer"}, -- disable collision
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
		animation = common.blankAnimation,
		animation_shadow = common.blankAnimation,
		energy_source = {type = "void"},
		base_picture = common.blankPicture,
		supply_area_distance = 0,
		radius_visualisation_picture = common.blankPicture,
		distribution_effectivity = 1,
		module_specification = {
			module_slots = 65535,
		},
		allowed_effects = {"speed", "consumption"},
		selection_box = {{0, 0}, {0, 0}},
		collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
	},
	-- hidden speed modules matching infinite tech bonus size
	{
		type = "module",
		name = "tiberium-growth-accelerator-speed-module",
		icon = "__core__/graphics/empty.png",
		icon_size = 1,
		flags = {"hidden"},
		subgroup = "module",
		category = "speed",
		tier = 0,
		stack_size = 1,
		effect = {speed = {bonus = 0.25}, consumption = {bonus = 0.40}},
	}
}
