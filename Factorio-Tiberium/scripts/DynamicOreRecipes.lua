--TODO:
-- Make matrix solver more reliable
-- Better rounding for centrifuge
-- Handle mono-resource outputs with actual weights instead of just targets

local debugText = settings.startup["tiberium-debug-text"].value
local free = {}
local excludedCrafting = {["transport-drone-request"] = true} --Rigorous way to do this?

--Debugging for findRecipe
local unreachable = {}
local multipleRecipes = {}

--Defined by giantSetupFunction
local availableRecipes = {}
local fakeRecipes = {}
local rawResources = {}
local tibComboPacks = {}
local catalyst = {}
local ingredientIndex = {}
local resultIndex = {}
local badRecipeCategories = {num = {}, div = {}}
local badRecipeCount = 0
local recipeDepth = {}
local ingredientDepth = {}
local recipeUnlockTracker = {}

local science = {{}, {}, {}}
local allPacks = {}
local oreMult = {}
for fluid in pairs(data.raw.fluid) do
	oreMult[fluid] = 4
end
-- Lazy insert for rare ores
oreMult["uranium-ore"] = 1 / 8
if mods["bobores"] then
	oreMult["thorium-ore"] = 1 / 8
end
if mods["Krastorio2"] then
	oreMult["raw-imersite"] = 1 / 8
	oreMult["raw-rare-metals"] = 1 / 8
end
if mods["dark-matter-replicators-18"] then
	oreMult["dmr18-tenemut"] = 1 / 32
end
if mods["dark-matter-replicators-18-patch"] then
	oreMult["tenemut"] = 1 / 32
end
if mods["space-exploration"] then
	for itemName, item in pairs(data.raw.item) do
		if item.subgroup == "core-fragments" then
			if not item.flags or not LSlib.utils.table.hasValue(item.flags, "hidden") then
				if debugText then log("Marked "..itemName.." as a raw resource") end
				rawResources[itemName] = true
			end
		end
	end
end
local TibCraftingTint = {
	primary    = {r = 0.109804, g = 0.721567, b = 0.231373,  a = 1.000000},
	secondary  = {r = 0.098039, g = 1.000000, b = 0.278431,  a = 1.000000},
	tertiary   = {r = 0.156863, g = 0.156863, b = 0.156863,  a = 0.235294},
	quaternary = {r = 0.160784, g = 0.745098, b = 0.3058824, a = 0.345217},
}

