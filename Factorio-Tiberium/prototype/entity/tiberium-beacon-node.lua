local hit_effects = require ("__base__.prototypes.entity.demo-hit-effects")
local sounds = require("__base__.prototypes.entity.demo-sounds")
local TiberiumRadius = 20 + settings.startup["tiberium-spread"].value * 0.4 --Translates to 20-60 range


data:extend({
	{
	type = "beacon",
	name = "tiberium-beacon-node",
	icon = tiberiumInternalName.."/graphics/icons/beacon.png",
	icon_size = 32, icon_mipmaps = 4,
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

	graphics_set = require("__base__/prototypes/entity/beacon-animations"),

	radius_visualisation_picture =
	{
		filename = "__base__/graphics/entity/beacon/beacon-radius-visualization.png",
		priority = "extra-high-no-scale",
		width = 10,
		height = 10
	},
	supply_area_distance = TiberiumRadius * 0.5,
	energy_source = {
		type = "electric",
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
})