--TODO:
-- Make matrix solver more reliable

local flib_table = require("__flib__.table")
local flib_data_util = require("__flib__.data-util")
local debugText = settings.startup["tiberium-debug-text-startup"].value
local easyMode = settings.startup["tiberium-easy-recipes"].value
local surfaceRestrictTransmute = settings.startup["tiberium-direct-surface-condition"].value
local planetTechs = settings.startup["tiberium-direct-planet-techs"].value
local allowAlienOres = settings.startup["tiberium-centrifuge-alien-ores"].value
local free = {}
local excludedCrafting = {["transport-drone-request"] = true, ["auto-fabricator"] = true} --Rigorous way to do this?

--Debugging for findRecipe
local unreachable = {}
local multipleRecipes = {}

--Defined by giantSetupFunction
local availableRecipes = {}
local fakeRecipes = {}
local rawResources = {}
local resourceExclusions = {}
local tibComboPacks = {}
local techCosts = {}
local catalyst = {}
local ingredientIndex = {}
local resultIndex = {}
local badRecipeCategories = {num = {}, div = {}}
local badRecipeCount = 0
local recipeDepth = {}
local ingredientDepth = {}
local recipeUnlockTracker = {}
local sludgeItems = {}  -- Allow any item to be converted to sludge
local emptyBarrel = {}
local science = {{}, {}, {}}
local allPacks = {}
local oreMult = {}
local resourcePlanets = {}
local surfaces = {
	aquilo = {restrictions = {property = "pressure", min = 300, max = 300}, technology = "cryogenic-science-pack", pack = "cryogenic-science-pack"},
	fulgora = {restrictions = {property = "magnetic-field", min = 99, max = 99}, technology = "electromagnetic-science-pack", pack = "electromagnetic-science-pack"},
	gleba = {restrictions = {property = "pressure", min = 2000, max = 2000}, technology = "agricultural-science-pack", pack = "agricultural-science-pack"},
	vulcanus = {restrictions = {property = "pressure", min = 4000, max = 4000}, technology = "metallurgic-science-pack", pack = "metallurgic-science-pack"},
	nauvis = {restrictions = {property = "pressure", min = 1000, max = 1000}, technology = "utility-science-pack", pack = "utility-science-pack"},
	space = {restrictions = {property = "gravity", min = 0, max = 0}, technology = "space-science-pack", pack = "space-science-pack"},
	tiber = {restrictions = {property = "pressure", min = 900, max = 900}, technology = "tiberium-mechanical-research", pack = "tiberium-science-pack"},
}
for planetName,planetData in pairs(data.raw.planet) do
	if planetData.tiberium_requirements then
		surfaces[planetName] = planetData.tiberium_requirements
	end
end

local function normalIngredients(recipeName)
	if fakeRecipes[recipeName] then
		return availableRecipes[recipeName]["ingredient"]
	end
	return common.recipeIngredientsTable(recipeName)
end

local function normalResults(recipeName)
	if fakeRecipes and fakeRecipes[recipeName] then
		return availableRecipes[recipeName]["result"]
	end
	return common.recipeResultsTable(recipeName)
end

local minableResultsTable = function(prototypeTable)  -- Local version that also checks that the resource has an autoplace
	if type(prototypeTable) ~= "table" or not prototypeTable.autoplace then return {} end
	return common.minableResultsTable(prototypeTable)
end

if mods["space-exploration"] then
	for itemName, item in pairs(data.raw.item) do
		if item.subgroup == "core-fragments" then
			if not item.hidden then
				if debugText then log("Marked "..itemName.." as a raw resource") end
				rawResources[itemName] = true
			end
		end
	end
end

