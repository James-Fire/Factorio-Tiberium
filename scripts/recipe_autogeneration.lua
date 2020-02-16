require("scripts/recipe")
--require("scripts/FactoriumLib")



local RecipeMult = (settings.startup["tiberium-growth"].value)/(100)

--Universal Variables used no matter what mods are active

local InputMaterial = 10*RecipeMult --Must be a multiple of 5, so that SlurrytoMolten makes a whole number.
local OretoSlurry = InputMaterial/5
local SlurrytoMolten = InputMaterial*0.06
local WaterRequirement = InputMaterial*10
local RefineEnergyRequired = InputMaterial*0.25
local WastePerCycle = InputMaterial/10
local CentEnergyRequired = 10*RecipeMult
local TiberiumPerCycle    = 40*RecipeMult*(settings.startup["tiberium-value"].value/10)
local SlurryPerCycle    = TiberiumPerCycle
local MoltenPerCycle    = 16*RecipeMult

LSlib.recipe.addIngredient("tiberium-magazine", "tiberium-ore", 10*RecipeMult, "item")	

--Code for Bob's ores, without his Science Packs

if (mods["bobores"]) then
	--Variables needed regardless of other Bob's mods being active.
	local AluminumPerCycle    = 4.4*RecipeMult
	local IronPerCycle    = 4.2*RecipeMult
	local StonePerCycle    = 4.1*RecipeMult
	local CopperPerCycle    = 3.2*RecipeMult
	local CoalPerCycle    = 2.7*RecipeMult
	local QuartzPerCycle    = 1.9*RecipeMult
	local TinPerCycle    = 1.7*RecipeMult
	local GoldPerCycle    = 0.8*RecipeMult
	local TitaniumPerCycle    = 0.5*RecipeMult
	local TungstenPerCycle    = 0.25*RecipeMult
	local LeadPerCycle    = 0.14*RecipeMult
	local SlverPerCycle    = 0.13*RecipeMult
	local NickelPerCycle    = 0.07*RecipeMult
	local ZincPerCycle    = 0.02*RecipeMult
	local OilPerCycle    = 44*RecipeMult
	local SludgePerCycle = StonePerCycle
	local TotalCentOutput = AluminumPerCycle+LeadPerCycle+SlverPerCycle+ZincPerCycle+QuartzPerCycle+GoldPerCycle+TinPerCycle+TitaniumPerCycle+TungstenPerCycle+NickelPerCycle+OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
	local DirectRecipeOutput = TotalCentOutput*0.8*RecipeMult --Must be a multiple of 4, so that DirectUraniumOutput is a whole number.
	local DirectOilOutput = DirectRecipeOutput*(OilPerCycle/IronPerCycle)
	local DirectUraniumOutput = DirectRecipeOutput/4
	local CreditEfficiency = 0.75 --How much of the ore should be converted into tiberium when used.
	local OrePerCredit = settings.startup["tiberium-growth"].value
	local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency*RecipeMult
	local CreditTime = 60*RecipeMult
	local EnergyCreditCost = 200*RecipeMult
	if (mods["bobplates"]) then
		if (mods["bobrevamp"]) then
			--Recipe generation for if bob's revamp is active.
			LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired)
			LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle, "item")
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "nickel-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-ore-centrifuging", "nickel-ore", NickelPerCycle)
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "lead-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-ore-centrifuging", "lead-ore", LeadPerCycle)
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "tin-ore", TinPerCycle, "item")
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "quartz", QuartzPerCycle, "item")
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "coal", CoalPerCycle, "item")
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "copper-ore", CopperPerCycle, "item")
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "iron-ore", IronPerCycle, "item")
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "bauxite-ore", AluminumPerCycle, "item")
			
			LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired * 1.5)
			LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle, "fluid")
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "zinc-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-slurry-centrifuging", "zinc-ore", ZincPerCycle)
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "nickel-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-slurry-centrifuging", "nickel-ore", NickelPerCycle)
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "lead-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-slurry-centrifuging", "lead-ore", LeadPerCycle)
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "rutile-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-slurry-centrifuging", "rutile-ore", TitaniumPerCycle)
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "gold-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-slurry-centrifuging", "gold-ore", GoldPerCycle)
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "tin-ore", TinPerCycle, "item")
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "quartz", QuartzPerCycle, "item")
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "coal", CoalPerCycle, "item")
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "copper-ore", CopperPerCycle, "item")
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "iron-ore", IronPerCycle, "item")
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "bauxite-ore", AluminumPerCycle, "item")
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "crude-oil", OilPerCycle, "fluid")
			
			LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired * 2)
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "zinc-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-molten-centrifuging", "zinc-ore", ZincPerCycle)
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "nickel-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-molten-centrifuging", "nickel-ore", NickelPerCycle)
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "silver-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-molten-centrifuging", "silver-ore", SlverPerCycle)
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "lead-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-molten-centrifuging", "lead-ore", LeadPerCycle)
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "tungsten-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-molten-centrifuging", "tungsten-ore", TungstenPerCycle)
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "rutile-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-molten-centrifuging", "rutile-ore", TitaniumPerCycle)
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "gold-ore", 1, "item")
			LSlib.recipe.setResultProbability("tiberium-molten-centrifuging", "gold-ore", GoldPerCycle)
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "tin-ore", TinPerCycle, "item")
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "quartz", QuartzPerCycle, "item")
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "copper-ore", CopperPerCycle, "item")
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "iron-ore", IronPerCycle, "item")
			
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "bauxite-ore", AluminumPerCycle, "item")
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "crude-oil", OilPerCycle, "fluid")
			LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle, "fluid")
			
			LSlib.recipe.duplicate("tiberium-ore-centrifuging", "tiberium-ore-sludge-centrifuging")
			LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
			
			LSlib.recipe.duplicate("tiberium-slurry-centrifuging", "tiberium-slurry-sludge-centrifuging")
			LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
			
			LSlib.recipe.duplicate("tiberium-molten-centrifuging", "tiberium-molten-sludge-centrifuging")
			LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
			
			LSlib.recipe.addResult("tiberium-molten-centrifuging", "stone", StonePerCycle, "item")
			LSlib.recipe.addResult("tiberium-slurry-centrifuging", "stone", StonePerCycle, "item")
			LSlib.recipe.addResult("tiberium-ore-centrifuging", "stone", StonePerCycle, "item")

			--[[
			31.2 Copper Ore
			40.97 Stone
			26.33 Coal
			42 Iron Ore
			16.37 Tin Ore
			7.885 Gold Ore
			2.5 Tungsten Ore
			18.12 Quartz
			0.11 Zinc Ore
			0.063 Nickel Ore
			1.241 Silver Ore
			1.333 lead
			4.746 Rutile
			43.72 Bauxite
			436.6 Crude Oil
			]]

		else
		--Vanilla fallback code if Bob's revamp, which is what actually changes most of the recipe ingredients, isn't active
			local IronPerCycle    = 17*RecipeMult
			local CopperPerCycle    = 18*RecipeMult
			local CoalPerCycle    = 3*RecipeMult
			local StonePerCycle    = 2*RecipeMult
			local OilPerCycle    = 70*RecipeMult
			local TotalCentOutput = OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
			local DirectRecipeOutput = TotalCentOutput*0.8*RecipeMult --Must be a multiple of 4, so that DirectUraniumOutput is a whole number.
			local DirectOilOutput = DirectRecipeOutput*(OilPerCycle/IronPerCycle)
			local DirectUraniumOutput = DirectRecipeOutput/4
			local CreditEfficiency = 0.75 --How much of the ore should be converted into tiberium when used.
			local OrePerCredit = settings.startup["tiberium-growth"].value
			local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency*RecipeMult
			local CreditTime = 60*RecipeMult
			local EnergyCreditCost = 200*RecipeMult
			local SludgePerCycle = StonePerCycle
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
			LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "crude-oil", DirectOilOutput, "fluid")
			LSlib.recipe.addResult("tiberium-molten-to-uranium-ore", "uranium-ore", DirectUraniumOutput, "item")
			
			
			
			LSlib.recipe.setEngergyRequired("iron-growth-credit", CreditTime)
			LSlib.recipe.setEngergyRequired("copper-growth-credit", CreditTime)
			LSlib.recipe.setEngergyRequired("coal-growth-credit", CreditTime)
			LSlib.recipe.setEngergyRequired("uranium-growth-credit", CreditTime)
			LSlib.recipe.setEngergyRequired("stone-growth-credit", CreditTime)
			LSlib.recipe.setEngergyRequired("oil-growth-credit", CreditTime)
			LSlib.recipe.setEngergyRequired("energy-growth-credit", EnergyCreditCost)
			LSlib.recipe.addIngredient("iron-growth-credit", "iron-ore", CreditCost, "item")
			LSlib.recipe.addIngredient("copper-growth-credit", "copper-ore", CreditCost, "item")
			LSlib.recipe.addIngredient("coal-growth-credit", "coal", CreditCost, "item")
			LSlib.recipe.addIngredient("stone-growth-credit", "stone", CreditCost, "item")
			LSlib.recipe.addIngredient("oil-growth-credit", "crude-oil", CreditCost*(OilPerCycle/IronPerCycle), "fluid")
			LSlib.recipe.addIngredient("uranium-growth-credit", "uranium-ore", CreditCost, "item")
		end
	end
	--Standard Growth Credit and Direct recipes for bob's ores, even if his other mods are not active.
	LSlib.recipe.setEngergyRequired("iron-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("copper-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("coal-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("uranium-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("stone-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("oil-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("energy-growth-credit", EnergyCreditCost)
	LSlib.recipe.addIngredient("iron-growth-credit", "iron-ore", CreditCost, "item")
	LSlib.recipe.addIngredient("copper-growth-credit", "copper-ore", CreditCost, "item")
	LSlib.recipe.duplicate("stone-growth-credit", "tungsten-growth-credit")
	LSlib.recipe.addIngredient("coal-growth-credit", "coal", CreditCost, "item")
	LSlib.recipe.addIngredient("oil-growth-credit", "crude-oil", CreditCost*(OilPerCycle/IronPerCycle), "fluid")
	LSlib.recipe.addIngredient("uranium-growth-credit", "uranium-ore", CreditCost, "item")
	LSlib.recipe.addIngredient("stone-growth-credit", "stone", CreditCost, "item")
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
	LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "crude-oil", DirectOilOutput, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-uranium-ore", "uranium-ore", DirectUraniumOutput, "item")
	
	LSlib.recipe.duplicate("stone-growth-credit", "tungsten-growth-credit")
	LSlib.recipe.editIngredient("tungsten-growth-credit", "stone", "tungsten-ore", 1)
	LSlib.recipe.duplicate("stone-growth-credit", "silver-growth-credit")
	LSlib.recipe.editIngredient("silver-growth-credit", "stone", "silver-ore", 1)
	LSlib.technology.addRecipeUnlock("tiberium-power-tech", "tungsten-growth-credit")
	LSlib.technology.addRecipeUnlock("tiberium-power-tech", "silver-growth-credit")
	
	LSlib.recipe.duplicate("stone-growth-credit", "zinc-growth-credit")
	LSlib.recipe.editIngredient("zinc-growth-credit", "stone", "zinc-ore", 1)
	LSlib.recipe.duplicate("stone-growth-credit", "gold-growth-credit")
	LSlib.recipe.editIngredient("gold-growth-credit", "stone", "gold-ore", 1)
	LSlib.recipe.duplicate("stone-growth-credit", "rutile-growth-credit")
	LSlib.recipe.editIngredient("rutile-growth-credit", "stone", "rutile-ore", 1)
	LSlib.technology.addRecipeUnlock("advanced-tiberium-processing-tech", "zinc-growth-credit")
	LSlib.technology.addRecipeUnlock("advanced-tiberium-processing-tech", "gold-growth-credit")
	LSlib.technology.addRecipeUnlock("advanced-tiberium-processing-tech", "rutile-growth-credit")
	
	
	
	LSlib.recipe.duplicate("stone-growth-credit", "nickel-growth-credit")
	LSlib.recipe.editIngredient("nickel-growth-credit", "stone", "nickel-ore", 1)
	LSlib.recipe.duplicate("stone-growth-credit", "lead-growth-credit")
	LSlib.recipe.editIngredient("lead-growth-credit", "stone", "lead-ore", 1)
	LSlib.recipe.duplicate("stone-growth-credit", "quartz-growth-credit")
	LSlib.recipe.editIngredient("quartz-growth-credit", "stone", "quartz", 1)
	LSlib.recipe.duplicate("stone-growth-credit", "bauxite-growth-credit")
	LSlib.recipe.editIngredient("bauxite-growth-credit", "stone", "bauxite-ore", 1)
	LSlib.recipe.duplicate("stone-growth-credit", "tin-growth-credit")
	LSlib.recipe.editIngredient("tin-growth-credit", "stone", "tin-ore", 1)
	LSlib.technology.addRecipeUnlock("advanced-tiberium-processing-tech", "nickel-growth-credit")
	LSlib.technology.addRecipeUnlock("advanced-tiberium-processing-tech", "lead-growth-credit")
	LSlib.technology.addRecipeUnlock("advanced-tiberium-processing-tech", "quartz-growth-credit")
	LSlib.technology.addRecipeUnlock("advanced-tiberium-processing-tech", "bauxite-growth-credit")
	LSlib.technology.addRecipeUnlock("advanced-tiberium-processing-tech", "tin-growth-credit")
	
	
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-tungsten")
	LSlib.recipe.editResult("tiberium-molten-to-tungsten", "stone", "tungsten-ore", 1)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-silver")
	LSlib.recipe.editResult("tiberium-molten-to-silver", "stone", "silver-ore", 1)
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-tungsten")
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-silver")
	
	
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-zinc")
	LSlib.recipe.editResult("tiberium-molten-to-zinc", "stone", "zinc-ore", 1)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-rutile")
	LSlib.recipe.editResult("tiberium-molten-to-rutile", "stone", "rutile-ore", 1)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-gold")
	LSlib.recipe.editResult("tiberium-molten-to-gold", "stone", "gold-ore", 1)
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-zinc")
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-rutile")
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-gold")
	
	
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-nickel")
	LSlib.recipe.editResult("tiberium-molten-to-nickel", "stone", "nickel-ore", 1)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-lead")
	LSlib.recipe.editResult("tiberium-molten-to-lead", "stone", "lead-ore", 1)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-quartz")
	LSlib.recipe.editResult("tiberium-molten-to-quartz", "stone", "quartz", 1)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-bauxite")
	LSlib.recipe.editResult("tiberium-molten-to-bauxite", "stone", "bauxite-ore", 1)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-tin")
	LSlib.recipe.editResult("tiberium-molten-to-tin", "stone", "tin-ore", 1)
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-nickel")
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-lead")
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-quartz")
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-bauxite")
	LSlib.technology.addRecipeUnlock("tiberium-control-network-tech", "tiberium-molten-to-tin")
	
	
	
	
	
	
	
else

--Vanilla recipe code

local IronPerCycle    = 17*RecipeMult
local CopperPerCycle    = 18*RecipeMult
local CoalPerCycle    = 3*RecipeMult
local StonePerCycle    = 2*RecipeMult
local OilPerCycle    = 70*RecipeMult
local TotalCentOutput = OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
local DirectRecipeOutput = TotalCentOutput*0.8*RecipeMult --Must be a multiple of 4, so that DirectUraniumOutput is a whole number.
local DirectOilOutput = DirectRecipeOutput*(OilPerCycle/IronPerCycle)
local DirectUraniumOutput = DirectRecipeOutput/4
local CreditEfficiency = 0.75 --How much of the ore value should be converted into tiberium when used.
local OrePerCredit = settings.startup["tiberium-growth"].value
local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency*RecipeMult
local CreditTime = 60*RecipeMult
local EnergyCreditCost = 200*RecipeMult
local SludgePerCycle = StonePerCycle



LSlib.recipe.addIngredient(recipeName, ingredientName, ingredientAmount, ingredientType)
LSlib.recipe.addResult(recipeName, resultName, resultAmount, resultType)
LSlib.recipe.setResultCount(recipeName, resultName, resultAmount)

LSlib.recipe.setEngergyRequired(recipeName, energyRequired)

--if (mods["bobores"]) then


	--else

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
	LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "crude-oil", DirectOilOutput, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-uranium-ore", "uranium-ore", DirectUraniumOutput, "item")




LSlib.recipe.setEngergyRequired("tiberium-ore-processing", RefineEnergyRequired)
LSlib.recipe.addIngredient("tiberium-ore-processing", "tiberium-ore", InputMaterial*(settings.startup["tiberium-value"].value/10), "item")
LSlib.recipe.addResult("tiberium-ore-processing", "tiberium-slurry", InputMaterial*OretoSlurry, "fluid")
LSlib.recipe.setEngergyRequired("advanced-tiberium-ore-processing", RefineEnergyRequired)
LSlib.recipe.addIngredient("advanced-tiberium-ore-processing", "tiberium-slurry", InputMaterial, "fluid")
LSlib.recipe.addResult("advanced-tiberium-ore-processing", "molten-tiberium", InputMaterial*SlurrytoMolten, "fluid")


LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired)
LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "stone", StonePerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired * 1.5)
LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle, "fluid")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "stone", StonePerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-centrifuging", "crude-oil", OilPerCycle, "fluid")
LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired * 2)
LSlib.recipe.addResult("tiberium-molten-centrifuging", "stone", StonePerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-centrifuging", "crude-oil", OilPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle, "fluid")

LSlib.recipe.setEngergyRequired("tiberium-ore-sludge-centrifuging", CentEnergyRequired)
LSlib.recipe.addIngredient("tiberium-ore-sludge-centrifuging", "tiberium-ore", TiberiumPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
LSlib.recipe.setEngergyRequired("tiberium-slurry-sludge-centrifuging", CentEnergyRequired * 1.5)
LSlib.recipe.addIngredient("tiberium-slurry-sludge-centrifuging", "tiberium-slurry", SlurryPerCycle, "fluid")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "copper-ore", CopperPerCycle, "item")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "crude-oil", OilPerCycle, "fluid")
LSlib.recipe.setEngergyRequired("tiberium-molten-sludge-centrifuging", CentEnergyRequired * 2)
LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "coal", CoalPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "iron-ore", IronPerCycle, "item")
LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "copper-ore", CopperPerCycle, "item")
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
LSlib.recipe.addIngredient("iron-growth-credit", "iron-ore", CreditCost, "item")
LSlib.recipe.addIngredient("copper-growth-credit", "copper-ore", CreditCost, "item")
LSlib.recipe.addIngredient("coal-growth-credit", "coal", CreditCost, "item")
LSlib.recipe.addIngredient("stone-growth-credit", "stone", CreditCost, "item")
LSlib.recipe.addIngredient("oil-growth-credit", "crude-oil", CreditCost*(OilPerCycle/17), "fluid")
LSlib.recipe.addIngredient("uranium-growth-credit", "uranium-ore", CreditCost, "item")

end

--[[if settings.startup["tiberium-byproduct-direct"].value == true then
	LSlib.recipe.addResult("tiberium-molten-to-iron-ore", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-copper-ore", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-coal", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-stone", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-uranium-ore", "tiberium-sludge", SludgePerCycle, "fluid")
end]]

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