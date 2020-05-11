require("scripts/recipe")
--require("scripts/FactoriumLib")



local RecipeMult = math.floor((settings.startup["tiberium-value"] +.5)/10) 




--Universal Variables used no matter what mods are active
local CreditTime = 100*RecipeMult
local EnergyCreditCost = CreditTime*3
local InputMaterial = 10/RecipeMult --Must be a multiple of 5, so that SlurrytoMolten makes a whole number.
local OretoSlurry = InputMaterial/5
local SlurrytoMolten = InputMaterial*0.06
local WaterRequirement = InputMaterial*10
local RefineEnergyRequired = InputMaterial*0.25
local WastePerCycle = InputMaterial/10
local CentEnergyRequired = 10/RecipeMult
local TiberiumPerCycle    = 40/RecipeMult
local SlurryPerCycle    = TiberiumPerCycle
local MoltenPerCycle    = 16/RecipeMult
local CreditEfficiency = 0.75 --How much of the ore should be converted into tiberium when used.
local OrePerCredit = settings.startup["tiberium-growth"].value
local DirectRecipeMult = 0.6 --The Efficiency of using Direct recipes over the Centrifuge recipes. All centrifuge outputs are added together and multiplied by this to get the Direct output.
local DirectRecipeTime = 12
local RefiningTime = 20

--Universal things that need to be done regardless of mods active
if settings.startup["tiberium-byproduct-direct"].value == true then
	--LSlib.recipe.addResult("tiberium-molten-to-stone", "tiberium-sludge", WastePerCycle, "fluid")
	--LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "tiberium-sludge", WastePerCycle, "fluid")
	--LSlib.recipe.addResult("tiberium-molten-to-coal", "tiberium-sludge", WastePerCycle, "fluid")
end

