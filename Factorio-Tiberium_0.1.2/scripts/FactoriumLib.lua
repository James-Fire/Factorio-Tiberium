local GrowthTech = "advanced-tiberium-processing-tech"
local DirectTech = "tiberium-control-network-tech"



function FactoriumLib.recipe.generateGrowthRecipe(OretoGrow)
	LSlib.recipe.duplicate("stone-growth-credit", OretoGrow"-growth-credit")
	LSlib.recipe.editIngredient(OretoGrow"-growth-credit", "stone", OretoGrow, 1)
	LSlib.technology.addRecipeUnlock(GrowthTech, OretoGrow"-growth-credit")
	
end

function FactoriumLib.recipe.generateDirectRecipe(OretoDirect)
	LSlib.recipe.duplicate("tiberium-molten-to-stone", "tiberium-molten-to-"OretoDirect)
	LSlib.recipe.editResult("tiberium-molten-to-"OretoDirect, "stone", OretoDirect, 1)
	LSlib.technology.addRecipeUnlock(DirectTech, "tiberium-molten-to-"OretoDirect)
end