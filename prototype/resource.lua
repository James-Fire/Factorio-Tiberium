local TiberiumMaxPerTile = settings.startup["tiberium-growth"].value * 100
local tibOnly = common.whichPlanet ~= "nauvis"
require("prototype.planet")

data:extend{
	{
		type = "resource-category",
		name = "basic-solid-tiberium"
	},
	{
		type = "resource-category",
		name = "advanced-solid-tiberium"
	},
	{
		type = "resource-category",
		name = "advanced-liquid-tiberium"
	},
	{
		type = "resource",
		name = "tiberium-ore",
		category = "basic-solid-tiberium",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-ore.png",
		icon_size = 64,
		flags = {"placeable-neutral"},
		order="a-b-f",
		minable = {
			hardness = 0.05,
			mining_particle = "stone-particle",
			mining_time = 1,
			result = "tiberium-ore",
			--fluid_amount = 10,
			--required_fluid = "sulfuric-acid"
		},
		collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		stage_counts = {
			TiberiumMaxPerTile * 0.9,
			TiberiumMaxPerTile * 0.75,
			TiberiumMaxPerTile * 0.6,
			TiberiumMaxPerTile * 0.47,
			TiberiumMaxPerTile * 0.35,
			TiberiumMaxPerTile * 0.25,
			TiberiumMaxPerTile * 0.15,
			TiberiumMaxPerTile * 0.8,
			TiberiumMaxPerTile * 0.4,
			TiberiumMaxPerTile * 0.2,
			TiberiumMaxPerTile * 0.1,
			1
		},
		stages = {
			sheet = {
				filename = tiberiumInternalName.."/graphics/entity/ores/hr-tiberium-ore.png",
				priority = "extra-high",
				width = 128,
				height = 128,
				frame_count = 12,
				variation_count = 12,
				scale = 0.5
			}
		},
		stages_effect = {
			sheet = {
				filename = tiberiumInternalName.."/graphics/entity/ores/tiberium-ore-glow.png",
				priority = "extra-high",
				width = 64,
				height = 64,
				frame_count = 12,
				variation_count = 12,
				blend_mode = "additive",
				flags = {"light"},
			}
		},
		effect_animation_period = 4,
		effect_animation_period_deviation = 1,
		effect_darkness_multiplier = 2.0,
		min_effect_alpha = 0.3,
		max_effect_alpha = 0.5,
		map_color = {0.02, 1.0, 0.02}
	},
	{
		type = "resource",
		name = "tiberium-ore-blue",
		category = "basic-solid-tiberium",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png",
		icon_size = 64,
		flags = {"placeable-neutral"},
		order="a-b-f",
		minable = {
			hardness = 0.05,
			mining_particle = "stone-particle",
			mining_time = 1,
			result = "tiberium-ore-blue",
		},
		collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		stage_counts = {
			TiberiumMaxPerTile * 0.9,
			TiberiumMaxPerTile * 0.75,
			TiberiumMaxPerTile * 0.6,
			TiberiumMaxPerTile * 0.47,
			TiberiumMaxPerTile * 0.35,
			TiberiumMaxPerTile * 0.25,
			TiberiumMaxPerTile * 0.15,
			TiberiumMaxPerTile * 0.8,
			TiberiumMaxPerTile * 0.4,
			TiberiumMaxPerTile * 0.2,
			TiberiumMaxPerTile * 0.1,
			1
		},
		stages = {
			sheet = {
				filename = tiberiumInternalName.."/graphics/entity/ores/tiberium-ore-blue-20-114-0.png",
				priority = "extra-high",
				width = 64,
				height = 64,
				frame_count = 12,
				variation_count = 12,
			}
		},
		stages_effect = {
			sheet = {
				filename = tiberiumInternalName.."/graphics/entity/ores/tiberium-ore-glow-blue-61-139-20.png",
				priority = "extra-high",
				width = 64,
				height = 64,
				frame_count = 12,
				variation_count = 12,
				blend_mode = "additive",
				flags = {"light"},
			}
		},
		effect_animation_period = 4,
		effect_animation_period_deviation = 1,
		effect_darkness_multiplier = 2.0,
		min_effect_alpha = 0.3,
		max_effect_alpha = 0.5,
		map_color = {0.15, 0.45, 1.0}
	},
}

if data.raw.resource["uranium-ore"] then
	data.raw.resource["tiberium-ore"].walking_sound = data.raw.resource["uranium-ore"].walking_sound
	data.raw.resource["tiberium-ore-blue"].walking_sound = data.raw.resource["uranium-ore"].walking_sound
	data.raw.resource["tiberium-ore"].driving_sound = data.raw.resource["uranium-ore"].driving_sound
	data.raw.resource["tiberium-ore-blue"].driving_sound = data.raw.resource["uranium-ore"].driving_sound
end

