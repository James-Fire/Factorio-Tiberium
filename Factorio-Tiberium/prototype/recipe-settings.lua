require("prototype/recipe")

local RecipeMult = settings.startup["tiberium-value"].value / 10
local OrePerCredit = settings.startup["tiberium-growth"].value * 10
local CreditTime = RecipeMult * OrePerCredit  --Scale with OrePerCredit instead of just constant 100
local EnergyCreditCost = CreditTime * 3
local WastePerCycle = math.max(1 / RecipeMult, 1)

LSlib.recipe.addIngredient("tiberium-rounds-magazine", "tiberium-ore", math.max(16 / RecipeMult, 1), "item") --So it doesn't crash for large RecipeMults
LSlib.recipe.addIngredient("tiberium-ore-processing", "tiberium-ore", math.max(16 / RecipeMult, 1), "item")
LSlib.recipe.setEngergyRequired("tiberium-growth-credit-from-energy", EnergyCreditCost)
LSlib.recipe.addResult("tiberium-farming", "tiberium-ore", 100 + (OrePerCredit * 0.5), "item") --Changed this so the 100 base tiberium ore isn't multiplied
LSlib.recipe.addResult("tiberium-farming", "tiberium-data-chemical", OrePerCredit * 0.04, "item")

if settings.startup["tiberium-byproduct-1"].value == true then  -- Refining Sludge Waste setting
	LSlib.recipe.addResult("tiberium-ore-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("molten-tiberium-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-advanced-molten-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-liquid-processing", "tiberium-sludge", WastePerCycle, "fluid")
end

if settings.startup["tiberium-byproduct-2"].value == true then  -- Refining Sulfur Waste setting
	LSlib.recipe.addResult("tiberium-ore-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("molten-tiberium-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("tiberium-advanced-molten-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("tiberium-liquid-processing", "sulfur", WastePerCycle, "item")
end