-- Assumes: excludedCrafting
-- Modifies: rawResources, availableRecipes, free, ingredientIndex, resultIndex, catalyst, ingredientDepth, recipeDepth, tibComboPacks
function giantSetupFunction()
	-- Load item properties defined by other mods or from our data-updates
	for itemName, itemData in pairs(data.raw.item) do
		if itemData.tiberium_empty_barrel then
			emptyBarrel[itemName] = true
		end

		if itemData.tiberium_multiplier then
			addOreMult(itemName, itemData.tiberium_multiplier)
		end

		if itemData.tiberium_sludge then
			sludgeItems[itemName] = true
		end
	end
	for fluidName, fluidData in pairs(data.raw.fluid) do
		if fluidData.tiberium_multiplier then
			addOreMult(fluidName, fluidData.tiberium_multiplier)
		end
		addOreMult(fluidName, 1/4)  -- Default fluid amounts to being 4 times more than ores

		if fluidData.tiberium_sludge then
			sludgeItems[fluidName] = true
		end
	end

	-- Resources excluded by settings
	local excludeSetting = string.gsub(settings.startup["tiberium-resource-exclusions"].value, "\"", "")
	if excludeSetting then
		local delim = ","
		for item in string.gmatch(excludeSetting, "[^"..delim.."]+") do  -- Loop over comma-delimited substrings
			resourceExclusions[item] = true
		end
	end
	for fluid, prototype in pairs(data.raw.fluid) do
		if prototype.tiberium_resource_exclusion then
			resourceExclusions[fluid] = true
		end
	end
	for item, prototype in pairs(data.raw.item) do
		if prototype.tiberium_resource_exclusion then
			resourceExclusions[item] = true
		end
	end
	-- Resources included by settings
	for _, prototypeList in pairs({data.raw.item, data.raw.fluid}) do
		for name, prototype in pairs(prototypeList) do
			if prototype.tiberium_resource_planet and not resourceExclusions[name] then
				if allowAlienOres or prototype.tiberium_resource_planet == "nauvis" then
					rawResources[name] = true
				end
				if not resourcePlanets[prototype.tiberium_resource_planet] then
					resourcePlanets[prototype.tiberium_resource_planet] = {}
				end
				resourcePlanets[prototype.tiberium_resource_planet][name] = true
			end
		end
	end

	-- Raw resources
	for planetName, planetData in pairs(data.raw.planet) do
		if not resourcePlanets[planetName] then
			resourcePlanets[planetName] = {}
		end
		if planetData.map_gen_settings and planetData.map_gen_settings.autoplace_settings and planetData.map_gen_settings.autoplace_settings.entity
				and planetData.map_gen_settings.autoplace_settings.entity.settings then
			for resourceName in pairs(planetData.map_gen_settings.autoplace_settings.entity.settings) do
				for item in pairs(minableResultsTable(data.raw.resource[resourceName])) do
					resourcePlanets[planetName][item] = true
					if allowAlienOres or planetName == "nauvis" then
						rawResources[item] = true
					end
				end
			end
		end
	end

	-- Find all science packs used with tib science in labs
	for labName, labData in pairs(data.raw.lab) do
		if flib_table.find(labData.inputs, "tiberium-science") and (labName ~= "creative-mod_creative-lab") then
			for _, pack in pairs(labData.inputs or {}) do
				if (pack ~= "tiberium-science") and data.raw.tool[pack] then
					tibComboPacks[pack] = {}
				end
			end
		end
	end

	-- Record all tech costs for later use
	allTechCosts()

	-- Compile list of available recipes
	allAvailableRecipes()

	-- Build indices used later for pruning and traversing tree
	for recipe in pairs(availableRecipes) do
		local ingredientList = normalIngredients(recipe)
		local resultList = normalResults(recipe)
		if flib_table.size(resultList) == 0 then
			availableRecipes[recipe] = nil  -- Remove recipes with no outputs
		else
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
	end

	if debugText then packHierarchy() end

	-- Build a more comprehensive list of free items and ingredient index for later
	for planetName, planetData in pairs(data.raw.planet) do
		if planetData.map_gen_settings and planetData.map_gen_settings.autoplace_settings and planetData.map_gen_settings.autoplace_settings.tile then
			for tileName in pairs(planetData.map_gen_settings.autoplace_settings.tile.settings or {}) do
				if data.raw.tile[tileName] and data.raw.tile[tileName].fluid then
					resourcePlanets[planetName][data.raw.tile[tileName].fluid] = true
					if allowAlienOres or planetName == "nauvis" then
						free[data.raw.tile[tileName].fluid] = true
					end
				end
			end
		end
	end
	for _, tree in pairs(data.raw["tree"]) do
		if tree.autoplace and tree.autoplace.control then
			if data.raw.planet.nauvis.map_gen_settings.autoplace_controls[tree.autoplace.control] then
				for item in pairs(minableResultsTable(tree)) do
					free[item] = true
				end
			end
		end
	end
	for _, fish in pairs(data.raw["fish"]) do
		for item in pairs(minableResultsTable(fish)) do
			free[item] = true
		end
	end

	-- Pruning stupid recipes
	removeBadRecipes(1)

	for recipe in pairs(availableRecipes) do
		local ingredientList = normalIngredients(recipe)
		local resultList = normalResults(recipe)
		if flib_table.size(ingredientList) == 0 then
			for result in pairs(resultList) do
				if not free[result] then
					free[result] = true
					if debugText then log(result.." is free because there are no ingredients for "..recipe) end
				end
			end
		end
	end

	local cachedFree = util.copy(free)  -- Cache free item list so we can rebuild until we reach a list without issues
	local freeItemIterations = 0
	if debugText then log(badRecipeCount.." bad recipes before building free item list") end

	repeat
		local previousBadRecipeCount = badRecipeCount  -- So we can check if new recipes were marked as bad during this loop
		local newFreeItems = util.copy(cachedFree)
		free = util.copy(cachedFree)
		local countFreeLoops = 0
		freeItemIterations = freeItemIterations + 1
		if debugText then log("$$ Building free item list. Attempt #"..freeItemIterations) end
		while flib_table.size(newFreeItems) > 0 do
			countFreeLoops = countFreeLoops + 1
			if debugText then log("On loop #"..countFreeLoops.." there were "..flib_table.size(newFreeItems).." new free items") end
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
						local badRecipe = false
						for result in pairs(normalResults(recipe)) do
							if (tibComboPacks[result] or rawResources[result]) and markBadRecipe(recipe) then
								badRecipe = true  -- Intervene against recipes that make resources/science free
								break
							end
						end
						if not badRecipe then
							for result in pairs(normalResults(recipe)) do
								if not free[result] then
									free[result] = true
									nextLoopFreeItems[result] = true
									if debugText then log(result.." is free via "..recipe.." since "..freeItem.." is free") end
								end
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
	local basicMaterials = util.copy(rawResources)
	for material in pairs(rawResources) do
		ingredientDepth[material] = 0
	end
	for item in pairs(free) do
		ingredientDepth[item] = 0
	end
	-- Now iteratively build up recipes starting from raw resources
	while flib_table.size(basicMaterials) > 0 do
		local nextMaterials = {}
		for material in pairs(basicMaterials) do
			for recipe in pairs(ingredientIndex[material] or {}) do
				if not recipeDepth[recipe] then  --I could nest this deeper but it seems simpler to have at the top
					-- Something with storing a complexity for the recipe, maybe move scoring to here from findRecipe?
					-- Nah leave it in findRecipe so it can account for other active ingredients
					local maxIngredientLevel = 0
					for ingredient in pairs(normalIngredients(recipe)) do
						if not ingredientDepth[ingredient] then
							maxIngredientLevel = -1
							break
						elseif ingredientDepth[ingredient] > maxIngredientLevel then
							maxIngredientLevel = ingredientDepth[ingredient]
						end
					end

					if maxIngredientLevel >= 0 then
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

