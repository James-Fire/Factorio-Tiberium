local TibProductivity = {
	"tiberium-science-mechanical",
	"tiberium-science-thermal",
	"tiberium-science-chemical",
	"tiberium-science-nuclear",
	"tiberium-science-EM",
	"tiberium-science-thru-thermal",
	"tiberium-science-thru-chemical",
	"tiberium-science-thru-nuclear",
	"tiberium-science-thru-EM",
	"tiberium-ore-processing",
	"tiberium-molten-processing",
	"tiberium-liquid-processing",
	"tiberium-liquid-processing-hot",
	"tiberium-empty-cell",
	"tiberium-fuel-cell",
	"tiberium-ion-core",
	"tiberium-farming",
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
	"tiberium-liquid-EM-data",
	"tiberium-ore-processing-blue",
	"tiberium-liquid-processing-blue",
	"tiberium-blue-explosives",
	"tiberium-enrich-blue-seed",
	"tiberium-enrich-blue",
	"tiberium-primed-reactant",
	"tiberium-primed-reactant-pure",
	"tiberium-primed-reactant-blue",
	"tiberium-primed-reactant-conversion"
}

for km, vm in pairs(data.raw.module) do
	if vm.effect.productivity and vm.limitation then
		for _, recipe in pairs(TibProductivity) do
			table.insert(vm.limitation, recipe)
		end
	end
end

-- Science stuff
local testingOrder = {["a"] = "mechanical", ["b"] = "thermal", ["c"] = "chemical", ["d"] = "nuclear", ["e"] = "EM"}
local testingIngredients = {
	["tiberium-slurry"] = 1,
	["molten-tiberium"] = 2,
	["liquid-tiberium"] = 4
}
local packExchangeRates = {
	mechanical = {data = 10, science = 1},
	thermal = {data = 6, science = 1},
	chemical = {data = 4, science = 1},
	nuclear = {data = 3, science = 1},
	EM = {data = 1, science = 1}
}
local comboExchangeRates = {
	thermal = {data = 3, science = 1},
	chemical = {data = 4, science = 3},
	nuclear = {data = 2, science = 3},
	EM = {data = 1, science = 4}
}

