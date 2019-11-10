TibProductivity = {}

table.insert(TibProductivity, "tiberium-ore-processing")
table.insert(TibProductivity, "advanced-tiberium-ore-processing")
table.insert(TibProductivity, "advanced-tiberium-brick-processing")
table.insert(TibProductivity, "tiberium-brick-to-iron-ore")
table.insert(TibProductivity, "tiberium-brick-to-copper-ore")
table.insert(TibProductivity, "tiberium-brick-to-coal")
table.insert(TibProductivity, "tiberium-brick-to-stone")
table.insert(TibProductivity, "tiberium-brick-to-uranium-ore")
table.insert(TibProductivity, "tiberium-brick-to-crude-oil")
table.insert(TibProductivity, "tiberium-brick-to-water")
table.insert(TibProductivity, "tiberium-liquid-to-iron-ore")
table.insert(TibProductivity, "tiberium-liquid-to-copper-ore")
table.insert(TibProductivity, "tiberium-liquid-to-coal")
table.insert(TibProductivity, "tiberium-liquid-to-stone")
table.insert(TibProductivity, "tiberium-liquid-to-uranium-ore")
table.insert(TibProductivity, "tiberium-liquid-to-crude-oil")
table.insert(TibProductivity, "tiberium-liquid-to-water")

for km, vm in pairs(data.raw.module) do
  if vm.effect.productivity and vm.limitation then
    for _, recipe in ipairs(TibProductivity) do
      table.insert(vm.limitation, recipe)
    end
  end
end

data:extend {
  {
    base_color = {
      b = 0,
      g = 1,
      r = 0
    },
    default_temperature = 75,
    flow_color = {
      b = 0.1,
      g = 1.0,
      r = 0.1
    },
    flow_to_energy_ratio = 0.3,
    heat_capacity = "1KJ",
    icon = "__Factorio-Tiberium__/graphics/icons/fluid/liquid-tiberium.png",
    icon_size = 32,
    max_temperature = 1000,
    name = "liquid-tiberium",
    order = "a[fluid]-c[crude-oil]",
    fuel_value = "50MJ",
    pressure_to_speed_ratio = 0.4,
    type = "fluid"
  },
  {
    base_color = {
      b = 0.3,
      g = 0.5,
      r = 0.3
    },
    default_temperature = 75,
    flow_color = {
      b = 0.3,
      g = 0.5,
      r = 0.3
    },
    flow_to_energy_ratio = 0.2,
    heat_capacity = "1KJ",
    icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-waste.png",
    icon_size = 32,
    max_temperature = 1000,
    name = "tiberium-waste",
    order = "a[fluid]-d[crude-oil]",
    pressure_to_speed_ratio = 0.2,
    type = "fluid"
  },
  {
    base_color = {
      b = 0,
      g = 0.7,
      r = 0
    },
    default_temperature = 50,
    flow_color = {
      b = 0,
      g = 0.7,
      r = 0
    },
    flow_to_energy_ratio = 0.5,
    heat_capacity = "1KJ",
    icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-sludge.png",
    icon_size = 32,
    max_temperature = 1000,
    name = "tiberium-sludge",
    order = "a[fluid]-d[crude-oil]",
    pressure_to_speed_ratio = 0.05,
    type = "fluid"
  },
  {
    type = "item",
    name = "tiberium-brick",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-brick.png",
    icon_size = 32,
    flags = {},
    subgroup = "intermediate-product",
    stack_size = 100
  }
}

