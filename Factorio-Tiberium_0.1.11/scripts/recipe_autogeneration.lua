require("scripts/recipe")
--require("scripts/FactoriumLib")

local RecipeMult = math.floor(settings.startup["tiberium-value"].value +.5)/10 

--Universal Variables used no matter what mods are active
local OrePerCredit = settings.startup["tiberium-growth"].value
local CreditTime = RecipeMult*OrePerCredit  --Scale with OrePerCredit instead of just constant 100
local EnergyCreditCost = CreditTime*3
local InputMaterial = 10/RecipeMult
local OretoSlurry = 2*RecipeMult
local SlurrytoMolten = 0.6
--local WaterRequirement = InputMaterial*10  --Currently unused
local RefineEnergyRequired = InputMaterial*0.25
local WastePerCycle      = math.max(InputMaterial/10, 1)
local CentEnergyRequired = 10/RecipeMult
local TiberiumPerCycle   = math.max(40/RecipeMult, 1) --As ore is more valuable, it should take less of it to centrifuge
local SlurryPerCycle     = 40
local MoltenPerCycle     = 16
local CreditEfficiency = 0.75 --How much of the ore should be converted into tiberium when used.
local DirectRecipeMult = 0.6 --The Efficiency of using Direct recipes over the Centrifuge recipes. All centrifuge outputs are added together and multiplied by this to get the Direct output.
local DirectRecipeTime = 12

--Universal things that need to be done regardless of mods active
if settings.startup["tiberium-byproduct-direct"].value == true then  -- Direct Sludge Waste setting, need this at top so it gets copied to other direct recipes
	LSlib.recipe.addResult("tiberium-molten-to-stone", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-crude-oil", "tiberium-sludge", WastePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-to-coal", "tiberium-sludge", WastePerCycle, "fluid")
end