-- Modifies: oreMult
function addOreMult(item, multiplier)
	multiplier = tonumber(multiplier)
	if multiplier and multiplier >= 0 and not oreMult[item] then
		oreMult[item] = multiplier
	end
end

--Assumes: tibComboPacks
--Modifies: techCosts
function allTechCosts()
	for techName, tech in pairs(data.raw.technology) do
		if string.sub(techName, 1, 9) ~= "tiberium-" and tech.enabled ~= false and tech.hidden ~= true then  -- idk probably avoid tib techs
			-- tell whether it is subset of tibcombopacks
			local skipTech = false
			local packDict = {}
			local packList = {}
			if tech.unit and tech.unit.ingredients then
				for packName, packAmount in pairs(common.itemPrototypesFromTable(tech.unit.ingredients)) do
					if not tibComboPacks[packName] then
						if debugText then log(techName.." contains "..packName.." which is not in tibComboPacks") end
						skipTech = true
						break
					end
					packDict[packName] = packAmount
					table.insert(packList, packName)
				end
				if not skipTech then
					-- make key for techCosts
					table.sort(packList)  -- Needed a list because we can't sort dicts
					local multiPackKey = ""
					if tech.max_level == "infinite" then
						multiPackKey = "infinite"
					end
					for _, pack in pairs(packList) do
						multiPackKey = multiPackKey..":"..pack
					end
					-- add dict to techCosts
					local count = tech.unit.count or 0
					if count == 0 and string.len(tech.unit.count_formula) > 0 then
						local level = tonumber(string.match(techName, "%d+$")) or 1
						local max_level = tonumber(tech.max_level) or 1
						if max_level < level then
							max_level = level
						elseif max_level == "infinite" then
							max_level = level + 3  -- idk how I should deal with ones that start with high base costs
						end
						for i = level, max_level do
							count = count + evaluateFormula(tech.unit.count_formula, level)
						end
					end
					packDict = makeScaledList(packDict, count)
					techCosts[multiPackKey] = sumOfDicts(techCosts[multiPackKey], packDict)
				end
			end
		end
	end
	if debugText then log("techCosts: "..serpent.block(techCosts)) end
end

function evaluateFormula(formula, value)
	-- Make formula Lua-readable
	formula = string.gsub(string.upper(formula), " ", "")  -- Strip spaces and force uppercase
	local pattern1 = "[%a%)][%a%d%(]" -- Multiplication because L or ) followed by L, #, or (
	local pattern2 = "%d[%a%(]" -- Multiplication because # followed by L or (
	local i = string.find(formula, pattern1) or string.find(formula, pattern2)
	while i do  -- Make implicit multiplication explicit
		formula = string.sub(formula, 1, i).."*"..string.sub(formula, i + 1, -1)
		i = string.find(formula, pattern1) or string.find(formula, pattern2)
	end

	local funcString = "function count_formula(L) return "..formula.." end"
	assert(load(funcString))()  -- Define this function and wrap in assert for debugging, I guess