-- Assumes: excludedCrafting
-- Modifies: rawResources, availableRecipes, free, ingredientIndex, resultIndex, catalyst, ingredientDepth, recipeDepth, tibComboPacks
function giantSetupFunction()
	-- Raw resources
	for _, resourceData in pairs(data.raw.resource) do
		if resourceData.autoplace and resourceData.minable then
			for item in pairs(resultsToTable(resourceData.minable)) do
				rawResources[item] = true
			end
		end
	end

	-- Find all science packs used with tib science in labs
	for labName, labData in pairs(data.raw.lab) do
		if LSlib.utils.table.hasValue(labData.inputs, "tiberium-science") then
			for _, pack in pairs(labData.inputs or {}) do
				if (pack ~= "tiberium-science") and data.raw.tool[pack] then
					tibComboPacks[pack] = {}
				end
			end
		end
	end

	-- Compile list of available recipes
	allAvailableRecipes()

	-- Build indices used later for pruning and traversing tree
	for recipe in pairs(availableRecipes) do
		local ingredientList = normalIngredients(recipe)
		local resultList     = normalResults(recipe)
		availableRecipes[recipe] = {ingredient = ingredientList, result = resultList}
		for ingredient in pairs(ingredientList) do
			if resultList[ingredient] then catalyst[recipe] = true end -- Keep track of enrichment/catalyst recipes
			ingredientIndex[ingredient] = ingredientIndex[ingredient] or {}
			ingredientIndex[ingredient][recipe] = true
		end
		for result in pairs(resultList) do
			if not resultIndex[result] then resultIndex[result] = {} end
			resultIndex[result][recipe] = true
		end
		if data.raw.recipe[recipe] and not fakeRecipes[recipe] then
			local category = data.raw.recipe[recipe].category
			availableRecipes[recipe].category = category
			if category or data.raw.recipe[recipe].subgroup then
				availableRecipes[recipe].fullCategory = (category or "").."|"..(data.raw.recipe[recipe].subgroup or "")
			end
		end
	end

	if debugText then packHierarchy() end

	-- Build a more comprehensive list of free items and ingredient index for later
	for _, pump in pairs(data.raw["offshore-pump"]) do
		if pump.fluid then
			free[pump.fluid] = true
		end
	end
	for _, tree in pairs(data.raw["tree"]) do
		if tree.autoplace and tree.minable then
			for item in pairs(resultsToTable(tree.minable)) do
				free[item] = true
			end
		end
	end
	for _, fish in pairs(data.raw["fish"]) do
		if fish.autoplace and fish.minable then
			for item in pairs(resultsToTable(fish.minable)) do
				free[item] = true
			end
		end
	end

	-- Pruning stupid recipes
	removeBadRecipes(1)
	
	for recipe in pairs(availableRecipes) do
		local ingredientList = normalIngredients(recipe)
		local resultList     = normalResults(recipe)
		if next(ingredientList) == nil then
			for result in pairs(resultList) do
				if not free[result] then
					free[result] = true
					if debugText then log(result.." is free because there are no ingredients for "..recipe) end
				end
			end
		end
	end

	local cachedFree = table.deepcopy(free)  -- Cache free item list so we can rebuild until we reach a list without issues
	local freeItemIterations = 0
	if debugText then log(badRecipeCount.." bad recipes before building free item list") end

	repeat
		local previousBadRecipeCount = badRecipeCount  -- So we can check if new recipes were marked as bad during this loop
		local newFreeItems = table.deepcopy(cachedFree)
		free = table.deepcopy(cachedFree)
		local countFreeLoops = 0
		freeItemIterations = freeItemIterations + 1
		if debugText then log("$$ Building free item list. Attempt #"..freeItemIterations) end
		while next(newFreeItems) do
			countFreeLoops = countFreeLoops + 1
			if debugText then log("On loop#"..countFreeLoops.." there were "..listLength(newFreeItems).." new free items") end
			local nextLoopFreeItems = {}
			for freeItem in pairs(newFreeItems) do
				for recipe in pairs(ingredientIndex[freeItem] or {}) do
					local actuallyFree = true
					for ingredient in pairs(normalIngredients(recipe)) do
						if not free[ingredient] then
							actuallyFree = false
							break
						end
					end
					if actuallyFree then
						for result in pairs(normalResults(recipe)) do
							if (tibComboPacks[result] or rawResources[result]) and markBadRecipe(recipe) then
								break  -- Intervene against recipes that make resources/science free
							end
							if not free[result] then
								free[result] = true
								nextLoopFreeItems[result] = true
								if debugText then log(result.." is free via "..recipe.." since "..freeItem.." is free") end
							end
						end
					end
				end
			end
			newFreeItems = nextLoopFreeItems
		end
		
		removeBadRecipes() -- Pruning stupid recipes
		if debugText then log(badRecipeCount.." bad recipes after free item list pass #"..freeItemIterations) end
	until (badRecipeCount == previousBadRecipeCount)

	if debugText then  -- Log pruned recipe category info
		for category, div in pairs(badRecipeCategories.div) do
			local bs = (badRecipeCategories.num[category] / div > 0.2) and "**BS** " or ""
			log(bs..category..": "..badRecipeCategories.num[category] .."/"..div)
		end
	end

	-- Setup for depth calculations
	local basicMaterials = table.deepcopy(rawResources)
	for material in pairs(rawResources) do
		ingredientDepth[material] = 0
	end
	for item in pairs(free) do
		ingredientDepth[item] = 0
	end
	-- Now iteratively build up recipes starting from raw resources
	while next(basicMaterials) do
		local nextMaterials = {}
		for material in pairs(basicMaterials) do
			for recipe in pairs(ingredientIndex[material] or {}) do
				if not recipeDepth[recipe] then  --I could nest this deeper but it seems simpler to have at the top
					-- Something with storing a complexity for the recipe, maybe move scoring to here from findRecipe?
					-- Nah leave it in findRecipe so it can account for other active ingredients
					local maxIngredientLevel = 0
					for ingredient in pairs(normalIngredients(recipe)) do
						if not ingredientDepth[ingredient] then
							maxIngredientLevel = false
							break
						elseif ingredientDepth[ingredient] > maxIngredientLevel then
							maxIngredientLevel = ingredientDepth[ingredient]
						end
					end
					
					if maxIngredientLevel then
						recipeDepth[recipe] = maxIngredientLevel + 1
						for result in pairs(normalResults(recipe)) do
							if not ingredientDepth[result] then
								ingredientDepth[result] = maxIngredientLevel + 1
								nextMaterials[result] = true --And then add new results to nextMaterials
							end
						end
					end
				end
			end
		end
		basicMaterials = nextMaterials
	end
end