LSlib.recipe.addIngredient("tiberium-magazine", "tiberium-ore", 10/RecipeMult, "item")	
LSlib.recipe.setEngergyRequired("tiberium-molten-to-stone", DirectRecipeTime)
LSlib.recipe.setEngergyRequired("tiberium-molten-to-crude-oil", DirectRecipeTime)
LSlib.recipe.setEngergyRequired("tiberium-molten-to-coal", DirectRecipeTime)
LSlib.recipe.addIngredient("tiberium-molten-to-coal", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-stone", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-crude-oil", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addResult("tiberium-farming", "tiberium-ore", OrePerCredit*1.5, "item")
LSlib.recipe.addResult("tiberium-farming", "tiberium-data", OrePerCredit*0.1, "item")





LSlib.recipe.setEngergyRequired("tiberium-ore-processing", RefiningTime*1.5)
LSlib.recipe.setEngergyRequired("advanced-tiberium-ore-processing", RefiningTime)
LSlib.recipe.setEngergyRequired("tiberium-liquid-processing", RefiningTime*4)





--Code for Bob's ores, without his Science Packs

if (mods["bobores"]) then
	--Variables needed regardless of other Bob's mods being active.
	local BobsMult = 100 --Since the requirement for bob's ores are weird, this is here to make it all whole numbers.
	local AluminumPerCycle    = 4.4*BobsMult
	local IronPerCycle    = 4.2*BobsMult
	local StonePerCycle    = 4.1*BobsMult
	local CopperPerCycle    = 3.2*BobsMult
	local CoalPerCycle    = 2.7*BobsMult
	local QuartzPerCycle    = 1.9*BobsMult
	local TinPerCycle    = 1.7*BobsMult
	local GoldPerCycle    = 0.8*BobsMult
	local TitaniumPerCycle    = 0.5*BobsMult
	local TungstenPerCycle    = 0.25*BobsMult
	local LeadPerCycle    = 0.14*BobsMult
	local SlverPerCycle    = 0.13*BobsMult
	local NickelPerCycle    = 0.07*BobsMult
	local ZincPerCycle    = 0.02*BobsMult
	local OilPerCycle    = 44*BobsMult
	local SludgePerCycle = StonePerCycle
	local TotalCentOutput = (AluminumPerCycle+LeadPerCycle+SlverPerCycle+ZincPerCycle+QuartzPerCycle+GoldPerCycle+TinPerCycle+TitaniumPerCycle+TungstenPerCycle+NickelPerCycle+OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle)/BobsMult
	local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult
	local DirectOilOutput = DirectRecipeOutput*((OilPerCycle/BobsMult)/(IronPerCycle/BobsMult))
	local DirectUraniumOutput = math.floor(DirectRecipeOutput/4 +.5) 
	local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency*RecipeMult
	LSlib.recipe.addIngredient("oil-growth-credit", "crude-oil", CreditCost*(OilPerCycle/IronPerCycle), "fluid")
	LSlib.recipe.setEngergyRequired("stone-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("oil-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("energy-growth-credit", EnergyCreditCost)
	LSlib.recipe.setEngergyRequired("coal-growth-credit", CreditTime)
	LSlib.recipe.addIngredient("coal-growth-credit", "coal", CreditCost, "item")
	LSlib.recipe.addIngredient("stone-growth-credit", "stone", CreditCost, "item")
	LSlib.recipe.addResult("tiberium-molten-to-coal", "coal", DirectRecipeOutput, "item")
	LSlib.recipe.addResult("tiberium-molten-to-stone", "stone", DirectRecipeOutput, "item")
	LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "crude-oil", DirectOilOutput, "fluid")
	LSlib.recipe.setMainResult("tiberium-molten-to-stone", "stone")
	LSlib.recipe.setMainResult("tiberium-molten-to-coal", "coal")
	LSlib.recipe.setMainResult("tiberium-molten-to-crude-oil", "crude-oil")
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-uranium")
	LSlib.recipe.editResult("tiberium-molten-to-uranium", "stone", "uranium-ore", 0.25)
	LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-uranium")
	
	if (mods["angelsrefining"]) then
		AngelsMult = 1
		local SaphiritePerCycle1    = 0.5*IronPerCycle+0.5*QuartzPerCycle+0.5*NickelPerCycle*AngelsMult
		local JivolitePerCycle1 = 0.5*AluminumPerCycle+0.5*IronPerCycle*AngelsMult
		local StiratitePerCycle1 = 0.5*CopperPerCycle+0.5*TinPerCycle*AngelsMult
		local CrotinniumPerCycle1    = 0.5*CopperPerCycle+0.5*LeadPerCycle*AngelsMult
		local RubytePerCycle1    = 0.5*AluminumPerCycle+0.5*LeadPerCycle+0.5*NickelPerCycle*AngelsMult
		local BobmoniumPerCycle1    = 0.5*TinPerCycle+0.5*QuartzPerCycle*AngelsMult
		
		local SaphiritePerCycle2 = SaphiritePerCycle1+0.333*TitaniumPerCycle*AngelsMult
		local JivolitePerCycle2 = JivolitePerCycle1+0.5*ZincPerCycle*AngelsMult
		local StiratitePerCycle2 = StiratitePerCycle1+0.333*TitaniumPerCycle+0.333*GoldPerCycle*AngelsMult
		local CrotinniumPerCycle2 = CrotinniumPerCycle1+0.333*GoldPerCycle*AngelsMult
		local RubytePerCycle2 = RubytePerCycle1+0.333*TitaniumPerCycle+0.333*GoldPerCycle*AngelsMult
		local BobmoniumPerCycle2 = BobmoniumPerCycle1+0.5*ZincPerCycle*AngelsMult
		
		
		local JivolitePerCycle3 = JivolitePerCycle2+0.333*SlverPerCycle+0.333*TungstenPerCycle*AngelsMult
		local StiratitePerCycle3 = StiratitePerCycle2+0.333*TungstenPerCycle*AngelsMult
		local CrotinniumPerCycle3 = CrotinniumPerCycle2+0.333*SlverPerCycle*AngelsMult
		local BobmoniumPerCycle3 = BobmoniumPerCycle2+0.333*SlverPerCycle+0.333*TungstenPerCycle*AngelsMult
		
		--Angel's Centrifuging Recipe generation
		
		LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired*BobsMult)
		LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle*BobsMult, "item")
		LSlib.recipe.addResult("tiberium-ore-centrifuging", "angels-ore1", SaphiritePerCycle1, "item")
		LSlib.recipe.addResult("tiberium-ore-centrifuging", "angels-ore2", JivolitePerCycle1, "item")
		LSlib.recipe.addResult("tiberium-ore-centrifuging", "angels-ore3", StiratitePerCycle1, "item")
		LSlib.recipe.addResult("tiberium-ore-centrifuging", "angels-ore4", CrotinniumPerCycle1, "item")
		LSlib.recipe.addResult("tiberium-ore-centrifuging", "angels-ore5", RubytePerCycle1, "item")
		LSlib.recipe.addResult("tiberium-ore-centrifuging", "angels-ore6", BobmoniumPerCycle1, "item")
		LSlib.recipe.addResult("tiberium-ore-centrifuging", "coal", CoalPerCycle, "item")
		
		LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired * 1.5 *BobsMult)
		LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle*BobsMult, "fluid")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore1", SaphiritePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore2", JivolitePerCycle3, "item")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore3", StiratitePerCycle3, "item")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore4", CrotinniumPerCycle3, "item")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore5", RubytePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore6", BobmoniumPerCycle3, "item")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "crude-oil", OilPerCycle, "fluid")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "coal", CoalPerCycle, "item")
		
		LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired * 2 *BobsMult)
		
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "crude-oil", OilPerCycle, "fluid")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore1", SaphiritePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore2", JivolitePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore3", StiratitePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore4", CrotinniumPerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore5", RubytePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore6", BobmoniumPerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
		LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle*BobsMult, "fluid")
		
		LSlib.recipe.duplicate("tiberium-ore-centrifuging", "tiberium-ore-sludge-centrifuging")
		LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
		
		LSlib.recipe.duplicate("tiberium-slurry-centrifuging", "tiberium-slurry-sludge-centrifuging")
		LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
		
		LSlib.recipe.duplicate("tiberium-molten-centrifuging", "tiberium-molten-sludge-centrifuging")
		LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
		
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "stone", StonePerCycle, "item")
		LSlib.recipe.addResult("tiberium-slurry-centrifuging", "stone", StonePerCycle, "item")
		LSlib.recipe.addResult("tiberium-ore-centrifuging", "stone", StonePerCycle, "item")
	
		--Direct and Growth Credit recipes for if Angel's Refining is active, overriding Bob's
		LSlib.recipe.duplicate("stone-growth-credit", "saphirite-growth-credit")
		LSlib.recipe.editIngredient("saphirite-growth-credit", "stone", "angels-ore1", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-saphirite")
		LSlib.recipe.editResult("tiberium-molten-to-saphirite", "stone", "angels-ore1", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "saphirite-growth-credit")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-saphirite")
		
		LSlib.recipe.duplicate("stone-growth-credit", "jivolite-growth-credit")
		LSlib.recipe.editIngredient("jivolite-growth-credit", "stone", "angels-ore2", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-jivolite")
		LSlib.recipe.editResult("tiberium-molten-to-jivolite", "stone", "angels-ore2", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "jivolite-growth-credit")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-jivolite")
		
		LSlib.recipe.duplicate("stone-growth-credit", "stiratite-growth-credit")
		LSlib.recipe.editIngredient("stiratite-growth-credit", "stone", "angels-ore3", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-stiratite")
		LSlib.recipe.editResult("tiberium-molten-to-stiratite", "stone", "angels-ore3", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "stiratite-growth-credit")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-stiratite")
		
		LSlib.recipe.duplicate("stone-growth-credit", "crotinnium-growth-credit")
		LSlib.recipe.editIngredient("crotinnium-growth-credit", "stone", "angels-ore4", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-crotinnium")
		LSlib.recipe.editResult("tiberium-molten-to-crotinnium", "stone", "angels-ore4", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "crotinnium-growth-credit")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-crotinnium")
		
		LSlib.recipe.duplicate("stone-growth-credit", "rubyte-growth-credit")
		LSlib.recipe.editIngredient("rubyte-growth-credit", "stone", "angels-ore5", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-rubyte")
		LSlib.recipe.editResult("tiberium-molten-to-rubyte", "stone", "angels-ore5", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "rubyte-growth-credit")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-rubyte")
		
		LSlib.recipe.duplicate("stone-growth-credit", "bobmonium-growth-credit")
		LSlib.recipe.editIngredient("bobmonium-growth-credit", "stone", "angels-ore6", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-bobmonium")
		LSlib.recipe.editResult("tiberium-molten-to-bobmonium", "stone", "angels-ore6", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "bobmonium-growth-credit")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-bobmonium")
		
		
	else
	
	
		--Standard Growth Credit and Direct recipes for bob's ores, even if his other mods are not active. Only fires if Angel's Refining is not active. If Angel's Refining, make recipes for his ores instead.
		LSlib.recipe.setEngergyRequired("iron-growth-credit", CreditTime)
		LSlib.recipe.setEngergyRequired("copper-growth-credit", CreditTime)
		LSlib.recipe.setEngergyRequired("uranium-growth-credit", CreditTime)
		LSlib.recipe.addIngredient("iron-growth-credit", "iron-ore", CreditCost, "item")
		LSlib.recipe.addIngredient("copper-growth-credit", "copper-ore", CreditCost, "item")
		LSlib.recipe.duplicate("stone-growth-credit", "tungsten-growth-credit")		
		LSlib.recipe.addIngredient("uranium-growth-credit", "uranium-ore", CreditCost*(DirectUraniumOutput/DirectRecipeOutput), "item")
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-uranium")
		LSlib.recipe.editResult("tiberium-molten-to-uranium", "stone", "uranium-ore", 0.25)
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-uranium")
		
		
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-iron")
		LSlib.recipe.editResult("tiberium-molten-to-iron", "stone", "iron-ore", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-copper")
		LSlib.recipe.editResult("tiberium-molten-to-copper", "stone", "copper-ore", 1)
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-iron")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-copper")
		
		LSlib.recipe.duplicate("stone-growth-credit", "tungsten-growth-credit")
		LSlib.recipe.editIngredient("tungsten-growth-credit", "stone", "tungsten-ore", 1)
		LSlib.recipe.duplicate("stone-growth-credit", "silver-growth-credit")
		LSlib.recipe.editIngredient("silver-growth-credit", "stone", "silver-ore", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "tungsten-growth-credit")
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "silver-growth-credit")
		
		LSlib.recipe.duplicate("stone-growth-credit", "zinc-growth-credit")
		LSlib.recipe.editIngredient("zinc-growth-credit", "stone", "zinc-ore", 1)
		LSlib.recipe.duplicate("stone-growth-credit", "gold-growth-credit")
		LSlib.recipe.editIngredient("gold-growth-credit", "stone", "gold-ore", 1)
		LSlib.recipe.duplicate("stone-growth-credit", "rutile-growth-credit")
		LSlib.recipe.editIngredient("rutile-growth-credit", "stone", "rutile-ore", 1)
		LSlib.recipe.duplicate("stone-growth-credit", "cobalt-growth-credit")
		LSlib.recipe.editIngredient("cobalt-growth-credit", "stone", "cobalt-ore", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "zinc-growth-credit")
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "gold-growth-credit")
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "rutile-growth-credit")
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "cobalt-growth-credit")
		
		
		
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
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "nickel-growth-credit")
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "lead-growth-credit")
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "quartz-growth-credit")
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "bauxite-growth-credit")
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "tin-growth-credit")
		
		LSlib.recipe.duplicate("uranium-growth-credit", "thorium-growth-credit")
		LSlib.recipe.editIngredient("thorium-growth-credit", "uranium-ore", "thorium-ore", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-uranium", "tiberium-molten-to-thorium")
		LSlib.recipe.editResult("tiberium-molten-to-thorium", "uranium-ore", "thorium-ore", 1)
		LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", "thorium-growth-credit")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-thorium")
		
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-tungsten")
		LSlib.recipe.editResult("tiberium-molten-to-tungsten", "stone", "tungsten-ore", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-silver")
		LSlib.recipe.editResult("tiberium-molten-to-silver", "stone", "silver-ore", 1)
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-tungsten")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-silver")
		
		
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-zinc")
		LSlib.recipe.editResult("tiberium-molten-to-zinc", "stone", "zinc-ore", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-rutile")
		LSlib.recipe.editResult("tiberium-molten-to-rutile", "stone", "rutile-ore", 1)
		LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-gold")
		LSlib.recipe.editResult("tiberium-molten-to-gold", "stone", "gold-ore", 1)
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-zinc")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-rutile")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-gold")
		
		
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
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-nickel")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-lead")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-quartz")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-bauxite")
		LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-tin")
		if (mods["bobplates"]) then
			if (mods["bobrevamp"]) then
				--Recipe generation for if bob's revamp is active.
				LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired*BobsMult)
				LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle*BobsMult, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "nickel-ore", NickelPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "lead-ore", LeadPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "tin-ore", TinPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "quartz", QuartzPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "coal", CoalPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "copper-ore", CopperPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "iron-ore", IronPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "bauxite-ore", AluminumPerCycle, "item")
				
				LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired * 1.5 *BobsMult)
				LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle*BobsMult, "fluid")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "zinc-ore", ZincPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "nickel-ore", NickelPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "lead-ore", LeadPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "rutile-ore", TitaniumPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "gold-ore", GoldPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "tin-ore", TinPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "quartz", QuartzPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "coal", CoalPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "copper-ore", CopperPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "iron-ore", IronPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "bauxite-ore", AluminumPerCycle, "item")
				LSlib.recipe.addResult("tiberium-slurry-centrifuging", "crude-oil", OilPerCycle, "fluid")
				
				LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired * 2 *BobsMult)
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "zinc-ore", ZincPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "nickel-ore", NickelPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "silver-ore", SlverPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "lead-ore", LeadPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "tungsten-ore", TungstenPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "rutile-ore", TitaniumPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "gold-ore", GoldPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "tin-ore", TinPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "quartz", QuartzPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "copper-ore", CopperPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "iron-ore", IronPerCycle, "item")
				
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "bauxite-ore", AluminumPerCycle, "item")
				LSlib.recipe.addResult("tiberium-molten-centrifuging", "crude-oil", OilPerCycle, "fluid")
				LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle *BobsMult, "fluid")
				
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
				local IronPerCycle    = 17
				local CopperPerCycle    = 18
				local CoalPerCycle    = 3
				local StonePerCycle    = 2
				local OilPerCycle    = 70
				local TotalCentOutput = OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
				local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult --Must be a multiple of 4, so that DirectUraniumOutput is a whole number.
				local DirectOilOutput = DirectRecipeOutput*(OilPerCycle/IronPerCycle)
				local DirectUraniumOutput = math.floor(DirectRecipeOutput/4 +.5) 
				local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency*RecipeMult
				local SludgePerCycle = StonePerCycle
				
				LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-iron")
				LSlib.recipe.editResult("tiberium-molten-to-iron", "stone", "iron-ore", 1)
				LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-copper")
				LSlib.recipe.editResult("tiberium-molten-to-copper", "stone", "copper-ore", 1)
				LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-iron")
				LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-copper")
				LSlib.recipe.addIngredient("tiberium-molten-to-coal", "molten-tiberium", MoltenPerCycle, "fluid")
				LSlib.recipe.addIngredient("tiberium-molten-to-stone", "molten-tiberium", MoltenPerCycle, "fluid")
				LSlib.recipe.addIngredient("tiberium-molten-to-crude-oil", "molten-tiberium", MoltenPerCycle, "fluid")
				LSlib.recipe.addIngredient("tiberium-molten-to-uranium-ore", "molten-tiberium", MoltenPerCycle, "fluid")
				LSlib.recipe.addResult("tiberium-molten-to-coal", "coal", DirectRecipeOutput, "item")
				LSlib.recipe.addResult("tiberium-molten-to-stone", "stone", DirectRecipeOutput, "item")
				LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "crude-oil", DirectOilOutput, "fluid")
				LSlib.recipe.addResult("tiberium-molten-to-uranium", "uranium-ore", DirectUraniumOutput, "item")
				
				
				
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
				LSlib.recipe.addIngredient("uranium-growth-credit", "uranium-ore", CreditCost*(DirectUraniumOutput/DirectRecipeOutput), "item")
			end
		end	
	end
	
	