local resource_autoplace = require("resource-autoplace")
resource_autoplace.initialize_patch_set("tibGrowthNode", common.TiberiumInStartingArea)  -- TODO
local autoplaceName = common.whichPlanet == "nauvis" and "nauvis_tibGrowthNode" or common.whichPlanet == "pure-nauvis" and "nauvis_tibGrowthNode" or "tiber_tibGrowthNode"

local oriented_cliff_dummy = {
	collision_bounding_box = {{-0.4, -0.4}, {0.4, 0.4}},
	pictures = {
		filename = tiberiumInternalName.."/graphics/entity/nodes/tiberium_blossom_tree.png",
		width = 320,
		height = 251,
	},
	fill_volume = 0
}

data:extend{
	{
		type = "cliff",
		name = "tibNode_tree",
		icon = tiberiumInternalName.."/graphics/entity/nodes/tiberium_blossom_tree.png",
		icon_size = 32,
		flags = {"placeable-neutral", "not-repairable", "not-flammable"},
		cliff_explosive = "tiberium-cliff-explosives",
		grid_size = {1, 1},
		grid_offset = {0.5, 0.5},
		selection_priority = 2,
		collision_mask = common.makeCollisionMask({"item", "object"}),
		orientations = {
			west_to_east = oriented_cliff_dummy,
			north_to_south = oriented_cliff_dummy,
			east_to_west = oriented_cliff_dummy,
			south_to_north = oriented_cliff_dummy,
			west_to_north = oriented_cliff_dummy,
			north_to_east = oriented_cliff_dummy,
			east_to_south = oriented_cliff_dummy,
			south_to_west = oriented_cliff_dummy,
			west_to_south = oriented_cliff_dummy,
			north_to_west = oriented_cliff_dummy,
			east_to_north = oriented_cliff_dummy,
			south_to_east = oriented_cliff_dummy,
			west_to_none = oriented_cliff_dummy,
			none_to_east = oriented_cliff_dummy,
			north_to_none = oriented_cliff_dummy,
			none_to_south = oriented_cliff_dummy,
			east_to_none = oriented_cliff_dummy,
			none_to_west = oriented_cliff_dummy,
			south_to_none = oriented_cliff_dummy,
			none_to_north = oriented_cliff_dummy,
		}
	},
	{
		type = "resource",
		name = "tibGrowthNode",
		icons = common.blankIcons,
		flags = {"placeable-neutral"},
		category = "advanced-solid-tiberium",
		order="a-b-a",
		infinite = false,
		highlight = true,
		minimum = 600000,
		normal = 3000000,
		resource_patch_search_radius = 12,
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable = {mining_time = 1, result = "tiberium-ore"},
		collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		autoplace = resource_autoplace.resource_autoplace_settings{
			name = autoplaceName,
			order = "c", -- Other resources are "b"; oil won't get placed if something else is already there.
			base_density = 3.0,
			base_spots_per_km2 = tibOnly and 12 or 1.8,
			random_probability = tibOnly and 1 / 36 or 1 / 48,
			random_spot_size_minimum = 1,
			random_spot_size_maximum = 1, -- don't randomize spot size
			additional_richness = 200000, -- this increases the total everywhere, so base_density needs to be decreased to compensate
			has_starting_area_placement = common.TiberiumInStartingArea,
			regular_rq_factor_multiplier = 1,
			starting_rq_factor_multiplier = 1.1
		},
		stage_counts = {0},
		stages = {
			sheet = common.blankAnimation
		},
		map_color = {0.02, 1.0, 0.02},
		map_grid = false
	},
	{
		type = "resource",
		name = "tibGrowthNode_infinite",
		icons = common.blankIcons,
		flags = {"placeable-neutral"},
		category = "advanced-liquid-tiberium",
		order="a-b-a",
		infinite = true,
		highlight = true,
		minimum = 600000,
		normal = 3000000,
		infinite_depletion_amount = 5,
		resource_patch_search_radius = 12,
		tree_removal_probability = 0.7,
		tree_removal_max_distance = 32 * 32,
		minable = {
			mining_time = 5,
			results = {
				{
					type = "fluid",
					name = "molten-tiberium",
					amount_min = 10,
					amount_max = 10,
					probability = 1
				}
			}
		},
		collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		stage_counts = {0},
		stages = {
			sheet = common.blankAnimation
		},
		map_color = {0.2, 0.9, 0},
		map_grid = false
	},
	{
		type = "autoplace-control",
		name = "tiber-rocks",
		category = "terrain",
		order = "c-y2"
	},
	{
		type = "simple-entity",
		name = "tiberium-tiber-rock",
		autoplace = {
			control = "tiber-rocks",
			local_expressions = {
				control = "control:rocks:size",
				multiplier = 0.1,
				penalty = 1.5,
				region_box = "range_select_base(distance, 20, 80, 10, -1, 0)"
			},
			order = "a[doodad]-a[rock]-a[huge]",
			probability_expression = "multiplier * control * (rock_noise + region_box - penalty)" --Make them more common around spawn
		},
		collision_box = {{-1.5, -1.1}, {1.5, 1.1}},
		count_as_rock_for_filtered_deconstruction = true,
		damaged_trigger_effect = {
			damage_type_filters = "fire",
			entity_name = "rock-damaged-explosion",
			offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
			offsets = {{0, 1}},
			type = "create-entity"
		},
		deconstruction_alternative = "big-rock",
		dying_trigger_effect = {
			{
				affects_target = false,
				frame_speed = 1,
				frame_speed_deviation = 0,
				initial_height = 0.3,
				initial_height_deviation = 0.5,
				initial_vertical_speed = 0.11500000000000001,
				initial_vertical_speed_deviation = 0.05,
				offset_deviation = {{-0.0789, -0.1}, {0.0789, 0.1}},
				offsets = {{0, 0}},
				particle_name = "huge-rock-stone-particle-small",
				probability = 1,
				repeat_count = 15,
				repeat_count_deviation = 2,
				show_in_tooltip = false,
				speed_from_center = 0.04,
				speed_from_center_deviation = 0.03,
				type = "create-particle"
			},
			{
				affects_target = false,
				frame_speed = 1,
				frame_speed_deviation = 0,
				initial_height = 0.5,
				initial_height_deviation = 0.5,
				initial_vertical_speed = 0.085999999999999979,
				initial_vertical_speed_deviation = 0.05,
				offset_deviation = {{-0.0789, -0.1}, {0.0789, 0.1}},
				offsets = {{0, 0}},
				particle_name = "huge-rock-stone-particle-big",
				probability = 1,
				repeat_count = 5,
				repeat_count_deviation = 3,
				show_in_tooltip = false,
				speed_from_center = 0.04,
				speed_from_center_deviation = 0.05,
				type = "create-particle"
			},
			{
				affects_target = false,
				frame_speed = 1,
				frame_speed_deviation = 0,
				initial_height = 0.4,
				initial_height_deviation = 0.5,
				initial_vertical_speed = 0.069000000000000004,
				initial_vertical_speed_deviation = 0.05,
				offset_deviation = {{-0.1, -0.0789}, {0.1, 0.0789}},
				offsets = {{0, 0}},
				particle_name = "huge-rock-stone-particle-tiny",
				probability = 1,
				repeat_count = 10,
				repeat_count_deviation = 10,
				show_in_tooltip = false,
				speed_from_center = 0.02,
				speed_from_center_deviation = 0.05,
				type = "create-particle"
			},
			{
				affects_target = false,
				frame_speed = 1,
				frame_speed_deviation = 0,
				initial_height = 0.4,
				initial_height_deviation = 0.60999999999999996,
				initial_vertical_speed = 0.085,
				initial_vertical_speed_deviation = 0.05,
				offset_deviation = {{-0.1, -0.0789}, {0.1, 0.0789}},
				offsets = {{0, 0}},
				particle_name = "huge-rock-stone-particle-medium",
				probability = 1,
				repeat_count = 15,
				repeat_count_deviation = 10,
				show_in_tooltip = false,
				speed_from_center = 0.05,
				speed_from_center_deviation = 0.05,
				type = "create-particle"
			}
		},
		flags = {
			"placeable-neutral",
			"placeable-off-grid"
		},
		icon = tiberiumInternalName.."/graphics/icons/huge-rock.png",
		impact_category = "stone",
		map_color = {
			129,
			105,
			78
		},
		max_health = 2000,
		minable = {
			mining_particle = "stone-particle",
			mining_time = 3,
			results = {
				{
					amount_max = 50,
					amount_min = 24,
					name = "stone",
					type = "item"
				},
				{
					amount_max = 50,
					amount_min = 24,
					name = "iron-ore",
					type = "item"
				},
				{
					amount_max = 30,
					amount_min = 12,
					name = "copper-ore",
					type = "item"
				}
			}
		},
		mined_sound = {
			switch_vibration_data = {
				filename = "__core__/sound/deconstruct-bricks.bnvib",
				gain = 0.32000000000000002
			},
			variations = {
				{
					filename = "__base__/sound/deconstruct-bricks.ogg",
					volume = 1
				}
			}
		},
		order = "b[decorative]-l[rock]-a[huge]",
		pictures = {},
		render_layer = "object",
		resistances = {
			{
				percent = 100,
				type = "fire"
			}
		},
		selection_box = {{-1.7, -1.3}, {1.7, 1.3}},
		subgroup = "grass",
	}
}

if data.raw["simple-entity"]["huge-rock"] then
	data.raw["simple-entity"]["tiberium-tiber-rock"].pictures = data.raw["simple-entity"]["huge-rock"].pictures
end
for _,picture in pairs(data.raw["simple-entity"]["tiberium-tiber-rock"].pictures) do
	picture.tint = {r = 0.7, g = 0.9, b = 0.6, a = 1}
end

-- Make islands for Tiberium on Aquilo
data.raw.resource["tibGrowthNode"].created_effect = util.copy(data.raw.resource["crude-oil"].created_effect)
