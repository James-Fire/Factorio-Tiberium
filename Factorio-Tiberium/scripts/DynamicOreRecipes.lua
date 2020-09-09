
--TODO:
-- Make matrix solver more reliable
-- Support alternate rocket silos (Py)
-- Detect bullshit recipes (recipe categories to avoid?)

local debugText = settings.startup["tiberium-debug-text"].value
local free = {}
local fromThinAir = {}
local excludedCrafting = {["barreling-pump"] = true, ["transport-drone-request"] = true} --Rigorous way to do this?
if mods["Clowns-Science"] then
	excludedCrafting["particle-accelerator"] = true
	excludedCrafting["facility"] = true
end
--Debugging for findRecipe
local unreachable = {}
local multipleRecipes = {}

--Defined by giantSetupFunction
local availableRecipes = {}
local fakeRecipes = {}
local rawResources = {}
local ingredientIndex = {}
local recipeDepth = {}
local ingredientDepth = {}
local catalyst = {}
local resultIndex = {}
local tibComboPacks = {}

local science = {{}, {}, {}}
local allPacks = {}
local oreMult = {}
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
local TibCraftingTint = {
	primary    = {r = 0.109804, g = 0.721567, b = 0.231373,  a = 1},
	secondary  = {r = 0.098039, g = 1,        b = 0.278431,  a = 1},
	tertiary   = {r = 0.156863, g = 0.156863, b = 0.156863,  a = 0.235294},
	quaternary = {r = 0.160784, g = 0.745098, b = 0.3058824, a = 0.345217},
}