---@diagnostic disable-next-line: undefined-global
	return count_formula(value)
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
						--log("~~~ Recipe "..effect.recipe.." unlocked by "..tech)
						availableRecipes[effect.recipe] = true
						recipeUnlockTracker["technology"][effect.recipe] = tech
						if data.raw.recipe[effect.recipe].result and tibComboPacks[data.raw.recipe[effect.recipe].result] and techData.unit then --TODO handle trigger techs
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
		if itemData.rocket_launch_products then
			local launchResults = common.itemPrototypesFromTable(itemData.rocket_launch_products)
			if flib_table.size(launchResults) > 0 then  -- Fake recipe for rockets
				for silo, siloData in pairs(data.raw["rocket-silo"]) do
					if siloData.fixed_recipe then
						local fakeRecipeName = "dummy-recipe-launching-"..item.."-from-"..silo
						local partName = next(normalResults(siloData.fixed_recipe))
						local numParts = tonumber(siloData.rocket_parts_required) or 1
						fakeRecipes[fakeRecipeName] = true
						availableRecipes[fakeRecipeName] = {ingredient = {[item] = 1, [partName] = numParts}, result = launchResults}
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

--Assumes: fakeRecipes, tibComboPacks, rawResources, emptyBarrel, excludedCrafting
--Modifies: availableRecipes, ingredientIndex, resultIndex, badRecipeCategories, badRecipeCount
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
				local numResults = flib_table.size(resultList)
				for result, amount in pairs(resultList) do
					if emptyBarrel[result] and (numResults > 1) then  -- Bad recipes like unbarreling give empty barrels
						markBadRecipe(recipe)
						break
					end
				end
			end
		end
		for recipe, recipeData in pairs(availableRecipes) do -- Breaking this up so we remove recipes in order of issue severity rather than alphabetically
			if not fakeRecipes[recipe] then
				local resultList = normalResults(recipe)
				for result, amount in pairs(resultList) do
					if (rawResources[result] or tibComboPacks[result]) and (flib_table.size(normalIngredients(recipe)) == 0) then  -- Bad recipes give raw resources/science for free
						markBadRecipe(recipe)
						break
					end
				end
			end
		end
		for recipe, recipeData in pairs(availableRecipes) do
			if not fakeRecipes[recipe] then
				local resultList = normalResults(recipe)
				local sciencePackTypes, sciencePackCount = 0, 0
				for result, amount in pairs(resultList) do
					if tibComboPacks[result] then
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
--Modifies: availableRecipes, ingredientIndex, resultIndex, badRecipeCategories, badRecipeCount
function markBadRecipe(recipe)
	-- Check whether we need to keep it because there are no other ways to get an item
	for result in pairs(availableRecipes[recipe]["result"]) do
		-- Not considering free items to avoid permanently marking a recipe as bad based on inaccurate lists of free items
		if not rawResources[result] and (flib_table.size(resultIndex[result]) == 1) then
			if debugText then log("Can't mark "..recipe.." as bad because we need it for "..result) end
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
	local recipeForPack = {}
	local packDependencyTier = {}
	for pack in pairs(tibComboPacks) do
		local recipe = ""
		if flib_table.size(resultIndex[pack]) == 1 then
			recipe = next(resultIndex[pack])
			log(recipe.." is the only recipe for "..pack)
			if fakeRecipes[recipe] then log(serpent.block(fakeRecipes[recipe])) end
			recipeForPack[pack] = recipe
		else
			log("Multiple recipes for "..pack.." "..serpent.block(resultIndex[pack]))
			-- todo: add something for choosing lowest recipe, but determining "lowest" recipe seems like it would be dependent on the rest of this, idk
		end
		-- Packs unlocked by default are tier 0
		if recipeUnlockTracker["default"][recipeForPack[pack]] then
			packDependencyTier[pack] = 0
		end
	end
	--Iteratively build up list of other pack tiers
	local done = false
	local maxloops = 99
	while maxloops > 0 and not done do
		done = true
		maxloops = maxloops - 1 -- Don't get hardstuck
		for pack in pairs(tibComboPacks) do
			if not packDependencyTier[pack] then
				done = false
				local tech = recipeUnlockTracker["technology"][recipeForPack[pack]]
				--log(pack.." from tech "..tostring(tech))
				if tech then
					local prereqDepth = 0
					for techPack in pairs(packForTech(tech)) do
						local depth = packDependencyTier[techPack]
						--log("prereq pack "..techPack.." has a depth of "..tostring(depth))
						if not depth then  -- Skip if it's still missing a prereq pack
							prereqDepth = -1
							break
						elseif depth > prereqDepth then
							prereqDepth = depth
						end
					end
					if prereqDepth >= 0 then
						packDependencyTier[pack] = prereqDepth + 1
					end
				end
			end
		end
	end
	log("Combo packs:")
	log(serpent.block(tibComboPacks))
	log("Pack tiers:")
	log(serpent.block(packDependencyTier))
end

-- Returns a list of packs required for a given tech (not counting prerequisites)
function packForTech(techName)
	local packList = {}
	if data.raw.technology[techName] and data.raw.technology[techName].unit then
		for _, ingredient in pairs(data.raw.technology[techName].unit.ingredients) do
			local pack = ingredient.name or ingredient[1]
			packList[pack] = ""
		end
	elseif data.raw.technology[techName] and data.raw.technology[techName].research_trigger then
		for _,prereq in pairs(data.raw.technology[techName].prerequisites or {}) do
			for pack in pairs(packForTech(prereq)) do
				packList[pack] = ""
			end
		end
	end
	return packList
