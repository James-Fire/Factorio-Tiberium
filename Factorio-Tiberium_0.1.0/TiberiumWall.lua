--[[local item = {
    type = "item",
    name = "tiberium-wall",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-wall.png",
    icon_size = 32,
    flags = {},
    subgroup = "a-buildings",
    order = "a[wall]-a[wall]",
    place_result = "tiberium-wall",
    stack_size = 100
}

local tiberiumWall = {
    type = "wall",
    name = "tiberium-wall",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-wall.png",
	icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    minable = {mining_time = 0.5, result = "tiberium-wall"},
    fast_replaceable_group = "wall",
    max_health = 350,
    repair_speed_modifier = 2,
    corpse = "wall-remnants",
    repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
    mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
    vehicle_impact_sound =  { filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0 },
    -- this kind of code can be used for having walls mirror the effect
    -- there can be multiple reaction items
    --attack_reaction =
    --{
      --{
        ---- how far the mirroring works
        --range = 2,
        ---- what kind of damage triggers the mirroring
        ---- if not present then anything triggers the mirroring
        --damage_type = "physical",
        ---- caused damage will be multiplied by this and added to the subsequent damages
        --reaction_modifier = 0.1,
        --action =
        --{
          --type = "direct",
          --action_delivery =
          --{
            --type = "instant",
            --target_effects =
            --{
              --type = "damage",
              ---- always use at least 0.1 damage
              --damage = {amount = 0.1, type = "physical"}
            --}
          --}
        --},
      --}
    --},
    connected_gate_visualization =
    {
      filename = "__core__/graphics/arrows/underground-lines.png",
      priority = "high",
      width = 64,
      height = 64,
      scale = 0.5
    },
    resistances =
    {
      {
        type = "physical",
        decrease = 3,
        percent = 20
      },
      {
        type = "impact",
        decrease = 45,
        percent = 60
      },
      {
        type = "explosion",
        decrease = 10,
        percent = 30
      },
      {
        type = "fire",
        percent = 100
      },
      {
        type = "laser",
        percent = 70
      },
	  {
		type = "acid",
		decrease = 100,
		percent = 100
	  }
    },
    pictures =
    {
      single =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-single.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 32,
            height = 46,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -6),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-single.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 64,
              height = 86,
              variation_count = 2,
              line_length = 2,
              shift = util.by_pixel(0, -5),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-single-shadow.png",
            priority = "extra-high",
            width = 50,
            height = 32,
            repeat_count = 2,
            shift = util.by_pixel(10, 16),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-single-shadow.png",
              priority = "extra-high",
              width = 98,
              height = 60,
              repeat_count = 2,
              shift = util.by_pixel(10, 17),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      straight_vertical =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-vertical.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 32,
            height = 68,
            variation_count = 5,
            line_length = 5,
            shift = util.by_pixel(0, 8),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-vertical.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 64,
              height = 134,
              variation_count = 5,
              line_length = 5,
              shift = util.by_pixel(0, 8),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-vertical-shadow.png",
            priority = "extra-high",
            width = 50,
            height = 58,
            repeat_count = 5,
            shift = util.by_pixel(10, 28),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-vertical-shadow.png",
              priority = "extra-high",
              width = 98,
              height = 110,
              repeat_count = 5,
              shift = util.by_pixel(10, 29),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      straight_horizontal =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-horizontal.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 32,
            height = 50,
            variation_count = 6,
            line_length = 6,
            shift = util.by_pixel(0, -4),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-horizontal.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 64,
              height = 92,
              variation_count = 6,
              line_length = 6,
              shift = util.by_pixel(0, -2),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-horizontal-shadow.png",
            priority = "extra-high",
            width = 62,
            height = 36,
            repeat_count = 6,
            shift = util.by_pixel(14, 14),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-horizontal-shadow.png",
              priority = "extra-high",
              width = 124,
              height = 68,
              repeat_count = 6,
              shift = util.by_pixel(14, 15),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      corner_right_down =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-corner-right.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 32,
            height = 64,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, 6),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-corner-right.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 64,
              height = 128,
              variation_count = 2,
              line_length = 2,
              shift = util.by_pixel(0, 7),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-corner-right-shadow.png",
            priority = "extra-high",
            width = 62,
            height = 60,
            repeat_count = 2,
            shift = util.by_pixel(14, 28),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-corner-right-shadow.png",
              priority = "extra-high",
              width = 124,
              height = 120,
              repeat_count = 2,
              shift = util.by_pixel(17, 28),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      corner_left_down =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-corner-left.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 32,
            height = 68,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, 6),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-corner-left.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 64,
              height = 134,
              variation_count = 2,
              line_length = 2,
              shift = util.by_pixel(0, 7),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-corner-left-shadow.png",
            priority = "extra-high",
            width = 54,
            height = 60,
            repeat_count = 2,
            shift = util.by_pixel(8, 28),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-corner-left-shadow.png",
              priority = "extra-high",
              width = 102,
              height = 120,
              repeat_count = 2,
              shift = util.by_pixel(9, 28),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      t_up =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-t.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 32,
            height = 68,
            variation_count = 4,
            line_length = 4,
            shift = util.by_pixel(0, 6),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-t.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 64,
              height = 134,
              variation_count = 4,
              line_length = 4,
              shift = util.by_pixel(0, 7),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-t-shadow.png",
            priority = "extra-high",
            width = 62,
            height = 60,
            repeat_count = 4,
            shift = util.by_pixel(14, 28),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-t-shadow.png",
              priority = "extra-high",
              width = 124,
              height = 120,
              repeat_count = 4,
              shift = util.by_pixel(14, 28),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      ending_right =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-ending-right.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 32,
            height = 48,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -4),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-ending-right.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 64,
              height = 92,
              variation_count = 2,
              line_length = 2,
              shift = util.by_pixel(0, -3),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-ending-right-shadow.png",
            priority = "extra-high",
            width = 62,
            height = 36,
            repeat_count = 2,
            shift = util.by_pixel(14, 14),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-ending-right-shadow.png",
              priority = "extra-high",
              width = 124,
              height = 68,
              repeat_count = 2,
              shift = util.by_pixel(17, 15),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      ending_left =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-ending-left.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 32,
            height = 48,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -4),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-ending-left.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 64,
              height = 92,
              variation_count = 2,
              line_length = 2,
              shift = util.by_pixel(0, -3),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-ending-left-shadow.png",
            priority = "extra-high",
            width = 54,
            height = 36,
            repeat_count = 2,
            shift = util.by_pixel(8, 14),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-ending-left-shadow.png",
              priority = "extra-high",
              width = 102,
              height = 68,
              repeat_count = 2,
              shift = util.by_pixel(9, 15),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      filling =
      {
        filename = "__base__/graphics/entity/wall/wall-filling.png",
		tint={r=0.2,g=0.5,b=0.2,a=0.9},
          priority = "extra-high",
          width = 24,
          height = 30,
          variation_count = 8,
          line_length = 8,
          shift = util.by_pixel(0, -2),
          hr_version =
          {
            filename = "__base__/graphics/entity/wall/hr-wall-filling.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 48,
            height = 56,
            variation_count = 8,
            line_length = 8,
            shift = util.by_pixel(0, -1),
            scale = 0.5
          }
      },
      water_connection_patch =
      {
        sheets =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-patch.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 58,
            height = 64,
            shift = util.by_pixel(0, -2),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-patch.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 116,
              height = 128,
              shift = util.by_pixel(0, -2),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-patch-shadow.png",
            priority = "extra-high",
            width = 74,
            height = 52,
            shift = util.by_pixel(8, 14),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-patch-shadow.png",
              priority = "extra-high",
              width = 144,
              height = 100,
              shift = util.by_pixel(9, 15),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      },
      gate_connection_patch =
      {
        sheets =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-gate.png",
			tint={r=0.2,g=0.5,b=0.2,a=0.9},
            priority = "extra-high",
            width = 42,
            height = 56,
            shift = util.by_pixel(0, -8),
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-gate.png",
			  tint={r=0.2,g=0.5,b=0.2,a=0.9},
              priority = "extra-high",
              width = 82,
              height = 108,
              shift = util.by_pixel(0, -7),
              scale = 0.5
            }
          },
          {
            filename = "__base__/graphics/entity/wall/wall-gate-shadow.png",
            priority = "extra-high",
            width = 66,
            height = 40,
            shift = util.by_pixel(14, 18),
            draw_as_shadow = true,
            hr_version =
            {
              filename = "__base__/graphics/entity/wall/hr-wall-gate-shadow.png",
              priority = "extra-high",
              width = 130,
              height = 78,
              shift = util.by_pixel(14, 18),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        }
      }
    },

    wall_diode_green = util.conditional_return(not data.is_demo,
    {
      sheet =
      {
        filename = "__base__/graphics/entity/wall/wall-diode-green.png",
        priority = "extra-high",
        width = 38,
        height = 24,
        --frames = 4, -- this is optional, it will default to 4 for Sprite4Way
        shift = util.by_pixel(-2, -24),
        hr_version =
        {
          filename = "__base__/graphics/entity/wall/hr-wall-diode-green.png",
          priority = "extra-high",
          width = 72,
          height = 44,
          --frames = 4,
          shift = util.by_pixel(-1, -23),
          scale = 0.5
        }
      }
    }),
    wall_diode_green_light_top = util.conditional_return(not data.is_demo,
    {
      minimum_darkness = 0.3,
      color = {g=1},
      shift = util.by_pixel(0, -30),
      size = 1,
      intensity = 0.3
    }),
    wall_diode_green_light_right = util.conditional_return(not data.is_demo,
    {
      minimum_darkness = 0.3,
      color = {g=1},
      shift = util.by_pixel(12, -23),
      size = 1,
      intensity = 0.3
    }),
    wall_diode_green_light_bottom = util.conditional_return(not data.is_demo,
    {
      minimum_darkness = 0.3,
      color = {g=1},
      shift = util.by_pixel(0, -17),
      size = 1,
      intensity = 0.3
    }),
    wall_diode_green_light_left = util.conditional_return(not data.is_demo,
    {
      minimum_darkness = 0.3,
      color = {g=1},
      shift = util.by_pixel(-12, -23),
      size = 1,
      intensity = 0.3
    }),

    wall_diode_red = util.conditional_return(not data.is_demo,
    {
      sheet =
      {
        filename = "__base__/graphics/entity/wall/wall-diode-red.png",
        priority = "extra-high",
        width = 38,
        height = 24,
        --frames = 4, -- this is optional, it will default to 4 for Sprite4Way
        shift = util.by_pixel(-2, -24),
        hr_version =
        {
          filename = "__base__/graphics/entity/wall/hr-wall-diode-red.png",
          priority = "extra-high",
          width = 72,
          height = 44,
          --frames = 4,
          shift = util.by_pixel(-1, -23),
          scale = 0.5
        }
      }
    }),
    wall_diode_red_light_top = util.conditional_return(not data.is_demo,
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = util.by_pixel(0, -30),
      size = 1,
      intensity = 0.3
    }),
    wall_diode_red_light_right = util.conditional_return(not data.is_demo,
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = util.by_pixel(12, -23),
      size = 1,
      intensity = 0.3
    }),
    wall_diode_red_light_bottom = util.conditional_return(not data.is_demo,
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = util.by_pixel(0, -17),
      size = 1,
      intensity = 0.3
    }),
    wall_diode_red_light_left = util.conditional_return(not data.is_demo,
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = util.by_pixel(-12, -23),
      size = 1,
      intensity = 0.3
    }),

    circuit_wire_connection_point = circuit_connector_definitions["gate"].points,
    circuit_connector_sprites = circuit_connector_definitions["gate"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance,
    default_output_signal = data.is_demo and {type = "virtual", name = "signal-green"} or {type = "virtual", name = "signal-G"}
  },
  {
    type = "corpse",
    name = "wall-remnants",
    icon = "__base__/graphics/icons/wall-remnants.png",
    icon_size = 32,
    flags = {"placeable-neutral", "not-on-map"},
    subgroup="remnants",
    order="d[remnants]-c[wall]",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selectable_in_game = false,
    time_before_removed = 60 * 60 * 15, -- 15 minutes
    final_render_layer = "remnants",
    animation =
    {
      {
        width = 36,
        height = 36,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/wall/remains/wall-remain-01.png"
      },
      {
        width = 38,
        height = 35,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/wall/remains/wall-remain-02.png"
      },
      {
        width = 35,
        height = 36,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/wall/remains/wall-remain-03.png"
      },
      {
        width = 41,
        height = 36,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/wall/remains/wall-remain-04.png"
      },
      {
        width = 35,
        height = 35,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/wall/remains/wall-remain-05.png"
      },
      {
        width = 50,
        height = 37,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/wall/remains/wall-remain-06.png"
      },
      {
        width = 54,
        height = 40,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/wall/remains/wall-remain-07.png"
      },
      {
        width = 43,
        height = 45,
        frame_count = 1,
        direction_count = 1,
        filename = "__base__/graphics/entity/wall/remains/wall-remain-08.png"
      }
    }
  }

 tiberiumWall.pictures.tint={r=0.2,g=0.5,b=0.2,a=0.9}
 
 local recipe = {
    type = "recipe",
    name = "tiberium-wall",
    ingredients = {{"electronic-circuit",5},{"stone-wall",1}},
	subgroup = "a-buildings",
    result = "tiberium-wall",
    energy_required = 2,
    enabled = false
}

data:extend{item, tiberiumWall,recipe}

local item = {
    type = "item",
    name = "tiberium-gate",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-gate.png",
    icon_size = 32,
    flags = {},
    subgroup = "a-buildings",
    order = "a[wall]-a[wall]",
    place_result = "tiberium-gate",
    stack_size = 100
}
 
local tiberiumGate = util.table.deepcopy(data.raw["gate"]["gate"])
tiberiumGate.name = "tiberium-gate"

--tiberiumGate.pictures.tint={r=0.2,g=0.5,b=0.2,a=0.9}
 
local recipe = {
    type = "recipe",
    name = "tiberium-gate",
    ingredients = {{"electronic-circuit",5},{"gate",1}},
    result = "tiberium-gate",
	subgroup = "a-buildings",
    energy_required = 2,
    enabled = false
}
data:extend{item, tiberiumGate,recipe}]]