for order, test in pairs(testingOrder) do
	-- Data recipes
	for tiberium, multiplier in pairs(testingIngredients) do
		local ingredients = {{type = "fluid", name = tiberium, amount = 5}}
		if test == "thermal" then
			table.insert(ingredients, {type = "item", name = "coal", amount = 1})
		elseif test == "chemical" then
			table.insert(ingredients, {type = "fluid", name = "sulfuric-acid", amount = 10})
		elseif test == "nuclear" then
			table.insert(ingredients, {type = "item", name = "uranium-ore", amount = 2})
		elseif test == "EM" then
			table.insert(ingredients, {type = "item", name = "processing-unit", amount = 1})
		end
		local simpleName = string.gsub(tiberium, "%A*tiberium%A*", "")
		data:extend{
			{
				type = "recipe",
				name = "tiberium-"..simpleName.."-"..test.."-data",
				category = (test == "mechanical") and "basic-tiberium-science" or "tiberium-science",
				always_show_made_in = true,
				energy_required = 5,
				enabled = false,
				ingredients = ingredients,
				results = {
					{type = "item", name = "tiberium-data-"..test, amount = multiplier}
				},
				icon = tiberiumInternalName.."/graphics/icons/"..simpleName.."-"..test..".png",
				icon_size = 64,
				localised_name = {"recipe-name.tiberium-testing-generic", {"recipe-name.tiberium-testing-"..test}},
				main_product = "",
				subgroup = "a-"..simpleName.."-science",
				order = order,
			}
		}
	end
	-- Science Pack reprocessing recipes
	data:extend{
		{
			type = "recipe",
			name = "tiberium-reprocessing-"..test.."-data",
			category = "tiberium-reprocessing",
			energy_required = 0.5,
			hidden = true,
			allow_decomposition = false,
			crafting_machine_tint = common.tibCraftingTint,
			ingredients = {
				{"tiberium-data-"..test, 1}
			},
			results = {
				{type = "item", name = "tiberium-growth-credit", amount = 1, probability = 0.1 / settings.startup["tiberium-growth"].value}
			},
		}
	}
	-- Science Pack simple recipes
	data:extend{
		{
			type = "recipe",
			name = "tiberium-science-"..test,
			category = "crafting",  -- Now hand-craftable
			--always_show_made_in = true,
			crafting_machine_tint = common.tibCraftingTint,
			energy_required = 1,
			enabled = false,
			icons = {
				{
					icon = tiberiumInternalName.."/graphics/icons/tacitus-recipe.png",
					icon_size = 32,
				},
				{
					icon = tiberiumInternalName.."/graphics/icons/tiberium-data-"..test..".png",
					icon_size = 32,
					scale = 16 / 32,
					shift = {8, -8},
				},
			},
			ingredients = {
				{type = "item", name = "tiberium-data-"..test, amount = packExchangeRates[test].data},
			},
			results = {
				{type = "item", name = "tiberium-science", amount = packExchangeRates[test].science}
			},
			subgroup = "a-simple-science",
			order = order
		}
	}
	-- Science Pack mixed recipes
	if test ~= "mechanical" then
		local ingredients = {}
		for subOrder, subTest in pairs(testingOrder) do
			if subOrder <= order then  -- Add data from all previous and current test
				table.insert(ingredients, {type = "item", name = "tiberium-data-"..subTest, amount = comboExchangeRates[test].data})
			end
		end
		data:extend{
			{
				type = "recipe",
				name = "tiberium-science-thru-"..test,
				category = "crafting",  -- Now hand-craftable
				--always_show_made_in = true,
				crafting_machine_tint = common.tibCraftingTint,
				energy_required = 1,
				enabled = false,
				icons = {
					{
						icon = tiberiumInternalName.."/graphics/icons/tacitus-recipe.png",
						icon_size = 32,
					},
					{
						icon = tiberiumInternalName.."/graphics/icons/tiberium-data-"..test..".png",
						icon_size = 32,
						scale = 16 / 32,
						shift = {8, -8},
					},
					{
						icon = "__core__/graphics/bonus-icon.png",
						icon_size = 32,
						scale = 16 / 32,
						shift = {-8, -8},
					},
				},
				ingredients = ingredients,
				results = {
					{type = "item", name = "tiberium-science", amount = comboExchangeRates[test].science}
				},
				subgroup = "a-mixed-science",
				order = order,
			}
		}
	end
end

-- Fancy descriptions for Mixed Science recipes
local dataTypeValues = {}
for _, recipe in pairs{"tiberium-science-mechanical", "tiberium-science-thermal", "tiberium-science-chemical", "tiberium-science-nuclear", "tiberium-science-EM"} do
	if data.raw.recipe[recipe] and data.raw.recipe[recipe].ingredients and data.raw.recipe[recipe].results then
		dataTypeValues[data.raw.recipe[recipe].ingredients[1].name] = data.raw.recipe[recipe].results[1].amount / data.raw.recipe[recipe].ingredients[1].amount
	end
end
for _, recipe in pairs{"tiberium-science-thru-thermal", "tiberium-science-thru-chemical", "tiberium-science-thru-nuclear", "tiberium-science-thru-EM"} do
	local ingredientValue, resultValue = 0, 0
	if data.raw.recipe[recipe] and data.raw.recipe[recipe].ingredients and data.raw.recipe[recipe].results then
		for _, ingredient in pairs(data.raw.recipe[recipe].ingredients) do
			ingredientValue = ingredientValue + (dataTypeValues[ingredient.name] * ingredient.amount)
		end
		resultValue = data.raw.recipe[recipe].results[1].amount
		local bonusValue = (resultValue / ingredientValue) - 1
		data.raw.recipe[recipe].localised_description = {"recipe-description.tiberium-mixed-science", string.format("%d", bonusValue * 100)}
	end
end

