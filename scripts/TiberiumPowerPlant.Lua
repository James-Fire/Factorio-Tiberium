local hit_effects = require ("__base__.prototypes.entity.demo-hit-effects")
local sounds = require("__base__.prototypes.entity.demo-sounds")

data:extend({
    {
      type = "item",
      name = "tiberium-plant",
      icon = "__base__/graphics/icons/chemical-plant.png",
      icon_size = 64,
      flags = {},
      subgroup = "a-buildings",
      order = "m",
      place_result = "tiberium-plant",
      stack_size = 20
    },
    {
      type = "recipe",
      name = "tiberium-plant",
      energy_required = 15,
      enabled = "false",
	  subgroup = "a-buildings",
	  order = "m",
      ingredients = {
        {"steel-plate", 25},
        {"electric-engine-unit", 10},
        {"advanced-circuit", 15},
        {"pipe", 10},
		{"chemical-plant", 1}
      },
      result = "tiberium-plant"
    },

	{
    type = "generator",
    name = "tiberium-plant",
    icon = "__base__/graphics/icons/chemical-plant.png",
    icon_size = 64,
    flags = {"placeable-neutral","placeable-player", "player-creation"},
    minable = {mining_time = 0.1, result = "tiberium-plant"},
    max_health = 300,
    corpse = "medium-remnants",
    dying_explosion = "medium-explosion",
    max_power_output = (100 / 60) .. "MJ",
	effectivity = 2,
    fluid_usage_per_tick = 2 / 60,
	maximum_temperature = 1000, --not needed...
	burns_fluid = true,
    scale_fluid_usage = true,
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    drawing_box = {{-1.5, -1.9}, {1.5, 1.5}},
	
    energy_source = {
        type = "electric",
        usage_priority = "secondary-output",
		emission = 5,
    },

	horizontal_animation = {
        filename = "__base__/graphics/entity/chemical-plant/chemical-plant.png",
        width = 108,
        height = 148,
        frame_count = 24,
        line_length = 12,
        shift = util.by_pixel(1, -9),
        hr_version =
        {
          filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant.png",
          width = 220,
          height = 292,
          frame_count = 24,
          line_length = 12,
          shift = util.by_pixel(0.5, -9),
          scale = 0.5
          }
      },
      vertical_animation = {
        filename = "__base__/graphics/entity/chemical-plant/chemical-plant.png",
        width = 108,
        height = 148,
        frame_count = 24,
        line_length = 12,
        shift = util.by_pixel(1, -9),
        hr_version =
        {
          filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant.png",
          width = 220,
          height = 292,
          frame_count = 24,
          line_length = 12,
          shift = util.by_pixel(0.5, -9),
          scale = 0.5
          }
      },

    animation = make_4way_animation_from_spritesheet({ layers =
    {
      {
        filename = "__base__/graphics/entity/chemical-plant/chemical-plant.png",
        width = 108,
        height = 148,
        frame_count = 24,
        line_length = 12,
        shift = util.by_pixel(1, -9),
        hr_version =
        {
          filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant.png",
          width = 220,
          height = 292,
          frame_count = 24,
          line_length = 12,
          shift = util.by_pixel(0.5, -9),
          scale = 0.5
          }
      },
      {
        filename = "__base__/graphics/entity/chemical-plant/chemical-plant-shadow.png",
        width = 154,
        height = 112,
        repeat_count = 24,
        frame_count = 1,
        shift = util.by_pixel(28, 6),
        draw_as_shadow = true,
        hr_version =
        {
          filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-shadow.png",
          width = 312,
          height = 222,
          repeat_count = 24,
          frame_count = 1,
          shift = util.by_pixel(27, 6),
          draw_as_shadow = true,
          scale = 0.5
          }
      }
    }}),
    working_visualisations =
    {
      {
        apply_recipe_tint = "primary",
        north_animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-north.png",
          frame_count = 24,
          line_length = 6,
          width = 32,
          height = 24,
          shift = util.by_pixel(24, 14),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-north.png",
            frame_count = 24,
            line_length = 6,
            width = 66,
            height = 44,
            shift = util.by_pixel(23, 15),
            scale = 0.5
          }
        },
        east_animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-east.png",
          frame_count = 24,
          line_length = 6,
          width = 36,
          height = 18,
          shift = util.by_pixel(0, 22),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-east.png",
            frame_count = 24,
            line_length = 6,
            width = 70,
            height = 36,
            shift = util.by_pixel(0, 22),
            scale = 0.5
          }
        },
        south_animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-south.png",
          frame_count = 24,
          line_length = 6,
          width = 34,
          height = 24,
          shift = util.by_pixel(0, 16),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-south.png",
            frame_count = 24,
            line_length = 6,
            width = 66,
            height = 42,
            shift = util.by_pixel(0, 17),
            scale = 0.5
          }
        },
        west_animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-liquid-west.png",
          frame_count = 24,
          line_length = 6,
          width = 38,
          height = 20,
          shift = util.by_pixel(-10, 12),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-liquid-west.png",
            frame_count = 24,
            line_length = 6,
            width = 74,
            height = 36,
            shift = util.by_pixel(-10, 13),
            scale = 0.5
          }
        }
      },
      {
        apply_recipe_tint = "secondary",
        north_animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-north.png",
          frame_count = 24,
          line_length = 6,
          width = 32,
          height = 22,
          shift = util.by_pixel(24, 14),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-north.png",
            frame_count = 24,
            line_length = 6,
            width = 62,
            height = 42,
            shift = util.by_pixel(24, 15),
            scale = 0.5
          }
        },
        east_animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-east.png",
          frame_count = 24,
          line_length = 6,
          width = 34,
          height = 18,
          shift = util.by_pixel(0, 22),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-east.png",
            frame_count = 24,
            line_length = 6,
            width = 68,
            height = 36,
            shift = util.by_pixel(0, 22),
            scale = 0.5
          }
        },
        south_animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-south.png",
          frame_count = 24,
          line_length = 6,
          width = 32,
          height = 18,
          shift = util.by_pixel(0, 18),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-south.png",
            frame_count = 24,
            line_length = 6,
            width = 60,
            height = 40,
            shift = util.by_pixel(1, 17),
            scale = 0.5
          }
        },
        west_animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-foam-west.png",
          frame_count = 24,
          line_length = 6,
          width = 36,
          height = 16,
          shift = util.by_pixel(-10, 14),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-foam-west.png",
            frame_count = 24,
            line_length = 6,
            width = 68,
            height = 28,
            shift = util.by_pixel(-9, 15),
            scale = 0.5
          }
        }
      },
      {
        apply_recipe_tint = "tertiary",
        fadeout = true,
        constant_speed = true,
        north_position = util.by_pixel_hr(-30, -161),
        east_position = util.by_pixel_hr(29, -150),
        south_position = util.by_pixel_hr(12, -134),
        west_position = util.by_pixel_hr(-32, -130),
        animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
          frame_count = 47,
          line_length = 16,
          width = 46,
          height = 94,
          animation_speed = 0.5,
          shift = util.by_pixel(-2, -40),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-smoke-outer.png",
            frame_count = 47,
            line_length = 16,
            width = 90,
            height = 188,
            animation_speed = 0.5,
            shift = util.by_pixel(-2, -40),
            scale = 0.5
          }
        }
      },
      {
        apply_recipe_tint = "quaternary",
        fadeout = true,
        constant_speed = true,
        north_position = util.by_pixel_hr(-30, -161),
        east_position = util.by_pixel_hr(29, -150),
        south_position = util.by_pixel_hr(12, -134),
        west_position = util.by_pixel_hr(-32, -130),
        animation =
        {
          filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
          frame_count = 47,
          line_length = 16,
          width = 20,
          height = 42,
          animation_speed = 0.5,
          shift = util.by_pixel(0, -14),
          hr_version =
          {
            filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-smoke-inner.png",
            frame_count = 47,
            line_length = 16,
            width = 40,
            height = 84,
            animation_speed = 0.5,
            shift = util.by_pixel(0, -14),
            scale = 0.5
          }
        }
      }
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        {
          filename = "__base__/sound/chemical-plant.ogg",
          volume = 0.8
        }
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5
    },
	fluid_box = {
		base_area = 1.5,
        base_level = -1.5,
        height = 3,
        pipe_connections = {
			{ type="input-output", position = {-1, -2} },
			{ type="input-output", position = {1, -2} },
			{ type="input-output", position = {-1, 2} },
			{ type="input-output", position = {1, 2} },
        },
	    filter = "liquid-tiberium",
	    production_type = "input-output",
	    pipe_covers = pipecoverspictures(),
    },
    },
	
	{
      type = "item",
      name = "tiberium-centrifuge",
      icon = "__base__/graphics/icons/centrifuge.png",
      icon_size = 64,
      flags = {},
      subgroup = "a-buildings",
      order = "a",
      place_result = "tiberium-centrifuge",
      stack_size = 20
    },
    {
      type = "recipe",
      name = "tiberium-centrifuge",
      energy_required = 15,
      enabled = "false",
	  subgroup = "a-buildings",
	  order = "m",
      ingredients = {
        {"iron-plate", 25},
		{"engine-unit", 10},
        {"electronic-circuit", 25},
        {"concrete", 10}
      },
      result = "tiberium-centrifuge"
    },
	{
    type = "assembling-machine",
    name = "tiberium-centrifuge",
    icon = "__base__/graphics/icons/centrifuge.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 0.1, result = "tiberium-centrifuge"},
    max_health = 350,
    corpse = "centrifuge-remnants",
    dying_explosion = "centrifuge-explosion",
	fast_replaceable_group = "tib-centrifuge",
    resistances =
    {
      {
        type = "fire",
        percent = 70
      },
	  {
        type = "tiberium",
        percent = 70
      }
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    drawing_box = {{-1.5, -2.2}, {1.5, 1.5}},
	fluid_boxes = {
		{
			production_type = "output",
			pipe_picture = assembler2pipepictures(),
			pipe_covers = pipecoverspictures(),
			base_area = 10,
			base_level = 1,
			pipe_connections = {
				{ type="output", position = {1, -2} },
				
			},
			secondary_draw_orders = { north = -1 }
		},
		{
			production_type = "output",
			pipe_picture = assembler2pipepictures(),
			pipe_covers = pipecoverspictures(),
			base_area = 10,
			base_level = 1,
			pipe_connections = {
				{ type="output", position = {-1, -2} }				
			},
			secondary_draw_orders = { north = -1 }
		},
		{
			production_type = "input",
			pipe_picture = assembler2pipepictures(),
			pipe_covers = pipecoverspictures(),
			base_area = 10,
			base_level = -1,
			pipe_connections = {
				{ type="input", position = {0, 2} }
			},
			secondary_draw_orders = { south = -1 }
		},
		off_when_no_fluid_recipe = true
    },

    always_draw_idle_animation = true,
    idle_animation =
	--tint={r=0.3,g=0.8,b=0.3,a=0.8}, green
    {
      layers =
      {
        -- Centrifuge A
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
		  tint={r=0.3,g=0.8,b=0.3,a=0.8},
          priority = "high",
          line_length = 8,
          width = 119,
          height = 107,
          frame_count = 64,
          shift = util.by_pixel(-0.5, -26.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C.png",
			tint={r=0.3,g=0.8,b=0.3,a=0.8},
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 237,
            height = 214,
            frame_count = 64,
            shift = util.by_pixel(-0.25, -26.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-C-shadow.png",
          draw_as_shadow = true,
          priority = "high",
          line_length = 8,
          width = 132,
          height = 74,
          frame_count = 64,
          shift = util.by_pixel(20, -10),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-shadow.png",
            draw_as_shadow = true,
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 279,
            height = 152,
            frame_count = 64,
            shift = util.by_pixel(16.75, -10)
          }
        },
        -- Centrifuge B
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
          priority = "high",
          line_length = 8,
          width = 78,
          height = 117,
          frame_count = 64,
          shift = util.by_pixel(23, 6.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B.png",
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 156,
            height = 234,
            frame_count = 64,
            shift = util.by_pixel(23, 6.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B-shadow.png",
          draw_as_shadow = true,
          priority = "high",
          line_length = 8,
          width = 124,
          height = 74,
          frame_count = 64,
          shift = util.by_pixel(63, 16),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B-shadow.png",
            draw_as_shadow = true,
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 251,
            height = 149,
            frame_count = 64,
            shift = util.by_pixel(63.25, 15.25)
          }
        },
        -- Centrifuge A
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-A.png",
          priority = "high",
          line_length = 8,
          width = 70,
          height = 123,
          frame_count = 64,
          shift = util.by_pixel(-26, 3.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A.png",
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 139,
            height = 246,
            frame_count = 64,
            shift = util.by_pixel(-26.25, 3.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-A-shadow.png",
          priority = "high",
          draw_as_shadow = true,
          line_length = 8,
          width = 108,
          height = 54,
          frame_count = 64,
          shift = util.by_pixel(6, 27),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A-shadow.png",
            priority = "high",
            draw_as_shadow = true,
            scale = 0.5,
            line_length = 8,
            width = 230,
            height = 124,
            frame_count = 64,
            shift = util.by_pixel(8.5, 23.5)
          }
        },
		--[[{
		  filename = util.multiplystripes(64, "__Factorio-Tiberium__/graphics/entity/centrifuge/Rank-bar.png"),
		  priority = "high",
		  line_length = 1,
		  width = 64,
		  height = 64,
		  frame_count = 64,
		  shift = {0, 0}, --util.by_pixel(-0.5, -26.5),
		  hr_version =
		  {
			filename = util.multiplystripes(64, "__Factorio-Tiberium__/graphics/entity/centrifuge/Rank-bar.png"),
			priority = "high",
			line_length = 1,
			scale = 0.5,
			width = 64,
			height = 64,
			frame_count = 64,
			shift = util.by_pixel(-0.25, -26.5)
		  }
		},]]
      },
    },
		

    animation =
    {
      layers =
      {
        -- Centrifuge C
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-C-light.png",
          priority = "high",
          blend_mode = "additive", -- centrifuge
          line_length = 8,
          width = 96,
          height = 104,
          frame_count = 64,
          shift = util.by_pixel(0, -27),

          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-light.png",
            priority = "high",
            scale = 0.5,
            blend_mode = "additive", -- centrifuge
            line_length = 8,
            width = 190,
            height = 207,
            frame_count = 64,
            shift = util.by_pixel(0, -27.25)
          }
        },
        -- Centrifuge B
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B-light.png",
          priority = "high",
          blend_mode = "additive", -- centrifuge
          line_length = 8,
          width = 65,
          height = 103,
          frame_count = 64,
          shift = util.by_pixel(16.5, 0.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B-light.png",
            priority = "high",
            scale = 0.5,
            blend_mode = "additive", -- centrifuge
            line_length = 8,
            width = 131,
            height = 206,
            frame_count = 64,
            shift = util.by_pixel(16.75, 0.5)
          }
        },
        -- Centrifuge A
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-A-light.png",
          priority = "high",
          blend_mode = "additive", -- centrifuge
          line_length = 8,
          width = 55,
          height = 98,
          frame_count = 64,
          shift = util.by_pixel(-23.5, -2),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A-light.png",
            priority = "high",
            scale = 0.5,
            blend_mode = "additive", -- centrifuge
            line_length = 8,
            width = 108,
            height = 197,
            frame_count = 64,
            shift = util.by_pixel(-23.5, -1.75)
          }
        },
      }
    },

    working_visualisations =
    {
      {
        effect = "uranium-glow", -- changes alpha based on energy source light intensity
        light = {intensity = 0.6, size = 9.9, shift = {0.0, 0.0}, color = {r = 0.0, g = 1.0, b = 0.0}}
      }
    },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.6 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.6 },
    vehicle_impact_sound = sounds.generic_impact,
    working_sound =
    {
      sound =
      {
        {
          filename = "__base__/sound/centrifuge-1.ogg",
          volume = 0.5
        },
        {
          filename = "__base__/sound/centrifuge-2.ogg",
          volume = 0.5
        }
      },
      fade_in_ticks = 10,
      fade_out_ticks = 30,
      max_sounds_per_type = 2,
      --idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.3 },
      apparent_volume = 1.5
    },
    crafting_speed = 1,
    crafting_categories = {"tiberium-centrifuge-1"},
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 4
    },
    energy_usage = "500kW",
    module_specification =
    {
      module_slots = 2
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"},
    water_reflection =
    {
      pictures =
      {
        filename = "__base__/graphics/entity/centrifuge/centrifuge-reflection.png",
        priority = "extra-high",
        width = 28,
        height = 32,
        shift = util.by_pixel(0, 65),
        variation_count = 1,
        scale = 5,
      },
      rotate = false,
      orientation_to_variation = false
    }
  },
  })
  
	local tiberiumcentri2Item = table.deepcopy(data.raw.item["tiberium-centrifuge"])
	tiberiumcentri2Item.name = "tiberium-centrifuge-2"
	tiberiumcentri2Item.subgroup = "a-buildings"
	tiberiumcentri2Item.order = "b"
	tiberiumcentri2Item.place_result = "tiberium-centrifuge-2"
	local tiberiumcentri2Entity = util.table.deepcopy(data.raw["assembling-machine"]["tiberium-centrifuge"])
	tiberiumcentri2Entity.name = "tiberium-centrifuge-2"
	tiberiumcentri2Entity.crafting_speed = 1.5
	tiberiumcentri2Entity.crafting_categories = {"tiberium-centrifuge-1", "tiberium-centrifuge-2"}
	tiberiumcentri2Entity.minable.result = "tiberium-centrifuge-2"
	tiberiumcentri2Entity.module_specification =
    {
      module_slots = 3
    }
	tiberiumcentri2Entity.idle_animation =
	--tint={r=0,g=180/255,b=150/255,a=0.8}, cyan
    {
      layers =
      {
        -- Centrifuge A
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
		  tint={r=0.3,g=0.8,b=0.3,a=0.8},
          priority = "high",
          line_length = 8,
          width = 119,
          height = 107,
          frame_count = 64,
          shift = util.by_pixel(-0.5, -26.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C.png",
			tint={r=0.3,g=0.8,b=0.3,a=0.8},
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 237,
            height = 214,
            frame_count = 64,
            shift = util.by_pixel(-0.25, -26.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-C-shadow.png",
          draw_as_shadow = true,
          priority = "high",
          line_length = 8,
          width = 132,
          height = 74,
          frame_count = 64,
          shift = util.by_pixel(20, -10),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-shadow.png",
            draw_as_shadow = true,
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 279,
            height = 152,
            frame_count = 64,
            shift = util.by_pixel(16.75, -10)
          }
        },
        -- Centrifuge B
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
		  tint={r=0.3,g=0.8,b=0.3,a=0.8},
          priority = "high",
          line_length = 8,
          width = 78,
          height = 117,
          frame_count = 64,
          shift = util.by_pixel(23, 6.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B.png",
			tint={r=0.3,g=0.8,b=0.3,a=0.8},
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 156,
            height = 234,
            frame_count = 64,
            shift = util.by_pixel(23, 6.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B-shadow.png",
          draw_as_shadow = true,
          priority = "high",
          line_length = 8,
          width = 124,
          height = 74,
          frame_count = 64,
          shift = util.by_pixel(63, 16),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B-shadow.png",
            draw_as_shadow = true,
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 251,
            height = 149,
            frame_count = 64,
            shift = util.by_pixel(63.25, 15.25)
          }
        },
        -- Centrifuge A
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-A.png",
          priority = "high",
          line_length = 8,
          width = 70,
          height = 123,
          frame_count = 64,
          shift = util.by_pixel(-26, 3.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A.png",
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 139,
            height = 246,
            frame_count = 64,
            shift = util.by_pixel(-26.25, 3.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-A-shadow.png",
          priority = "high",
          draw_as_shadow = true,
          line_length = 8,
          width = 108,
          height = 54,
          frame_count = 64,
          shift = util.by_pixel(6, 27),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A-shadow.png",
            priority = "high",
            draw_as_shadow = true,
            scale = 0.5,
            line_length = 8,
            width = 230,
            height = 124,
            frame_count = 64,
            shift = util.by_pixel(8.5, 23.5)
          }
        }
      }
    },
	
	data:extend({tiberiumcentri2Item,tiberiumcentri2Entity,
		{
      type = "recipe",
      name = "tiberium-centrifuge-2",
      energy_required = 15,
      enabled = "false",
	  subgroup = "a-buildings",
	  order = "m",
      ingredients = {
        {"concrete", 25},
		{"copper-plate", 25},
		{"engine-unit", 10},
        {"advanced-circuit", 25},
        {"tiberium-centrifuge", 1}
      },
      result = "tiberium-centrifuge-2"
    },
	})
	
	
	local tiberiumcentri3Item = table.deepcopy(data.raw.item["tiberium-centrifuge"])
	tiberiumcentri3Item.name = "tiberium-centrifuge-3"
	tiberiumcentri3Item.subgroup = "a-buildings"
	tiberiumcentri3Item.order = "c"
	tiberiumcentri3Item.place_result = "tiberium-centrifuge-3"
	local tiberiumcentri3Entity = util.table.deepcopy(data.raw["assembling-machine"]["tiberium-centrifuge"])
	tiberiumcentri3Entity.name = "tiberium-centrifuge-3"
	tiberiumcentri3Entity.crafting_speed = 2
	tiberiumcentri3Entity.crafting_categories = {"tiberium-centrifuge-1", "tiberium-centrifuge-2", "tiberium-centrifuge-3"}
	tiberiumcentri3Entity.minable.result = "tiberium-centrifuge-3"
	tiberiumcentri3Entity.module_specification =
    {
      module_slots = 4
    }
	tiberiumcentri3Entity.idle_animation =
	--tint={r=200/255,g=40/255,b=220/255,a=0.8}, purple
    {
      layers =
      {
        -- Centrifuge A
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
		  tint={r=0.3,g=0.8,b=0.3,a=0.8},
          priority = "high",
          line_length = 8,
          width = 119,
          height = 107,
          frame_count = 64,
          shift = util.by_pixel(-0.5, -26.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C.png",
			tint={r=0.3,g=0.8,b=0.3,a=0.8},
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 237,
            height = 214,
            frame_count = 64,
            shift = util.by_pixel(-0.25, -26.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-C-shadow.png",
          draw_as_shadow = true,
          priority = "high",
          line_length = 8,
          width = 132,
          height = 74,
          frame_count = 64,
          shift = util.by_pixel(20, -10),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-shadow.png",
            draw_as_shadow = true,
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 279,
            height = 152,
            frame_count = 64,
            shift = util.by_pixel(16.75, -10)
          }
        },
        -- Centrifuge B
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
		  tint={r=0.3,g=0.8,b=0.3,a=0.8},
          priority = "high",
          line_length = 8,
          width = 78,
          height = 117,
          frame_count = 64,
          shift = util.by_pixel(23, 6.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B.png",
			tint={r=0.3,g=0.8,b=0.3,a=0.8},
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 156,
            height = 234,
            frame_count = 64,
            shift = util.by_pixel(23, 6.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-B-shadow.png",
          draw_as_shadow = true,
          priority = "high",
          line_length = 8,
          width = 124,
          height = 74,
          frame_count = 64,
          shift = util.by_pixel(63, 16),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B-shadow.png",
            draw_as_shadow = true,
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 251,
            height = 149,
            frame_count = 64,
            shift = util.by_pixel(63.25, 15.25)
          }
        },
        -- Centrifuge A
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-A.png",
		  tint={r=0.3,g=0.8,b=0.3,a=0.8},
          priority = "high",
          line_length = 8,
          width = 70,
          height = 123,
          frame_count = 64,
          shift = util.by_pixel(-26, 3.5),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A.png",
			tint={r=0.3,g=0.8,b=0.3,a=0.8},
            priority = "high",
            scale = 0.5,
            line_length = 8,
            width = 139,
            height = 246,
            frame_count = 64,
            shift = util.by_pixel(-26.25, 3.5)
          }
        },
        {
          filename = "__base__/graphics/entity/centrifuge/centrifuge-A-shadow.png",
          priority = "high",
          draw_as_shadow = true,
          line_length = 8,
          width = 108,
          height = 54,
          frame_count = 64,
          shift = util.by_pixel(6, 27),
          hr_version =
          {
            filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A-shadow.png",
            priority = "high",
            draw_as_shadow = true,
            scale = 0.5,
            line_length = 8,
            width = 230,
            height = 124,
            frame_count = 64,
            shift = util.by_pixel(8.5, 23.5)
          }
        }
      }
    },
	
	data:extend({tiberiumcentri3Item,tiberiumcentri3Entity,	
	{
      type = "recipe",
      name = "tiberium-centrifuge-3",
      energy_required = 15,
      enabled = "false",
	  subgroup = "a-buildings",
	  order = "m",
      ingredients = {
        {"refined-concrete", 25},
		{"steel-plate", 25},
		{"electric-engine-unit", 10},
        {"processing-unit", 25},
        {"tiberium-centrifuge-2", 1}
      },
      result = "tiberium-centrifuge-3"
    },})
