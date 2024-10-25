local RecipeMult = settings.startup["tiberium-value"].value / 10
local OrePerCredit = settings.startup["tiberium-growth"].value * 10
local CreditTime = RecipeMult * OrePerCredit  --Scale with OrePerCredit instead of just constant 100
local EnergyCreditCost = CreditTime * 3
local WastePerCycle = math.max(1 / RecipeMult, 1)

common.recipe.addIngredient("tiberium-rounds-magazine", "tiberium-ore", math.max(16 / RecipeMult, 1), "item") --So it doesn't crash for large RecipeMults
common.recipe.addIngredient("tiberium-ore-processing", "tiberium-ore", math.max(16 / RecipeMult, 1), "item")
common.recipe.addIngredient("tiberium-ore-processing-blue", "tiberium-ore-blue", math.max(16 / RecipeMult, 1), "item")
data.raw.recipe["tiberium-growth-credit-from-energy"].energy_required = EnergyCreditCost
common.recipe.addResult("tiberium-farming", "tiberium-ore", 100 + (OrePerCredit * 0.5), "item") --Changed this so the 100 base tiberium ore isn't multiplied
common.recipe.addResult("tiberium-farming", "tiberium-data-chemical", OrePerCredit * 0.04, "item")

if settings.startup["tiberium-byproduct-1"].value == true then  -- Refining Sludge Waste setting
	--common.recipe.addResult("tiberium-ore-processing", "tiberium-sludge", WastePerCycle, "fluid")
	common.recipe.addResult("tiberium-molten-processing", "tiberium-sludge", WastePerCycle, "fluid")
	common.recipe.addResult("tiberium-advanced-molten-processing", "tiberium-sludge", WastePerCycle, "fluid")
	common.recipe.addResult("tiberium-liquid-processing", "tiberium-sludge", WastePerCycle, "fluid")
	common.recipe.addResult("tiberium-liquid-processing-hot", "tiberium-sludge", WastePerCycle, "fluid")
end

if settings.startup["tiberium-byproduct-2"].value == true then  -- Refining Sulfur Waste setting
	--common.recipe.addResult("tiberium-ore-processing", "sulfur", WastePerCycle, "item")
	common.recipe.addResult("tiberium-molten-processing", "sulfur", WastePerCycle, "item")
	common.recipe.addResult("tiberium-advanced-molten-processing", "sulfur", WastePerCycle, "item")
	common.recipe.addResult("tiberium-liquid-processing", "sulfur", WastePerCycle, "item")
	common.recipe.addResult("tiberium-liquid-processing-hot", "sulfur", WastePerCycle, "item")
end

local easyMode = settings.startup["tiberium-easy-recipes"].value
if easyMode then
	-- Find recipes with catalysts
	-- Use lslib functions to remove catalyst amounts
	for recipeName, _ in pairs(data.raw.recipe) do
		if string.sub(recipeName, 1, 9) == "tiberium-" then
			local ingredients = common.recipeIngredientsTable(recipeName)
			local results = common.recipeResultsTable(recipeName)
			for item, after in pairs(results) do
				local before = ingredients[item]
				if before then
					local reduce = math.min(before, after)
					log(recipeName.." reducing "..item.." by "..reduce)
					-- Safe to do this inside of the for loop because we are changing the recipe and not the results var
					if before == reduce then
						common.recipe.removeIngredient(recipeName, item)
					else
						common.recipe.editIngredient(recipeName, item, item, (before - reduce) / before)
					end
					common.recipe.editResult(recipeName, item, item, (after - reduce) / after)
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
			energy_required = 4,
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
			energy_required = 4,
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
				{type = "item", name = "iron-gear-wheel", amount = 20},
				{type = "item", name = "stone-brick", amount = 10}
			},
			results = {
				{type = "item", name = "tiberium-centrifuge-0", amount = 1},
			},
		},
	}
	data.raw.recipe["tiberium-centrifuge-1"].ingredients = {
		{type = "item", name = "steel-plate", amount = 10},
		{type = "item", name = "electronic-circuit", amount = 10},
		{type = "item", name = "tiberium-centrifuge-0", amount = 1}
	}
end