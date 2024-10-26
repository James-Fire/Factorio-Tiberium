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
				{type = "item", name = "tiberium-data-"..test, amount = 1}
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
			localised_name = {"item-name.tiberium-science"}, -- idk why this broke with 2.0
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
				localised_name = {"item-name.tiberium-science"},  -- idk why this broke with 2.0
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
		emissions_multiplier = common.emissionMultiplier(2),
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
		emissions_multiplier = common.emissionMultiplier(4),
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
		emissions_multiplier = common.emissionMultiplier(4),
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
		results = {
			{type = "item", name = "tiberium-ore-blue", amount = 1},
		},
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
		emissions_multiplier = common.emissionMultiplier(2),
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
		emissions_multiplier = common.emissionMultiplier(2),
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
		emissions_multiplier = common.emissionMultiplier(2),
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
		emissions_multiplier = common.emissionMultiplier(8),
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
		emissions_multiplier = common.emissionMultiplier(8),
		enabled = false,
		ingredients = {
			{type = "fluid", name = "molten-tiberium", amount = 16},
			{type = "fluid", name = "steam", amount = 100, minimum_temperature = 500, maximum_temperature = 1000},
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
		localised_name = {"item-name.stone-brick"},
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
		localised_name = {"item-name.concrete"},
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
		localised_name = {"item-name.refined-concrete"},
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
		localised_name = {"item-name.landfill"},
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
		name = "tiberium-aoe-node-harvester",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "processing-unit", amount = 25},
			{type = "item", name = "tiberium-node-harvester", amount = 5},
			{type = "item", name = "iron-gear-wheel", amount = 50},
			{type = "item", name = "steel-plate", amount = 100}
		},
		results = {
			{type = "item", name = "tiberium-aoe-node-harvester", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-beacon-node",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "processing-unit", amount = 100},
			{type = "item", name = "beacon", amount = 5},
			{type = "item", name = "copper-plate", amount = 50},
			{type = "item", name = "steel-plate", amount = 50}
		},
		results = {
			{type = "item", name = "tiberium-beacon-node", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-network-node",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "processing-unit", amount = 20},
			{type = "item", name = "electric-engine-unit", amount = 20},
			{type = "item", name = "electric-mining-drill", amount = 20},
			{type = "item", name = "pipe", amount = 100},
		},
		results = {
			{type = "item", name = "tiberium-network-node", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-srf-emitter",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{type = "item", name = "copper-plate", amount = 25},
			{type = "item", name = "steel-plate", amount = 25},
			{type = "item", name = "advanced-circuit", amount = 10},
			{type = "item", name = "battery", amount = 10}
		},
		results = {
			{type = "item", name = "tiberium-srf-emitter", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-sonic-emitter",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{type = "item", name = "steel-plate", amount = 25},
			{type = "item", name = "battery", amount = 20},
			{type = "item", name = "advanced-circuit", amount = 10},
			{type = "item", name = "programmable-speaker", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-sonic-emitter", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-sonic-emitter-blue",
		enabled = false,
		energy_required = 5,
		ingredients = {
			{type = "item", name = "steel-plate", amount = 25},
			{type = "item", name = "battery", amount = 20},
			{type = "item", name = "advanced-circuit", amount = 10},
			{type = "item", name = "programmable-speaker", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-sonic-emitter-blue", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-power-plant",
		energy_required = 15,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "steel-plate", amount = 20},
			{type = "item", name = "steam-turbine", amount = 4},
			{type = "item", name = "advanced-circuit", amount = 10},
			{type = "item", name = "chemical-plant", amount = 1}
		},
		results = {
			{type = "item", name = "tiberium-power-plant", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-centrifuge-1",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "steel-plate", amount = 10},
			{type = "item", name = "iron-gear-wheel", amount = 20},
			{type = "item", name = "electronic-circuit", amount = 10},
			{type = "item", name = "stone-brick", amount = 10}
		},
		results = {
			{type = "item", name = "tiberium-centrifuge-1", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-centrifuge-2",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "concrete", amount = 50},
			{type = "item", name = "engine-unit", amount = 10},
			{type = "item", name = "advanced-circuit", amount = 10},
			{type = "item", name = "tiberium-centrifuge-1", amount = 1}
		},
		results = {
			{type = "item", name = "tiberium-centrifuge-2", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-centrifuge-3",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "refined-concrete", amount = 50},
			{type = "item", name = "electric-engine-unit", amount = 10},
			{type = "item", name = "processing-unit", amount = 5},
			{type = "item", name = "tiberium-centrifuge-2", amount = 1}
		},
		results = {
			{type = "item", name = "tiberium-centrifuge-3", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-reprocessor",
		energy_required = 10,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "stone-brick", amount = 50},
			{type = "item", name = "steel-plate", amount = 20},
			{type = "item", name = "engine-unit", amount = 10},
		},
		results = {
			{type = "item", name = "tiberium-reprocessor", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-monoculture-green-fixed-recipe",
		energy_required = 1,
		enabled = false,
		hidden = true,
		category = "tiberium-monoculture",
		crafting_machine_tint = common.tibCraftingBlueTint,
		ingredients = {
			{type = "item", name = "tiberium-ore-blue", amount = 4},
		},
		results = {
			{type = "item", name = "tiberium-ore", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-monoculture-blue-fixed-recipe",
		energy_required = 1,
		enabled = false,
		hidden = true,
		category = "tiberium-monoculture",
		crafting_machine_tint = common.tibCraftingTint,
		ingredients = {
			{type = "item", name = "tiberium-ore", amount = 4},
		},
		results = {
			{type = "item", name = "tiberium-ore-blue", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-obelisk-of-light",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "advanced-circuit", amount = 40},
			{type = "item", name = "steel-plate", amount = 40},
			{type = "item", name = "tiberium-ion-core", amount = 1}
		},
		results = {
			{type = "item", name = "tiberium-obelisk-of-light", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-advanced-guard-tower",
		energy_required = 20,
		enabled = false,
		subgroup = "a-buildings",
		ingredients = {
			{type = "item", name = "iron-plate", amount = 40},
			{type = "item", name = "steel-plate", amount = 10},
			{type = "item", name = "electronic-circuit", amount = 10},
			{type = "item", name = "stone-brick", amount = 40}
		},
		results = {
			{type = "item", name = "tiberium-advanced-guard-tower", amount = 1},
		},
	},
}
-- Node buildings
data:extend{
	{
		type = "recipe",
		name = "tiberium-node-harvester",
		energy_required = 20,
		enabled = false,
		subgroup = "a-node-buildings",
		ingredients = {
			{type = "item", name = "advanced-circuit", amount = 25},
			{type = "item", name = "electric-mining-drill", amount = 5},
			{type = "item", name = "iron-gear-wheel", amount = 50},
			{type = "item", name = "iron-plate", amount = 100}
		},
		results = {
			{type = "item", name = "tiberium-node-harvester", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-growth-accelerator",
		enabled = false,
		subgroup = "a-node-buildings",
		ingredients = {
			{type = "item", name = "steel-plate", amount = 25},
			{type = "item", name = "advanced-circuit", amount = 15},
			{type = "item", name = "pipe", amount = 10}
		},
		energy_required = 30,
		results = {
			{type = "item", name = "tiberium-growth-accelerator", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-detonation-charge",
		energy_required = 8,
		enabled = false,
		subgroup = "a-node-buildings",
		ingredients = {
			{type = "item", name = "tiberium-blue-explosives", amount = 10},
			{type = "item", name = "barrel", amount = 1},
			{type = "item", name = "grenade", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-detonation-charge", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-cliff-explosives",
		enabled = false,
		subgroup = "a-node-buildings",
		category = "crafting",
		energy_required = 1,
		ingredients = {
			{type = "item", name = "tiberium-blue-explosives", amount = 10},
			{type = "item", name = "barrel", amount = 1},
			{type = "item", name = "grenade", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-cliff-explosives", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-spike",
		energy_required = 20,
		enabled = false,
		subgroup = "a-node-buildings",
		ingredients = {
			{type = "item", name = "processing-unit", amount = 20},
			{type = "item", name = "pumpjack", amount = 5},
			{type = "item", name = "solar-panel", amount = 10},
			{type = "item", name = "tiberium-srf-emitter", amount = 4}
		},
		results = {
			{type = "item", name = "tiberium-spike", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-monoculture-green",
		energy_required = 10,
		enabled = false,
		subgroup = "a-node-buildings",
		ingredients = {
			{type = "item", name = "steel-plate", amount = 50},
			{type = "item", name = "tiberium-growth-accelerator", amount = 1},
			{type = "item", name = "tiberium-sonic-emitter-blue", amount = 4},
		},
		results = {
			{type = "item", name = "tiberium-monoculture-green", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-monoculture-blue",
		energy_required = 10,
		enabled = false,
		subgroup = "a-node-buildings",
		ingredients = {
			{type = "item", name = "steel-plate", amount = 50},
			{type = "item", name = "tiberium-growth-accelerator", amount = 1},
			{type = "item", name = "tiberium-sonic-emitter", amount = 4},
		},
		results = {
			{type = "item", name = "tiberium-monoculture-blue", amount = 1},
		},
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
			{type = "item", name = "piercing-rounds-magazine", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-rounds-magazine", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-chemical-sprayer-ammo",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 6,
		ingredients = {
			{type = "item", name = "steel-plate", amount = 5},
			{type = "fluid", name = "liquid-tiberium", amount = 100}
		},
		results = {
			{type = "item", name = "tiberium-chemical-sprayer-ammo", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-rocket",
		enabled = false,
		category = "crafting",
		energy_required = 1,
		ingredients = {
			{type = "item", name = "tiberium-blue-explosives", amount = 1},
			{type = "item", name = "rocket", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-rocket", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-nuke",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 50,
		ingredients = {
			{type = "item", name = "rocket", amount = 1},
			{type = "item", name = "processing-unit", amount = 10},
			{type = "item", name = "tiberium-blue-explosives", amount = 100},
		},
		results = {
			{type = "item", name = "tiberium-nuke", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-seed",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 50,
		ingredients = {
			{type = "item", name = "processing-unit", amount = 10},
			{type = "item", name = "tiberium-ore", amount = 100},
			{type = "fluid", name = "liquid-tiberium", amount = 300}
		},
		results = {
			{type = "item", name = "tiberium-seed", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-seed-blue",
		enabled = false,
		category = "crafting-with-fluid",
		energy_required = 50,
		ingredients = {
			{type = "item", name = "processing-unit", amount = 10},
			{type = "item", name = "tiberium-ore-blue", amount = 100},
			{type = "fluid", name = "liquid-tiberium", amount = 300}
		},
		results = {
			{type = "item", name = "tiberium-seed-blue", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-artillery-shell",
		enabled = false,
		category = "crafting",
		energy_required = 1,
		ingredients = {
			{type = "item", name = "tiberium-blue-explosives", amount = 8},
			{type = "item", name = "explosive-cannon-shell", amount = 4},
			{type = "item", name = "radar", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-artillery-shell", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-grenade-all",
		enabled = false,
		category = "crafting",
		energy_required = 1,
		ingredients = {
			{type = "item", name = "tiberium-blue-explosives", amount = 1},
			{type = "item", name = "grenade", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-grenade-all", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-grenade-blue",
		enabled = false,
		category = "crafting",
		energy_required = 1,
		ingredients = {
			{type = "item", name = "tiberium-blue-explosives", amount = 1},
			{type = "item", name = "grenade", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-grenade-blue", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-catalyst-missile-all",
		enabled = false,
		category = "crafting",
		energy_required = 5,
		ingredients = {
			{type = "item", name = "tiberium-blue-explosives", amount = 7},
			{type = "item", name = "rocket", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-catalyst-missile-all", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-catalyst-missile-blue",
		enabled = false,
		category = "crafting",
		energy_required = 5,
		ingredients = {
			{type = "item", name = "tiberium-blue-explosives", amount = 7},
			{type = "item", name = "rocket", amount = 1},
		},
		results = {
			{type = "item", name = "tiberium-catalyst-missile-blue", amount = 1},
		},
	},
	{
		type = "recipe",
		name = "tiberium-marv",
		enabled = false,
		energy_required = 40,
		ingredients = {
			{type = "item", name = "engine-unit", amount = 20},
			{type = "item", name = "steel-plate", amount = 100},
			{type = "item", name = "processing-unit", amount = 10},
			{type = "item", name = "tiberium-node-harvester", amount = 4},
		},
		results = {
			{type = "item", name = "tiberium-marv", amount = 1},
		},
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
		energy_required = 4,
		enabled = false,
		ingredients = {
			{type = "item", name = "steel-plate", amount = 2},
			{type = "item", name = "plastic-bar", amount = 4},
		},
		results = {
			{type = "item", name = "tiberium-empty-cell", amount = 12},
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
			{type = "fluid", name = "liquid-tiberium", amount = 160},
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
		localised_name = {"item-name.tiberium-growth-credit"},
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
		localised_name = {"item-name.tiberium-primed-reactant"},
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
		localised_name = {"item-name.tiberium-primed-reactant"},
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
		localised_name = {"item-name.tiberium-primed-reactant"},
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
		ingredients = {
			{type = "item", name = "tiberium-growth-credit", amount = 1}
		},
		energy_required = 15,	-- 20 credits every 5 minutes
		results = {
			{
				type = "item",
				name = "tiberium-growth-credit-void",
				amount = 1,
				probability = 0
			}
		},
	},
}

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

for _, recipeName in pairs(TibProductivity) do
	if data.raw.recipe[recipeName] then
		data.raw.recipe[recipeName].allow_productivity = true
	end
end

for name, recipe in pairs(data.raw.recipe) do
	if (string.sub(name, 1, 9) == "tiberium-") and not recipe.crafting_machine_tint then
		if (recipe.category == "chemistry") or (recipe.category == "oil-processing") or (recipe.category == "crafting-with-fluid")
				or (recipe.category == "tiberium-science") or (recipe.category == "basic-tiberium-science") then
			recipe.crafting_machine_tint = common.tibCraftingTint
		end
	end
end
