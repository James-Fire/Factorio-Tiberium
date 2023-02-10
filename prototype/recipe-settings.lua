local RecipeMult = settings.startup["tiberium-value"].value / 10
local OrePerCredit = settings.startup["tiberium-growth"].value * 10
local CreditTime = RecipeMult * OrePerCredit  --Scale with OrePerCredit instead of just constant 100
local EnergyCreditCost = CreditTime * 3
local WastePerCycle = math.max(1 / RecipeMult, 1)

LSlib.recipe.addIngredient("tiberium-rounds-magazine", "tiberium-ore", math.max(16 / RecipeMult, 1), "item") --So it doesn't crash for large RecipeMults
LSlib.recipe.addIngredient("tiberium-ore-processing", "tiberium-ore", math.max(16 / RecipeMult, 1), "item")
LSlib.recipe.addIngredient("tiberium-ore-processing-blue", "tiberium-ore-blue", math.max(16 / RecipeMult, 1), "item")
LSlib.recipe.setEngergyRequired("tiberium-growth-credit-from-energy", EnergyCreditCost)
LSlib.recipe.addResult("tiberium-farming", "tiberium-ore", 100 + (OrePerCredit * 0.5), "item") --Changed this so the 100 base tiberium ore isn't multiplied
LSlib.recipe.addResult("tiberium-farming", "tiberium-data-chemical", OrePerCredit * 0.04, "item")

if settings.startup["tiberium-byproduct-1"].value == true then  -- Refining Sludge Waste setting
	--LSlib.recipe.addResult("tiberium-ore-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-advanced-molten-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-liquid-processing", "tiberium-sludge", WastePerCycle, "fluid")
end

if settings.startup["tiberium-byproduct-2"].value == true then  -- Refining Sulfur Waste setting
	--LSlib.recipe.addResult("tiberium-ore-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("tiberium-advanced-molten-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("tiberium-liquid-processing", "sulfur", WastePerCycle, "item")
end

local easyMode = settings.startup["tiberium-easy-recipes"].value
if easyMode then
	-- Find recipes with catalysts
	-- Use lslib functions to remove catalyst amounts
	for recipeName, _ in pairs(data.raw.recipe) do
		if string.sub(recipeName, 1, 9) == "tiberium-" then
			local ingredients = common.normalIngredients(recipeName)
			local results = common.normalResults(recipeName)
			for item, after in pairs(results) do
				local before = ingredients[item]
				if before then
					local reduce = math.min(before, after)
					log(recipeName.." reducing "..item.." by "..reduce)
					-- Safe to do this inside of the for loop because we are changing the recipe and not the results var
					if before == reduce then
						LSlib.recipe.removeIngredient(recipeName, item)
					else
						LSlib.recipe.editIngredient(recipeName, item, item, (before - reduce) / before)
					end
					LSlib.recipe.editResult(recipeName, item, item, (after - reduce) / after)
				end
			end
		end
	end
end

local tierZero = settings.startup["tiberium-tier-zero"].value
if tierZero then
	data:extend{
		{
			type = "recipe",
			name = "tiberium-ore-centrifuging",
			localised_name = {"recipe-name.tiberium-centrifuging", {"item-name.tiberium-ore"}},
			category = "tiberium-centrifuge-0",
			subgroup = "a-centrifuging",
			energy_required = 10,
			enabled = false,
			ingredients = {
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
			name = "tiberium-ore-sludge-centrifuging",
			--localised_name set by DynamicOreRecipes
			category = "tiberium-centrifuge-0",
			subgroup = "a-centrifuging",
			energy_required = 10,
			enabled = false,
			ingredients = {
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
			name = "tiberium-centrifuge-0",
			energy_required = 10,
			enabled = false,
			subgroup = "a-buildings",
			ingredients = {
				{"iron-gear-wheel", 20},
				{"stone-brick", 10}
			},
			result = "tiberium-centrifuge-0"
		},
	}
	data.raw.recipe["tiberium-centrifuge-1"].ingredients = {
		{"steel-plate", 10},
		{"electronic-circuit", 10},
		{"tiberium-centrifuge-0", 1}
	}
end