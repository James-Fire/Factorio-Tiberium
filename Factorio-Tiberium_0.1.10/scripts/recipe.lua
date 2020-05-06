
TibProductivity = {}
table.insert(TibProductivity, "tiberium-science")
table.insert(TibProductivity, "tiberium-ore-processing")
table.insert(TibProductivity, "advanced-tiberium-ore-processing")
table.insert(TibProductivity, "tiberium-liquid-processing")

for km, vm in pairs(data.raw.module) do
  if vm.effect.productivity and vm.limitation then
    for _, recipe in ipairs(TibProductivity) do
      table.insert(vm.limitation, recipe)
    end
  end
end

TibCraftingTint = {
  primary = {r=0.109804,g=0.721567,b=0.231373,a=1},
  secondary={r=0.098039,g=1,b=0.278431,a=1},
  tertiary={r=0.156863,g=0.156863,b=0.156863,a=0.235294},
  quaternary={r=0.160784,g=0.745098,b=0.3058824,a=0.345217},
},

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
    icon_size = 64,
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
    icon_size = 64,
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
    icon_size = 64,
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
    icon_size = 64,
    max_temperature = 1000,
    name = "tiberium-slurry",
    order = "a[fluid]-d[crude-oil]",
    pressure_to_speed_ratio = 0.05,
    type = "fluid"
  },
  {
    type = "item",
    name = "tiberium-empty-cell",
    icon = "__Factorio-Tiberium__/graphics/icons/empty-fuel-cell.png",
    icon_size = 64,
    flags = {},
    subgroup = "a-items",
    stack_size = 100
  },
  {
    type = "item",
    name = "tiberium-dirty-cell",
    icon = "__Factorio-Tiberium__/graphics/icons/dirty-fuel-cell.png",
    icon_size = 64,
    flags = {},
    subgroup = "a-items",
    stack_size = 5
  },
  {
    type = "item",
    name = "tiberium-fuel-cell",
    icon = "__base__/graphics/icons/uranium-fuel-cell.png",
    icon_size = 64,
    flags = {},
    subgroup = "a-items",
	fuel_category = "nuclear",
    burnt_result = "tiberium-dirty-cell",
	fuel_value = "1GJ",
    stack_size = 5
  },
  {
    type = "item",
    name = "tiberium-bar",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-bar.png",
    icon_size = 32,
    flags = {},
    subgroup = "a-items",
    stack_size = 100
  },
  {
    type = "item",
    name = "tiberium-data",
    icon = "__Factorio-Tiberium__/graphics/icons/tiberium-bar.png",
    icon_size = 32,
    flags = {},
    subgroup = "a-items",
    stack_size = 200
  },
  {
    type = "tool",
    name = "tiberium-science",
    icon = "__Factorio-Tiberium__/graphics/icons/Tacitus.png",
    icon_size = 32,
    flags = {},
    subgroup = "a-items",
	durability = 1,
	durability_description_key = "description.science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value",
    stack_size = 200,
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
--Science stuff. Making data, turning it into science, learning from farming tib
  {
	{
      type = "recipe",
      name = "tiberium-farming",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 40,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-ore", amount = 100},
		{type = "item", name = "growth-credit", amount = 1},
      },
      results = {
      },
      icon = "__Factorio-Tiberium__/graphics/icons/Tiberium-farming.png",
      icon_size = 64,
      subgroup = "a-science",
      order = "a-1"
    },
	{
      type = "recipe",
      name = "tiberium-science",
      category = "basic-tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-data", amount = 10},
      },
      results = {
        {type = "item", name = "tiberium-science", amount = 1}
      },
      icon_size = 64,
      subgroup = "a-science",
      order = "a"
    },
	--Ore Data
	{
      type = "recipe",
      name = "tiberium-ore-mechanical-data",
      category = "basic-tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-ore", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 1}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/ore-mechanical.png",
      icon_size = 64,
      subgroup = "a-science",
      order = "b"
    },
	{
      type = "recipe",
      name = "tiberium-ore-thermal-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 30,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-ore", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 2}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/ore-thermal.png",
      icon_size = 64,
      subgroup = "a-science",
      order = "c"
    },
	{
      type = "recipe",
      name = "tiberium-ore-chemical-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-ore", amount = 1},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 3}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/ore-chemical.png",
      icon_size = 64,
      subgroup = "a-science",
      order = "d"
    },
	{
      type = "recipe",
      name = "tiberium-ore-nuclear-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-ore", amount = 1},
		{type = "item", name = "uranium-ore", amount = 2}
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 4}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/ore-nuclear.png",
      icon_size = 64,
      subgroup = "a-science",
      order = "e"
    },
	{
      type = "recipe",
      name = "tiberium-ore-EM-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "item", name = "tiberium-ore", amount = 1},
		{type = "item", name = "processing-unit", amount = 1}
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 5}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/ore-EM.png",
      icon_size = 64,
      subgroup = "a-science",
      order = "f"
    },
	--Slurry Data
	{
      type = "recipe",
      name = "tiberium-slurry-mechanical-data",
      category = "basic-tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 2}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-mechanical.png",
      icon_size = 64,
      subgroup = "a-slurry-science",
      order = "a"
    },
	{
      type = "recipe",
      name = "tiberium-slurry-thermal-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 30,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 4}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-thermal.png",
      icon_size = 64,
      subgroup = "a-slurry-science",
      order = "b"
    },
	{
      type = "recipe",
      name = "tiberium-slurry-chemical-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 1},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 6}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-chemical.png",
      icon_size = 64,
      subgroup = "a-slurry-science",
      order = "c"
    },
	{
      type = "recipe",
      name = "tiberium-slurry-nuclear-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 1},
		{type = "item", name = "uranium-ore", amount = 2}
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-nuclear.png",
      icon_size = 64,
      subgroup = "a-slurry-science",
      order = "d"
    },
	{
      type = "recipe",
      name = "tiberium-slurry-EM-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 1},
		{type = "item", name = "processing-unit", amount = 1}
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 10}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-EM.png",
      icon_size = 64,
      subgroup = "a-slurry-science",
      order = "e"
    },
	--Molten Data
	{
      type = "recipe",
      name = "tiberium-molten-mechanical-data",
      category = "basic-tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 4}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-mechanical.png",
      icon_size = 64,
      subgroup = "a-molten-science",
      order = "a"
    },
	{
      type = "recipe",
      name = "tiberium-molten-thermal-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 30,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 8}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-thermal.png",
      icon_size = 64,
      subgroup = "a-molten-science",
      order = "b"
    },
	{
      type = "recipe",
      name = "tiberium-molten-chemical-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 12}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-chemical.png",
      icon_size = 64,
      subgroup = "a-molten-science",
      order = "c"
    },
	{
      type = "recipe",
      name = "tiberium-molten-nuclear-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1},
		{type = "item", name = "uranium-ore", amount = 2}
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 16}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-nuclear.png",
      icon_size = 64,
      subgroup = "a-molten-science",
      order = "d"
    },
	{
      type = "recipe",
      name = "tiberium-molten-EM-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 1},
		{type = "item", name = "processing-unit", amount = 1}
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 20}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-EM.png",
      icon_size = 64,
      subgroup = "a-molten-science",
      order = "e"
    },
	--Liquid Data
	{
      type = "recipe",
      name = "tiberium-liquid-mechanical-data",
      category = "basic-tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 14}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/liquid-mechanical.png",
      icon_size = 64,
      subgroup = "a-liquid-science",
      order = "a"
    },
	{
      type = "recipe",
      name = "tiberium-liquid-thermal-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 30,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 1},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 28}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/liquid-thermal.png",
      icon_size = 64,
      subgroup = "a-liquid-science",
      order = "b"
    },
	{
      type = "recipe",
      name = "tiberium-liquid-chemical-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 1},
		{type = "fluid", name = "sulfuric-acid", amount = 10},
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 42}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/liquid-chemical.png",
      icon_size = 64,
      subgroup = "a-liquid-science",
      order = "c"
    },
	{
      type = "recipe",
      name = "tiberium-liquid-nuclear-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 1},
		{type = "item", name = "uranium-ore", amount = 2}
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 56}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/liquid-nuclear.png",
      icon_size = 64,
      subgroup = "a-liquid-science",
      order = "d"
    },
	{
      type = "recipe",
      name = "tiberium-liquid-EM-data",
      category = "tiberium-science",
	  always_show_made_in = true,
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 1},
		{type = "item", name = "processing-unit", amount = 1}
      },
      results = {
        {type = "item", name = "tiberium-data", amount = 70}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/liquid-EM.png",
      icon_size = 64,
      subgroup = "a-liquid-science",
      order = "e"
    },
