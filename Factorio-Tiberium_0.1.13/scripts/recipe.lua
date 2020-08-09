local TibProductivity = {
	"tiberium-science",
	"tiberium-ore-processing",
	"molten-tiberium-processing",
	"tiberium-liquid-processing",
	"tiberium-empty-cell",
	"tiberium-fuel-cell",
	"tiberium-ion-core",
	"tiberium-farming",
	"tiberium-ore-mechanical-data",
	"tiberium-ore-thermal-data",
	"tiberium-ore-chemical-data",
	"tiberium-ore-nuclear-data",
	"tiberium-ore-EM-data",
	"tiberium-slurry-mechanical-data",
	"tiberium-slurry-thermal-data",
	"tiberium-slurry-chemical-data",
	"tiberium-slurry-nuclear-data",
	"tiberium-slurry-EM-data",
	"tiberium-molten-mechanical-data",
	"tiberium-molten-thermal-data",
	"tiberium-molten-chemical-data",
	"tiberium-molten-nuclear-data",
	"tiberium-molten-EM-data",
	"tiberium-liquid-mechanical-data",
	"tiberium-liquid-thermal-data",
	"tiberium-liquid-chemical-data",
	"tiberium-liquid-nuclear-data",
	"tiberium-liquid-EM-data"
}

for km, vm in pairs(data.raw.module) do
  if vm.effect.productivity and vm.limitation then
    for _, recipe in ipairs(TibProductivity) do
      table.insert(vm.limitation, recipe)
    end
  end
end

local TibCraftingTint = {
  primary    = {r = 0.109804, g = 0.721567, b = 0.231373,  a = 1},
  secondary  = {r = 0.098039, g = 1,        b = 0.278431,  a = 1},
  tertiary   = {r = 0.156863, g = 0.156863, b = 0.156863,  a = 0.235294},
  quaternary = {r = 0.160784, g = 0.745098, b = 0.3058824, a = 0.345217},
}

data:extend{
  {
    type = "fluid",
    name = "liquid-tiberium",
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
    icon = tiberiumInternalName.."/graphics/icons/fluid/liquid-tiberium.png",
    icon_size = 64,
    max_temperature = 1000,
    order = "a[fluid]-c[crude-oil]",
    fuel_value = "25MJ",
	emissions_multiplier = 3,
    pressure_to_speed_ratio = 0.4,
  },
  {
    type = "fluid",
    name = "molten-tiberium",
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
    icon = tiberiumInternalName.."/graphics/icons/fluid/molten-tiberium.png",
    icon_size = 64,
    max_temperature = 1000,
    order = "a[fluid]-c[crude-oil]",
    pressure_to_speed_ratio = 0.4,
  },
  {
    type = "fluid",
    name = "tiberium-sludge",
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
    icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-sludge.png",
    icon_size = 64,
    max_temperature = 1000,
    order = "a[fluid]-d[crude-oil]",
    pressure_to_speed_ratio = 0.2,
  },
  {
    type = "fluid",
    name = "tiberium-slurry",
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
    icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-waste.png",
    icon_size = 64,
    max_temperature = 1000,
    order = "a[fluid]-d[crude-oil]",
    pressure_to_speed_ratio = 0.05,
  },
  {
    type = "item",
    name = "tiberium-empty-cell",
    icon = tiberiumInternalName.."/graphics/icons/empty-fuel-cell.png",
    icon_size = 64,
    flags = {},
	order = "c[tiberium-fuel-cell]-a[empty-cell]",
    subgroup = "a-intermediates",
    stack_size = 100
  },
  {
    type = "item",
    name = "tiberium-dirty-cell",
    icon = tiberiumInternalName.."/graphics/icons/dirty-fuel-cell.png",
    icon_size = 64,
    flags = {},
	order = "c[tiberium-fuel-cell]-c[dirty-cell]",
    subgroup = "a-intermediates",
    stack_size = 5
  },
  {
    type = "item",
    name = "tiberium-fuel-cell",
    icon = "__base__/graphics/icons/uranium-fuel-cell.png",
    icon_size = 64,
    flags = {},
	order = "c[tiberium-fuel-cell]-b[fuel-cell]",
    subgroup = "a-intermediates",
	fuel_category = "nuclear",
    burnt_result = "tiberium-dirty-cell",
	fuel_value = "4GJ",
    stack_size = 50
  },
  {
    type = "item",
    name = "tiberium-bar",
    icon = tiberiumInternalName.."/graphics/icons/tiberium-bar.png",
    icon_size = 32,
    flags = {},
    subgroup = "a-items",
    stack_size = 100
  },
  {
    type = "item",
    name = "tiberium-data",
    icon = tiberiumInternalName.."/graphics/icons/tiberium-bar.png",
    icon_size = 32,
    flags = {},
    subgroup = "a-items",
    stack_size = 200
  },
  {
    type = "tool",
    name = "tiberium-science",
    icon = tiberiumInternalName.."/graphics/icons/Tacitus.png",
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
    icon = tiberiumInternalName.."/graphics/icons/tiberium-bar.png",
    icon_size = 32,
    flags = {},
    subgroup = "intermediate-product",
    stack_size = 100
  }
}