--Modifies: availableRecipes, fakeRecipes, tibComboPacks, recipeUnlockTracker
function allAvailableRecipes()
	recipeUnlockTracker["default"] = {}
	recipeUnlockTracker["fixed_recipe"] = {}
	recipeUnlockTracker["technology"] = {}
	-- Recipes unlocked by default
	for recipe, recipeData in pairs(data.raw.recipe) do
		if (recipeData.enabled ~= false) and (recipeData.hidden ~= true) then  -- Enabled and not hidden
			availableRecipes[recipe] = true
			recipeUnlockTracker["default"][recipe] = ""
		end
	end
	-- Recipes enabled but only at a specific structure
	for _, assembler in pairs(data.raw["assembling-machine"]) do
		if assembler.fixed_recipe and data.raw.recipe[assembler.fixed_recipe] and (data.raw.recipe[assembler.fixed_recipe].enabled ~= false) then
			availableRecipes[assembler.fixed_recipe] = true
			recipeUnlockTracker["fixed_recipe"][assembler.fixed_recipe] = assembler.name
		end
	end
	-- Recipes unlocked by a technology
	for tech, techData in pairs(data.raw.technology) do
		if (techData.enabled == nil) or (techData.enabled == true) then  -- Only use enabled technologies
			for _, effect in pairs(techData.effects or {}) do
				if effect.recipe then
					if data.raw.recipe[effect.recipe] then
						availableRecipes[effect.recipe] = true
						recipeUnlockTracker["technology"][effect.recipe] = tech
						if data.raw.recipe[effect.recipe].result and tibComboPacks[data.raw.recipe[effect.recipe].result] then
							tibComboPacks[data.raw.recipe[effect.recipe].result] = techData.unit.ingredients  --save for later
						end
					else
						log(tech.." tried to unlock recipe "..effect.recipe.." which does not exist?")
					end
				end
			end
		end
	end
	for item, itemData in pairs(data.raw.item) do
		-- Dummy recipes for rocket launch products
		if itemData.rocket_launch_product then
			local launchProduct = itemData.rocket_launch_product[1] or itemData.rocket_launch_product.name
			local launchAmount  = itemData.rocket_launch_product[2] or itemData.rocket_launch_product.amount
			if launchProduct then  -- Fake recipe for rockets
				for silo, siloData in pairs(data.raw["rocket-silo"]) do
					if siloData.fixed_recipe and siloData.rocket_result_inventory_size and (siloData.rocket_result_inventory_size > 0) then
						local fakeRecipeName = "dummy-recipe-launching-"..item.."-from-"..silo
						local partName = next(normalResults(siloData.fixed_recipe))
						local numParts = (siloData.rocket_parts_required or 1) / siloData.rocket_result_inventory_size
						fakeRecipes[fakeRecipeName] = true
						availableRecipes[fakeRecipeName] = {ingredient = {[item] = 1, [partName] = numParts}, result = {[launchProduct] = launchAmount}}
					end
				end
			end
		end
		-- Dummy recipes for burning items
		local burntResult = itemData.burnt_result
		if burntResult then
			local fakeRecipeName = "dummy-recipe-burning-"..item
			fakeRecipes[fakeRecipeName] = true
			availableRecipes[fakeRecipeName] = {ingredient = {[item] = 1}, result = {[burntResult] = 1}}
		end
	end
	-- Dummy recipes for boilers
	for name, boiler in pairs(data.raw["boiler"]) do
		if boiler.fluid_box.filter and boiler.output_fluid_box.filter then
			availableRecipes["dummy-recipe-boiler-"..name] = {ingredient = {[boiler.fluid_box.filter] = 1}, result = {[boiler.output_fluid_box.filter] = 1}}
			fakeRecipes["dummy-recipe-boiler-"..name] = true
		end
	end
	-- Avoid Tiberium recipes
	for recipe in pairs(availableRecipes) do
		if string.find(recipe, "tiberium") then
			availableRecipes[recipe] = nil
		end
	end
end