end

-- Assumes: free, recipeDepth
-- Modifies: unreachable, multipleRecipes
function findRecipe(item, itemList)
	local recipes = {}
	for recipeName in pairs(resultIndex[item]) do
		local resultList = normalResults(recipeName)
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
			local itemIn = normalIngredients(recipes[1]["name"])[item] or 0
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
	for item, amount in pairs(itemList) do -- First alphabetically, also don't break out of loop so orderedPairs can do cleanup
		if not targetItem and (amount > 0) and (ingredientDepth[item] == maxDepth) then
			targetItem = item
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

	itemList = sumOfDicts(itemList, makeScaledList(normalIngredients(recipeName), recipeTimes))
	itemList = sumOfDicts(itemList, makeScaledList(normalResults(recipeName), -1 * recipeTimes))

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

function sumOfDicts(dict1, dict2, loggingIndent)  --Lists with numeric values
	local out = {}
	if type(dict1) == "table" then out = util.copy(dict1) end
	if type(dict2) == "table" then
		for k, v in pairs(dict2) do
			out[k] = v + (out[k] or 0)
			if debugText and loggingIndent then  -- Unused but leaving this for the future
				local sign = v >= 0 and "+" or ""
				log(loggingIndent..sign..v.." "..k)
			end
		end
	end
	return out
end

function makeScaledList(list, scalar)
	if type(list) ~= "table" then log("bad list:"..tostring(list)) return {} end
	scalar = tonumber(scalar)
	if type(scalar) ~= "number" then log("bad scalar:"..tostring(scalar)) return list end

	local scaledList = {}
	for k, v in pairs(list) do
		scaledList[k] = v * scalar
	end
	return scaledList
end

function addPacksToTier(ingredients, collection)
	for _, pack in pairs(ingredients or {}) do
		local packName = pack[1] or pack.name
		if not collection[packName] and (packName ~= "tiberium-science") then
			collection[packName] = true
		end
	end
end

function fugeTierSetup()
	for pack in pairs(tibComboPacks or {}) do
		if not allPacks[pack] then
			if debugText then log("}\r\n"..pack.."{") end
			allPacks[pack] = breadthFirst({[pack] = 1})
			-- If the only way to get the pack is from the pack, then don't include the pack in the recipes
			if allPacks[pack][pack] == 1 then
				allPacks[pack] = {}
				log("@@@ Unable to break down recipe for "..pack)
			end
			local tier1 = true
			for ingredient in pairs(allPacks[pack]) do
				if data.raw["fluid"][ingredient] then
					tier1 = false
					break
				end
			end
			if tier1 then
				science[1][pack] = true
			end
		end
	end
	if debugText then log("}") end
	-- Purge high tier packs from T1
	repeat
		local somethingNew = false
		for pack in pairs(science[1]) do
			for _, ingredient in pairs(tibComboPacks[pack]) do
				local required = ingredient[1] or ingredient.name
				if not science[1][required] then
					science[1][pack] = nil
					somethingNew = true
					if debugText then log("Removed "..pack.." from tier 1 because it requires non-T1 "..required) end
				end
			end
		end
	until not somethingNew

	-- Fallback to the packs for one of our early-game techs in case nothing qualifies for tier 1
	if (flib_table.size(science[1]) == 0) and data.raw.technology["tiberium-thermal-research"] then
		for _, ingredient in pairs(data.raw.technology["tiberium-thermal-research"].unit.ingredients) do
			local packName = ingredient.name or ingredient[1]
			if tibComboPacks[packName] then
				science[1][packName] = true
			end
		end
	end

	-- Compile weights based on the relative frequency of the packs in the current tier
	updatePackWeights(3)
	updatePackWeights(1)
	updatePackWeights(2)

	if flib_table.size(science[1]) == 0 then  -- Don't know how it would still be empty at this point, but leaving this just in case
		science[1] = util.copy(science[2])
	end
	science[0] = science[1]
end