LSlib.recipe.addIngredient("tiberium-magazine", "tiberium-ore", math.max(10/RecipeMult, 1), "item") --So it doesn't crash for large RecipeMults
LSlib.recipe.setEngergyRequired("tiberium-ore-processing", RefineEnergyRequired)
LSlib.recipe.setEngergyRequired("advanced-tiberium-ore-processing", RefineEnergyRequired)  --Liquid Tiberium Processing is just a constant 60s
LSlib.recipe.setEngergyRequired("tiberium-liquid-processing", RefineEnergyRequired*24)
LSlib.recipe.setEngergyRequired("tiberium-molten-to-stone", DirectRecipeTime)
LSlib.recipe.setEngergyRequired("tiberium-molten-to-crude-oil", DirectRecipeTime)
LSlib.recipe.setEngergyRequired("tiberium-molten-to-coal", DirectRecipeTime)
LSlib.recipe.addIngredient("tiberium-molten-to-coal", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-stone", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addIngredient("tiberium-molten-to-crude-oil", "molten-tiberium", MoltenPerCycle, "fluid")
LSlib.recipe.addResult("tiberium-farming", "tiberium-ore", 100+(OrePerCredit*.5), "item") --Changed this so the 100 base tiberium ore isn't multiplied
LSlib.recipe.addResult("tiberium-farming", "tiberium-data", OrePerCredit*0.1, "item")

--Creates recipes to turn Molten Tiberium directly into raw materials, options is an optional list
--Assumes MoltenPerCycle, WastePerCycle
function addDirectRecipe(recipeName, ore, oreAmount, options)
	local energy, order, tech, tibType, tibAmount
	if not options then options = {} end
	energy = options.energy
	order = options.order
	tech = options.tech and options.tech or "advanced-tiberium-transmutation-tech"
	tibType = options.tibType and tibType or "molten-tiberium"
	tibAmount = options.tibAmount and options.tibAmount or MoltenPerCycle
	local itemOrFluid = data.raw.fluid[ore] and "fluid" or "item"
	local tibItemOrFluid = data.raw.fluid[tibType] and "fluid" or "item"
	
	LSlib.recipe.duplicate("template-direct", recipeName)
	LSlib.recipe.addIngredient(recipeName, tibType, tibAmount, tibItemOrFluid)
	LSlib.recipe.addResult(recipeName, ore, oreAmount, itemOrFluid)
	LSlib.recipe.setMainResult(recipeName, ore)
	if settings.startup["tiberium-byproduct-direct"].value then  -- Direct Sludge Waste setting
		LSlib.recipe.addResult(recipeName, "tiberium-sludge", WastePerCycle, "fluid")
	end
	LSlib.technology.addRecipeUnlock(tech, recipeName)
	if energy then LSlib.recipe.setEngergyRequired(recipeName, energy) end
	if order then LSlib.recipe.setOrderstring(recipeName, order) end
end

--Creates recipes to turn raw materials into Growth Credits, options is an optional list
--Assumes Credit Time
function addCreditRecipe(recipeName, ore, oreAmount, options)
	local energy, icon, order, tech
	if not options then options = {} end
	energy = options.energy and options.energy or CreditTime
	icon = options.icon
	order = options.order
	tech = options.tech and options.tech or "tiberium-growth-acceleration"

	LSlib.recipe.duplicate("template-growth-credit", recipeName)
	if ore then
		local itemOrFluid = data.raw.fluid[ore] and "fluid" or "item"
		LSlib.recipe.addIngredient(recipeName, ore, oreAmount, itemOrFluid)
	end
	LSlib.technology.addRecipeUnlock(tech, recipeName)
	if energy then LSlib.recipe.setEngergyRequired(recipeName, energy) end
	if order then LSlib.recipe.setOrderstring(recipeName, order) end
	if icon then LSlib.recipe.changeIcon(recipeName, "__Factorio-Tiberium__/graphics/icons/"..icon, 32) end
end

--Code for Bob's ores, without his Science Packs
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
	local SludgePerCycle   = StonePerCycle
	local TotalCentOutput  = (AluminumPerCycle+LeadPerCycle+SlverPerCycle+ZincPerCycle+QuartzPerCycle+GoldPerCycle+TinPerCycle
			+TitaniumPerCycle+TungstenPerCycle+NickelPerCycle+OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle)/BobsMult
	local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult
	local DirectOilOutput = DirectRecipeOutput*((OilPerCycle/BobsMult)/(IronPerCycle/BobsMult))
	local DirectUraniumOutput = math.floor(DirectRecipeOutput/4 +.5) 
	local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
	
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
		addDirectRecipe("tiberium-molten-to-saphirite", "angels-ore1", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-jivolite", "angels-ore2", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-stiratite", "angels-ore3", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-crotinnium", "angels-ore4", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-rubyte", "angels-ore5", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-bobmonium", "angels-ore6", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-stone", "stone", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-coal", "coal", DirectRecipeOutput, {order="d"})
		addDirectRecipe("tiberium-molten-to-crude-oil", "crude-oil", DirectOilOutput,
						{order="e", tech="tiberium-molten-processing"})
		
		addCreditRecipe("saphirite-growth-credit", "angels-ore1", CreditCost)
		addCreditRecipe("jivolite-growth-credit", "angels-ore2", CreditCost)
		addCreditRecipe("stiratite-growth-credit", "angels-ore3", CreditCost)
		addCreditRecipe("crotinnium-growth-credit", "angels-ore4", CreditCost)
		addCreditRecipe("rubyte-growth-credit", "angels-ore5", CreditCost)
		addCreditRecipe("bobmonium-growth-credit", "angels-ore6", CreditCost)
		addCreditRecipe("stone-growth-credit", "stone", CreditCost, {order="c", icon="stone-growth-credit.png"})
		addCreditRecipe("coal-growth-credit", "coal", CreditCost, {order="d", icon="coal-growth-credit.png"})
		addCreditRecipe("oil-growth-credit", "crude-oil", CreditCost * (OilPerCycle / IronPerCycle),
						{order="e", icon="oil-growth-credit.png"})
		
	else
		-- Standard Growth Credit and Direct recipes for bob's ores, even if his other mods are not active.
		-- Only fires if Angel's Refining is not active. If Angel's Refining, make recipes for his ores instead.
		addDirectRecipe("tiberium-molten-to-iron", "iron-ore", DirectRecipeOutput, {order="a"})
		addDirectRecipe("tiberium-molten-to-copper", "copper-ore", DirectRecipeOutput, {order="b"})
		addDirectRecipe("tiberium-molten-to-stone", "stone", DirectRecipeOutput, {order="c"})
		addDirectRecipe("tiberium-molten-to-coal", "coal", DirectRecipeOutput, {order="d"})
		addDirectRecipe("tiberium-molten-to-uranium", "uranium-ore", DirectUraniumOutput, {order="f"})
		
		addDirectRecipe("tiberium-molten-to-tungsten", "tungsten-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-silver", "silver-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-zinc", "zinc-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-rutile", "rutile-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-gold", "gold-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-cobalt", "cobalt-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-nickel", "nickel-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-lead", "lead-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-quartz", "quartz-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-bauxite", "bauxite-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-tin", "tin-ore", DirectRecipeOutput)
		addDirectRecipe("tiberium-molten-to-thorium", "thorium-ore", DirectUraniumOutput, {order="f"})
		
		addCreditRecipe("iron-growth-credit", "iron-ore", CreditCost, {order="a", icon="iron-growth-credit.png"})
		addCreditRecipe("copper-growth-credit", "copper-ore", CreditCost, {order="b", icon="copper-growth-credit.png"})
		addCreditRecipe("stone-growth-credit", "stone", CreditCost, {order="c", icon="stone-growth-credit.png"})
		addCreditRecipe("coal-growth-credit", "coal", CreditCost, {order="d", icon="coal-growth-credit.png"})
		addCreditRecipe("oil-growth-credit", "crude-oil", CreditCost * (OilPerCycle / IronPerCycle),
						{order="e", icon="oil-growth-credit.png"})
		addCreditRecipe("uranium-growth-credit", "uranium-ore", CreditCost * (DirectUraniumOutput / DirectRecipeOutput),
						{order="f", icon="uranium-growth-credit.png"})
		
		addCreditRecipe("tungsten-growth-credit", "tungsten-ore", CreditCost)
		addCreditRecipe("silver-growth-credit", "silver-ore", CreditCost)
		addCreditRecipe("zinc-growth-credit", "zinc-ore", CreditCost)
		addCreditRecipe("gold-growth-credit", "gold-ore", CreditCost)
		addCreditRecipe("rutile-growth-credit", "rutile-ore", CreditCost)
		addCreditRecipe("cobalt-growth-credit", "cobalt-ore", CreditCost)
		addCreditRecipe("nickel-growth-credit", "nickel-ore", CreditCost)
		addCreditRecipe("quartz-growth-credit", "quartz-ore", CreditCost)
		addCreditRecipe("bauxite-growth-credit", "bauxite-ore", CreditCost)
		addCreditRecipe("tin-growth-credit", "tin-ore", CreditCost)
		addCreditRecipe("thorium-growth-credit", "thorium-ore", CreditCost * (DirectUraniumOutput / DirectRecipeOutput), {order="f"})
		
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
				local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult
				local DirectUraniumOutput = math.floor(DirectRecipeOutput/4 +.5) 
				local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
				local SludgePerCycle = StonePerCycle
				
				-- Direct Recipes
				addDirectRecipe("tiberium-molten-to-iron", "iron-ore", DirectRecipeOutput, {order="a"})
				addDirectRecipe("tiberium-molten-to-copper", "copper-ore", DirectRecipeOutput, {order="b"})
				addDirectRecipe("tiberium-molten-to-stone", "stone", DirectRecipeOutput, {order="c"})
				addDirectRecipe("tiberium-molten-to-coal", "coal", DirectRecipeOutput, {order="d"})
				addDirectRecipe("tiberium-molten-to-crude-oil", "crude-oil", DirectRecipeOutput * (OilPerCycle / IronPerCycle),
								{order="e", tech="tiberium-molten-processing"})
				addDirectRecipe("tiberium-molten-to-uranium", "uranium-ore", DirectUraniumOutput, {order="f"})
				
				-- Growth Credit Recipes
				addCreditRecipe("iron-growth-credit", "iron-ore", CreditCost, {order="a", icon="iron-growth-credit.png"})
				addCreditRecipe("copper-growth-credit", "copper-ore", CreditCost, {order="b", icon="copper-growth-credit.png"})
				addCreditRecipe("stone-growth-credit", "stone", CreditCost, {order="c", icon="stone-growth-credit.png"})
				addCreditRecipe("coal-growth-credit", "coal", CreditCost, {order="d", icon="coal-growth-credit.png"})
				addCreditRecipe("oil-growth-credit", "crude-oil", CreditCost*(OilPerCycle/IronPerCycle), {order="e", icon="oil-growth-credit.png"})
				addCreditRecipe("uranium-growth-credit", "uranium-ore", CreditCost*(DirectUraniumOutput/DirectRecipeOutput), {order="f", icon="uranium-growth-credit.png"})
				LSlib.recipe.setEngergyRequired("energy-growth-credit", EnergyCreditCost)
			end
		end	
	end
elseif (mods["angelsrefining"] and mods["angelspetrochem"]) then
	AngelsMult = 1
	local IronPerCycle   = 17
	local CopperPerCycle = 18
	local CoalPerCycle   = 3
	local StonePerCycle  = 2
	local OilPerCycle    = 70
	local TotalCentOutput = OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
	local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult
	local DirectOilOutput     = math.floor(DirectRecipeOutput * (OilPerCycle / IronPerCycle))
	local DirectUraniumOutput = math.floor(DirectRecipeOutput/4 +.5) 
	local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
	local SludgePerCycle = StonePerCycle
	local SaphiritePerCycle  = 0.8*IronPerCycle*AngelsMult
	local JivolitePerCycle   = 0.2*IronPerCycle*AngelsMult
	local StiratitePerCycle  = 0.8*CopperPerCycle*AngelsMult
	local CrotinniumPerCycle = 0.2*CopperPerCycle*AngelsMult

	--Angel's Centrifuging Recipe generation
	
	LSlib.recipe.setEngergyRequired("tiberium-ore-centrifuging", CentEnergyRequired*AngelsMult)
	LSlib.recipe.setEngergyRequired("tiberium-ore-sludge-centrifuging", CentEnergyRequired*AngelsMult)
	LSlib.recipe.setEngergyRequired("tiberium-slurry-centrifuging", CentEnergyRequired*AngelsMult* 1.5)
	LSlib.recipe.setEngergyRequired("tiberium-slurry-sludge-centrifuging", CentEnergyRequired*AngelsMult* 1.5)
	LSlib.recipe.setEngergyRequired("tiberium-molten-centrifuging", CentEnergyRequired*AngelsMult * 2)
	LSlib.recipe.setEngergyRequired("tiberium-molten-sludge-centrifuging", CentEnergyRequired*AngelsMult * 2)
	
	LSlib.recipe.addIngredient("tiberium-ore-centrifuging", "tiberium-ore", TiberiumPerCycle*AngelsMult, "item")
	LSlib.recipe.addIngredient("tiberium-ore-sludge-centrifuging", "tiberium-ore", TiberiumPerCycle*AngelsMult, "item")
	LSlib.recipe.addIngredient("tiberium-slurry-centrifuging", "tiberium-slurry", SlurryPerCycle*AngelsMult, "fluid")
	LSlib.recipe.addIngredient("tiberium-slurry-sludge-centrifuging", "tiberium-slurry", SlurryPerCycle*AngelsMult, "fluid")
	LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle*AngelsMult, "fluid")
	LSlib.recipe.addIngredient("tiberium-molten-sludge-centrifuging", "molten-tiberium", MoltenPerCycle*AngelsMult, "fluid")
	
	local centrifugeRecipes = {"tiberium-ore-centrifuging", "tiberium-slurry-centrifuging", "tiberium-molten-centrifuging",
			"tiberium-ore-sludge-centrifuging", "tiberium-slurry-sludge-centrifuging", "tiberium-molten-sludge-centrifuging"}
	for _, recipe in pairs(centrifugeRecipes) do
		LSlib.recipe.addResult(recipe, "angels-ore1", SaphiritePerCycle, "item")
		LSlib.recipe.addResult(recipe, "angels-ore2", JivolitePerCycle, "item")
		LSlib.recipe.addResult(recipe, "angels-ore3", StiratitePerCycle, "item")
		LSlib.recipe.addResult(recipe, "angels-ore4", CrotinniumPerCycle, "item")
		LSlib.recipe.addResult(recipe, "coal", CoalPerCycle, "item")
	end
	
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "liquid-multi-phase-oil", OilPerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "liquid-multi-phase-oil", OilPerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "liquid-multi-phase-oil", OilPerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "liquid-multi-phase-oil", OilPerCycle, "fluid")
	
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "stone", StonePerCycle, "item")
	LSlib.recipe.addResult("tiberium-slurry-centrifuging", "stone", StonePerCycle, "item")
	LSlib.recipe.addResult("tiberium-ore-centrifuging", "stone", StonePerCycle, "item")
	
	LSlib.recipe.addResult("tiberium-ore-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-slurry-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
	
	--Direct and Growth Credit recipes for if Angel's Refining is active, overriding Bob's
	addDirectRecipe("tiberium-molten-to-saphirite", "angels-ore1", DirectRecipeOutput, {order="a"})
	addDirectRecipe("tiberium-molten-to-jivolite", "angels-ore2", DirectRecipeOutput, {order="b"})
	addDirectRecipe("tiberium-molten-to-stiratite", "angels-ore3", DirectRecipeOutput, {order="c"})
	addDirectRecipe("tiberium-molten-to-crotinnium", "angels-ore4", DirectRecipeOutput, {order="d"})
	addDirectRecipe("tiberium-molten-to-stone", "stone", DirectRecipeOutput, {order="e"})
	addDirectRecipe("tiberium-molten-to-coal", "coal", DirectRecipeOutput, {order="f"})
	addDirectRecipe("tiberium-molten-to-crude-oil", "liquid-multi-phase-oil", DirectOilOutput,
					{order="g", tech="tiberium-molten-processing"})
	addDirectRecipe("tiberium-molten-to-natural-gas", "gas-natural-1", 3 * DirectOilOutput,
					{order="h", tech="tiberium-molten-processing"})
	addDirectRecipe("tiberium-molten-to-uranium", "uranium-ore", DirectUraniumOutput, {order="i"})
	
	addCreditRecipe("saphirite-growth-credit", "angels-ore1", CreditCost, {order="a"})
	addCreditRecipe("jivolite-growth-credit", "angels-ore2", CreditCost, {order="b"})
	addCreditRecipe("stiratite-growth-credit", "angels-ore3", CreditCost, {order="c"})
	addCreditRecipe("crotinnium-growth-credit", "angels-ore4", CreditCost, {order="d"})
	addCreditRecipe("stone-growth-credit", "stone", CreditCost, {order="e", icon="stone-growth-credit.png"})
	addCreditRecipe("coal-growth-credit", "coal", CreditCost, {order="f", icon="coal-growth-credit.png"})
	addCreditRecipe("multi-phase-oil-growth-credit", "liquid-multi-phase-oil", CreditCost * (DirectOilOutput / DirectRecipeOutput),
					{order="g", icon="oil-growth-credit.png"})
	addCreditRecipe("natural-gas-growth-credit", "gas-natural-1", 3 * CreditCost * (DirectOilOutput / DirectRecipeOutput),
					{order="h", icon="oil-growth-credit.png"})
	addCreditRecipe("uranium-growth-credit", "uranium-ore", CreditCost * (DirectUraniumOutput / DirectRecipeOutput),
					{order="i", icon="uranium-growth-credit.png"})
	LSlib.recipe.setEngergyRequired("energy-growth-credit", EnergyCreditCost)

else
	--Vanilla recipe code
	local IronPerCycle   = 17
	local CopperPerCycle = 18
	local CoalPerCycle   = 3
	local StonePerCycle  = 2
	local OilPerCycle    = 70
	local TotalCentOutput = OilPerCycle+StonePerCycle+CoalPerCycle+CopperPerCycle+IronPerCycle
	local DirectRecipeOutput = TotalCentOutput*DirectRecipeMult
	local DirectUraniumOutput = math.floor(DirectRecipeOutput/4 +.5) 
	local CreditCost = (OrePerCredit/DirectRecipeOutput)*(MoltenPerCycle/SlurrytoMolten*OretoSlurry)/CreditEfficiency
	local SludgePerCycle = StonePerCycle

	-- LSlib.recipe.addIngredient(recipeName, ingredientName, ingredientAmount, ingredientType)
	-- LSlib.recipe.addResult(recipeName, resultName, resultAmount, resultType)
	-- LSlib.recipe.setResultCount(recipeName, resultName, resultAmount)
	-- LSlib.recipe.setEngergyRequired(recipeName, energyRequired)
	
	-- Direct Recipes
	addDirectRecipe("tiberium-molten-to-iron", "iron-ore", DirectRecipeOutput, {order="a"})
	addDirectRecipe("tiberium-molten-to-copper", "copper-ore", DirectRecipeOutput, {order="b"})
	addDirectRecipe("tiberium-molten-to-stone", "stone", DirectRecipeOutput, {order="c"})
	addDirectRecipe("tiberium-molten-to-coal", "coal", DirectRecipeOutput, {order="d"})
	addDirectRecipe("tiberium-molten-to-crude-oil", "crude-oil", DirectRecipeOutput * (OilPerCycle / IronPerCycle),
					{order="e", tech="tiberium-molten-processing"})
	addDirectRecipe("tiberium-molten-to-uranium", "uranium-ore", DirectUraniumOutput, {order="f"})

	-- Refining Recipes
	LSlib.recipe.addIngredient("tiberium-ore-processing", "tiberium-ore", InputMaterial, "item")
	LSlib.recipe.addResult("tiberium-ore-processing", "tiberium-slurry", InputMaterial*OretoSlurry, "fluid")
	
	LSlib.recipe.addIngredient("advanced-tiberium-ore-processing", "tiberium-slurry", InputMaterial, "fluid")
	LSlib.recipe.addResult("advanced-tiberium-ore-processing", "molten-tiberium", InputMaterial*SlurrytoMolten, "fluid")
	
	-- Centrifuging Recipes
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
	LSlib.recipe.addIngredient("tiberium-molten-centrifuging", "molten-tiberium", MoltenPerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "stone", StonePerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "coal", CoalPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "iron-ore", IronPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "copper-ore", CopperPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-centrifuging", "crude-oil", OilPerCycle, "fluid")
	
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
	LSlib.recipe.addIngredient("tiberium-molten-sludge-centrifuging", "molten-tiberium", MoltenPerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "coal", CoalPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "iron-ore", IronPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "copper-ore", CopperPerCycle, "item")
	LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "tiberium-sludge", SludgePerCycle, "fluid")
	LSlib.recipe.addResult("tiberium-molten-sludge-centrifuging", "crude-oil", OilPerCycle, "fluid")
	
	-- Growth Credit Recipes
	addCreditRecipe("iron-growth-credit", "iron-ore", CreditCost, {order="a", icon="iron-growth-credit.png"})
	addCreditRecipe("copper-growth-credit", "copper-ore", CreditCost, {order="b", energy=CreditTime, icon="copper-growth-credit.png"})
	addCreditRecipe("stone-growth-credit", "stone", CreditCost, {order="c", icon="stone-growth-credit.png"})
	addCreditRecipe("coal-growth-credit", "coal", CreditCost, {order="d", icon="coal-growth-credit.png"})
	addCreditRecipe("oil-growth-credit", "crude-oil", CreditCost*(OilPerCycle/IronPerCycle), {order="e", icon="oil-growth-credit.png"})
	addCreditRecipe("uranium-growth-credit", "uranium-ore", CreditCost*(DirectUraniumOutput/DirectRecipeOutput), {order="f", icon="uranium-growth-credit.png"})
	LSlib.recipe.setEngergyRequired("energy-growth-credit", EnergyCreditCost)
end

if (mods["angelspetrochem"]) then --Replace the vanilla Chemical Plant with one of Angel's, cause apparently it's too hard to simply use the vanilla one.
	LSlib.recipe.editIngredient("tiberium-plant", "chemical-plant", "angels-chemical-plant-2", 1)    
end

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

if settings.startup["waste-recycling"].value == true then  -- Waste Recycling setting
	LSlib.technology.addRecipeUnlock("tiberium-power-tech", "tiberium-waste-recycling")
end

--Needs an icon since it has no output, idk how to delete it
LSlib.recipe.changeIcon("template-direct", "__Factorio-Tiberium__/graphics/icons/tiberium-brick.png", 32)