else

--Vanilla recipe code

local IronPerCycle    = 17
local CopperPerCycle    = 18
local CoalPerCycle    = 3
local StonePerCycle    = 2
local OilPerCycle    = 70
local TotalCentOutput = OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult --Must be a multiple of 4, so that DirectUraniumOutput is a whole number.
local DirectUraniumOutput = math.floor(DirectRecipeOutput/4 +.5) 
local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency*RecipeMult
local SludgePerCycle = StonePerCycle

LSlib.recipe.addIngredient(recipeName, ingredientName, ingredientAmount, ingredientType)
LSlib.recipe.addResult(recipeName, resultName, resultAmount, resultType)
LSlib.recipe.setResultCount(recipeName, resultName, resultAmount)

LSlib.recipe.setEngergyRequired(recipeName, energyRequired)



--if (mods["bobores"]) then
	--else
	--Recipes that are Duplicated
	LSlib.recipe.addResult("tiberium-molten-to-stone", "stone", DirectRecipeOutput, "item")
	LSlib.recipe.setMainResult("tiberium-molten-to-stone", "stone")
	
	LSlib.recipe.addIngredient("stone-growth-credit", "stone", CreditCost, "item")
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-uranium")
	LSlib.recipe.editResult("tiberium-molten-to-uranium", "stone", "uranium-ore", 0.25)
	
	
	
	LSlib.recipe.addResult("tiberium-molten-to-coal", "coal", DirectRecipeOutput, "item")
	LSlib.recipe.setMainResult("tiberium-molten-to-coal", "coal")
	LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "crude-oil", DirectRecipeOutput*(OilPerCycle/IronPerCycle), "fluid")
	LSlib.recipe.setMainResult("tiberium-molten-to-crude-oil", "crude-oil")
	LSlib.recipe.addIngredient("coal-growth-credit", "coal", CreditCost, "item")
	LSlib.recipe.setEngergyRequired("coal-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("stone-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("oil-growth-credit", CreditTime)
	LSlib.recipe.setEngergyRequired("energy-growth-credit", EnergyCreditCost)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-iron")
	LSlib.recipe.editResult("tiberium-molten-to-iron", "stone", "iron-ore", 1)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-copper")
	LSlib.recipe.editResult("tiberium-molten-to-copper", "stone", "copper-ore", 1)
	LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-iron")
	LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-copper")
	
	LSlib.recipe.addIngredient("tiberium-molten-to-crude-oil", "molten-tiberium", MoltenPerCycle, "fluid")
	LSlib.recipe.addIngredient("tiberium-molten-to-uranium", "molten-tiberium", MoltenPerCycle, "fluid")
	LSlib.technology.addRecipeUnlock("advanced-tiberium-transmutation-tech", "tiberium-molten-to-uranium")




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
LSlib.recipe.addResult("tiberium-ore-centrifuging", "iron-ore", IronPerCycle+2, "item")
LSlib.recipe.addResult("tiberium-ore-centrifuging", "copper-ore", CopperPerCycle-2, "item")
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
LSlib.recipe.setEngergyRequired("uranium-growth-credit", CreditTime)
LSlib.recipe.addIngredient("iron-growth-credit", "iron-ore", CreditCost, "item")
LSlib.recipe.addIngredient("copper-growth-credit", "copper-ore", CreditCost, "item")
LSlib.recipe.addIngredient("oil-growth-credit", "crude-oil", CreditCost*(OilPerCycle/17), "fluid")
LSlib.recipe.addIngredient("uranium-growth-credit", "uranium-ore", CreditCost*(DirectUraniumOutput/DirectRecipeOutput), "item")



end

--[[if settings.startup["tiberium-byproduct-direct"].value == true then
	LSlib.recipe.addResult("tiberium-molten-to-iron-ore", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-copper-ore", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-coal", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-stone", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-uranium", "tiberium-sludge", SludgePerCycle, "fluid")
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