function fugeRecipeTier(tier)
	-- Return the raw resources needed for the packs or use the override from settings
	local resourceList = fugeRawResources(tier)
	-- Fall back to equal bits of everything
	if flib_table.size(resourceList) == 0 then
		local dummyResourceList = {}
		for resource in pairs(rawResources) do
			if resource ~= "tiberium-ore" then
				dummyResourceList[resource] = 1 / (oreMult[resource] and oreMult[resource] > 0 and oreMult[resource] or 1)
			end
		end
		resourceList = fugeScaleResources(dummyResourceList, tier)
	end

	-- Check number of fluids
	local fluidList = {}
	for resource in pairs(resourceList) do
		if data.raw.fluid[resource] then
			fluidList[resource] = true
		end
	end
	if flib_table.size(fluidList) > 2 then
		log("Uh oh, your tier "..tier.." recipe has "..flib_table.size(fluidList).." fluids")
		--idk what my plan is for handling this case
	end

	-- Make actual recipe changes
	local material = (tier == 0) and "ore" or (tier == 1) and "slurry" or (tier == 2) and "molten" or "liquid"
	local fluid = (tier == 0) and "tiberium-ore" or (tier == 1) and "tiberium-slurry" or (tier == 2) and "molten-tiberium" or "liquid-tiberium"
	local ingredientAmount = (tier ~= 1) and math.max(160 / settings.startup["tiberium-value"].value, 1) or 16
	local normalFugeRecipeName = "tiberium-"..material.."-centrifuging"
	local sludgeFugeRecipeName = "tiberium-"..material.."-sludge-centrifuging"
	common.recipe.addIngredient(normalFugeRecipeName, fluid, ingredientAmount, tier > 0 and "fluid" or "item")
	if debugText then log("Tier "..tier.." centrifuge: "..ingredientAmount.." "..fluid) end
	local sludge = 0
	local sludgeDict = {}
	for resource, amount in pairs(resourceList) do
		local rounded = roundResults(amount)
		if debugText then log("> "..rounded.." "..resource) end
		if tibComboPacks[resource] then
			-- Do nothing, do not put packs in our fuge recipes
		elseif sludgeItems[resource] then
			sludge = sludge + rounded
			sludgeDict[resource] = rounded
		else
			recipeAddResult(normalFugeRecipeName, resource, rounded, fluidList[resource] and "fluid" or "item")
		end
	end
	if (sludge > 0) and (flib_table.size(fluidList) < 3) then -- Only create sludge recipe if there is sludge items to convert and we have enough fluid boxes
		data.raw.recipe[sludgeFugeRecipeName] = flib_data_util.copy_prototype(data.raw.recipe[normalFugeRecipeName], sludgeFugeRecipeName)
		data.raw.recipe[sludgeFugeRecipeName].localised_name = {"recipe-name.tiberium-sludge-centrifuging", {(tier > 0 and "fluid-name." or "item-name.")..fluid}}
		data.raw.recipe[sludgeFugeRecipeName].icon = tiberiumInternalName.."/graphics/icons/"..material.."-sludge-centrifuging.png"
		data.raw.recipe[sludgeFugeRecipeName].icon_size = 32
		data.raw.recipe[sludgeFugeRecipeName].icons = nil
		common.technology.addRecipeUnlock("tiberium-"..material.."-centrifuging", sludgeFugeRecipeName)  -- First argument is the technology name
		recipeAddResult(sludgeFugeRecipeName, "tiberium-sludge", sludge, "fluid")
	end
	if sludge > 0 then  -- Add sludge items after duplicating bc LSlib change result doesn't support changing result types
		for resource, amount in pairs(sludgeDict) do
			recipeAddResult(normalFugeRecipeName, resource, amount, fluidList[resource] and "fluid" or "item")
		end
	end
end

function roundResults(number)
	local upscale = 1
	if number < 0.995 then
		number = number * 100
		upscale = 100
	end
	return math.min(65535, math.floor(number + 0.5) / upscale)
end

-- Wrapper for common.recipe.addResult that also does rounding and handles probabilities for results with amounts less than 1
function recipeAddResult(recipeName, item, amount, type, exact)
	if not exact then amount = roundResults(amount) end
	common.recipe.addResult(recipeName, item, math.ceil(amount), type)
	if amount < 1 then
		common.recipe.setResultProbability(recipeName, item, amount)
	end
end

function updatePackWeights(tier)
	--maybe remove the node from techCosts?
	local packsFromSubsets = {}
	local totalPacks = 0
	for multiPackKey, packs in pairs(techCosts) do
		local subsetOfTierPacks = true
		if tier == 3 then  -- Tier 3 should only consider infinite techs
			subsetOfTierPacks = (string.sub(multiPackKey, 1, 8) == "infinite")
		elseif tier == 1 then  -- Tier 1 should only include techs using subset packs
			for pack in pairs(packs) do
				if not science[tier][pack] then
					subsetOfTierPacks = false
					break
				end
			end
		elseif tier == 2 then  -- Tier 2 gets whatever is left with no restrictions
		end
		if subsetOfTierPacks then
			packsFromSubsets = sumOfDicts(packsFromSubsets, packs)
			techCosts[multiPackKey] = nil
		end
	end
	for _, amount in pairs(packsFromSubsets) do
		totalPacks = totalPacks + amount
	end
	if totalPacks > 0 then
		packsFromSubsets = makeScaledList(packsFromSubsets, flib_table.size(packsFromSubsets) / totalPacks)  -- Gets scaled again later, this just makes it more readable
		if debugText then log("Tier "..tier.." pack distribution: "..serpent.block(packsFromSubsets)) end
		science[tier] = packsFromSubsets
	else
		log("no techs qualified for tier "..tier)
	end
end

