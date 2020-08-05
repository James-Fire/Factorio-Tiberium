require("scripts/recipe")
--require("scripts/FactoriumLib")

local RecipeMult = settings.startup["tiberium-value"].value / 10

--Universal Variables used no matter what mods are active
local OrePerCredit = settings.startup["tiberium-growth"].value * 10
local CreditTime = RecipeMult * OrePerCredit  --Scale with OrePerCredit instead of just constant 100
local EnergyCreditCost = CreditTime * 3
local InputMaterial = 10 / RecipeMult
local OretoSlurry = 0.6 * RecipeMult
local SlurrytoMolten = 0.6
local RefineEnergyRequired = InputMaterial * 0.25
local WastePerCycle      = math.max(InputMaterial / 10, 1)
local CentEnergyRequired = 10 / RecipeMult
local TiberiumPerCycle   = math.max(40 / RecipeMult, 1) --As ore is more valuable, it should take less of it to centrifuge
local SlurryPerCycle     = 40
local MoltenPerCycle     = 16
local CreditEfficiency = 0.75 --How much of the ore should be converted into tiberium when used.
local DirectRecipeMult = 0.6 --The Efficiency of using Direct recipes over the Centrifuge recipes. All centrifuge outputs are added together and multiplied by this to get the Direct output.
local DirectRecipeTime = 12

LSlib.recipe.addIngredient("tiberium-rounds-magazine", "tiberium-ore", math.max(10 / RecipeMult, 1), "item") --So it doesn't crash for large RecipeMults
LSlib.recipe.setEngergyRequired("tiberium-ore-processing", RefineEnergyRequired)
LSlib.recipe.setEngergyRequired("molten-tiberium-processing", RefineEnergyRequired)
LSlib.recipe.setEngergyRequired("tiberium-liquid-processing", RefineEnergyRequired * 24)
LSlib.recipe.setEngergyRequired("tiberium-growth-credit-from-energy", EnergyCreditCost)
LSlib.recipe.addResult("tiberium-farming", "tiberium-ore", 100 + (OrePerCredit * 0.5), "item") --Changed this so the 100 base tiberium ore isn't multiplied
LSlib.recipe.addResult("tiberium-farming", "tiberium-data", OrePerCredit * 0.1, "item")

--Because we use this everywhere
function doCentrifugeRecipeSplit(StonePerCycle)
	for _, type in pairs({"ore", "slurry", "molten"}) do
		LSlib.recipe.duplicate("tiberium-"..type.."-centrifuging", "tiberium-"..type.."-sludge-centrifuging")
		LSlib.recipe.changeIcon("tiberium-"..type.."-sludge-centrifuging", tiberiumInternalName.."/graphics/icons/"..type.."-sludge-centrifuging.png", 32)
		LSlib.recipe.addResult("tiberium-"..type.."-sludge-centrifuging", "tiberium-sludge", StonePerCycle, "fluid")
		LSlib.recipe.addResult("tiberium-"..type.."-centrifuging", "stone", StonePerCycle, "item")
	end
end

--[[Code for Bob's ores, without his Science Packs
if (mods["bobores"]) then
	--Variables needed regardless of other Bob's mods being active.
	local BobsMult = 100 --Since the requirement for bob's ores are weird, this is here to make it all whole numbers.
	local AluminumPerCycle = 4.4 * BobsMult
	local IronPerCycle     = 4.2 * BobsMult
	local StonePerCycle    = 4.1 * BobsMult
	local CopperPerCycle   = 3.2 * BobsMult
	local CoalPerCycle     = 2.7 * BobsMult
	local QuartzPerCycle   = 1.9 * BobsMult
	local TinPerCycle      = 1.7 * BobsMult
	local GoldPerCycle     = 0.8 * BobsMult
	local TitaniumPerCycle = 0.5 * BobsMult
	local TungstenPerCycle = 0.25 * BobsMult
	local LeadPerCycle     = 0.14 * BobsMult
	local SlverPerCycle    = 0.13 * BobsMult
	local NickelPerCycle   = 0.07 * BobsMult
	local ZincPerCycle     = 0.02 * BobsMult
	local OilPerCycle      = 44 * BobsMult
	local TotalCentOutput  = (AluminumPerCycle+LeadPerCycle+SlverPerCycle+ZincPerCycle+QuartzPerCycle+GoldPerCycle+TinPerCycle
			+TitaniumPerCycle+TungstenPerCycle+NickelPerCycle+OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle)/BobsMult
	local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult
	local DirectOilOutput = DirectRecipeOutput*((OilPerCycle/BobsMult)/(IronPerCycle/BobsMult))
	local DirectUraniumOutput = math.floor(DirectRecipeOutput/4 +.5)
	local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency

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
		LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle*BobsMult, "fluid")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "crude-oil", OilPerCycle, "fluid")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore1", SaphiritePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore2", JivolitePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore3", StiratitePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore4", CrotinniumPerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore5", RubytePerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore6", BobmoniumPerCycle2, "item")
		LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
		
		doCentrifugeRecipeSplit(StonePerCycle) --Wow such refactor
	else
		-- Standard Growth Credit and Direct recipes for bob's ores, even if his other mods are not active.
		-- Only fires if Angel's Refining is not active. If Angel's Refining, make recipes for his ores instead.
		if (mods["bobplates"]) then
			if (mods["bobrevamp"]) then
				--Recipe generation for if bob's revamp is active.
				LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired * BobsMult)
				LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle * BobsMult, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "nickel-ore", NickelPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "lead-ore", LeadPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "tin-ore", TinPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "quartz", QuartzPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "coal", CoalPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "copper-ore", CopperPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "iron-ore", IronPerCycle, "item")
				LSlib.recipe.addResult("tiberium-ore-centrifuging", "bauxite-ore", AluminumPerCycle, "item")
				
				LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired * 1.5 * BobsMult)
				LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle * BobsMult, "fluid")
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
				
				LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired * 2 * BobsMult)
				LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle * BobsMult, "fluid")
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
				
				doCentrifugeRecipeSplit(StonePerCycle)
			end
		end	
	end
