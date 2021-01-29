local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local TiberiumRadius = 20 + settings.startup["tiberium-spread"].value * 0.4 --Translates to 20-60 range


data:extend({
	{
	type = "beacon",
	name = "tiberium-beacon-node",
	icon = tiberiumInternalName.."/graphics/icons/beacon.png",
	icon_size = 32,
	flags = {"placeable-player", "player-creation"},
	minable = {mining_time = 0.2, result = "tiberium-beacon-node"},
	max_health = 200,
	corpse = "beacon-remnants",
	dying_explosion = "beacon-explosion",
	collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
	selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
	damaged_trigger_effect = hit_effects.entity(),
	drawing_box = {{-1.5, -2.2}, {1.5, 1.3}},
	allowed_effects = {"consumption"},
	animation = {
		animation_speed = 0.5,
		filename = tiberiumInternalName.."/graphics/entity/beacon/beacon-antenna.png",
		frame_count = 32,
		height = 50,
		width = 54,
		line_length = 8,
		shift = {-0.03125, -1.71875},
	},
	base_picture = {
		filename = tiberiumInternalName.."/graphics/entity/beacon/beacon-base.png",
		height = 93,
		width = 116,
		shift = {0.34375, 0.046875},
	},
	radius_visualisation_picture = {
		filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
		priority = "extra-high-no-scale",
		width = 10,
		height = 10
	},
	supply_area_distance = math.floor(TiberiumRadius * 0.5),
	energy_source = {
		type = "void",
		usage_priority = "secondary-input"
	},
	vehicle_impact_sound = sounds.generic_impact,
	open_sound = sounds.machine_open,
	close_sound = sounds.machine_close,
	working_sound = {
		sound = {
			{
			filename = "__base__/sound/beacon-1.ogg",
			volume = 0.2
			},
			{
			filename = "__base__/sound/beacon-2.ogg",
			volume = 0.2
			}
		},
		audible_distance_modifier = 0.33,
		max_sounds_per_type = 3
		-- fade_in_ticks = 4,
		-- fade_out_ticks = 60
	},
	energy_usage = "10MW",
	distribution_effectivity = 0,
	module_specification = {
		module_slots = 0,
		module_info_icon_shift = {0, 0},
		module_info_multi_row_initial_height_modifier = -0.3,
		module_info_max_icons_per_row = 2,
	},
	water_reflection = {
		pictures = {
			filename = "__base__/graphics/entity/beacon/beacon-reflection.png",
			priority = "extra-high",
			width = 24,
			height = 28,
			shift = util.by_pixel(0, 55),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false
	}
	},
	--Invisible beacons for Growth Accelerator speed research
	{
		type = "beacon",
		name = "TCN-beacon",
		energy_usage = "5MW",
		icon = tiberiumInternalName.."/graphics/icons/beacon.png",
		icon_size = 32,
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
		animation = {
			filename =  "__core__/graphics/empty.png",
			width = 1,
			height = 1,
			line_length = 1,
			frame_count = 1,
		},
		animation_shadow = {
			filename = "__core__/graphics/empty.png",
			width = 1,
			height = 1,
			line_length = 1,
			frame_count = 1,
		},
		-- 0.17 supports 0W entities
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input"
		},
		base_picture = {
			filename = "__core__/graphics/empty.png",
			width = 1,
			height = 1,
		},
		supply_area_distance = 0,
		radius_visualisation_picture = {
			filename = "__core__/graphics/empty.png",
			width = 1,
			height = 1
		},
		distribution_effectivity = 1,
		module_specification = {
			module_slots = 65535,
		},
		allowed_effects = {"speed", "consumption"},
		selection_box = {{0, 0}, {0, 0}},
		collision_box = {{-0.4, -0.4}, {0.4, 0.4}}, -- reduce size preventing inserters from picking modules, will not power unless center is covered
	},
})