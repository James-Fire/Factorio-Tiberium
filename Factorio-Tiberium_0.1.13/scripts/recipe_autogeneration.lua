require("scripts/recipe")
--require("scripts/FactoriumLib")

local RecipeMult = settings.startup["tiberium-value"].value / 10

--Universal Variables used no matter what mods are active
local OrePerCredit = settings.startup["tiberium-growth"].value * 10
local CreditTime = RecipeMult * OrePerCredit  --Scale with OrePerCredit instead of just constant 100
local EnergyCreditCost = CreditTime * 3
local InputMaterial = 10 / RecipeMult
local RefineEnergyRequired = InputMaterial * 0.25
local WastePerCycle      = math.max(InputMaterial / 10, 1)
-- local CentEnergyRequired = 10 / RecipeMult
-- local TiberiumPerCycle   = math.max(40 / RecipeMult, 1) --As ore is more valuable, it should take less of it to centrifuge

LSlib.recipe.addIngredient("tiberium-rounds-magazine", "tiberium-ore", math.max(10 / RecipeMult, 1), "item") --So it doesn't crash for large RecipeMults
LSlib.recipe.setEngergyRequired("tiberium-ore-processing", RefineEnergyRequired)
LSlib.recipe.setEngergyRequired("molten-tiberium-processing", RefineEnergyRequired)
LSlib.recipe.setEngergyRequired("tiberium-liquid-processing", RefineEnergyRequired * 24)
LSlib.recipe.setEngergyRequired("tiberium-growth-credit-from-energy", EnergyCreditCost)
LSlib.recipe.addResult("tiberium-farming", "tiberium-ore", 100 + (OrePerCredit * 0.5), "item") --Changed this so the 100 base tiberium ore isn't multiplied
LSlib.recipe.addResult("tiberium-farming", "tiberium-data", OrePerCredit * 0.1, "item")

if settings.startup["tiberium-byproduct-1"].value == true then  -- Refining Sludge Waste setting
	LSlib.recipe.addResult("tiberium-ore-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("molten-tiberium-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-liquid-processing", "tiberium-sludge", WastePerCycle, "fluid")
end

if settings.startup["tiberium-byproduct-2"].value == true then  -- Refining Sulfur Waste setting
	LSlib.recipe.addResult("tiberium-ore-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("molten-tiberium-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("tiberium-liquid-processing", "sulfur", WastePerCycle, "item")
end
