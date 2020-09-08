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

--Science stuff
data:extend{
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
		results = {},
		icon = tiberiumInternalName.."/graphics/icons/tiberium-farming.png",
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
		energy_required = 10,
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-ore", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-ore", amount = 5},
			{type = "item", name = "coal", amount = 1}
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-ore", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-ore", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-ore", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 5},
			{type = "item", name = "coal", amount = 1}
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 5},
			{type = "item", name = "coal", amount = 1}
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "liquid-tiberium", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "liquid-tiberium", amount = 5},
			{type = "item", name = "coal", amount = 1}
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "liquid-tiberium", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "liquid-tiberium", amount = 5},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "liquid-tiberium", amount = 5},
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

--Refining/fluid recipes
data:extend{
	{
		type = "recipe",
		name = "tiberium-ore-processing",
		category = "oil-processing",
		energy_required = 5,
		crafting_machine_tint = TibCraftingTint,
		emissions_multiplier = 2,
		enabled = false,
		ingredients = {
			-- The Tiberium Ore is added to recipe during recipe-autogeneration since it varies based on the settings
			{type = "fluid", name = "water", amount = 100},
		},
		results = {
			{type = "fluid", name = "tiberium-slurry", amount = 10}
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
		energy_required = 5,
		emissions_multiplier = 2,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 16},
			{type = "fluid", name = "water", amount = 100},
		},
		results = {
			{type = "fluid", name = "molten-tiberium", amount = 10}
		},
		icon = tiberiumInternalName.."/graphics/icons/fluid/molten-tiberium.png",
		icon_size = 64,
		subgroup = "a-refining",
		order = "b"
	},
	{
		type = "recipe",
		name = "tiberium-advanced-molten-processing",
		category = "oil-processing",
		crafting_machine_tint = TibCraftingTint,
		energy_required = 5,
		emissions_multiplier = 2,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 16},
			{type = "fluid", name = "crude-oil", amount = 32},
		},
		results = {
			{type = "fluid", name = "molten-tiberium", amount = 16},
			{type = "fluid", name = "sulfuric-acid", amount = 16},
		},
		icon = tiberiumInternalName.."/graphics/icons/fluid/advanced-molten-processing.png",
		icon_size = 64,
		subgroup = "a-refining",
		order = "b-2"
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
		order = "b-3"
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
		order = "b-4"
	},
	{
		type = "recipe",
		name = "tiberium-liquid-processing",
		category = "oil-processing",
		crafting_machine_tint = TibCraftingTint,
		energy_required = 5,
		emissions_multiplier = 12,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 3},
			{type = "fluid", name = "steam", amount = 100},
		},
		results = {
			{type = "fluid", name = "liquid-tiberium", amount = 1},
			{type = "fluid", name = "water", amount = 100},
		},
		icon = tiberiumInternalName.."/graphics/icons/fluid/liquid-tiberium.png",
		icon_size = 64,
		subgroup = "a-refining",
		order = "c"
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
		name = "tiberium-sludge-to-refined-concrete",
		category = "crafting-with-fluid",
		crafting_machine_tint = TibCraftingTint,
		energy_required = 10,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-sludge", amount = 10},
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
}

--Centrifuging Recipes
data:extend{
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
}