-- Farming
data:extend{
	{
		type = "recipe",
		name = "tiberium-farming",
		category = "tiberium-science",
		always_show_made_in = true,
		energy_required = 40,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-ore-blue", amount = 1},
			{type = "item", name = "tiberium-ore", amount = 100},
			{type = "item", name = "tiberium-growth-credit", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-ore-blue", amount = 1},
			-- Green Tiberium Ore and Tiberium Chemical Data are added to recipe during recipe-autogeneration since they vary based on the settings
		},
		icon = tiberiumInternalName.."/graphics/icons/tiberium-farming.png",
		icon_size = 64,
		allow_decomposition = false,
		subgroup = "a-mixed-science",
		order = "a"
	}
}

-- Blue Tiberium recipes
data:extend{
	{
		type = "recipe",
		name = "tiberium-ore-processing-blue",
		localised_name = {"recipe-name.tiberium-ore-processing-blue"},
		category = "crafting-with-fluid",
		crafting_machine_tint = common.tibCraftingBlueTint,
		energy_required = 5,
		emissions_multiplier = common.scalePollution(2),
		enabled = false,
		ingredients = {
			-- The Blue Tiberium Ore is added to recipe during recipe-autogeneration since it varies based on the settings
			{type = "fluid", name = "water", amount = 32},
		},
		results = {
			{type = "fluid", name = "tiberium-slurry-blue", amount = 16},
		},
		icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-slurry-blue.png",
		icon_size = 64,
		main_product = "",
		subgroup = "a-refining",
		order = "a-2"
	},
	{
		type = "recipe",
		name = "tiberium-liquid-processing-blue",
		category = "oil-processing",
		crafting_machine_tint = common.tibCraftingBlueTint,
		energy_required = 30,
		emissions_multiplier = common.scalePollution(4),
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry-blue", amount = 16},
			{type = "fluid", name = "crude-oil", amount = 32},
		},
		results = {
			{type = "fluid", name = "liquid-tiberium", amount = 16},
		},
		main_product = "",
		icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-refining-blue.png",
		icon_size = 64,
		subgroup = "a-refining",
		order = "c-3"
	},
	{
		type = "recipe",
		name = "tiberium-blue-explosives",
		category = "chemistry",
		crafting_machine_tint = common.tibCraftingBlueTint,
		energy_required = 4,
		emissions_multiplier = common.scalePollution(4),
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry-blue", amount = 2},
			{type = "fluid", name = "tiberium-sludge", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-blue-explosives", amount = 1},
		},
		subgroup = "a-intermediates",
		order = "a2[tiberium-blue-explosives]"
	},
	{
		type = "recipe",
		name = "tiberium-enrich-blue-seed",
		category = "tiberium-science",
		crafting_machine_tint = common.tibCraftingBlueTint,
		always_show_made_in = true,
		energy_required = 40,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-ore", amount = 100},
			{type = "item", name = "tiberium-growth-credit", amount = 1},
		},
		result = "tiberium-ore-blue",
		main_product = "",
		icons = common.layeredIcons(tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-75%.png", 64,
			tiberiumInternalName.."/graphics/icons/growth-credit.png", 64, "ne"),
		allow_decomposition = false,
		subgroup = "a-mixed-science",
		order = "z-1"
	},
	{
		type = "recipe",
		name = "tiberium-enrich-blue",
		category = "tiberium-science",
		crafting_machine_tint = common.tibCraftingBlueTint,
		always_show_made_in = true,
		energy_required = 40,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-ore-blue", amount = 3},
			{type = "item", name = "tiberium-ore", amount = 20},
			--{type = "item", name = "tiberium-growth-credit", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-ore-blue", amount = 5},
			{type = "item", name = "tiberium-ore", amount = 12},
		},
		icons = common.layeredIcons(tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-75%.png", 64,
				tiberiumInternalName.."/graphics/icons/tiberium-ore.png", 64, "ne"),
		allow_decomposition = false,
		subgroup = "a-mixed-science",
		order = "z-2"
	},
}