--Assumes: fakeRecipes, tibComboPacks, rawResources
--Modifies: availableRecipes, ingredientIndex, resultIndex
function removeBadRecipes(pass)
	local vanillaCategories = {
		["advanced-crafting"] = true,
		["basic-crafting"] = true,
		["centrifuging"] = true,
		["chemistry"] = true,
		["crafting"] = true,
		["crafting-with-fluid"] = true,
		["oil-processing"] = true,
		["rocket-building"] = true,
		["smelting"] = true,
	}
	if pass == 1 then
		--Build table and remove specific recipes on first pass
		for recipe, recipeData in pairs(availableRecipes) do
			if not fakeRecipes[recipe] then
				local category = recipeData.category
				if category then
					if not badRecipeCategories.div[category] then  -- Initialize
						badRecipeCategories.num[category] = 0
						badRecipeCategories.div[category] = 1
					else
						badRecipeCategories.div[category] = badRecipeCategories.div[category] + 1
					end
				end
				local fullCategory = recipeData.fullCategory
				if fullCategory then
					if not badRecipeCategories.div[fullCategory] then  -- Initialize
						badRecipeCategories.num[fullCategory] = 0
						badRecipeCategories.div[fullCategory] = 1
					else
						badRecipeCategories.div[fullCategory] = badRecipeCategories.div[fullCategory] + 1
					end
				end
				local resultList = normalResults(recipe)
				local numResults = listLength(resultList)
				local sciencePackTypes, sciencePackCount = 0, 0
				for result, amount in pairs(resultList) do
					if (result == "empty-barrel") and (numResults > 1) then  -- Bad recipes like unbarreling give empty barrels
						markBadRecipe(recipe)
						break
					elseif (rawResources[result] or tibComboPacks[result]) and (next(normalIngredients(recipe)) == nil) then  -- Bad recipes give raw resources/science for free
						markBadRecipe(recipe)
						break
					elseif tibComboPacks[result] then
						sciencePackTypes = sciencePackTypes + 1
						if sciencePackTypes > 2 then  -- Bad recipes make more than 2 types of science packs
							markBadRecipe(recipe)
							break
						end
						sciencePackCount = sciencePackCount + amount
						if sciencePackCount > 1000 then  -- Bad recipes give more than 1000 science packs
							markBadRecipe(recipe)
							break
						end
					end
				end
			end
		end
	end

	-- Look for categories that contained broken recipes and exclude other recipes from the same category
	for recipe, recipeData in pairs(availableRecipes) do
		if not fakeRecipes[recipe] then
			local category = recipeData.category
			local fullCategory = recipeData.fullCategory
			if fullCategory and (badRecipeCategories.num[fullCategory] / badRecipeCategories.div[fullCategory] > 0.2) then
				markBadRecipe(recipe)
			elseif category and not vanillaCategories[category] and (badRecipeCategories.num[category] / badRecipeCategories.div[category] > 0.2) then
				markBadRecipe(recipe)
			elseif category and excludedCrafting[category] then
				markBadRecipe(recipe)
			end
		end
	end
end

--Returns: Whether the recipe was successfully removed
--Assumes: rawResources
--Modifies: availableRecipes, ingredientIndex, resultIndex
function markBadRecipe(recipe)
	-- Check whether we need to keep it because there are no other ways to get an item
	for result in pairs(availableRecipes[recipe]["result"]) do
		if not rawResources[result] and not free[result] and (listLength(resultIndex[result]) == 1) then
			return false
		end
	end
	-- Now we are clear to remove it
	if debugText then log("Removing bad recipe "..recipe) end
	for ingredient in pairs(availableRecipes[recipe]["ingredient"]) do
		ingredientIndex[ingredient][recipe] = nil
	end
	for result in pairs(availableRecipes[recipe]["result"]) do
		resultIndex[result][recipe] = nil
	end
	local category = availableRecipes[recipe].category
	if category then badRecipeCategories.num[category] = badRecipeCategories.num[category] + 1 end
	local fullCategory = availableRecipes[recipe].fullCategory
	if fullCategory then badRecipeCategories.num[fullCategory] = badRecipeCategories.num[fullCategory] + 1 end
	badRecipeCount = badRecipeCount + 1
	availableRecipes[recipe] = nil
	return true
end

--Assumes: recipeUnlockTracker, tibComboPacks
function packHierarchy()
	for pack in pairs(tibComboPacks) do
		local recipe = ""
		if listLength(resultIndex[pack]) == 1 then
			recipe = next(resultIndex[pack])
			log(recipe.." is the only recipe for "..pack)
		else
			log("Multiple recipes for "..pack.." "..serpent.block(resultIndex[pack]))
		end
	end
end

