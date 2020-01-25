TibProductivity = {}

table.insert(TibProductivity, "tiberium-ore-processing")
table.insert(TibProductivity, "advanced-tiberium-ore-processing")
table.insert(TibProductivity, "iron-growth-credit")
table.insert(TibProductivity, "copper-growth-credit")
table.insert(TibProductivity, "coal-growth-credit")
table.insert(TibProductivity, "uranium-growth-credit")
table.insert(TibProductivity, "oil-growth-credit")
table.insert(TibProductivity, "energy-growth-credit")

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
    fuel_value = "25MJ",
	emissions_multiplier = 3,
    pressure_to_speed_ratio = 0.4,
    type = "fluid"
  },
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
    icon = "__Factorio-Tiberium__/graphics/icons/fluid/molten-tiberium.png",
    icon_size = 32,
    max_temperature = 1000,
    name = "molten-tiberium",
    order = "a[fluid]-c[crude-oil]",
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
    icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-sludge.png",
    icon_size = 32,
    max_temperature = 1000,
    name = "tiberium-sludge",
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
    icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-waste.png",
    icon_size = 32,
    max_temperature = 1000,
    name = "tiberium-slurry",
    order = "a[fluid]-d[crude-oil]",
    pressure_to_speed_ratio = 0.05,
    type = "fluid"
  },
  {
    type = "item",
    name = "tiberium-bar",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-bar.png",
    icon_size = 32,
    flags = {},
    subgroup = "intermediate-product",
    stack_size = 100
  },
  {
    type = "item",
    name = "tiberium-brick",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-bar.png",
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
      name = "tiberium-ore-pressing",
      category = "crafting",
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-ore", amount = 5}
      },
      results = {
        {type = "item", name = "tiberium-bar", amount = 1},
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-bar.png",
      icon_size = 32,
      subgroup = "a-refining",
      order = "a"
    },
    {
      type = "recipe",
      name = "tiberium-ore-processing",
      category = "oil-processing",
      energy_required = 15,
	  emissions_multiplier = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 150},
         {type = "item", name = "tiberium-bar", amount = 10},
      },
      results = {
        {type = "fluid", name = "tiberium-slurry", amount = 6},
		{type = "fluid", name = "tiberium-sludge", amount = 1}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-waste.png",
      icon_size = 32,
      subgroup = "a-refining",
      order = "a"
    },
    {
      type = "recipe",
      name = "advanced-tiberium-ore-processing",
      category = "oil-processing",
      energy_required = 10,
	  emissions_multiplier = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 100},
        {type = "fluid", name = "tiberium-slurry", amount = 10},
      },
      results = {
        {type = "fluid", name = "molten-tiberium", amount = 6},
		{type = "fluid", name = "tiberium-sludge", amount = 1}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/molten-tiberium.png",
      icon_size = 32,
      subgroup = "a-refining",
      order = "b"
    },
	{
      type = "recipe",
      name = "tiberium-liquid-processing",
      category = "chemistry",
      energy_required = 60,
	  emissions_multiplier = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 9},
      },
      results = {
        {type = "fluid", name = "liquid-tiberium", amount = 3},
		{type = "fluid", name = "tiberium-sludge", amount = 1}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/liquid-tiberium.png",
      icon_size = 32,
      subgroup = "a-refining",
      order = "m"
    },
	{
      type = "recipe",
      name = "tiberium-sludge-to-stone-brick",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-sludge", amount = 1}
      },
      results = {
        {type = "item", name = "stone-brick", amount = 1}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-sludge-to-stone-brick.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "z"
    },
    
    {
      type = "recipe",
      name = "tiberium-molten-to-iron-ore",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1}
      },
      results = {
        {type = "item", name = "iron-ore", amount = 20}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-to-iron.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-e[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-molten-to-copper-ore",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1}
      },
      results = {
        {type = "item", name = "copper-ore", amount = 15}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-to-copper.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-f[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-molten-to-coal",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1}
      },
      results = {
        {type = "item", name = "coal", amount = 10}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-to-coal.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-g[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-molten-to-stone",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1}
      },
      results = {
        {type = "item", name = "stone", amount = 5}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-to-stone.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-d[petroleum-gas-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-slurry-to-uranium-ore",
      category = "chemistry",
      energy_required = 5,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 2}
      },
      results = {
        {type = "item", name = "uranium-ore", amount = 1}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-to-uranium.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-y[petroleum-gas-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-slurry-to-crude-oil",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 1}
      },
      results = {
        {type = "fluid", name = "crude-oil", amount = 25}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-to-oil.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-z[heavy-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-ore-centrifuging",
      category = "centrifuging",
	  subgroup = "a-centrifuging",
      energy_required = 10,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 100},
         {type = "item", name = "tiberium-bar", amount = 25},
      },
      results = {
		{type = "item", name = "stone", amount = 1},
		{type = "item", name = "coal", amount = 1},
        {type = "item", name = "copper-ore", amount = 6},
		{type = "item", name = "iron-ore", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-centrifuging.png",
      icon_size = 32,
      order = "a[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-slurry-centrifuging",
      category = "centrifuging",
	  subgroup = "a-centrifuging",
      energy_required = 8,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 15}
      },
      results = {
		{type = "item", name = "stone", amount = 1},
		{type = "item", name = "coal", amount = 1},
        {type = "item", name = "copper-ore", amount = 6},
		{type = "item", name = "iron-ore", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-centrifuging.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-molten-centrifuging",
      category = "centrifuging",
	  subgroup = "a-centrifuging",
      energy_required = 6,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 9}
      },
      results = {
		{type = "item", name = "stone", amount = 1},
		{type = "item", name = "coal", amount = 1},
        {type = "item", name = "copper-ore", amount = 6},
		{type = "item", name = "iron-ore", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-centrifuging.png",
      icon_size = 32,
      order = "c[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "tiberium-ore-sludge-centrifuging",
      category = "centrifuging",
	  subgroup = "a-centrifuging",
      energy_required = 10,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 100},
        {type = "item", name = "tiberium-bar", amount = 25}
      },
      results = {
		{type = "fluid", name = "tiberium-sludge", amount = 1},
		{type = "item", name = "coal", amount = 1},
        {type = "item", name = "copper-ore", amount = 6},
		{type = "item", name = "iron-ore", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-centrifuging.png",
      icon_size = 32,
      order = "d"
    },
    {
      type = "recipe",
      name = "tiberium-slurry-sludge-centrifuging",
      category = "centrifuging",
	  subgroup = "a-centrifuging",
      energy_required = 8,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 15}
      },
      results = {
		{type = "fluid", name = "tiberium-sludge", amount = 1},
		{type = "item", name = "coal", amount = 1},
        {type = "item", name = "copper-ore", amount = 6},
		{type = "item", name = "iron-ore", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-centrifuging.png",
      icon_size = 32,
      order = "e"
    },
    {
      type = "recipe",
      name = "tiberium-molten-sludge-centrifuging",
      category = "centrifuging",
	  subgroup = "a-centrifuging",
      energy_required = 6,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 9}
      },
      results = {
		{type = "fluid", name = "tiberium-sludge", amount = 1},
		{type = "item", name = "coal", amount = 1},
        {type = "item", name = "copper-ore", amount = 6},
		{type = "item", name = "iron-ore", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-centrifuging.png",
      icon_size = 32,
      order = "f"
    },
    {
      type = "recipe",
      name = "tiberium-waste-recycling",
      category = "chemistry",
      energy_required = 10,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 20},
        {type = "fluid", name = "tiberium-sludge", amount = 5}
      },
      results = {
        {type = "fluid", name = "molten-tiberium", amount = 23}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-recycling.png",
      icon_size = 32,
      subgroup = "a-refining",
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "iron-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "iron-ore", amount = 106}
      },
      results = {
        {type = "item", name = "growth-credit", amount = 1},
      },
      icon = "__Factorio-Tiberium__/graphics/icons/iron-growth-credit.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "copper-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "copper-ore", amount = 106}
      },
      results = {
        {type = "item", name = "growth-credit", amount = 1},
      },
      icon = "__Factorio-Tiberium__/graphics/icons/copper-growth-credit.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "coal-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "coal", amount = 106}
      },
      results = {
        {type = "item", name = "growth-credit", amount = 1},
      },
      icon = "__Factorio-Tiberium__/graphics/icons/coal-growth-credit.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "uranium-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "uranium-ore", amount = 32}
      },
      results = {
        {type = "item", name = "growth-credit", amount = 1},
      },
      icon = "__Factorio-Tiberium__/graphics/icons/uranium-growth-credit.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "stone-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "stone", amount = 106}
      },
      results = {
        {type = "item", name = "growth-credit", amount = 1},
      },
      icon = "__Factorio-Tiberium__/graphics/icons/stone-growth-credit.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "oil-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "crude-oil", amount = 1060}
      },
      results = {
        {type = "item", name = "growth-credit", amount = 1},
      },
      icon = "__Factorio-Tiberium__/graphics/icons/oil-growth-credit.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "energy-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
      energy_required = 200,
      enabled = false,
      ingredients = {
      },
      results = {
        {type = "item", name = "growth-credit", amount = 1},
      },
      icon = "__Factorio-Tiberium__/graphics/icons/energy-growth-credit.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "liquid-tiberium-cell",
      category = "chemistry",
	  subgroup = "a-items",
      energy_required = 20,
      enabled = false,
      ingredients = {
		{type = "fluid", name = "liquid-tiberium", amount = 102},
		{type = "item", name = "steel-plate", amount = 2},
		{type = "item", name = "copper-plate", amount = 2},
        {type = "item", name = "electric-engine-unit", amount = 1},
        {type = "item", name = "processing-unit", amount = 2},
        {type = "item", name = "pipe", amount = 1},
      },
      results = {
        {type = "item", name = "nuclear-fuel", amount = 1},
      },
      icon = "__base__/graphics/icons/nuclear-fuel.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "tiberium-ion-core",
      category = "chemistry",
	  subgroup = "a-items",
      energy_required = 20,
      enabled = false,
      ingredients = {
		{type = "fluid", name = "liquid-tiberium", amount = 1},
		{type = "item", name = "steel-plate", amount = 2},
		{type = "item", name = "copper-plate", amount = 2},
        {type = "item", name = "processing-unit", amount = 2},
        {type = "item", name = "pipe", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-ion-core", amount = 1},
      },
      icon = "__base__/graphics/icons/nuclear-reactor.png",
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
		type = "recipe",
		name = "CnC_SonicWall_Hub",
        enabled = false,
		energy_required = 5,
		ingredients = {{"steel-plate", 25}, {"advanced-circuit", 10}, {"battery", 10}},
		result = "CnC_SonicWall_Hub"
	},
  }
)


	--[[{
      type = "recipe",
      name = "advanced-tiberium-brick-processing",
      category = "crafting-with-fluid",
      energy_required = 4,
	  emissions_multiplier = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 3}
      },
      results = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-brick.png",
      icon_size = 32,
      subgroup = "a-refining",
      order = "h"
    },
	{
      type = "recipe",
      name = "tiberium-brick-to-iron-ore",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "item", name = "iron-ore", amount = 4}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-brick-to-iron.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-e[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-copper-ore",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "item", name = "copper-ore", amount = 4}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-brick-to-copper.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-f[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-coal",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "item", name = "coal", amount = 4}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-brick-to-coal.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-g[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-brick-to-stone",
      category = "chemistry",
      energy_required = 4,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-brick", amount = 1}
      },
      results = {
        {type = "item", name = "stone", amount = 4}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-brick-to-stone.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-d[petroleum-gas-processing]"
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
      subgroup = "a-direct",
      order = "b[oil-processing]-g[light-oil-processing]"
    },
	{
      type = "recipe",
      name = "tiberium-molten-to-water",
      category = "chemistry",
      energy_required = 0.1,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1}
      },
      results = {
        {type = "fluid", name = "water", amount = 1000}
      },
      icon = "__base__/graphics/icons/fluid/water.png",
      icon_size = 32,
      subgroup = "a-direct",
      order = "b[oil-processing]-g[light-oil-processing]"
    },]]