-- Refining/fluid recipes
data:extend{
	{
		type = "recipe",
		name = "tiberium-ore-processing",
		localised_name = {"recipe-name.tiberium-ore-processing"},
		category = "crafting-with-fluid",
		energy_required = 5,
		emissions_multiplier = common.scalePollution(2),
		enabled = false,
		ingredients = {
			-- The Tiberium Ore is added to recipe during recipe-autogeneration since it varies based on the settings
			{type = "fluid", name = "water", amount = 32},
		},
		results = {
			{type = "fluid", name = "tiberium-slurry", amount = 16}
		},
		icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-waste.png",
		icon_size = 64,
		main_product = "",
		subgroup = "a-refining",
		order = "a"
	},
	{
		type = "recipe",
		name = "tiberium-molten-processing",
		category = "oil-processing",
		energy_required = 5,
		emissions_multiplier = common.scalePollution(2),
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 16},
			{type = "fluid", name = "water", amount = 32},
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
		energy_required = 5,
		emissions_multiplier = common.scalePollution(2),
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
		name = "tiberium-liquid-processing",
		category = "oil-processing",
		energy_required = 20,
		emissions_multiplier = common.scalePollution(8),
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 16},
			{type = "fluid", name = "steam", amount = 300},
		},
		results = {
			{type = "fluid", name = "liquid-tiberium", amount = 10},
			{type = "fluid", name = "water", amount = 100},
		},
		icon = tiberiumInternalName.."/graphics/icons/fluid/liquid-tiberium.png",
		icon_size = 64,
		subgroup = "a-refining",
		order = "c-1"
	},
	{
		type = "recipe",
		name = "tiberium-liquid-processing-hot",
		category = "oil-processing",
		energy_required = 5,
		emissions_multiplier = common.scalePollution(8),
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 16},
			{type = "fluid", name = "steam", amount = 100},
		},
		results = {
			{type = "fluid", name = "liquid-tiberium", amount = 10},
			{type = "fluid", name = "water", amount = 100},
		},
		icons = common.layeredIcons(tiberiumInternalName.."/graphics/icons/fluid/liquid-tiberium.png", 64,
			"__base__/graphics/icons/fluid/steam.png", 64, "ne"),
		subgroup = "a-refining",
		order = "c-2"
	},
	{
		type = "recipe",
		name = "tiberium-sludge-from-slurry",
		category = "chemistry",
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
		order = "d-1"
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
		icon = tiberiumInternalName.."/graphics/icons/tiberium-recycling.png",
		icon_size = 32,
		main_product = "",
		subgroup = "a-refining",
		allow_decomposition = false,
		order = "d-2"
	},
	{
		type = "recipe",
		name = "tiberium-sludge-to-stone-brick",
		category = "crafting-with-fluid",
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

-- Centrifuging Recipes
data:extend{
	{
		type = "recipe",
		name = "tiberium-slurry-centrifuging",
		localised_name = {"recipe-name.tiberium-centrifuging", {"fluid-name.tiberium-slurry"}},
		category = "tiberium-centrifuge-1",
		subgroup = "a-centrifuging",
		energy_required = 8,
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
		order = "a[fluid-chemistry]-f[heavy-oil-cracking]"
	},
	{
		type = "recipe",
		name = "tiberium-molten-centrifuging",
		localised_name = {"recipe-name.tiberium-centrifuging", {"fluid-name.molten-tiberium"}},
		category = "tiberium-centrifuge-2",
		subgroup = "a-centrifuging",
		energy_required = 16,
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
		order = "b[fluid-chemistry]-f[heavy-oil-cracking]"
	},
	{
		type = "recipe",
		name = "tiberium-liquid-centrifuging",
		localised_name = {"recipe-name.tiberium-centrifuging", {"fluid-name.liquid-tiberium"}},
		category = "tiberium-centrifuge-3",
		subgroup = "a-centrifuging",
		energy_required = 32,
		enabled = false,
		ingredients = {
		},
		results = {
		},
		icon = tiberiumInternalName.."/graphics/icons/liquid-centrifuging.png",
		icon_size = 32,
		allow_as_intermediate = false,
		allow_decomposition = false,
		always_show_made_in = true,
		always_show_products = true,
		order = "c[fluid-chemistry]-f[heavy-oil-cracking]"
	},
	{
		type = "recipe",
		name = "tiberium-slurry-sludge-centrifuging",
		--localised_name set by DynamicOreRecipes
		category = "tiberium-centrifuge-1",
		subgroup = "a-centrifuging",
		energy_required = 8,
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
		order = "d"
	},
	{
		type = "recipe",
		name = "tiberium-molten-sludge-centrifuging",
		--localised_name set by DynamicOreRecipes
		category = "tiberium-centrifuge-2",
		subgroup = "a-centrifuging",
		energy_required = 16,
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
		order = "e"
	},
	{
		type = "recipe",
		name = "tiberium-liquid-sludge-centrifuging",
		--localised_name set by DynamicOreRecipes
		category = "tiberium-centrifuge-3",
		subgroup = "a-centrifuging",
		energy_required = 32,
		enabled = false,
		ingredients = {
		},
		results = {
		},
		icon = tiberiumInternalName.."/graphics/icons/liquid-sludge-centrifuging.png",
		icon_size = 32,
		allow_as_intermediate = false,
		allow_decomposition = false,
		always_show_made_in = true,
		always_show_products = true,
		order = "f"
	},
}

-- Structure recipes
data:extend{
	{
		type = "recipe",
		name = "tiberium-node-harvester",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"advanced-circuit", 25},
			{"electric-mining-drill", 5},
			{"iron-gear-wheel", 50},
			{"iron-plate", 100}
		},
		result = "tiberium-node-harvester",
	},
	{
		type = "recipe",
		name = "tiberium-aoe-node-harvester",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"processing-unit", 25},
			{"tiberium-node-harvester", 5},
			{"iron-gear-wheel", 50},
			{"steel-plate", 100}
		},
		result = "tiberium-aoe-node-harvester",
	},
	{
		type = "recipe",
		name = "tiberium-beacon-node",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"processing-unit", 100},
			{"beacon", 5},
			{"copper-plate", 50},
			{"steel-plate", 50}
		},
		result = "tiberium-beacon-node",
	},
	{
		type = "recipe",
		name = "tiberium-spike",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"processing-unit", 20},
			{"pumpjack", 5},
			{"solar-panel", 10},
			{"tiberium-srf-emitter", 4}
		},
		result = "tiberium-spike",
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
		name = "tiberium-srf-emitter",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{"copper-plate", 25},
			{"steel-plate", 25},
			{"advanced-circuit", 10},
			{"battery", 10}
		},
		result = "tiberium-srf-emitter"
	},
	{
		type = "recipe",
		name = "tiberium-sonic-emitter",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{"copper-plate", 25},
			{"steel-plate", 25},
			{"advanced-circuit", 10},
			{"electric-engine-unit", 1},
		},
		result = "tiberium-sonic-emitter"
	},
	{
		type = "recipe",
		name = "tiberium-sonic-emitter-blue",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{"copper-plate", 25},
			{"steel-plate", 25},
			{"advanced-circuit", 10},
			{"electric-engine-unit", 1},
		},
		result = "tiberium-sonic-emitter-blue"
	},
	{
		type = "recipe",
		name = "tiberium-growth-accelerator",
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"steel-plate", 25},
			{"advanced-circuit", 15},
			{"pipe", 10}
		},
		energy_required = 30,
		result = "tiberium-growth-accelerator",
	},
	{
		type = "recipe",
		name = "tiberium-power-plant",
		energy_required = 15,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"steel-plate", 20},
			{"steam-turbine", 4},
			{"advanced-circuit", 10},
			{"chemical-plant", 1}
		},
		result = "tiberium-power-plant"
	},
	{
		type = "recipe",
		name = "tiberium-centrifuge-1",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"steel-plate", 10},
			{"iron-gear-wheel", 20},
			{"electronic-circuit", 10},
			{"stone-brick", 10}
		},
		result = "tiberium-centrifuge-1"
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
			{"tiberium-centrifuge-1", 1}
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
		name = "tiberium-reprocessor",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"stone-brick", 50},
			{"steel-plate", 20},
			{"engine-unit", 10},
		},
		result = "tiberium-reprocessor"
	},
	{
		type = "recipe",
		name = "tiberium-obelisk-of-light",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"advanced-circuit", 40},
			{"steel-plate", 40},
			{"tiberium-ion-core", 1}
		},
		result = "tiberium-obelisk-of-light"
	},
	{
		type = "recipe",
		name = "tiberium-advanced-guard-tower",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"iron-plate", 40},
			{"steel-plate", 10},
			{"electronic-circuit", 10},
			{"stone-brick", 40}
		},
		result = "tiberium-advanced-guard-tower"
	},
	{
		type = "recipe",
		name = "tiberium-detonation-charge",
		energy_required = 8,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{"empty-barrel", 1},
			{"tiberium-blue-explosives", 10},
			{"grenade", 1},
		},
		result = "tiberium-detonation-charge"
	},
}

