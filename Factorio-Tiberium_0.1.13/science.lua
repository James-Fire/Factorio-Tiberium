
--TODO:
--Support custom science packs (programmatically assign packs to each fuge tier)
--Support enrichment/catalyst recipes?
--Support for generic boilers?
--Recipe selection to consider other products and look for multiple matches?

--Set these manually
local free = {["water"] = true, ["wood"] = true, ["steam"] = true}
local excludedCrafting = {["barreling-pump"] = true} --Rigorous way to do this?
--Debugging for findRecipe
local unreachable = {}
local multipleRecipes = {}
--Caching used by depthFirst
--local recipeTable = {}
--local cachedBreakdown = {}

--Defined by giantSetupFunction
local availableRecipes = {}
local fakeRecipes = {}
local rawResources = {}
local ingredientIndex = {}
local recipeDepth = {}
local ingredientDepth = {}
local catalyst = {}
local resultIndex = {}

local science1, science2, science3 = {}, {}, {}
local tibComboPacks = {}

-- Assumes: excludedCrafting
-- Modifies: rawResources, availableRecipes, free, ingredientIndex, resultIndex, catalyst, ingredientDepth, recipeDepth
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
	-- Compile list of available recipes
	for recipe, recipeData in pairs(data.raw.recipe) do
		if recipeData.enabled ~= false then  --Defaults to true, so only disabled if false
			availableRecipes[recipe] = true
		end
	end
	for tech, techData in pairs(data.raw.technology) do
		for _, effect in pairs(techData.effects or {}) do
			if effect.recipe then
				availableRecipes[effect.recipe] = true
			end
		end
		-- Also store data for centrifuge tiers
		if techData.max_level and techData.max_level == "infinite" then
			addPacksToTier(techData.unit.ingredients, science3)
		elseif (tech == "rocket-silo") or (tech == "space-science-pack") then
			addPacksToTier(techData.unit.ingredients, science2)
		end
		if string.sub(tech, 1, 9) == "tiberium-" then
			addPacksToTier(techData.unit.ingredients, tibComboPacks)
		end
	end
	for recipeName in pairs(availableRecipes) do
		local recipe = data.raw.recipe[recipeName]
		if excludedCrafting[recipe.category] then
			availableRecipes[recipeName] = nil
		elseif recipe.subgroup and (string.find(recipe.subgroup, "empty%-barrel") or string.find(recipe.subgroup, "barrel%-empty")) then -- Hope other mods have good naming
			availableRecipes[recipeName] = nil
		elseif string.find(recipeName, "tiberium") or string.find(recipeName, "coal%-liquefaction") then  -- Want non-tib recipes only for fuge stuff
			availableRecipes[recipeName] = nil
		end
	end
	-- Build a more comprehensive list of free items and ingredient index for later
	for _, pump in pairs(data.raw["offshore-pump"]) do
		if pump.fluid then free[pump.fluid] = true end
	end
	for recipeName in pairs(availableRecipes) do
		local ingredientList = normalIngredients(recipeName)
		local resultList     = normalResults(recipeName)
		availableRecipes[recipeName] = {ingredient = ingredientList, result = resultList}
		if next(ingredientList) == nil then
			for result in pairs(resultList) do
				if not free[result] then
					free[result] = true
					--log(result.." is free because there are no ingredients for "..recipeName)
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
		--log("On loop#"..countFreeLoops.." there were "..listLength(newFreeItems).." new free items")
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
						if not free[result] then
							free[result] = true
							nextLoopFreeItems[result] = true
							--log(result.." is free via "..recipeName.." since "..freeItem.." is free")
						end
					end
				end
			end
		end
		newFreeItems = nextLoopFreeItems
	end
	-- Setup for depth calculations
	for item in pairs(free) do
		ingredientDepth[item] = 0
	end
	for material in pairs(rawResources) do -- Sanity check
		ingredientDepth[material] = 0 -- But not free, idk if that means they should be 1 and free should be 0?
		if free[material] then log("^^^ You have a free resource: "..material) end
	end
	-- Now iteratively build up recipes starting from raw resources
	local basicMaterials = table.deepcopy(rawResources)
	local checkedRockets = false
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
										fakeRecipes["dummy-recipe-burning-"..result] = true
										availableRecipes["dummy-recipe-burning-"..result] = {ingredient = {[result] = 1},
																							 result = {[burntResult] = 1}}
										if not resultIndex[burntResult] then resultIndex[burntResult] = {} end
										resultIndex[burntResult]["dummy-recipe-burning-"..result] = true
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
					local depth = math.max(ingredientDepth[satellite] or 99, ingredientDepth[partName] or 99)
					local launchProduct = satelliteData.rocket_launch_product[1] or satelliteData.rocket_launch_product.name
					local launchAmount  = satelliteData.rocket_launch_product[2] or satelliteData.rocket_launch_product.amount
					if launchProduct then  -- Fake recipe for rockets
						ingredientDepth[launchProduct] = depth + 1
						nextMaterials[launchProduct] = true
						fakeRecipes["dummy-recipe-launching-"..satellite] = true
						availableRecipes["dummy-recipe-launching-"..satellite] = {ingredient = {[satellite] = 1, [partName] = numParts},
																				  result = {[launchProduct] = launchAmount}}
						if not resultIndex[launchProduct] then resultIndex[launchProduct] = {} end
						resultIndex[launchProduct]["dummy-recipe-launching-"..satellite] = true
					end
				end
			end
		end
		basicMaterials = nextMaterials
	end
