data:extend(
{
	{
        type = "item",
        name = "growth-credit",
        icon = "__Factorio-Tiberium__/graphics/icons/growth-credit.png",
		icon_size = 32,
        flags = {},
        subgroup = "raw-resource",
        order = "a[tiberium-ore]",
        stack_size = 200
    },
	}
)

data:extend(
{
	{
		type = "autoplace-control",
		name = "tibGrowthNode",
		richness = true,
		order = "b-f",
		category = "resource",
	},
	{
		type = "noise-layer",
		name = "tiberium-ore"
	},
	{
		type = "resource-category",
		name = "basic-solid-tiberium"
	},
	{
		type = "resource-category",
		name = "advanced-solid-tiberium"
	},
  {
    type = "resource",
    name = "tiberium-ore",
	category = "basic-solid-tiberium",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-ore.png",
    icon_size = 32,
    flags = {"placeable-neutral"},
    order="a-b-f",
    minable =
    {
      hardness = 0.05,
      mining_particle = "stone-particle",
      mining_time = 0.1,
      result = "tiberium-ore",
      --fluid_amount = 10,
      --required_fluid = "sulfuric-acid"
    },
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    stage_counts = {1000, 600, 400, 200, 100, 50, 20, 1},
    stages =
    {
      sheet =
      {
        filename = "__Factorio-Tiberium__/graphics/entity/ores/tiberium-ore.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 8,
        variation_count = 8,
        hr_version = {
          filename = "__Factorio-Tiberium__/graphics/entity/ores/hr-tiberium-ore.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5
        }
      }
    },
    stages_effect =
    {
      sheet =
      {
        filename = "__Factorio-Tiberium__/graphics/entity/ores/tiberium-ore-glow.png",
        priority = "extra-high",
        width = 64,
        height = 64,
        frame_count = 8,
        variation_count = 8,
        blend_mode = "additive",
        flags = {"light"},
        hr_version = {
          filename = "__Factorio-Tiberium__/graphics/entity/ores/hr-tiberium-ore-glow.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5,
          blend_mode = "additive",
          flags = {"light"},
        }
      }
    },
    effect_animation_period = 5,
    effect_animation_period_deviation = 1,
    effect_darkness_multiplier = 3.6,
    min_effect_alpha = 0.2,
    max_effect_alpha = 0.3,
    map_color = {r=0, g=0.9, b=0}
  },
  
    {
        type = "item",
        name = "tiberium-ore",
        icon = "__Factorio-Tiberium__/graphics/icons/tiberium-ore.png",
		icon_size = 32,
        flags = {},
        subgroup = "raw-resource",
        order = "a[tiberium-ore]",
        stack_size = 200
    },
    }
    )
	
local noise = require("noise");
local tne = noise.to_noise_expression;
resource_autoplace = require("resource-autoplace");

resource_autoplace.initialize_patch_set("tibGrowthNode", false)

data:extend(
{
  {
    type = "resource",
    name = "tibGrowthNode",
    icon = "__base__/graphics/icons/crude-oil.png",
    icon_size = 32,
    flags = {"placeable-neutral"},
    category = "advanced-solid-tiberium",
    order="a-b-a",
    infinite = false,
    highlight = true,
    minimum = 3000000,
    normal = 15000000,
    infinite_depletion_amount = 10,
    resource_patch_search_radius = 12,
    tree_removal_probability = 0.7,
    tree_removal_max_distance = 32 * 32,
    minable =
    {
      mining_time = 0.5,
      results =
      {
        {
          type = "item",
          name = "tiberium-ore",
          amount_min = 1,
          amount_max = 1,
          probability = 1
        }
      }
    },
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = resource_autoplace.resource_autoplace_settings
    {
      name = "tibGrowthNode",
      order = "c", -- Other resources are "b"; oil won't get placed if something else is already there.
      base_density = 3.0,
      base_spots_per_km2 = 1.8,
      random_probability = 1/48,
      random_spot_size_minimum = 1,
      random_spot_size_maximum = 1, -- don't randomize spot size
      additional_richness = 11000000, -- this increases the total everywhere, so base_density needs to be decreased to compensate
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = 1
    },
    stage_counts = {0},
    stages =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/crude-oil/crude-oil.png",
        priority = "extra-high",
        width = 75,
        height = 61,
        frame_count = 4,
        variation_count = 1
      }
    },
    map_color = {0, 0.9, 0},
    map_grid = false
  },
})