-- Military
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
		name = "tiberium-chemical-sprayer-ammo",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 6,
		ingredients = {
			{"steel-plate", 5},
			{type = "fluid", name = "liquid-tiberium", amount = 100}
		},
		result = "tiberium-chemical-sprayer-ammo",
	},
	{
		type = "recipe",
		name = "tiberium-rocket",
		enabled = false,
		category = "crafting",
		energy_required = 1,
		ingredients = {
			{"tiberium-blue-explosives", 1},
			{"rocket", 1},
		},
		result= "tiberium-rocket",
	},
	{
		type = "recipe",
		name = "tiberium-nuke",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 50,
		ingredients = {
			{"rocket", 1},
			{"rocket-control-unit", 10},
			{"tiberium-blue-explosives", 100},
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
			{"tiberium-ore", 100},
			{type = "fluid", name = "liquid-tiberium", amount = 300}
		},
		result = "tiberium-seed"
	},
	{
		type = "recipe",
		name = "tiberium-seed-blue",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 50,
		ingredients = {
			{"rocket-control-unit", 10},
			{"tiberium-ore-blue", 100},
			{type = "fluid", name = "liquid-tiberium", amount = 300}
		},
		result = "tiberium-seed-blue"
	},
	{
		type = "recipe",
		name = "tiberium-grenade-all",
		enabled = false,
		category = "crafting",
		energy_required = 1,
		ingredients = {
			{"tiberium-blue-explosives", 1},
			{"grenade", 1},
		},
		result= "tiberium-grenade-all",
	},
	{
		type = "recipe",
		name = "tiberium-grenade-blue",
		enabled = false,
		category = "crafting",
		energy_required = 1,
		ingredients = {
			{"tiberium-blue-explosives", 1},
			{"grenade", 1},
		},
		result= "tiberium-grenade-blue",
	},
	{
		type = "recipe",
		name = "tiberium-catalyst-missile-all",
		enabled = false,
		category = "crafting",
		energy_required = 5,
		ingredients = {
			{"tiberium-blue-explosives", 7},
			{"rocket", 1},
		},
		result= "tiberium-catalyst-missile-all",
	},
	{
		type = "recipe",
		name = "tiberium-catalyst-missile-blue",
		enabled = false,
		category = "crafting",
		energy_required = 5,
		ingredients = {
			{"tiberium-blue-explosives", 7},
			{"rocket", 1},
		},
		result= "tiberium-catalyst-missile-blue",
	},
	{
		type = "recipe",
		name = "tiberium-marv",
		enabled = false,
		energy_required = 40,
		ingredients = {
			{"engine-unit", 20},
			{"steel-plate", 100},
			{"processing-unit", 10},
			{"tiberium-node-harvester", 4},
		},
		result = "tiberium-marv",
		subgroup = "a-items",
	},
}