data:extend{
--Science stuff. Making data, turning it into science, learning from farming tib
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
      icon = tiberiumInternalName.."/graphics/icons/Tiberium-farming.png",
      icon_size = 64,
	  allow_decomposition = false,
      subgroup = "a-refining",
      order = "d"
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
      subgroup = "a-refining",
      order = "e"
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
      icon = tiberiumInternalName.."/graphics/icons/ore-mechanical.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/ore-thermal.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/ore-chemical.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/ore-nuclear.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/ore-EM.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/slurry-mechanical.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/slurry-thermal.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/slurry-chemical.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/slurry-nuclear.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/slurry-EM.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/molten-mechanical.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/molten-thermal.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/molten-chemical.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/molten-nuclear.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/molten-EM.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/liquid-mechanical.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/liquid-thermal.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/liquid-chemical.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/liquid-nuclear.png",
      icon_size = 64,
	  main_product = "",
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
      icon = tiberiumInternalName.."/graphics/icons/liquid-EM.png",
      icon_size = 64,
	  main_product = "",
      subgroup = "a-liquid-science",
      order = "e"
    }
}

data:extend{
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
      icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-waste.png",
      icon_size = 64,
      subgroup = "a-refining",
      order = "a"
    },
    {
      type = "recipe",
      name = "molten-tiberium-processing",
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
      icon = tiberiumInternalName.."/graphics/icons/fluid/molten-tiberium.png",
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
      icon = tiberiumInternalName.."/graphics/icons/fluid/liquid-tiberium.png",
      icon_size = 64,
      subgroup = "a-refining",
      order = "c"
    },
	{
      type = "recipe",
      name = "tiberium-sludge-from-slurry",
      category = "chemistry",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 10},
		{type = "item", name = "stone", amount = 10},
      },
      results = {
        {type = "fluid", name = "tiberium-sludge", amount = 10}
      },
      icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-sludge.png",
      icon_size = 64,
	  main_product = "",
      subgroup = "a-refining",
      order = "a-2"
    },
	{
      type = "recipe",
      name = "tiberium-sludge-to-stone-brick",
      category = "crafting-with-fluid",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-sludge", amount = 1}
      },
      results = {
        {type = "item", name = "stone-brick", amount = 1}
      },
      icon = tiberiumInternalName.."/graphics/icons/tiberium-sludge-to-stone-brick.png",
      icon_size = 32,
      subgroup = "a-direct",
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
      order = "x"
    },
	{
      type = "recipe",
      name = "tiberium-sludge-to-concrete",
      category = "crafting-with-fluid",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 10,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-sludge", amount = 5}
      },
      results = {
        {type = "item", name = "concrete", amount = 10}
      },
      subgroup = "a-direct",
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
      order = "y"
    },
	{
      type = "recipe",
      name = "tiberium-slurry-to-refined-concrete",
      category = "crafting-with-fluid",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 10,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-slurry", amount = 20},
        {type = "item", name = "steel-plate", amount = 2}		
      },
      results = {
        {type = "item", name = "refined-concrete", amount = 10}
      },
      subgroup = "a-direct",
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
      order = "z"
    },
	{
      type = "recipe",
      name = "tiberium-sludge-to-landfill",
      category = "crafting-with-fluid",
	  crafting_machine_tint = TibCraftingTint,
      energy_required = 2,
      enabled = false,
      ingredients = {
        {type = "fluid", name = "tiberium-sludge", amount = 20}
      },
      results = {
        {type = "item", name = "landfill", amount = 1}
      },
      subgroup = "a-direct",
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
      order = "z-2"
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
      icon = tiberiumInternalName.."/graphics/icons/tiberium-recycling.png",
      icon_size = 32,
	  main_product = "",
      subgroup = "a-refining",
	  allow_decomposition = false,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
--Direct Recipes
    {
      type = "recipe",
      name = "template-direct",
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
	  always_show_made_in = true,
      order = "c"
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
      icon = tiberiumInternalName.."/graphics/icons/ore-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
	  always_show_products = true,
      order = "a[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-slurry-centrifuging",
      category = "tiberium-centrifuge-2",
	  subgroup = "a-centrifuging",
      energy_required = 15,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon = tiberiumInternalName.."/graphics/icons/slurry-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
	  always_show_products = true,
      order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
    },
    {
      type = "recipe",
      name = "tiberium-molten-centrifuging",
      category = "tiberium-centrifuge-3",
	  subgroup = "a-centrifuging",
      energy_required = 20,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon = tiberiumInternalName.."/graphics/icons/molten-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
	  always_show_products = true,
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
      icon = tiberiumInternalName.."/graphics/icons/ore-sludge-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
	  always_show_products = true,
      order = "d"
    },
    {
      type = "recipe",
      name = "tiberium-slurry-sludge-centrifuging",
      category = "tiberium-centrifuge-2",
	  subgroup = "a-centrifuging",
      energy_required = 15,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon = tiberiumInternalName.."/graphics/icons/slurry-sludge-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
	  always_show_products = true,
      order = "e"
    },
    {
      type = "recipe",
      name = "tiberium-molten-sludge-centrifuging",
      category = "tiberium-centrifuge-3",
	  subgroup = "a-centrifuging",
      energy_required = 20,
      enabled = false,
      ingredients = {
      },
      results = {
      },
      icon = tiberiumInternalName.."/graphics/icons/molten-sludge-centrifuging.png",
      icon_size = 32,
	  allow_as_intermediate = false,
	  allow_decomposition = false,
	  always_show_made_in = true,
	  always_show_products = true,
      order = "f"
    },
--Growth Credits
	{
      type = "recipe",
      name = "template-growth-credit",
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
      icon = tiberiumInternalName.."/graphics/icons/growth-credit.png",
      icon_size = 32,
	  allow_decomposition = false,
      order = "c",
	  always_show_made_in = true,
    },
	{
      type = "recipe",
      name = "tiberium-growth-credit-from-energy",
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
      icon = tiberiumInternalName.."/graphics/icons/growth-credit.png",
      icon_size = 32,
	  allow_decomposition = false,
      order = "z",
	  always_show_made_in = true,
    },
	
--Power recipes
	{
      type = "recipe",
      name = "tiberium-nuclear-fuel",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-intermediates",
      energy_required = 30,
      enabled = false,
      ingredients = {
		{type = "item", name = "solid-fuel", amount = 10},
		{type = "fluid", name = "liquid-tiberium", amount = 10},
      },
      results = {
        {type = "item", name = "nuclear-fuel", amount = 1},
      },
      icon = "__base__/graphics/icons/nuclear-fuel.png",
      icon_size = 64,
	  main_product = "",
      order = "b[tiberium-nuclear-fuel]"
    },
	{
      type = "recipe",
      name = "tiberium-empty-cell",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-intermediates",
      energy_required = 5,
      enabled = false,
      ingredients = {
		{type = "item", name = "steel-plate", amount = 2},
		{type = "item", name = "copper-plate", amount = 2},
        {type = "item", name = "plastic-bar", amount = 5},
      },
      results = {
        {type = "item", name = "tiberium-empty-cell", amount = 10},
      },
      icon_size = 64
    },
	{
      type = "recipe",
      name = "tiberium-cell-cleaning",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-intermediates",
      energy_required = 30,
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
	  icon = tiberiumInternalName.."/graphics/icons/dirty-fuel-cell.png",
	  allow_decomposition = false,
      order = "c[tiberium-fuel-cell]-c[cell-cleaning]"
    },	
	{
      type = "recipe",
      name = "tiberium-fuel-cell",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-intermediates",
      energy_required = 10,
      enabled = false,
      ingredients = {
		{type = "item", name = "tiberium-empty-cell", amount = 1},
		{type = "fluid", name = "liquid-tiberium", amount = 160},
      },
      results = {
        {type = "item", name = "tiberium-fuel-cell", amount = 1},
      },
      icon_size = 64
    },
	
--Intermediate Products
	{
      type = "recipe",
      name = "tiberium-ion-core",
	  crafting_machine_tint = TibCraftingTint,
      category = "chemistry",
	  subgroup = "a-intermediates",
      energy_required = 20,
      enabled = false,
      ingredients = {
		{type = "fluid", name = "liquid-tiberium", amount = 10},
		{type = "item", name = "steel-plate", amount = 5},
        {type = "item", name = "pipe", amount = 5},
      },
      results = {
        {type = "item", name = "tiberium-ion-core", amount = 1},
      },
      icon = "__base__/graphics/icons/nuclear-reactor.png",
      icon_size = 64,
      order = "a[tiberium-ion-core]"
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