-- Assumes: free, recipeDepth
-- Modifies: unreachable, multipleRecipes
function findRecipe(item, itemList)
	local recipes = {}
	for recipeName in pairs(availableRecipes) do
		local resultList = normalResults(recipeName)
		if resultList[item] then
			-- Score the recipes so we can choose the best
			local penalty = 0
			local ingredientList = normalIngredients(recipeName)
			for ingredient in pairs(ingredientList) do
				if (ingredient ~= item) and not free[ingredient] then
					-- Less bad if it uses something we already have extra of?
					if itemList and itemList[ingredient] and itemList[ingredient] > 0 then
						penalty = penalty - 8
					else
						penalty = penalty + 10
					end
				end
			end
			if penalty > 0 then -- Only penalize byproducts if recipe isn't free
				for result in pairs(resultList) do
					if (result ~= item) and not free[result] then
						if itemList and itemList[result] and itemList[result] > 0 then  -- Bonus if other output is useful
							penalty = penalty - 20
						else
							penalty = penalty + 5  -- Penalize or reward excess products?
						end
					end
				end
			end
			if recipeDepth[recipeName] then
				if recipeDepth[recipeName] > ingredientDepth[item] then
					penalty = penalty + 10000  -- Avoid recipes that don't reduce overall complexity
				end
				penalty = penalty + 20 * recipeDepth[recipeName]
				table.insert(recipes, {name=recipeName, count=resultList[item], penalty=penalty})
			else  -- If it isn't reachable, don't use it, since we won't be able to break it down
				unreachable[recipeName] = true
			end
		end
	end
	
	if #recipes > 1 then
		-- Name as tiebreaker because otherwise it's not deterministic >.<
		table.sort(recipes, function(a,b) return (a.penalty == b.penalty) and (a.name < b.name) or (a.penalty < b.penalty) end)
		--log("Found "..#recipes.." recipes for "..item..". Defaulting to "..recipes[1]["name"])
		local recipeNames = {}
		for i = 1, #recipes do
			table.insert(recipeNames, {recipes[i].name, recipes[i].penalty})
		end
		multipleRecipes[item] = recipeNames
		if debugText then
			log("  multiple recipes for "..item)
			for _,v in pairs(recipeNames) do
				log("    "..v[1].." penalty: "..v[2])
			end
		end
	end
	if recipes[1] then
		if catalyst[recipes[1]] then  -- Scale properly for catalyst/enrichment
			local itemIn = normalIngredients(recipeName)[item] or 0
			return recipes[1]["name"], recipes[1]["count"] - itemIn
		else
			return recipes[1]["name"], recipes[1]["count"]
		end
	else
		return nil, nil
	end
end

-- Assumes: ingredientDepth
-- Optional parameters: recipesUsed, intermediates
function breadthFirst(itemList, recipesUsed, intermediates)
	local maxDepth = 0
	for item, amount in pairs(itemList) do
		if (amount > 0) and ingredientDepth[item] and (ingredientDepth[item] > maxDepth) then  -- Add something for things with no depth?
			maxDepth = ingredientDepth[item]
		elseif not ingredientDepth[item] then
			log("@@@ Missing depth for "..item)
		end
	end
	if maxDepth == 0 then -- Done
		return itemList
	end
	
	local targetItem  -- Only doing one item per loop so they don't step on each other's toes
	for item, amount in pairs(itemList) do
		if (amount > 0) and (ingredientDepth[item] == maxDepth) then
			if (targetItem == nil) or (item < targetItem) then targetItem = item end -- First alphabetically
		end
	end
	local targetAmount = itemList[targetItem]
	--log("depth:"..maxDepth.." "..targetAmount.." "..targetItem)
	
	local recipeName, recipeCount = findRecipe(targetItem, itemList) -- No point caching with breadthFirst
	if not recipeName then
		log("%%% Couldn't find a recipe for "..targetItem)
		itemList[targetItem] = -1 * targetAmount -- Lazy way to avoid infinite loops
		return breadthFirst(itemList, recipesUsed, intermediates)
	end
	local recipeTimes = targetAmount / recipeCount
	if debugText then log("Using recipe "..recipeName.." "..recipeTimes.." times to get "..targetAmount.." "..targetItem) end
	if recipesUsed then
		recipesUsed[recipeName] = (recipesUsed[recipeName] or 0) + recipeTimes
	end
	
	sumDicts(itemList, makeScaledList(normalIngredients(recipeName), recipeTimes), "  ")
	sumDicts(itemList, makeScaledList(normalResults(recipeName), -1 * recipeTimes), "  ")

	if intermediates then
		for ingredient in pairs(normalIngredients(recipeName)) do
			if not free[ingredient] and not rawResources[ingredient] then
				intermediates[ingredient] = true
			end
		end
	end

	for item, amount in pairs(itemList) do
		if free[item] or (math.abs(amount) < 0.0001) then itemList[item] = nil end  -- Clean up list
	end
	return breadthFirst(itemList, recipesUsed, intermediates)
end

function normalIngredients(recipeName)
	if fakeRecipes[recipeName] then
		return availableRecipes[recipeName]["ingredient"]
	end
	local recipe = data.raw["recipe"][recipeName]
	local ingredients = recipe.normal and recipe.normal.ingredients or recipe.ingredients
	if not ingredients then
		log("#######Could not find ingredients for "..recipeName)
		return {}
	end
	local ingredientTable = {}
	for _, ingredient in pairs(ingredients) do
		if ingredient[1] then
			ingredientTable[ingredient[1]] = ingredient[2]
		elseif ingredient.name then
			ingredientTable[ingredient.name] = ingredient.amount
		end
	end
	return ingredientTable
end

function normalResults(recipeName)
	if fakeRecipes[recipeName] then
		return availableRecipes[recipeName]["result"]
	end
	local recipe = data.raw["recipe"][recipeName]
	local resultTable = resultsToTable(recipe.normal)
	if next(resultTable) == nil then
		resultTable = resultsToTable(recipe)
	end
	if next(resultTable) == nil then
		log("#######Could not find results for "..recipeName)
	end
	return resultTable
end

function resultsToTable(prototypeTable)
	local out = {}
	if type(prototypeTable) ~= "table" then
		return out
	end
	if prototypeTable.results then
		for _, result in pairs(prototypeTable.results) do
			if result[1] then
				local amount = result[2]
				if amount > 0 then
					out[result[1]] = amount
				end
			elseif result.name then
				local amount = (result.amount or (result.amount_min + math.max(result.amount_min, result.amount_max)) / 2) * (result.probability or 1)
				if amount > 0 then
					out[result.name] = amount
				end
			end
		end
	elseif prototypeTable.result then
		out[prototypeTable.result] = prototypeTable.result_count or prototypeTable.count or 1
	end
	return out
end

function sumDicts(dict1, dict2, logging)
	if type(dict1) ~= "table" then dict1 = {} end
	if type(dict2) == "table" then
		for k, v in pairs(dict2) do
			dict1[k] = v + (dict1[k] or 0)
			if logging then
				local sign = v >= 0 and "+" or ""
				--log(logging..sign..v.." "..k)
			end
		end
	end
	return dict1
end

function makeScaledList(list, scalar)
	if not scalar then log("bad scalar") return {} end
	if type(list) ~= "table" then log("bad list") return {} end

	local scaledList = {}
	for k, v in pairs(list) do
		scaledList[k] = v * scalar
	end
	return scaledList
end

function listLength(list)
	local count = 0
	for _ in pairs(list) do count = count + 1 end
	return count
end

function addPacksToTier(ingredients, collection)
	for _, pack in pairs(ingredients or {}) do
		local packName = pack[1] and pack[1] or pack.name
		if not collection[packName] and (packName ~= "tiberium-science") then
			collection[packName] = true
		end
	end
end

function fugeTierSetup()
	-- Store data for centrifuge tiers
	for tech, techData in pairs(data.raw.technology) do
		if techData.max_level and techData.max_level == "infinite" then
			addPacksToTier(techData.unit.ingredients, science[3])
		elseif (tech == "rocket-silo") or (tech == "space-science-pack") then
			addPacksToTier(techData.unit.ingredients, science[2])
		end
	end
	
	for pack in pairs(tibComboPacks or {}) do
		if not allPacks[pack] then
			if debugText then log("}\r\n"..pack.."{") end
			allPacks[pack] = breadthFirst({[pack] = 1})
			local tier1 = true
			for ingredient in pairs(allPacks[pack]) do
				if data.raw["fluid"][ingredient] then
					tier1 = false
					break
				end
			end
			if tier1 then
				science[1][pack] = true
			elseif not science[3][pack] then
				science[2][pack] = true
			end
		end
	end
	-- Purge high tier packs from T1
	repeat
		local somethingNew = false
		for pack in pairs(science[1]) do
			for _, ingredient in pairs(tibComboPacks[pack]) do
				local required = ingredient[1] and ingredient[1] or ingredient.name
				if not science[1][required] then
					science[1][pack] = nil
					somethingNew = true
					if not science[2][pack] and not science[3][pack] then
						science[2][pack] = true
					end
					if debugText then log("Removed "..pack.." from tier 1 because it requires non-T1 "..required) end
				end
			end
		end
	until not somethingNew
	for pack in pairs(science[2] or {}) do
		if not allPacks[pack] then
			if debugText then log("}\r\n"..pack.."{") end
			allPacks[pack] = breadthFirst({[pack] = 1})
		end
	end
	for pack in pairs(science[3] or {}) do
		if not allPacks[pack] then
			if debugText then log("}\r\n"..pack.."{") end
			allPacks[pack] = breadthFirst({[pack] = 1})
		end
	end
	if listLength(science[1]) == 0 then  -- Fallback in case nothing qualifies for T1
		science[1] = table.deepcopy(science[2])
	end
	if debugText then log("}") end
end

function fugeRecipeTier(tier)
	local resources, fluids = {}, {}
	local smallResources = 0
	local recipeMult = 1
	local foundRecipeMult = false
	local material = (tier == 1) and "slurry" or (tier == 2) and "molten" or "liquid"
	local item = (tier == 1) and "tiberium-slurry" or (tier == 2) and "molten-tiberium" or "liquid-tiberium"
	local ingredientAmount = (tier ~= 1) and math.max(160 / settings.startup["tiberium-value"].value, 1) or 16
	local targetAmount = (tier == 1) and 32 or (tier == 2) and 64 or 128
	local totalOre = 0
	local overrideSetting = settings.startup["tiberium-centrifuge-override-"..tier].value
	overrideSetting = string.gsub(overrideSetting, "\"", "")  -- Strip quotes
	if string.len(overrideSetting) > 0 then
		local delim = ","
		local subDelim = ":"
		for sub in string.gmatch(overrideSetting, "[^"..delim.."]+") do  -- Loop over comma-delimited substrings
			local item = sub
			local amount = 1
			if string.find(sub, subDelim) then
				item = string.match(sub, "^[^"..subDelim.."]+")  -- Before the colon
				amount = tonumber(string.match(sub, "[^"..subDelim.."]+$"))  -- After the colon
				if amount == 0 then  -- In case they put some non-numeric
					amount = 1
					log("tiberium-centrifuge-override-"..tier.." setting has an invalid number for item "..item)
				end
			end
			if data.raw.item[item] or data.raw.fluid[item] then
				resources[item] = amount
			else
				log("tiberium-centrifuge-override-"..tier.." setting has an invalid item: "..item)
			end
		end
	else
		-- Total all resources for the tier
		for pack in pairs(science[tier]) do
			sumDicts(resources, allPacks[pack])
		end
	end
	-- Check number of fluids and weighted sum the resources
	for res, amount in pairs(resources) do
		if amount > 0 then
			if data.raw.fluid[res] then
				fluids[res] = amount
				totalOre = totalOre + (amount * 0.25)
			else
				totalOre = totalOre + amount
			end
		end
	end
	if listLength(fluids) > 2 then
		log("Uh oh, your tier "..tier.." recipe has "..listLength(fluids).." fluids")
		--idk what my plan is for handling this case
	end
	resources = makeScaledList(resources, targetAmount / math.max(totalOre, 1)) --Scale resources to match tier target amounts
	
	for resource, amount in pairs(resources) do
		if amount < 1 / 128 then  -- Cutoff for amounts too small to scale up
			resources[resource] = nil
		elseif amount <= 0.5 then
			smallResources = smallResources + 1
		end
	end
	--Find recipe multiplier to mitigate impact of later rounding
	while ((smallResources > 1) or (smallResources > 0.2 * listLength(resources))) and (recipeMult ~= 64) do
		recipeMult = 2 * recipeMult
		smallResources = 0
		for _, amount in pairs(resources) do
			if (amount * recipeMult) <= 0.5 then
				smallResources = smallResources + 1
			elseif (amount * recipeMult) > 32000 then  -- Don't double if it would put us over stack limit
				smallResources = 0
				break
			end
		end
	end
	--Make actual recipe changes
	local normalFugeRecipeName = "tiberium-"..material.."-centrifuging"
	local sludgeFugeRecipeName = "tiberium-"..material.."-sludge-centrifuging"
	LSlib.recipe.editEngergyRequired(normalFugeRecipeName, recipeMult)
	LSlib.recipe.addIngredient(normalFugeRecipeName, item, ingredientAmount * recipeMult, "fluid")
	if debugText then log("Tier "..tier.." centrifuge: "..ingredientAmount * recipeMult.." "..item) end
	for resource, amount in pairs(resources) do
		if (resource ~= "stone") and (amount > 1 / 128) then
			local rounded = math.ceil(amount * recipeMult)
			LSlib.recipe.addResult(normalFugeRecipeName, resource, rounded, fluids[resource] and "fluid" or "item")
			if debugText then log("> "..rounded.." "..resource) end
		end
	end
	local stone = math.ceil((resources["stone"] or 0) * recipeMult)
	if (stone > 0) and (listLength(fluids) < 3) then -- Only create sludge recipe if there is stone to convert and we have enough fluid boxes
		LSlib.recipe.duplicate(normalFugeRecipeName, sludgeFugeRecipeName)
		LSlib.recipe.setLocalisedName(sludgeFugeRecipeName, {"recipe-name.tiberium-sludge-centrifuging", {"fluid-name."..item}})
		LSlib.recipe.changeIcon(sludgeFugeRecipeName, tiberiumInternalName.."/graphics/icons/"..material.."-sludge-centrifuging.png", 32)
		LSlib.technology.addRecipeUnlock("tiberium-"..material.."-centrifuging", sludgeFugeRecipeName)
		LSlib.recipe.addResult(sludgeFugeRecipeName, "tiberium-sludge", stone, "fluid")
	end
	if stone > 0 then  -- Add stone after duplicating bc LSlib change result doesn't support changing result types
		LSlib.recipe.addResult(normalFugeRecipeName, "stone", stone, "item")
		if debugText then log("> "..stone.." stone") end
	end
end

function singletonRecipes()
	for resourceName, resourceData in pairs(data.raw.resource) do
		if resourceData.autoplace and resourceData.minable then
			for ore in pairs(resultsToTable(resourceData.minable)) do
				if ore ~= "tiberium-ore" then
					addDirectRecipe(ore)
					addCreditRecipe(ore)
				end
			end
		end
	end
end

--Creates recipes to turn Molten Tiberium directly into raw materials
--Assumes oreMult
function addDirectRecipe(ore)
	local recipeName = "tiberium-molten-to-"..ore
	local oreAmount = math.floor(64 * (oreMult[ore] and oreMult[ore] or 1) + 0.5)
	local itemOrFluid = data.raw.fluid[ore] and "fluid" or "item"
	local tech = data.raw.fluid[ore] and "tiberium-molten-centrifuging" or "tiberium-transmutation-tech"
	local energy = 12
	local order = (not oreMult[ore] and "a-" or oreMult[ore] > 1 and "b-" or "c-")..ore
	
	LSlib.recipe.create(recipeName)
	LSlib.recipe.addIngredient(recipeName, "molten-tiberium", 16, "fluid")
	LSlib.recipe.addResult(recipeName, ore, oreAmount, itemOrFluid)
	LSlib.recipe.setMainResult(recipeName, ore)
	if settings.startup["tiberium-byproduct-direct"].value then  -- Direct Sludge Waste setting
		local WastePerCycle = math.max(10 / settings.startup["tiberium-value"].value, 1)
		LSlib.recipe.addResult(recipeName, "tiberium-sludge", WastePerCycle, "fluid")
	end
	LSlib.technology.addRecipeUnlock(tech, recipeName)
	LSlib.recipe.setEngergyRequired(recipeName, energy)
	LSlib.recipe.setOrderstring(recipeName, order)
	LSlib.recipe.disable(recipeName)
	LSlib.recipe.setSubgroup(recipeName, "a-direct")
	LSlib.recipe.setShowMadeIn(recipeName, true)
	data.raw.recipe[recipeName].category = "chemistry"
	data.raw.recipe[recipeName].crafting_machine_tint = TibCraftingTint
	data.raw.recipe[recipeName].allow_as_intermediate = false
	data.raw.recipe[recipeName].allow_decomposition = false
end

--Creates recipes to turn raw materials into Growth Credits
--Assumes oreMult
function addCreditRecipe(ore)
	local recipeName = "tiberium-growth-credit-from-"..ore
	local oreAmount = settings.startup["tiberium-value"].value * settings.startup["tiberium-growth"].value * (oreMult[ore] and oreMult[ore] or 1)
	local itemOrFluid = data.raw.fluid[ore] and "fluid" or "item"
	local energy = settings.startup["tiberium-growth"].value * settings.startup["tiberium-value"].value
	local order = (not oreMult[ore] and "a-" or oreMult[ore] > 1 and "b-" or "c-")..ore
	local oreIcon, oreIconSize, oreTint
	if data.raw["item"][ore] then
		local icon = LSlib.item.getIcons("item", ore)[1]
		oreIcon = icon.icon
		oreIconSize = icon.icon_size
		oreTint = icon.tint
	elseif data.raw["fluid"][ore] then
		local icon = LSlib.item.getIcons("fluid", ore)[1]
		oreIcon = icon.icon
		oreIconSize = icon.icon_size
		oreTint = icon.tint
	end
	local icons = {
		{
			icon = tiberiumInternalName.."/graphics/icons/growth-credit.png",
			icon_size = 64,
		},
	}
	if oreIcon then
		icons[2] = {
			icon = oreIcon,
			icon_size = oreIconSize,
			icon_mipmaps = ore.icon_mipmaps,
			scale = 12.0 / (oreIconSize or 1), -- scale = 0.5 * 32 / icon_size simplified
			shift = {10, -10},
			tint = oreTint,
		}
	end
	
	LSlib.recipe.create(recipeName)
	LSlib.recipe.addIngredient(recipeName, ore, oreAmount, itemOrFluid)
	LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", recipeName)
	LSlib.recipe.setEngergyRequired(recipeName, energy)
	LSlib.recipe.setOrderstring(recipeName, order)
	LSlib.recipe.changeIcons(recipeName, icons, 64)
	LSlib.recipe.addResult(recipeName, "tiberium-growth-credit", 1, "item")
	LSlib.recipe.disable(recipeName)
	LSlib.recipe.setSubgroup(recipeName, "a-growth-credits")
	LSlib.recipe.setShowMadeIn(recipeName, true)
	data.raw.recipe[recipeName].category = "chemistry"
	data.raw.recipe[recipeName].crafting_machine_tint = TibCraftingTint
	data.raw.recipe[recipeName].allow_decomposition = false
end

giantSetupFunction()
singletonRecipes()
log("%%% Setup complete beginning recipe parse")
fugeTierSetup()
fugeRecipeTier(1)
fugeRecipeTier(2)
fugeRecipeTier(3)

if debugText then
	log("Active mods: "..serpent.block(mods))
	log("science "..serpent.block(science))
	log("all packs "..serpent.block(allPacks))
	log("raw resources "..serpent.block(rawResources))
	log("free items "..serpent.block(free))
	log("unreachable "..serpent.block(unreachable))
	local sortedDepth = {}
	for item, depth in pairs(ingredientDepth) do
		table.insert(sortedDepth, {item, depth})
	end
	table.sort(sortedDepth, function(a,b) return (a[2] == b[2]) and (a[1] < b[1]) or (a[2] < b[2]) end)
	local output = ""
	for _, v in pairs(sortedDepth) do
		output = output..v[2].." "..v[1].."\r\n"
	end
	log("item depths {\r\n"..output.."}")
end