end


--[[function depthFirst(item, itemCount, depth, parentRecipe)
-- Assumes: rawResources, free
-- Modifies: cachedBreakdown, recipeTable
	-- itemCount = itemCount or 1
	-- depth = depth or 1
	-- log(string.rep("  ", depth - 1)..itemCount.." "..item)
	
	-- --Stopping conditions
	-- if free[item] then
		-- --log("}")
		-- return {}
	-- end
	-- if rawResources[item] then 
		-- --log("}")
		-- return {[item] = itemCount}
	-- end
	-- if depth > 20 then
		-- log("!!!Hit maximum depth, check that recipes aren't looping")
		-- return {[item] = itemCount}
	-- end
	-- --Check cache
	-- if cachedBreakdown[item] then
		-- --log("}")
		-- return makeScaledList(cachedBreakdown[item], itemCount)
	-- end
	-- --Find recipes
	-- local recipeName, recipeCount, rocketLaunch
	-- if not recipeTable[item] then  --Table for caching recipes
		-- recipeName, recipeCount, rocketLaunch = findRecipe(item)
		-- recipeTable[item] = {name = recipeName, count = recipeCount, rocket = rocketLaunch}
	-- else
		-- recipeName   = recipeTable[item].name
		-- recipeCount  = recipeTable[item].count
		-- rocketLaunch = recipeTable[item].rocket
	-- end
	-- recipeCount = recipeCount or 1
	
	-- if not recipeName then
		-- log("Couldn't find a recipe for "..item)
		-- --log("}")
		-- return {[item] = itemCount}
	-- elseif recipeName == parentRecipe then --Don't use same recipe as the one we're refunding
		-- --log("}")
		-- return {[item] = itemCount}
	-- end
	
	-- --Recurse through ingredients
	-- local sumIngredients = {}
	-- for ingredient, ingredientAmount in pairs(normalIngredients(recipeName)) do
		-- local ingredientParts = depthFirst(ingredient, ingredientAmount / recipeCount, depth + 1)
		-- sumDicts(sumIngredients, ingredientParts)
		-- if next(ingredientParts) == nil then free[ingredient] = true end
	-- end
	-- if rocketLaunch then
		-- local numParts = data.raw["rocket-silo"]["rocket-silo"].rocket_parts_required or 1
		-- local ingredientParts = depthFirst(rocketLaunch, 1 / (recipeCount * numParts), depth + 1)
		-- sumDicts(sumIngredients, ingredientParts)
	-- elseif next(sumIngredients) ~= nil then  --If recipe isn't free, we need to discount the other results
		-- for result, resultAmount in pairs(normalResults(recipeName)) do
			-- if result ~= item then
				-- local resultParts = depthFirst(result, -1 * resultAmount / recipeCount, depth + 1, recipeName)
				-- sumDicts(sumIngredients, resultParts)
				-- if next(resultParts) == nil then free[result] = true end
			-- end
		-- end
	-- end
	-- cachedBreakdown[item] = sumIngredients
	-- --log("}")
	-- return makeScaledList(sumIngredients, itemCount)
-- end]]