--Refining. Taking in a lower product, and turning it into a higher one. 
    {
      type = "recipe",
      name = "tiberium-ore-processing",
      category = "oil-processing",
      energy_required = 15,
	  crafting_machine_tint = TibCraftingTint,
	  emissions_multiplier = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 100},
         {type = "item", name = "tiberium-ore", amount = 10},
      },
      results = {
        {type = "fluid", name = "tiberium-slurry", amount = 6}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/tiberium-waste.png",
      icon_size = 64,
      subgroup = "a-refining",
      order = "a"
    },
    {
      type = "recipe",
      name = "advanced-tiberium-ore-processing",
      category = "oil-processing",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 10,
	  emissions_multiplier = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 10},
		{type = "fluid", name = "water", amount = 100},
      },
      results = {
        {type = "fluid", name = "molten-tiberium", amount = 6}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/molten-tiberium.png",
      icon_size = 64,
      subgroup = "a-refining",
      order = "b"
    },
	{
      type = "recipe",
      name = "tiberium-liquid-processing",
      category = "chemistry",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 60,
	  emissions_multiplier = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "molten-tiberium", amount = 9},
      },
      results = {
        {type = "fluid", name = "liquid-tiberium", amount = 3}
      },
      icon = "__Factorio-Tiberium__/graphics/icons/fluid/liquid-tiberium.png",
      icon_size = 64,
      subgroup = "a-refining",
      order = "m"
    },
	{
      type = "recipe",
      name = "tiberium-sludge-to-stone-brick",
      category = "chemistry",
	  crafting_machine_tint = TibCraftingTint,
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
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "z"
    },
	{
      type = "recipe",
      name = "tiberium-waste-recycling",
      category = "chemistry",
	  crafting_machine_tint = TibCraftingTint,
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
--Direct Recipes
    {
      type = "recipe",
      name = "tiberium-molten-to-coal",
      category = "chemistry",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 4,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon_size = 32,
      subgroup = "a-direct",
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "b[oil-processing]-g[advanced-oil-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-molten-to-stone",
      category = "chemistry",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 4,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon_size = 32,
      subgroup = "a-direct",
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "b[oil-processing]-d[petroleum-gas-processing]"
    },
    {
      type = "recipe",
      name = "tiberium-molten-to-crude-oil",
      category = "chemistry",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 4,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon_size = 32,
      subgroup = "a-direct",
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "b[oil-processing]-z[heavy-oil-processing]"
    },
	
--Centrifuging Recipes
    {
      type = "recipe",
      name = "tiberium-ore-centrifuging",
      category = "tiberium-centrifuge-1",
	  subgroup = "a-centrifuging",
      energy_required = 10,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 100},
      },
      results = {
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "a[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-slurry-centrifuging",
      category = "tiberium-centrifuge-2",
	  subgroup = "a-centrifuging",
      energy_required = 8,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-molten-centrifuging",
      category = "tiberium-centrifuge-3",
	  subgroup = "a-centrifuging",
      energy_required = 6,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "c[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "tiberium-ore-sludge-centrifuging",
      category = "tiberium-centrifuge-1",
	  subgroup = "a-centrifuging",
      energy_required = 10,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "water", amount = 100},
      },
      results = {
      },
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "d"
    },
    {
      type = "recipe",
      name = "tiberium-slurry-sludge-centrifuging",
      category = "tiberium-centrifuge-2",
	  subgroup = "a-centrifuging",
      energy_required = 8,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon = "__Factorio-Tiberium__/graphics/icons/slurry-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "e"
    },
    {
      type = "recipe",
      name = "tiberium-molten-sludge-centrifuging",
      category = "tiberium-centrifuge-3",
	  subgroup = "a-centrifuging",
      energy_required = 6,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon = "__Factorio-Tiberium__/graphics/icons/molten-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
      order = "f"
    },