--Structure recipes
data:extend{
	{
		type = "recipe",
		name = "node-harvester",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"advanced-circuit", 25},
			{"electric-mining-drill", 5},
			{"iron-gear-wheel", 50},
			{"iron-plate", 100}
		},
		result = "node-harvester",
	},
	{
		type = "recipe",
		name = "tib-spike",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"processing-unit", 20},
			{"pumpjack", 5},
			{"solar-panel", 10},
			{"CnC_SonicWall_Hub", 4}
		},
		result = "tib-spike",
	},
	{
		type = "recipe",
		name = "tiberium-network-node",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"processing-unit", 20},
			{"electric-engine-unit", 20},
			{"electric-mining-drill", 20},
			{"pipe", 100},
		},
		result = "tiberium-network-node"
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
	{
		type = "recipe",
		name = "growth-accelerator",
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"steel-plate", 25},
			{"advanced-circuit", 15},
			{"pipe", 10}
		},
		energy_required = 30,
		result = "growth-accelerator",
	},
	{
		type = "recipe",
		name = "tiberium-power-plant",
		energy_required = 15,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"steel-plate", 25},
			{"electric-engine-unit", 10},
			{"advanced-circuit", 15},
			{"chemical-plant", 1}
		},
		result = "tiberium-power-plant"
	},
	{
		type = "recipe",
		name = "tiberium-centrifuge",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"steel-plate", 10},
			{"iron-gear-wheel", 20},
			{"electronic-circuit", 10},
			{"stone-brick", 10}
		},
		result = "tiberium-centrifuge"
	},
	{
		type = "recipe",
		name = "tiberium-centrifuge-2",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"concrete", 50},
			{"engine-unit", 10},
			{"advanced-circuit", 10},
			{"tiberium-centrifuge", 1}
		},
		result = "tiberium-centrifuge-2"
	},
	{
		type = "recipe",
		name = "tiberium-centrifuge-3",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"refined-concrete", 50},
			{"electric-engine-unit", 10},
			{"processing-unit", 5},
			{"tiberium-centrifuge-2", 1}
		},
		result = "tiberium-centrifuge-3"
	},
	{
		type = "recipe",
		name = "ion-turret",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"advanced-circuit", 40},
			{"steel-plate", 40},
			{"tiberium-ion-core", 1}
		},
		result = "ion-turret"
	},
}

--Military
data:extend{
	{
		type = "recipe",
		name = "tiberium-rounds-magazine",
		enabled = false,
		category = "advanced-crafting",
		energy_required = 5,
		-- The Tiberium Ore is added to recipe during recipe-autogeneration since it varies based on the settings
		ingredients = {
			{"piercing-rounds-magazine", 1},
		},
		result = "tiberium-rounds-magazine"
	},
	{
		type = "recipe",
		name = "tiberium-rocket",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 50,
		ingredients = {
			{"rocket", 10},
			{type = "fluid", name = "liquid-tiberium", amount = 1}
		},
		results = {
			{"tiberium-rocket", 10},
		}
	},
	{
		type = "recipe",
		name = "tiberium-nuke",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 50,
		ingredients = {
			{"rocket-control-unit", 10},
			{"explosives", 10},
			{type = "fluid", name = "liquid-tiberium", amount = 10}
		},
		result = "tiberium-nuke"
	},
	{
		type = "recipe",
		name = "tiberium-seed",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 50,
		ingredients = {
			{"rocket-control-unit", 10},
			{type = "fluid", name = "liquid-tiberium", amount = 200}
		},
		result = "tiberium-seed"
	},
	{
		type = "recipe",
		name = "tiberium-marv",
		enabled = false,
		energy_required = 40,
		ingredients = {
			{"engine-unit", 100},
			{"steel-plate", 100},
			{"iron-gear-wheel", 50},
			{"node-harvester", 4},
		},
		result = "tiberium-marv",
		subgroup = "a-items",
	},
	{
		type = "recipe",
		name = "tiberium-armor",
		enabled = false,
		energy_required = 8,
		ingredients = {
			{"heavy-armor", 1},
			{"plastic-bar", 50},
			{"pipe", 2},
		},
		result = "tiberium-armor",
	},
	{
		type = "recipe",
		name = "tiberium-power-armor",
		enabled = false,
		energy_required = 25,
		ingredients = {
			{"power-armor-mk2", 1},
			{"plastic-bar", 50},
			{"pipe", 2},
		},
		requester_paste_multiplier = 1,
		result = "tiberium-power-armor",
	},
}

--Power recipes
data:extend{
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
}

--Other
data:extend{
	--Growth Credit recipes
	{
		type = "recipe",
		name = "tiberium-growth-credit-from-energy",
		category = "chemistry",
		subgroup = "a-growth-credits",
		crafting_machine_tint = TibCraftingTint,
		energy_required = 300,
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
	--Void recipe for consuming energy credits
	{
		type = "recipe",
		name = "tiberium-growth",
		enabled = false,
		category = "growth",
		ingredients = {{"growth-credit", 1}},
		energy_required = 15,	-- 20 credits every 5 minutes
		results = {
			{
				name = "growth-credit-void",
				amount = 1,
				probability = 0
			}
		},
	},
}