-- Assumes: free, recipeDepth
-- Modifies: unreachable, multipleRecipes
function findRecipe(item, itemList)
	local recipes = {}
	for recipeName in pairs(availableRecipes) do
		local resultList = normalResults(recipeName)
		if resultList[item] then
			-- Score the recipes so we can choose the best
			local score = 0
			local ingredientList = normalIngredients(recipeName)
			for ingredient in pairs(ingredientList) do
				if (ingredient ~= item) and not free[ingredient] then
					-- Less bad if it uses something we already have extra of?
					if itemList and itemList[ingredient] and itemList[ingredient] > 0 then
						score = score - 12
					else
						score = score + 10
					end
				end
			end
			if score > 0 then -- Only penalize byproducts if recipe isn't free
				for result in pairs(resultList) do
					if (result ~= item) and not free[result] then
						if itemList and itemList[result] and itemList[result] > 0 then  -- Bonus if other output is useful
							score = score - 20
						else
							score = score - 5  -- Penalize or reward excess products?
						end
					end
				end
			end
			if recipeDepth[recipeName] then
				score = score + 10 * recipeDepth[recipeName]
				table.insert(recipes, {name=recipeName, count=resultList[item], score=score})
			else  -- If it isn't reachable, don't use it.  Since we won't be able to break it down
				table.insert(unreachable, recipeName)
			end
		end
	end

	--Fall back to rocket silo recipes if needed (just space science in vanilla)
	if #recipes == 0 and not data.raw.fluid[item] then
		for satellite, satelliteData in pairs(data.raw.item) do
			if satelliteData.rocket_launch_product and ((satelliteData.rocket_launch_product[1] or satelliteData.rocket_launch_product.name) == item) then
				local recipeName = "dummy-recipe-launching-"..satellite
				local recipeCount = availableRecipes[recipeName]["result"][item]
				return recipeName, recipeCount
			elseif satelliteData.burnt_result == item then -- Mainly for fuel cell shennanigans
				local recipeName = "dummy-recipe-burning-"..satellite
				return recipeName, 1
			end
		end
	end
	
	if #recipes > 1 then
		-- Name as tiebreaker because otherwise it's not deterministic >.<
		table.sort(recipes, function(a,b) return (a.score == b.score) and (a.name < b.name) or (a.score < b.score) end)
		--log("Found "..#recipes.." recipes for "..item..". Defaulting to "..recipes[1]["name"])
		local recipeNames = {}
		for i = 1, #recipes do
			table.insert(recipeNames, {recipes[i].name, recipes[i].score})
		end
		multipleRecipes[item] = recipeNames
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
			resultTable[result.name] = (result.amount or (result.amount_min + result.amount_max) / 2) * (result.probability or 1)
		end
	end
	return resultTable
end

function listLength(list)
	local count = 0
	for _ in pairs(list) do count = count + 1 end
	return count
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function addPacksToTier(ingredients, collection)
	for _, pack in pairs(ingredients or {}) do
		if not collection[pack[1]] and (pack[1] ~= "tiberium-science") then
			collection[pack[1]] = true
		end
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
	--log("Max depth: "..maxDepth)
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
	end
	local recipeTimes = targetAmount / recipeCount
	--log("Using recipe "..recipeName.." "..recipeTimes.." times")
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

function finalFormatting()
	--try breadthFirst
	--if all entries are positive, call it good enough

	--call inner function
	--strip negatives
	--rounding and liquids
	--something with scaling for large rounding errors
end

function solveRecipeLP(targetList) --Temporarily abandoned
	--Take all recipes for all targets+all intermediates
	local recipeList = {}
	local intermediateList = {}
	local rawList = {}
	local itemList = table.deepcopy(targetList)
	while next(itemList) do
		local nextItemList = {}
		for item in pairs(itemList) do
			if not free[item] then
				--log("Looking at recipes that give "..item)
				for recipe in pairs(resultIndex[item] or {}) do
					if not recipeList[recipe] then
						--log("  Found that "..recipe.." gives "..item)
						recipeList[recipe] = 0
						for ingredient in pairs(availableRecipes[recipe]["ingredient"]) do
							if not free[ingredient] then
								if not rawResources[ingredient] and not intermediateList[ingredient] then
									--log("    Ingredient found: "..ingredient)
									intermediateList[ingredient] = 0
									nextItemList[ingredient] = true
								elseif rawResources[ingredient] and not rawList[ingredient] then
									rawList[ingredient] = 0
								end
							end
						end
					end
				end
			end
		end
		itemList = nextItemList
	end
	log("There are "..listLength(recipeList).." recipes")
	log("There are "..listLength(intermediateList).." intermediates")
	if true then return	end
	-- Determine row order
	local resourceOrderList = {}
	local rows = 1  -- Objective function row plus 1 row per item
	for item in pairs(rawList) do
		if not targetList[item] then
			rows = rows + 1
			resourceOrderList[item] = rows
		end
	end
	for item in pairs(intermediateList) do
		if not targetList[item] then
			rows = rows + 1
			resourceOrderList[item] = rows
		end
	end
	for item in pairs(targetList) do
		rows = rows + 1
		resourceOrderList[item] = rows
	end

	local matrix = matrixZeroes(rows, 1)
	matrix[1][1] = 1
	--Build A and -c
	for recipe in pairs(recipeList) do
		local recipeMatrix = matrixZeroes(rows, 1)
		for ingredient, amount in pairs(availableRecipes[recipe]["ingredient"]) do
			if not free[ingredient] then
				local row = resourceOrderList[ingredient]
				recipeMatrix[row][1] = recipeMatrix[row][1] + amount  -- A
				if rawList[ingredient] then
					recipeMatrix[1][1] = recipeMatrix[1][1] + amount  -- -c
				end
			end
		end
		for result, amount in pairs(availableRecipes[recipe]["result"]) do
			if not free[result] then
				local row = resourceOrderList[result]
				if row then  -- For now, ignoring byproducts not used by other recipes
					recipeMatrix[row][1] = recipeMatrix[row][1] - amount  -- A
					if rawList[result] then
						recipeMatrix[1][1] = recipeMatrix[1][1] - amount  -- -c
					end
				end
			end
		end
		matrixHorzAppend(matrix, recipeMatrix)
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
	
	local bVector = {}
	for i = 1, #matrix do
		bVector[i] = matrix[i][#matrix[1]]
	end
	log("B vector before: "..serpent.block(bVector))
	
	while next(nonIdentityRows) do  -- Is this going to infinite loop?
		for _, i in pairs(nonIdentityRows) do
			log("Trying to fix missing identity on row "..i)
			for j = 1, #matrix[1] - 1 do
				if matrix[i][j] > 0.00000001 then
					-- local pivotConfirmed = true
					-- for row = 2, #matrix do
						-- if (row ~= i) and (matrix[row][j] > 0) then
							-- pivotConfirmed = false
							-- break
						-- end
					-- end
					-- if pivotConfirmed then  -- Idk what my plan is if these conditions aren't met
						log("Successfully found pivot on "..i..", "..j.." with value of "..matrix[i][j])
						matrixDoPivot2(matrix, i, j)
						if matrix[i][j] ~= 1 then log("*** Precision error, lua stahp") end
						break
					--end
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
	--detect if already canon
	--choose pivot that moves us towards feasible solution
	-- local identityMapping = {}
	-- while (not matrixIsCanonical(matrix, identityMapping)) do
		-- for i = 1, #matrix do
			-- if not identityMapping[i] then
				
	
	-- end

	
	log("Relevant recipes: "..serpent.block(recipeList))
	log("Intermediates: "..serpent.block(intermediateList))
	log("Raw: "..serpent.block(rawList))
	
	local bVector = {}
	for i = 1, #matrix do
		bVector[i] = matrix[i][#matrix[1]]
	end
	log("B vector after: "..serpent.block(bVector))
	
	-- local i, j = matrixFindPivot(matrix)
	-- log("Pivot on "..tostring(i)..", "..tostring(j))
	--convert recipes to matrix (no free items in matrix)
	--[[1 -c 0]
	-- [0  A b]] --Building standard form matrix from recipes
	--positive slack for intermediates (<=0) negative slack for targets (>=target amount)
	--objective function is to minimize resources
	
	--simplex: convert to canonical
	--  pivot if valid pivot exists
	--pivotSimplex(matrix)
	--log("Matrix "..serpent.block(matrix))
	--  take end solution and convert back to something usable
end

function hybridSolve(targetList)
	local recipesUsed = {}
	local intermediates = {}
	local initialSolve = table.deepcopy(targetList)
	breadthFirst(initialSolve, recipesUsed, intermediates) --Already removes frees
	local excess = false
	local rawList = {}
	
	--log("target:"..serpent.block(targetList))
	--log("initial solve:"..serpent.block(initialSolve))
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
						recipeMatrix[1][1] = recipeMatrix[1][1] - amount  -- -c
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
	--log("Took "..pivotsToFeasible.." pivots to reach a feasible solution, there's got to be a better way!")
	--log("Initial score: "..matrix[1][#matrix[1]])
	--log("Available recipes: "..serpent.block(recipesUsed))
	--log("Resource order list: "..serpent.block(resourceOrderList))
	--log("Current matrix: "..serpent.block(matrix))
	--Now we pivot simplex
	pivotSimplex(matrix)
	--log("Final score: "..matrix[1][#matrix[1]])
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
	return finalSolve
end

function matrixIsCanonical(matrix, identityMapping) --unused
	--the i-th element of identity mapping will give the column that only contains 1 on i-th row
	identityMapping = {}  --wipe out on purpose?
	for row = 1, #matrix do
		for col = 1, #matrix[1] - 1 do  -- Don't include b column
			if matrix[row][col] == 1 then
				local identity = true
				for i = 1, #matrix do
					if (i ~= row) and (matrix[i][col] ~= 0) then
						identity = false
						break
					end
				end
				if identity then
					identityMapping[row] = col
				end
			end
		end
	end
	for i = 1, #matrix do
		if not identityMapping[i] then
			return false
		end
	end
	return true
end

function pivotSimplex(matrix)
	local pivotRow, pivotColumn = matrixFindPivot(matrix)
	local pivotNumber = 0
	while (pivotRow and pivotColumn) do
		pivotNumber = pivotNumber + 1
		--log("Pivot #"..pivotNumber.." on "..pivotRow..", "..pivotColumn.." with objective function "..matrix[1][#matrix[1]])
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

function matrixAddRow(matrix, target, source, scalar)
	for i = 1, #matrix[target] do
		matrix[target][i] = matrix[target][i] + (matrix[source][i] * scalar)
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

function matrixDoPivot(matrix, row, column)
	if matrix[row][column] == 0 then return end
	matrixScaleRow(matrix, row, 1 / matrix[row][column])
	for i = 1, #matrix do
		if i ~= row then
			matrixAddRow(matrix, i, row, -1 * matrix[i][column])
		end
	end
end

function matrixDoPivot2(matrix, row, column) --Trying handling it all in one function
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

giantSetupFunction()
log("%%% Setup complete beginning recipe parse")

local allPacks = {}
for pack in pairs(tibComboPacks) do
	if not allPacks[pack] then
		allPacks[pack] = hybridSolve({[pack] = 1})
		local tier1 = true
		for ingredient in pairs(allPacks[pack]) do
			if data.raw["fluid"][ingredient] then
				tier1 = false
				break
			end
		end
		if tier1 then
			science1[pack] = true
		end
	end
end

for pack in pairs(science2) do
	if not allPacks[pack] then
		allPacks[pack] = hybridSolve({[pack] = 1})
	end
end
for pack in pairs(science3) do
	if not allPacks[pack] then
		allPacks[pack] = hybridSolve({[pack] = 1})
	end
end

local fuge1, fuge2, fuge3 = {}, {}, {}
for pack in pairs(science1) do
	sumDicts(fuge1, allPacks[pack])
end
for pack in pairs(science2) do
	sumDicts(fuge2, allPacks[pack])
end
for pack in pairs(science3) do
	sumDicts(fuge3, allPacks[pack])
end

log(serpent.block(science1))
log(serpent.block(fuge1))
log(serpent.block(science2))
log(serpent.block(fuge2))
log(serpent.block(science3))
log(serpent.block(fuge3))
log(serpent.block(allPacks))


-- local fuelRecipesUsed = {}
-- local fuelIntermediates = {}
-- log("New fuel: "..serpent.block(breadthFirst({["rocket-fuel"]=1}, fuelRecipesUsed, fuelIntermediates)))
-- log("Fuel intermediates: "..listLength(fuelIntermediates))
-- log("Fuel recipes: "..listLength(fuelRecipesUsed))


-- log("Free recipes: "..serpent.block(free))
-- log("Multiple recipes: "..serpent.block(multipleRecipes))
-- log("Depths: "..serpent.block(ingredientDepth))
-- log("Multiple recipe table: "..serpent.block(multipleRecipes))
-- log("Raw resources: "..serpent.block(rawResources))