--Growth Credits
	{
      type = "recipe",
      name = "iron-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
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
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
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
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
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
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
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
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
      },
      results = {
        {type = "item", name = "growth-credit", amount = 1},
      },
      icon_size = 32,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "oil-growth-credit",
      category = "chemistry",
	  subgroup = "a-growth-credits",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 20,
      enabled = false,
      ingredients = {
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
	  crafting_machine_tint = TibCraftingTint,
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
	
--Power recipes
	{
      type = "recipe",
      name = "liquid-tiberium-cell",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-items",
      energy_required = 20,
      enabled = false,
      ingredients = {
		{type = "fluid", name = "liquid-tiberium", amount = 25},
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
      icon_size = 64,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "tiberium-empty-cell",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-items",
      energy_required = 20,
      enabled = false,
      ingredients = {
		{type = "item", name = "steel-plate", amount = 2},
		{type = "item", name = "copper-plate", amount = 2},
        {type = "item", name = "plastic-bar", amount = 5},
      },
      results = {
        {type = "item", name = "tiberium-empty-cell", amount = 10},
      },
      icon_size = 64,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
      type = "recipe",
      name = "tiberium-cell-cleaning",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-items",
      energy_required = 20,
      enabled = false,
      ingredients = {
		{type = "item", name = "tiberium-dirty-cell", amount = 10},
        {type = "item", name = "plastic-bar", amount = 1},
		{type = "fluid", name = "water", amount = 50},
      },
      results = {
        {type = "item", name = "tiberium-empty-cell", amount = 9},
		{type = "item", name = "tiberium-empty-cell", amount = 1, probability = 0.9},
		{type = "fluid", name = "tiberium-sludge", amount = 1},
      },
      icon_size = 64,
	  icon = "__Factorio-Tiberium__/graphics/icons/dirty-fuel-cell.png",
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	
	{
      type = "recipe",
      name = "tiberium-fuel-cell",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-items",
      energy_required = 20,
      enabled = false,
      ingredients = {
		{type = "item", name = "tiberium-empty-cell", amount = 1},
		{type = "fluid", name = "liquid-tiberium", amount = 10},
      },
      results = {
        {type = "item", name = "tiberium-fuel-cell", amount = 1},
      },
      icon_size = 64,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	
	
--Intermediate Products
	{
      type = "recipe",
      name = "tiberium-ion-core",
	  crafting_machine_tint = TibCraftingTint,
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
      icon_size = 64,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
	{
		type = "recipe",
		name = "CnC_SonicWall_Hub",
		crafting_machine_tint = TibCraftingTint,
        enabled = false,
		energy_required = 5,
		ingredients = {
			{"copper-plate", 25},
			{"steel-plate", 25},
			{"advanced-circuit", 10},
			{"battery", 10}
		},
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