elseif (mods["angelsrefining"] and mods["angelspetrochem"]) then
	AngelsMult = 1
	local IronPerCycle   = 17 * AngelsMult
	local CopperPerCycle = 18 * AngelsMult
	local CoalPerCycle   =  3 * AngelsMult
	local StonePerCycle  =  2 * AngelsMult
	local OilPerCycle    = 70 * AngelsMult
	local TotalCentOutput = OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
	local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult
	local DirectOilOutput     = math.floor(DirectRecipeOutput * (OilPerCycle / IronPerCycle))
	local DirectUraniumOutput = math.floor(DirectRecipeOutput/10 +.5)
	local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency

	--Angel's Centrifuging Recipe generation
	LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired*AngelsMult)
	LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle*AngelsMult, "item")
	LSlib.recipe.addResult("tiberium-ore-centrifuging", "angels-ore1", IronPerCycle, "item")  --Saphirite
	LSlib.recipe.addResult("tiberium-ore-centrifuging", "angels-ore3", CopperPerCycle, "item")  --Stiratite
	LSlib.recipe.addResult("tiberium-ore-centrifuging", "coal", CoalPerCycle, "item")
	
	LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired*AngelsMult* 1.5)
	LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle*AngelsMult, "fluid")
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore1", math.ceil(IronPerCycle * 0.8), "item")  --Saphirite
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore2", IronPerCycle * 0.2, "item")  --Jivolite
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore3", math.ceil(CopperPerCycle * 0.8), "item")  --Stiratite
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "angels-ore4", CopperPerCycle * 0.2, "item")  --Crotinnium
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "coal", CoalPerCycle, "item")
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "liquid-multi-phase-oil", OilPerCycle, "fluid")
	
	LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired*AngelsMult * 2)
	LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle*AngelsMult, "fluid")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore1", math.ceil(IronPerCycle * 0.6), "item")  --Saphirite
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore2", IronPerCycle * 0.4, "item")  --Jivolite
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore3", math.ceil(CopperPerCycle * 0.6), "item")  --Stiratite
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "angels-ore4", CopperPerCycle * 0.4, "item")  --Crotinnium
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "liquid-multi-phase-oil", OilPerCycle, "fluid")

	doCentrifugeRecipeSplit(StonePerCycle)
else
	--Vanilla recipe code
	local IronPerCycle   = 17
	local CopperPerCycle = 18
	local CoalPerCycle   = 3
	local StonePerCycle  = 2
	local OilPerCycle    = 70
	local TotalCentOutput = OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
	local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult
	local DirectUraniumOutput = math.floor(DirectRecipeOutput/10 +.5)
	local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
	local SludgePerCycle = StonePerCycle

	-- Centrifuging Recipes
	LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired)
	LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle, "item")
	LSlib.recipe.addResult("tiberium-ore-centrifuging", "iron-ore", IronPerCycle+2, "item")
	LSlib.recipe.addResult("tiberium-ore-centrifuging", "copper-ore", CopperPerCycle-2, "item")
	LSlib.recipe.addResult("tiberium-ore-centrifuging", "coal", CoalPerCycle, "item")
	
	LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired * 1.5)
	LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "iron-ore", IronPerCycle, "item")
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "copper-ore", CopperPerCycle, "item")
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "coal", CoalPerCycle, "item")
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "crude-oil", OilPerCycle, "fluid")
	
	LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired * 2)
	LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "iron-ore", IronPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "copper-ore", CopperPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "crude-oil", OilPerCycle, "fluid")
	
	doCentrifugeRecipeSplit(StonePerCycle)
end
--]]

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