data:extend(
  {
    {
      type = "recipe",
      name = "tiberium-ore-processing",
      category = "oil-processing",
      energy_required = 0.3,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 100},
        {type = "item", name = "tiberium-ore", amount = 5}
      },
      results = {
        {type = "fluid", name = "tiberium-sludge", amount = 8},
        {type = "fluid", name = "tiberium-waste", amount = 1}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-sludge.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "advanced-tiberium-ore-processing",
      category = "oil-processing",
      energy_required = 0.2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 50},
        {type = "item", name = "tiberium-ore", amount = 5}
      },
      results = {
        {type = "fluid", name = "liquid-tiberium", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/liquid-tiberium.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "advanced-tiberium-brick-processing",
      category = "crafting-with-fluid",
      energy_required = 0.2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 20}
      },
      results = {
        {type = "item", name = "tiberium-brick", amount = 3}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-brick.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-h[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-iron-ore",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "item", name = "iron-ore", amount = 1}
      },
      icon = "__base__/graphics/icons/iron-ore.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-e[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-copper-ore",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "item", name = "copper-ore", amount = 1}
      },
      icon = "__base__/graphics/icons/copper-ore.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-f[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-coal",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 2}
      },
      results = {
        {type = "item", name = "coal", amount = 1}
      },
      icon = "__base__/graphics/icons/coal.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-g[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-stone",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "item", name = "stone", amount = 1}
      },
      icon = "__base__/graphics/icons/stone.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-d[petroleum-gas-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-uranium-ore",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 10}
      },
      results = {
        {type = "item", name = "uranium-ore", amount = 1}
      },
      icon = "__base__/graphics/icons/uranium-ore.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-d[petroleum-gas-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-crude-oil",
      category = "chemistry",
      energy_required = 0.2,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "fluid", name = "crude-oil", amount = 10}
      },
      icon = "__base__/graphics/icons/fluid/crude-oil.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-f[heavy-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-water",
      category = "chemistry",
      energy_required = 0.1,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "fluid", name = "water", amount = 1000}
      },
      icon = "__base__/graphics/icons/fluid/water.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-g[light-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-liquid-to-iron-ore",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 3}
      },
      results = {
        {type = "item", name = "iron-ore", amount = 1}
      },
      icon = "__base__/graphics/icons/iron-ore.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-e[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-liquid-to-copper-ore",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 3}
      },
      results = {
        {type = "item", name = "copper-ore", amount = 1}
      },
      icon = "__base__/graphics/icons/copper-ore.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-f[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-liquid-to-coal",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 6}
      },
      results = {
        {type = "item", name = "coal", amount = 1}
      },
      icon = "__base__/graphics/icons/coal.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-g[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-liquid-to-stone",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 3}
      },
      results = {
        {type = "item", name = "stone", amount = 1}
      },
      icon = "__base__/graphics/icons/stone.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-d[petroleum-gas-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-liquid-to-uranium-ore",
      category = "chemistry",
      energy_required = 0.5,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 30}
      },
      results = {
        {type = "item", name = "uranium-ore", amount = 1}
      },
      icon = "__base__/graphics/icons/uranium-ore.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-d[petroleum-gas-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-liquid-to-crude-oil",
      category = "chemistry",
      energy_required = 0.2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 3}
      },
      results = {
        {type = "fluid", name = "crude-oil", amount = 10}
      },
      icon = "__base__/graphics/icons/fluid/crude-oil.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-f[heavy-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-liquid-to-water",
      category = "chemistry",
      energy_required = 0.1,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 6}
      },
      results = {
        {type = "fluid", name = "water", amount = 1000}
      },
      icon = "__base__/graphics/icons/fluid/water.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[oil-processing]-g[light-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-ore-centrifuging",
      category = "centrifuging",
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 100},
        {type = "item", name = "tiberium-ore", amount = 16}
      },
      results = {
        {type = "item", name = "iron-ore", amount = 7},
        {type = "item", name = "copper-ore", amount = 6},
        {type = "item", name = "coal", amount = 3},
        {type = "item", name = "uranium-ore", amount = 1},
        {type = "item", name = "stone", amount = 1},
        {type = "fluid", name = "crude-oil", amount = 10}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-ore.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-sludge-centrifuging",
      category = "centrifuging",
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-sludge", amount = 20}
      },
      results = {
        {type = "item", name = "iron-ore", amount = 7},
        {type = "item", name = "copper-ore", amount = 6},
        {type = "item", name = "coal", amount = 3},
        {type = "item", name = "uranium-ore", amount = 1},
        {type = "item", name = "stone", amount = 1},
        {type = "fluid", name = "crude-oil", amount = 10}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-sludge.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-liquid-centrifuging",
      category = "centrifuging",
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 16}
      },
      results = {
        {type = "item", name = "iron-ore", amount = 7},
        {type = "item", name = "copper-ore", amount = 6},
        {type = "item", name = "coal", amount = 3},
        {type = "item", name = "uranium-ore", amount = 1},
        {type = "item", name = "stone", amount = 1},
        {type = "fluid", name = "crude-oil", amount = 10}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/liquid-tiberium.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-waste-recycling",
      category = "chemistry",
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 20},
        {type = "fluid", name = "tiberium-waste", amount = 5}
      },
      results = {
        {type = "fluid", name = "liquid-tiberium", amount = 23}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-waste.png",
      icon_size = 32,
      subgroup = "fluid-recipes",
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    }
  }
)