-- Assumes: excludedCrafting
-- Modifies: rawResources, availableRecipes, free, ingredientIndex, resultIndex, catalyst, ingredientDepth, recipeDepth, tibComboPacks
function giantSetupFunction()
	-- Raw resources
	for _, resourceData in pairs(data.raw.resource) do
		if resourceData.autoplace and resourceData.minable then 
			if resourceData.minable.result then
				rawResources[resourceData.minable.result] = true
			elseif resourceData.minable.results then --For fluids/multiple results
				for _, result in pairs(resourceData.minable.results) do
					if result.name then
						rawResources[result.name] = true
					end
				end
			end
		end
	end
	-- Find all science packs used with tib science in labs
	for labName, labData in pairs(data.raw.lab) do
		if LSlib.utils.table.hasValue(labData.inputs, "tiberium-science") then
			for _, pack in pairs(labData.inputs or {}) do
				if pack ~= "tiberium-science" then
					tibComboPacks[pack] = {}
				end
			end
		end
	end
	-- Compile list of available recipes
	for recipe, recipeData in pairs(data.raw.recipe) do
		if (recipeData.enabled ~= false) and (recipeData.hidden ~= true) then  -- Enabled and not hidden
			availableRecipes[recipe] = true
		end
	end
	for _, assembler in pairs(data.raw["assembling-machine"]) do
		if assembler.fixed_recipe and data.raw.recipe[assembler.fixed_recipe] and (data.raw.recipe[assembler.fixed_recipe].enabled ~= false) then
			availableRecipes[assembler.fixed_recipe] = true  -- Enabled but only at a specific structure
		end
	end
	for tech, techData in pairs(data.raw.technology) do
		if (techData.enabled == nil) or (techData.enabled == true) then  -- Only use enabled recipes
			for _, effect in pairs(techData.effects or {}) do
				if effect.recipe then
					if data.raw.recipe[effect.recipe] then
						availableRecipes[effect.recipe] = true
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
	for recipeName in pairs(availableRecipes) do
		local recipe = data.raw.recipe[recipeName]
		if excludedCrafting[recipe.category] then
			availableRecipes[recipeName] = nil
		elseif recipe.subgroup and (string.find(recipe.subgroup, "empty%-barrel") or string.find(recipe.subgroup, "barrel%-empty")) then -- Hope other mods have good naming
			availableRecipes[recipeName] = nil
		elseif string.find(recipeName, "tiberium") then  -- Want only non-tib recipes for fuge stuff
			availableRecipes[recipeName] = nil
		end
	end
	-- Build a more comprehensive list of free items and ingredient index for later
	for _, pump in pairs(data.raw["offshore-pump"]) do
		if pump.fluid then
			free[pump.fluid] = true
		end
	end
	for _, tree in pairs(data.raw["tree"]) do
		if tree.autoplace and tree.minable and tree.minable.result then
			free[tree.minable.result] = true
		end
	end
	for _, fish in pairs(data.raw["fish"]) do
		if fish.autoplace and fish.minable and fish.minable.result then
			free[fish.minable.result] = true
		end
	end
	local cachedFree = table.deepcopy(free)  -- Cache list in case we encounter transmutation degeneracy
	
	for name, boiler in pairs(data.raw["boiler"]) do
		if boiler.fluid_box.filter and boiler.output_fluid_box.filter then
			availableRecipes["dummy-recipe-boiler-"..name] = {ingredient = {[boiler.fluid_box.filter] = 1}, result = {[boiler.output_fluid_box.filter] = 1}}
			fakeRecipes["dummy-recipe-boiler-"..name] = true
		end
	end
	for recipeName in pairs(availableRecipes) do
		local ingredientList = normalIngredients(recipeName)
		local resultList     = normalResults(recipeName)
		availableRecipes[recipeName] = {ingredient = ingredientList, result = resultList}
		if next(ingredientList) == nil then
			for result in pairs(resultList) do
				if not free[result] then
					free[result] = true
					if debugText then log(result.." is free because there are no ingredients for "..recipeName) end
					fromThinAir[result] = recipeName
				end
			end
		else
			for ingredient in pairs(ingredientList) do
				if resultList[ingredient] then catalyst[recipeName] = true end -- Keep track of enrichment/catalyst recipes
				ingredientIndex[ingredient] = ingredientIndex[ingredient] or {}
				ingredientIndex[ingredient][recipeName] = true
			end
		end
	end
	local newFreeItems = table.deepcopy(free)
	local countFreeLoops = 0
	while next(newFreeItems) do
		countFreeLoops = countFreeLoops + 1
		if debugText then log("On loop#"..countFreeLoops.." there were "..listLength(newFreeItems).." new free items") end
		local nextLoopFreeItems = {}
		for freeItem in pairs(newFreeItems) do
			for recipeName in pairs(ingredientIndex[freeItem] or {}) do
				local actuallyFree = true
				for ingredient in pairs(normalIngredients(recipeName)) do
					if not free[ingredient] then
						actuallyFree = false
						break
					end
				end
				if actuallyFree then
					for result in pairs(normalResults(recipeName)) do
						if free[result] == nil then
							free[result] = true
							nextLoopFreeItems[result] = true
							if debugText then log(result.." is free via "..recipeName.." since "..freeItem.." is free") end
						end
					end
				end
			end
		end
		newFreeItems = nextLoopFreeItems
	end
	-- Setup for depth calculations
	local basicMaterials = table.deepcopy(rawResources)
	local checkedRockets = false
	local checkedTranmutation = true
	local freeResources = 0
	local freeScience = false
	for material in pairs(rawResources) do
		ingredientDepth[material] = 0 -- idk if resources should be 1 and only free should be 0?
		if free[material] then
			freeResources = freeResources + 1
			log("^^^ You have a free resource: "..material)
		end
	end
	for pack in pairs(tibComboPacks) do
		if free[pack] then
			log(pack.." was marked as free, need to recalculate free items")
			freeScience = true
		end
	end
	if freeScience or (freeResources > (listLength(rawResources) - 1) * 0.6) then  --Excluding tib
		log(freeResources.."/"..listLength(rawResources).." resources are free, other transmutation mod suspected")
		checkedTransmutation = false
		free = table.deepcopy(cachedFree)
		for item in pairs(cachedFree) do  -- Include in first level of recipe tree building, since we no longer have free tree
			basicMaterials[item] = true
		end
	end
	for item, bool in pairs(free) do
		if bool then ingredientDepth[item] = 0 end
	end
	-- Now iteratively build up recipes starting from raw resources
	while next(basicMaterials) do
		local nextMaterials = {}
		for material in pairs(basicMaterials) do
			for recipeName in pairs(ingredientIndex[material] or {}) do
				if not recipeDepth[recipeName] then  --I could nest this deeper but it seems simpler to have at the top
					-- Something with storing a complexity for the recipe, maybe move scoring to here from findRecipe?
					-- Nah leave it in findRecipe so it can account for other active ingredients
					local maxIngredientLevel = 0
					for ingredient in pairs(normalIngredients(recipeName)) do
						if not ingredientDepth[ingredient] then
							maxIngredientLevel = false
							break
						elseif ingredientDepth[ingredient] > maxIngredientLevel then
							maxIngredientLevel = ingredientDepth[ingredient]
						end
					end
					
					if maxIngredientLevel then
						recipeDepth[recipeName] = maxIngredientLevel + 1
						for result in pairs(normalResults(recipeName)) do
							if not resultIndex[result] then resultIndex[result] = {} end
							resultIndex[result][recipeName] = true
							if not ingredientDepth[result] then 
								ingredientDepth[result] = maxIngredientLevel + 1
								nextMaterials[result] = true --And then add new results to nextMaterials
								if data.raw.item[result] then
									local burntResult = data.raw.item[result].burnt_result
									if burntResult then -- Fake recipe for burning fuel
										local fakeRecipeName = "dummy-recipe-burning-"..result
										fakeRecipes[fakeRecipeName] = true
										availableRecipes[fakeRecipeName] = {ingredient = {[result] = 1}, result = {[burntResult] = 1}}
										if not resultIndex[burntResult] then resultIndex[burntResult] = {} end
										resultIndex[burntResult][fakeRecipeName] = true
										if not ingredientDepth[burntResult] then
											ingredientDepth[burntResult] = maxIngredientLevel + 2
											nextMaterials[burntResult] = true
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if not next(nextMaterials) and not checkedRockets then
			checkedRockets = true
			for satellite, satelliteData in pairs(data.raw.item) do
				if satelliteData.rocket_launch_product then
					local partName = next(normalResults(data.raw["rocket-silo"]["rocket-silo"].fixed_recipe))
					local numParts = data.raw["rocket-silo"]["rocket-silo"].rocket_parts_required or 1
					local depth = math.max(ingredientDepth[satellite] or 999, ingredientDepth[partName] or 999)
					local launchProduct = satelliteData.rocket_launch_product[1] or satelliteData.rocket_launch_product.name
					local launchAmount  = satelliteData.rocket_launch_product[2] or satelliteData.rocket_launch_product.amount
					if launchProduct then  -- Fake recipe for rockets
						local fakeRecipeName = "dummy-recipe-launching-"..satellite
						ingredientDepth[launchProduct] = depth + 1
						recipeDepth[fakeRecipeName] = depth + 1
						nextMaterials[launchProduct] = true
						fakeRecipes[fakeRecipeName] = true
						availableRecipes[fakeRecipeName] = {ingredient = {[satellite] = 1, [partName] = numParts}, result = {[launchProduct] = launchAmount}}
						if not resultIndex[launchProduct] then resultIndex[launchProduct] = {} end
						resultIndex[launchProduct][fakeRecipeName] = true
					end
				end
			end
		elseif not next(nextMaterials) and not checkedTransmutation then
			checkedTransmutation = true
			for item in pairs(fromThinAir) do  -- Repopulate with items that have no normal recipes
				if not resultIndex[item] and not rawResources[item] then
					free[item] = true
					ingredientDepth[item] = 0
					nextMaterials[item] = true
				end
			end
		end
		basicMaterials = nextMaterials
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
					penalty = penalty + 1000000  -- Avoid recipes that don't reduce overall complexity
				end
				penalty = penalty + 10 * recipeDepth[recipeName]
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

