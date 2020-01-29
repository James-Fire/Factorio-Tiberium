require("scripts/recipes")

--Centrifuge inputs/outputs
local TiberiumPerCycle    = 40
local SlurryPerCycle    = TiberiumPerCycle
local MoltenPerCycle    = 16
local IronPerCycle    = 17
local CopperPerCycle    = 18
local CoalPerCycle    = 3
local StonePerCycle    = 2
local OilPerCycle    = 70
local CentEnergyRequired = 10
local SludgePerCycle = 1

--Refining Values
local InputMaterial = 10 --Must be a multiple of 5, so that SlurrytoMolten makes a whole number.
local OretoSlurry = InputMaterial/5
local SlurrytoMolten = InputMaterial*0.06
local WaterRequirement = InputMaterial*10
local RefineEnergyRequired = InputMaterial*0.6
local WastePerCycle = InputMaterial/10

--Direct Values
local DirectRecipeOutput = 32 --Must be a multiple of 4, so that DirectUraniumOutput is a whole number.p
local DirectOilOutput = DirectRecipeOutput*(OilPerCycle/17)
local DirectUraniumOutput = DirectRecipeOutput/4

--Growth Credits
local CreditEfficiency = 0.75 --How much of the ore should be converted into tiberium when used.
local OrePerCredit = 100
local IronCreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
local CopperCreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
local CoalCreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
local StoneCreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
local OilCreditCost = (OrePerCredit/DirectOilOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency*(OilPerCycle/17)
local UraniumCreditCost = (OrePerCredit/DirectUraniumOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
local CreditTime = 60
local EnergyCreditCost = 200



LSlib.recipe.addIngredient(recipeName, ingredientName, ingredientAmount, ingredientType)
LSlib.recipe.addResult(recipeName, resultName, resultAmount, resultType)
LSlib.recipe.setResultCount(recipeName, resultName, resultAmount)

LSlib.recipe.setEngergyRequired(recipeName, energyRequired)






LSlib.recipe.addIngredient("tiberium-molten-to-iron-ore", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-copper-ore", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-coal", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-stone", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-crude-oil", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-uranium-ore", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addResult("tiberium-molten-to-iron-ore", "iron-ore", DirectRecipeOutput, "item")
LSlib.recipe.addResult("tiberium-molten-to-copper-ore", "copper-ore", DirectRecipeOutput, "item")
LSlib.recipe.addResult("tiberium-molten-to-coal", "coal", DirectRecipeOutput, "item")
LSlib.recipe.addResult("tiberium-molten-to-stone", "stone", DirectRecipeOutput, "item")
LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "crude-oil", DirectOilOutput, "item")
LSlib.recipe.addResult("tiberium-molten-to-uranium-ore", "uranium-ore", DirectUraniumOutput, "item")




LSlib.recipe.setEngergyRequired("tiberium-ore-processing", RefineEnergyRequired)
LSlib.recipe.addIngredient("tiberium-ore-processing", "tiberium-ore", InputMaterial, "item")
LSlib.recipe.addResult("tiberium-ore-processing", "tiberium-slurry", InputMaterial*OretoSlurry, "fluid")
LSlib.recipe.setEngergyRequired("advanced-tiberium-ore-processing", RefineEnergyRequired)
LSlib.recipe.addIngredient("advanced-tiberium-ore-processing", "tiberium-slurry", InputMaterial, "fluid")
LSlib.recipe.addResult("advanced-tiberium-ore-processing", "molten-tiberium", InputMaterial*SlurrytoMolten, "fluid")


LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired)
LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "stone", StonePerCycle, "item")
LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired)
LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle, "fluid")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "stone", StonePerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "crude-oil", OilPerCycle, "fluid")
LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired)
LSlib.recipe.addResult("tiberium-molten-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-centrifuging", "stone", StonePerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-centrifuging", "crude-oil", OilPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.setEngergyRequired("tiberium-ore-sludge-centrifuging", CentEnergyRequired)
LSlib.recipe.addIngredient("tiberium-ore-sludge-centrifuging", "tiberium-ore", TiberiumPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")

LSlib.recipe.setEngergyRequired("tiberium-slurry-sludge-centrifuging", CentEnergyRequired)
LSlib.recipe.addIngredient("tiberium-slurry-sludge-centrifuging", "tiberium-slurry", SlurryPerCycle, "fluid")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "crude-oil", OilPerCycle, "fluid")
LSlib.recipe.setEngergyRequired("tiberium-molten-sludge-centrifuging", CentEnergyRequired)
LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "crude-oil", OilPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-sludge-centrifuging", "molten-tiberium", MoltenPerCycle, "fluid")


LSlib.recipe.setEngergyRequired("iron-growth-credit", CreditTime)
LSlib.recipe.setEngergyRequired("copper-growth-credit", CreditTime)
LSlib.recipe.setEngergyRequired("coal-growth-credit", CreditTime)
LSlib.recipe.setEngergyRequired("uranium-growth-credit", CreditTime)
LSlib.recipe.setEngergyRequired("stone-growth-credit", CreditTime)
LSlib.recipe.setEngergyRequired("oil-growth-credit", CreditTime)
LSlib.recipe.setEngergyRequired("energy-growth-credit", EnergyCreditCost)
LSlib.recipe.addIngredient("iron-growth-credit", "iron-ore", IronCreditCost, "item")
LSlib.recipe.addIngredient("copper-growth-credit", "copper-ore", CopperCreditCost, "item")
LSlib.recipe.addIngredient("coal-growth-credit", "coal", CoalCreditCost, "item")
LSlib.recipe.addIngredient("stone-growth-credit", "stone", StoneCreditCost, "item")
LSlib.recipe.addIngredient("oil-growth-credit", "crude-oil", OilCreditCost, "fluid")
LSlib.recipe.addIngredient("uranium-growth-credit", "uranium-ore", UraniumCreditCost, "item")


if settings.startup["waste-recycling"].value == true then
		LSlib.technology.addRecipeUnlock("tiberium-power-tech", "tiberium-waste-recycling")
	end
if settings.startup["tiberium-byproduct-1"].value == true then
	LSlib.recipe.addResult("tiberium-ore-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("advanced-tiberium-ore-processing", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-liquid-processing", "tiberium-sludge", WastePerCycle, "fluid")
	
end
if settings.startup["tiberium-byproduct-2"].value == true then
	LSlib.recipe.addResult("tiberium-ore-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("advanced-tiberium-ore-processing", "sulfur", WastePerCycle, "item")
	LSlib.recipe.addResult("tiberium-liquid-processing", "sulfur", WastePerCycle, "item")
end	