function fugeRawResources(tier)
	local resourceList = {}
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
				amount = tonumber(string.match(sub, "[^"..subDelim.."]+$")) or -1  -- After the colon
				if amount <= 0 then  -- In case they put some non-numeric
					amount = 1
					log("tiberium-centrifuge-override-"..tier.." setting has an invalid number for item "..item)
				end
			end
			if data.raw.item[item] or data.raw.fluid[item] then
				resourceList[item] = amount
			else
				log("tiberium-centrifuge-override-"..tier.." setting has an invalid item: "..item)
			end
		end
	else
		-- Total all resources for the tier
		for pack, amount in pairs(science[tier]) do
			local weightedResources = makeScaledList(allPacks[pack], amount)  -- TODO if setup fails, amount is true instead of a number. What should happen then?
			resourceList = sumOfDicts(resourceList, weightedResources)
		end
		-- Don't scale resources when the user uses the override setting
		return fugeScaleResources(resourceList, tier)
	end
	return resourceList
end

function fugeScaleResources(resourceList, tier)
	-- Weighted sum the resources
	local totalOre = 0
	for resource, amount in pairs(resourceList) do
		if resourceExclusions[resource] then  -- Prevent explicitly restricted resources from being included
			resourceList[resource] = nil
		elseif tibComboPacks[resource] then  -- Prevent packs from showing up in auto-generated recipes
			resourceList[resource] = nil
		elseif oreMult[resource] == math.huge then  -- Ores with infinite value are too valuable to include in recipe
			resourceList[resource] = nil
		elseif amount > 0 then
			totalOre = totalOre + amount * (oreMult[resource] or 1)
		end
	end

	-- Scale resourceList to match tier target amounts
	local targetAmount = (tier == 0) and 16 or (tier == 1) and 32 or (tier == 2) and 64 or 128
	local scaledResourceList = makeScaledList(resourceList, targetAmount / math.max(totalOre, 1))

	-- Cutoff for amounts too small to be worth including
	for resource, amount in pairs(scaledResourceList) do
		if amount < 0.05 then
			scaledResourceList[resource] = nil
		end
	end

	return scaledResourceList
end

function singletonRecipes()
	for resourceName, resourceData in pairs(data.raw.resource) do
		for ore in pairs(minableResultsTable(resourceData)) do
			if ore ~= "tiberium-ore" then
				if not oreMult[ore] or (oreMult[ore] ~= math.huge and oreMult[ore] ~= 0) then  -- Don't create recipes for infinite or zero ore
					addCreditRecipe(ore)
					if not resourceExclusions[ore] then
						addDirectRecipe(ore, false)
						if easyMode then
							addDirectRecipe(ore, true)
						end
					end
				end
			end
		end
	end
end

--Creates recipes to turn Molten Tiberium directly into raw materials
--Assumes oreMult
function addDirectRecipe(ore, easy)
	local recipeName = (easy and "tiberium-slurry" or "tiberium").."-tranmutation-to-"..ore
	local oreAmount = 64 / (oreMult[ore] or 1)
	local addSeed = settings.startup["tiberium-direct-catalyst"].value
	local itemOrFluid = data.raw.fluid[ore] and "fluid" or "item"
	local surfaceRestriction = data.raw[itemOrFluid][ore].tiberium_surface
	local tech = easy and "tiberium-easy-transmutation-tech" or data.raw.fluid[ore] and "tiberium-molten-centrifuging" or "tiberium-transmutation-tech"
	local category = "chemistry" --data.raw.fluid[ore] and "chemistry" or "tiberium-transmutation"
	local energy = 12
	local order = (not oreMult[ore] and "a-" or oreMult[ore] > 1 and "b-" or "c-")..ore
	local subgroup = easy and "a-direct-easy" or "a-direct"

	data:extend{{
		type = "recipe",
		name = recipeName,
		localised_name = {itemOrFluid.."-name."..ore},
		ingredients = {},
		results = {},
		energy_required = energy,
		order = order,
		enabled = false,
		subgroup = subgroup,
		always_show_made_in = true,
		category = category,
		crafting_machine_tint = common.tibCraftingTint,
		allow_as_intermediate = false,
		allow_decomposition = false,
	}}
	if easy then
		common.recipe.addIngredient(recipeName, "tiberium-slurry", 32, "fluid")
	elseif data.raw.fluid[ore] then
		common.recipe.addIngredient(recipeName, "molten-tiberium", 16, "fluid")
	else
		common.recipe.addIngredient(recipeName, "tiberium-primed-reactant", 1, "item")
	end
	if addSeed and not easy then
		common.recipe.addIngredient(recipeName, ore, 1, itemOrFluid)
		oreAmount = oreAmount + 1
	end
	recipeAddResult(recipeName, ore, oreAmount, itemOrFluid)
	data.raw.recipe[recipeName].main_product = ore
	if settings.startup["tiberium-byproduct-direct"].value then  -- Direct Sludge Waste setting
		local WastePerCycle = math.max(10 / settings.startup["tiberium-value"].value, 1)
		common.recipe.addResult(recipeName, "tiberium-sludge", WastePerCycle, "fluid")
	end
	-- Add new techs for recipe unlock if needed
	if (surfaceRestrictTransmute or planetTechs) and not easy and (surfaceRestriction or not resourcePlanets["nauvis"][ore]) then
		for planet, resources in pairs(resourcePlanets) do
			if resources[ore] or (surfaceRestriction == planet and surfaces[surfaceRestriction]) then
				if surfaceRestrictTransmute and surfaces[planet] and surfaces[planet].restrictions then
					data.raw.recipe[recipeName].surface_conditions = {surfaces[planet].restrictions}
				end
				if planetTechs and surfaces[planet] and surfaces[planet].technology and surfaces[planet].pack then
					tech = "tiberium-transmutation-tech-"..planet
					if not data.raw.technology[tech] then
						data:extend{{
							type = "technology",
							name = tech,
							localised_name = {"technology-name.tiberium-transmutation-tech-planet", {"space-location-name."..planet}},
							localised_description = {"technology-description.tiberium-transmutation-tech-planet", {"space-location-name."..planet}},
							icons = common.layeredIcons(tiberiumInternalName.."/graphics/technology/tiberium-transmutation.png", 128, 
									data.raw.planet[planet].icon, data.raw.planet[planet].icon_size, "se"),
							effects = {},
							unit = util.copy(data.raw.technology["tiberium-transmutation-tech"].unit),
							prerequisites = {"tiberium-transmutation-tech", surfaces[planet].technology}
						}}
						data.raw.technology[tech].unit.count = 1000
						local packPresent = false
						for _,packs in pairs(data.raw.technology[tech].unit.ingredients) do
							if packs[1] == surfaces[planet].pack then
								packPresent = true
								break
							end
						end
						if not packPresent then
							table.insert(data.raw.technology[tech].unit.ingredients, {surfaces[planet].pack, 1})
						end
					end
				end
				break
			end
		end
	end
	common.technology.addRecipeUnlock(tech, recipeName)