function hybridSolve(targetList)
	local recipesUsed = {}
	local intermediates = {}
	local initialSolve = table.deepcopy(targetList)
	breadthFirst(initialSolve, recipesUsed, intermediates) --Already removes frees
	local excess = false
	local rawList = {}
	
	--log("target:"..serpent.block(targetList))
	log("initial solve:"..serpent.block(initialSolve))
	--Look for ways to use excess ingredients productively
	for item, amount in pairs(initialSolve) do
		if amount < 0 then
			excess = true
			for recipeName in pairs(ingredientIndex[item]) do
				for result in pairs(normalResults(recipeName)) do
					if intermediates[result] or targetList[result] then
						recipesUsed[recipeName] = 0
					end
				end
			end
		end
	end
	if not excess then
		return initialSolve  -- 4Head? The alternative is the super intense method that spins
	end
	for recipeName in pairs(recipesUsed) do
		for ingredient in pairs(availableRecipes[recipeName]["ingredient"]) do
			if rawResources[ingredient] and not free[ingredient] then
				rawList[ingredient] = 0
			elseif not rawResources[ingredient] and not targetList[ingredient] and not intermediates[ingredient] then
				intermediates[ingredient] = true
			end
		end
	end
	
	-- Determine row order
	local resourceOrderList = {}
	local rows = 1  -- Objective function row plus 1 row per item
	for item in pairs(rawList) do
		if not targetList[item] then
			rows = rows + 1
			resourceOrderList[item] = rows
		end
	end
	for item in pairs(intermediates) do
		if not targetList[item] then
			rows = rows + 1
			resourceOrderList[item] = rows
		end
	end
	for item in pairs(targetList) do
		rows = rows + 1
		resourceOrderList[item] = rows
	end
	--log("Rows: "..rows)
	local recipeOrderList = {}
	local matrix = matrixZeroes(rows, 1)
	matrix[1][1] = 1
	--Build A and -c
	for recipe in pairs(recipesUsed) do
		local recipeMatrix = matrixZeroes(rows, 1)
		for ingredient, amount in pairs(availableRecipes[recipe]["ingredient"]) do
			if not free[ingredient] then
				local row = resourceOrderList[ingredient]
				if row then
					recipeMatrix[row][1] = recipeMatrix[row][1] + amount  -- A
					if rawList[ingredient] then
						recipeMatrix[1][1] = recipeMatrix[1][1] + amount  -- -c
					end
				else log("extraneous ingredient "..ingredient.." for recipe "..recipe)
				end
			end
		end
		for result, amount in pairs(availableRecipes[recipe]["result"]) do
			if not free[result] then
				local row = resourceOrderList[result]
				if row then  -- For now, ignoring byproducts not used by other recipes
					recipeMatrix[row][1] = recipeMatrix[row][1] - amount  -- A
					if rawList[result] then
						local fluidMultiplier = data.raw.fluid[result] and 0.25 or 1  -- Reflect that liquids are cheaper
						recipeMatrix[1][1] = recipeMatrix[1][1] - (amount * fluidMultiplier)  -- -c
					end
				end
			end
		end
		matrixHorzAppend(matrix, recipeMatrix)
		recipeOrderList[recipe] = #matrix[1] --Store which column each recipe is in?
	end
	for item in pairs(rawList) do
		local row = resourceOrderList[item]
		matrixScaleRow(matrix, row, -1)  -- Flipping inequality so slack variables are consistent
	end
	
	local slackMatrix = matrixZeroes(1, rows - 1)
	matrixVertAppend(slackMatrix, matrixIdentity(rows - 1))
	matrixHorzAppend(matrix, slackMatrix)
	
	local bMatrix = matrixZeroes(rows, 1)
	for item, amount in pairs(targetList) do
		local row = resourceOrderList[item]
		bMatrix[row][1] = -1 * amount
	end
	matrixHorzAppend(matrix, bMatrix)
	
	-- Standard matrix done, now make it canonical so we can start pivoting
	-- Make b non-negative
	local nonIdentityRows = {}
	for i = 2, #matrix do
		if matrix[i][#matrix[1]] < 0 then
			matrixScaleRow(matrix, i, -1)
			table.insert(nonIdentityRows, i)  -- I don't trust using numeric keys to iterate correctly
		end
	end
	
	-- local bVector = {}
	-- for i = 1, #matrix do
		-- bVector[i] = matrix[i][#matrix[1]]
	-- end
	--log("B vector before: "..serpent.block(bVector))
	local pivotsToFeasible = 0
	while next(nonIdentityRows) do  -- Is this going to infinite loop?
		for _, i in pairs(nonIdentityRows) do
			--log("Trying to fix missing identity on row "..i)
			for j = 1, #matrix[1] - 1 do
				if matrix[i][j] > 0.00000001 then
					--log("Successfully found pivot on "..i..", "..j.." with value of "..matrix[i][j])
					matrixDoPivot2(matrix, i, j)
					pivotsToFeasible = pivotsToFeasible + 1
					if matrix[i][j] ~= 1 then log("*** Precision error, lua stahp") end
					break
				end
			end
		end
		if matrix[1][#matrix[1]] ~= matrix[1][#matrix[1]] then log("&&& We fucked up the objective at this point") end
		nonIdentityRows = {}
		for i = 2, #matrix do
			if matrix[i][#matrix[1]] < 0 then
				matrixScaleRow(matrix, i, -1)
				table.insert(nonIdentityRows, i)
			end
		end
	end
	log("Took "..pivotsToFeasible.." pivots to reach a feasible solution")
	log("Initial score: "..matrix[1][#matrix[1]])
	--log("Available recipes: "..serpent.block(recipesUsed))
	--log("Resource order list: "..serpent.block(resourceOrderList))
	--log("Current matrix: "..serpent.block(matrix))
	--Now we pivot simplex
	pivotSimplex(matrix)
	log("Final score: "..matrix[1][#matrix[1]])
	--log("Final matrix: "..serpent.block(matrix))
	
	local finalSolve = {}
	for row = 2, #matrix do
		for col = 2, #matrix[1] - 1 do
			if matrix[row][col] == 1 then
				local inSolution = true
				for i = 1, #matrix do
					if i ~= row and matrix[i][col] ~= 0 then
						inSolution = false
						break
					end
				end
				if inSolution then
					--take row# look up items and add to final solve
					for item, rowNum in pairs(resourceOrderList) do
						if rowNum == row then
							if rawResources[item] then
								finalSolve[item] = matrix[row][#matrix[1]]
							-- elseif not targetList[item] then
								-- finalSolve[item] = -1 * matrix[row][#matrix[1]]
							end
							break
						end
					end
					break -- found identity for this row, go to next
				end
			end
		end
	end
	log("final solve:"..serpent.block(finalSolve))
	return finalSolve
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
	local result = recipe.normal and recipe.normal.result or recipe.result
	if result then
		resultAmount = recipe.normal and recipe.normal.result_count or recipe.result_count or 1
		return {[result] = resultAmount}
	end
	local results = recipe.normal and recipe.normal.results or recipe.results
	if not results then
		log("#######Could not find results for "..recipeName)
		return {}
	end
	local resultTable = {}
	for _, result in pairs(results) do
		if result[1] then
			resultTable[result[1]] = result[2]
		elseif result.name then
			resultTable[result.name] = (result.amount or (result.amount_min + math.max(result.amount_min, result.amount_max)) / 2) * (result.probability or 1)
		end
	end
	return resultTable
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

function pivotSimplex(matrix)
	local pivotRow, pivotColumn = matrixFindPivot(matrix)
	local pivotNumber = 0
	while (pivotRow and pivotColumn) do
		pivotNumber = pivotNumber + 1
		log("Pivot #"..pivotNumber.." on "..pivotRow..", "..pivotColumn.." with objective function "..matrix[1][#matrix[1]])
		matrixDoPivot2(matrix, pivotRow, pivotColumn)
		pivotRow, pivotColumn = matrixFindPivot(matrix)
	end
	log("Took "..pivotNumber.." pivots to optimize")
end

function matrixScaleRow(matrix, row, scalar)
	for i = 1, #matrix[row] do
		matrix[row][i] = matrix[row][i] * scalar
	end
end

function matrixFindPivot(matrix)
	local bestRatio, pivotRow, pivotColumn
	for j = 1, #matrix[1] - 1 do  -- Can't pivot on last column (b)
		if matrix[1][j] < 0 then
			for i = 2, #matrix do
				if matrix[i][j] > 0 then
					if not bestRatio or matrix[i][#matrix[i]] / matrix[i][j] < bestRatio then
						bestRatio   = matrix[i][#matrix[i]] / matrix[i][j]
						pivotRow    = i
						pivotColumn = j
					end
				end
			end
		end
	end
	--log("Looked for pivot and found "..tostring(pivotRow)..", "..tostring(pivotColumn).." with a ratio of "..tostring(bestRatio))
	return pivotRow, pivotColumn
end

function matrixDoPivot2(matrix, row, column) -- All in one function to avoid float issues
	if matrix[row][column] == 0 then return end
	matrixScaleRow(matrix, row, 1 / matrix[row][column])
	for i = 1, #matrix do
		if i ~= row then
			for j = 1, #matrix[i] do
				if j ~= column then
					matrix[i][j] = matrix[i][j] - (matrix[row][j] * matrix[i][column] / matrix[row][column])
				end
			end
			-- Do pivot column last because we need it for determining ratios for other columns
			matrix[i][column] = 0
		end
	end
	--Scale pivot row at the end, I guess we could also do it at the start
	for j = 1, #matrix[row] do
		if j ~= column then
			matrix[row][j] = matrix[row][j] / matrix[row][column]
		end
	end
	matrix[row][column] = 1
end

function matrixHorzAppend(matrix, append)
	if #matrix ~= #append then  -- Row #s must match
		log("Won't horz combine matrices with different sizes "..#matrix..", "..#append)
		return
	end
	
	local cols = #matrix[1]
	for i = 1, #matrix do
		for j = 1, #append[1] do
			matrix[i][cols + j] = append[i][j]
		end
	end
end

function matrixVertAppend(matrix, append)
	if #matrix[1] ~= #append[1] then  -- Col #s must match
		log("Won't vert combine matrices with different sizes "..#matrix[1]..", "..#append[1])
		return
	end
	
	local rows = #matrix
	for i = 1, #append do
		matrix[rows + i] = append[i]
	end
end

-- Returns nxn identity matrix
function matrixIdentity(n)
	local matrix = {}
	if type(n) == "number" then
		for i = 1, n do
			matrix[i] = {}
			for j = 1, n do
				if i == j then
					matrix[i][j] = 1
				else
					matrix[i][j] = 0
				end
			end
		end
	else
		log("Invalid identity call with "..tostring(n))
	end
	return matrix
end

-- Returns a rowsxcols matrix of zeroes
function matrixZeroes(rows, cols)
	local matrix = {}
	for i = 1, rows do
		matrix[i] = {}
		for j = 1, cols do
			matrix[i][j] = 0
		end
	end
	return matrix
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
	local material = (tier == 1) and "ore" or (tier == 2) and "slurry" or "molten"
	local item = (tier == 1) and "tiberium-ore" or (tier == 2) and "tiberium-slurry" or "molten-tiberium"
	local ingredientAmount = (tier ~= 1) and math.max(160 / settings.startup["tiberium-value"].value, 1) or 16
	local targetAmount = (tier == 1) and 32 or (tier == 2) and 64 or 128
	local totalOre = 0
	-- Total all resources for the tier
	for pack in pairs(science[tier]) do
		sumDicts(resources, allPacks[pack])
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
	LSlib.recipe.editEngergyRequired("tiberium-"..material.."-centrifuging", recipeMult)
	LSlib.recipe.addIngredient("tiberium-"..material.."-centrifuging", item, ingredientAmount * recipeMult, (tier > 1) and "fluid" or "item")
	if debugText then log("Tier "..tier.." centrifuge: "..ingredientAmount * recipeMult.." "..item) end
	for resource, amount in pairs(resources) do
		if (resource ~= "stone") and (amount > 1 / 128) then
			local rounded = math.ceil(amount * recipeMult)
			LSlib.recipe.addResult("tiberium-"..material.."-centrifuging", resource, rounded, fluids[resource] and "fluid" or "item")
			if debugText then log("> "..rounded.." "..resource) end
		end
	end
	if resources["stone"] and (listLength(fluids) < 3) then
		local stone = math.ceil(resources["stone"] * recipeMult)
		LSlib.recipe.duplicate("tiberium-"..material.."-centrifuging", "tiberium-"..material.."-sludge-centrifuging")
		LSlib.recipe.changeIcon("tiberium-"..material.."-sludge-centrifuging", tiberiumInternalName.."/graphics/icons/"..material.."-sludge-centrifuging.png", 32)
		LSlib.recipe.addResult("tiberium-"..material.."-sludge-centrifuging", "tiberium-sludge", stone, "fluid")
		LSlib.recipe.addResult("tiberium-"..material.."-centrifuging", "stone", stone, "item")
		if debugText then log("> "..stone.." stone") end
	else  -- Don't create sludge recipe if there is no stone to convert or we don't have enough fluid boxes
		--data.raw["recipe"]["tiberium-"..material.."-sludge-centrifuging"] = nil  Don't delete recipe, just make it unavailable
		local tech = (tier == 1) and "tiberium-separation-tech" or (tier == 2) and "tiberium-processing-tech" or "tiberium-molten-processing"
		for i, effect in pairs(data.raw["technology"][tech]["effects"]) do
			if effect.recipe == "tiberium-"..material.."-sludge-centrifuging" then
				table.remove(data.raw["technology"][tech]["effects"], i)
				break
			end
		end
		if resources["stone"] then
			local stone = math.ceil(resources["stone"] * recipeMult)
			LSlib.recipe.addResult("tiberium-"..material.."-centrifuging", "stone", stone, "item")
			if debugText then log("> "..stone.." stone") end
		end
	end
end

function singletonRecipes()
	for resourceName, resourceData in pairs(data.raw.resource) do
		if resourceData.autoplace and resourceData.minable then
			local minableResults = {}
			if resourceData.minable.result then
				minableResults[resourceData.minable.result] = true
			elseif resourceData.minable.results then --For fluids/multiple results
				for _, result in pairs(resourceData.minable.results) do
					if result.name then
						minableResults[result.name] = true
						if (result.type == "fluid") and not oreMult[result.name] then
							oreMult[result.name] = 4
						end
					end
				end
			end
			for ore in pairs(minableResults) do
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
	local tech = data.raw.fluid[ore] and "tiberium-molten-processing" or "tiberium-transmutation-tech"
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

	LSlib.recipe.create(recipeName)
	LSlib.recipe.addIngredient(recipeName, ore, oreAmount, itemOrFluid)
	LSlib.technology.addRecipeUnlock("tiberium-growth-acceleration", recipeName)
	LSlib.recipe.setEngergyRequired(recipeName, energy)
	LSlib.recipe.setOrderstring(recipeName, order)
	if (ore == "coal") or (ore == "copper-ore") or (ore == "iron-ore") or (ore == "stone") or (ore == "crude-oil") or (ore == "uranium-ore") then
		LSlib.recipe.changeIcon(recipeName, tiberiumInternalName.."/graphics/icons/growth-credit-"..ore..".png", 32)
	end
	LSlib.recipe.addResult(recipeName, "growth-credit", 1, "item")
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