-- Power recipes
data:extend{
	{
		type = "recipe",
		name = "tiberium-nuclear-fuel",
		category = "chemistry",
		subgroup = "a-intermediates",
		energy_required = 30,
		enabled = false,
		ingredients = {
			{type = "item", name = "solid-fuel", amount = 10},
			{type = "fluid", name = "liquid-tiberium", amount = 40},
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
		category = "crafting",
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
		category = "chemistry",
		subgroup = "a-intermediates",
		energy_required = 10,
		enabled = false,
		ingredients = {
			{type = "item", name = "tiberium-empty-cell", amount = 1},
			{type = "fluid", name = "liquid-tiberium", amount = 320},
		},
		results = {
			{type = "item", name = "tiberium-fuel-cell", amount = 1},
		},
		icon_size = 64
	},
}

-- Other
data:extend{
	-- Tiberium Substrate recipes
	{
		type = "recipe",
		name = "tiberium-growth-credit-from-energy",
		category = "chemistry",
		subgroup = "a-growth-credits",
		energy_required = 300,
		enabled = false,
		ingredients = {
		},
		results = {
			{type = "item", name = "tiberium-growth-credit", amount = 1},
		},
		icon = tiberiumInternalName.."/graphics/icons/growth-credit-from-energy.png",
		icon_size = 64,
		allow_decomposition = false,
		order = "z",
		always_show_made_in = true,
	},
	-- Intermediate Products
	{
		type = "recipe",
		name = "tiberium-ion-core",
		category = "chemistry",
		subgroup = "a-intermediates",
		energy_required = 20,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "liquid-tiberium", amount = 20},
			{type = "item", name = "steel-plate", amount = 5},
			{type = "item", name = "pipe", amount = 5},
		},
		results = {
			{type = "item", name = "tiberium-ion-core", amount = 1},
		},
		icon = tiberiumInternalName.."/graphics/icons/nuclear-reactor.png",
		icon_size = 32,
		order = "a[tiberium-ion-core]"
	},
	{
		type = "recipe",
		name = "tiberium-primed-reactant-easy",
		category = "chemistry",
		subgroup = "a-intermediates",
		energy_required = 10,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry", amount = 16},
		},
		results = {
			{type = "item", name = "tiberium-primed-reactant", amount = 1},
		},
		order = "a[tiberium-primed-reactant]"
	},
	{
		type = "recipe",
		name = "tiberium-primed-reactant-pure",
		category = "chemistry",
		subgroup = "a-intermediates",
		energy_required = 10,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 48},
		},
		results = {
			{type = "item", name = "tiberium-primed-reactant", amount = 1},
		},
		order = "a[tiberium-primed-reactant]"
	},
	{
		type = "recipe",
		name = "tiberium-primed-reactant",
		category = "chemistry",
		subgroup = "a-intermediates",
		energy_required = 10,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 16},
			{type = "item", name = "tiberium-growth-credit", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-primed-reactant", amount = 1},
		},
		order = "a[tiberium-primed-reactant]"
	},
	{
		type = "recipe",
		name = "tiberium-primed-reactant-blue",
		category = "chemistry",
		subgroup = "a-intermediates",
		energy_required = 10,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "tiberium-slurry-blue", amount = 16},
			{type = "item", name = "tiberium-growth-credit", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-primed-reactant-blue", amount = 1},
		},
		order = "a[tiberium-primed-reactant]"
	},
	{
		type = "recipe",
		name = "tiberium-primed-reactant-conversion",
		category = "chemistry",
		subgroup = "a-intermediates",
		energy_required = 10,
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 16},
			{type = "item", name = "tiberium-primed-reactant-blue", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-primed-reactant", amount = 2},
		},
		order = "a[tiberium-primed-reactant]"
	},
	-- Void recipe for consuming energy credits
	{
		type = "recipe",
		name = "tiberium-growth",
		enabled = false,
		hidden = true,
		category = "growth",
		ingredients = {{"tiberium-growth-credit", 1}},
		energy_required = 15,	-- 20 credits every 5 minutes
		results = {
			{
				name = "tiberium-growth-credit-void",
				amount = 1,
				probability = 0
			}
		},
	},
}

for name, recipe in pairs(data.raw.recipe) do
	if (string.sub(name, 1, 9) == "tiberium-") and not recipe.crafting_machine_tint then
		if (recipe.category == "chemistry") or (recipe.category == "oil-processing") or (recipe.category == "crafting-with-fluid")
				or (recipe.category == "tiberium-science") or (recipe.category == "basic-tiberium-science") then
			recipe.crafting_machine_tint = common.tibCraftingTint
		end
	end
end