end

--Creates recipes to turn raw materials into Tiberium Substrate
--Assumes oreMult
function addCreditRecipe(ore)
	local recipeName = "tiberium-growth-credit-from-"..ore
	local oreAmount = math.min(65535, math.ceil(settings.startup["tiberium-growth"].value * settings.startup["tiberium-value"].value / (oreMult[ore] or 1)))
	local itemOrFluid = data.raw.fluid[ore] and "fluid" or "item"
	local energy = 0.5 * settings.startup["tiberium-growth"].value * settings.startup["tiberium-value"].value
	local order = (not oreMult[ore] and "a-" or oreMult[ore] > 1 and "b-" or "c-")..ore
	local oreIcon, oreIconSize, oreTint
	if data.raw["item"][ore] then
		local icon = flib_data_util.create_icons(data.raw["item"][ore])[1]
		oreIcon = icon.icon
		oreIconSize = icon.icon_size
		oreTint = icon.tint
	elseif data.raw["fluid"][ore] then
		local icon = flib_data_util.create_icons(data.raw["fluid"][ore])[1]
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
			scale = 12.0 / (oreIconSize or 64), -- scale = 0.5 * 32 / icon_size simplified
			shift = {10, -10},
			tint = oreTint,
		}
	end
	data:extend{{
		type = "recipe",
		name = recipeName,
		localised_name = {"item-name.tiberium-growth-credit"},
		ingredients = {{type = itemOrFluid, name = ore, amount = oreAmount}},
		results = {{type = "item", name = "tiberium-growth-credit", amount = 1}},
		energy_required = energy,
		order = order,
		icons = util.copy(icons),
		enabled = false,
		subgroup = "a-growth-credits",
		always_show_made_in = true,
		category = "chemistry",
		crafting_machine_tint = common.tibCraftingTint,
		allow_decomposition = false,
	}}
	common.technology.addRecipeUnlock("tiberium-growth-acceleration", recipeName)

	if itemOrFluid == "item" then
		-- Make reprocessor recipe
		local reprocessingName = "tiberium-reprocessing-"..ore
		data:extend{{
			type = "recipe",
			name = reprocessingName,
			ingredients = {{type = "item", name = ore, amount = 1}},
			results = {},
			energy_required = energy / oreAmount,  -- Preserve the energy-per-input-ore from the other recipe
			category = "tiberium-reprocessing",
			crafting_machine_tint = common.tibCraftingTint,
			allow_decomposition = false,
			hide_from_player_crafting = true,
		}}
		recipeAddResult(reprocessingName, "tiberium-growth-credit", 1 / oreAmount, "item", true)

	end
end

giantSetupFunction()
log("%%% Setup complete beginning recipe parse")
fugeTierSetup()
fugeRecipeTier(1)
fugeRecipeTier(2)
fugeRecipeTier(3)
if common.tierZero then
	fugeRecipeTier(0)
end
singletonRecipes()  -- So fluid recipes come after sludge recipes for molten centrifuging

for k,v in pairs(resultIndex) do
	if (flib_table.size(v) == 0) and not rawResources[k] then log("~~~ No remaining recipes create "..k) end
end

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
log("%%% Recipes complete")
