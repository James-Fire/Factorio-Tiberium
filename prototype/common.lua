flib_table = require("__flib__/table")

local common = {}
common.technology = {}
common.recipe = {}

common.blankAnimation = {
	filename =  "__core__/graphics/empty.png",
	width = 1,
	height = 1,
	line_length = 1,
	frame_count = 1,
	variation_count = 1,
}

common.blankPicture = {
	filename = "__core__/graphics/empty.png",
	width = 1,
	height = 1
}

common.blankIcons = {
	{
		icon = "__core__/graphics/empty.png",
		icon_size = 1
	}
}

common.TiberiumRadius = settings.startup["tiberium-radius"].value

common.TiberiumInStartingArea = settings.startup["tiberium-starting-area"].value or settings.startup["tiberium-ore-removal"].value or false

common.hit_effects = require("__base__.prototypes.entity.hit-effects")

common.sounds = require("__base__.prototypes.entity.sounds")

common.tibCraftingTint = {
	primary    = {r = 0.109804, g = 0.721567, b = 0.231373,  a = 1},
	secondary  = {r = 0.098039, g = 1,        b = 0.278431,  a = 1},
	tertiary   = {r = 0.156863, g = 0.156863, b = 0.156863,  a = 0.235294},
	quaternary = {r = 0.160784, g = 0.745098, b = 0.3058824, a = 0.345217},
}

common.tibCraftingBlueTint = {
	primary    = {r = 0.2,  g = 0.2, b = 1, a = 1},
	secondary  = {r = 0.04, g = 0.4, b = 1, a = 1},
	tertiary   = {r = 0.3,  g = 0.4, b = 1, a = 0.3},
	quaternary = {r = 0.3,  g = 0.2, b = 1, a = 0.4},
}

common.pollutionMulti = settings.startup["tiberium-pollution-multiplier"].value

common.emissionMultiplier = function(scaling, base)
	base = base or 1
	if common.pollutionMulti == 1 then return base end
	return math.max(base * scaling * common.pollutionMulti / 4, 1)
end

common.scaledEmissions = function(scaling, base)
	return {["pollution"] = common.emissionMultiplier(scaling, base)}
end

common.scaleUpSprite = function(sprite, scalar)
	if sprite.layers then
		for layerIndex, layerSprite in pairs(sprite.layers) do
			sprite.layers[layerIndex] = common.scaleUpSprite(layerSprite, scalar)
		end
	else
		sprite.scale = scalar * (sprite.scale or 1)
	end
	return sprite
end

common.scaleUpSprite4Way = function(sprite4Way, scalar)
	if sprite4Way.sheet then
		sprite4Way.sheet = common.scaleUpSprite(sprite4Way.sheet, scalar)
	elseif sprite4Way.sheets then
		for sheetIndex, sheet in pairs(sprite4Way.sheets) do
			sprite4Way.sheets[sheetIndex] = common.scaleUpSprite(sheet, scalar)
		end
	elseif not sprite4Way.north then
		sprite4Way = common.scaleUpSprite(sprite4Way, scalar)
	else
		for direction, sprite in pairs(sprite4Way) do
			sprite4Way[direction] = common.scaleUpSprite(sprite, scalar)
		end
	end
	return sprite4Way
end

common.applyTiberiumValue = function(item, value)
	if data.raw.item[item] and not data.raw.item[item].tiberium_multiplier then
		data.raw.item[item].tiberium_multiplier = value
	end
end

common.layeredIcons = function(baseImg, baseSize, layerImg, layerSize, corner, targetSize)
	baseSize = baseSize or 64
	layerSize = layerSize or 64
	targetSize = targetSize or 24
	local base = {
		icon = baseImg,
		icon_size = baseSize,
		scale = 64 / baseSize,
	}
	local corners = {ne = {x = 1, y = -1}, se = {x = 1, y = 1}, sw = {x = -1, y = 1}, nw = {x = -1, y = -1}}
	local offset = {}
	if corner and corners[corner] then
		offset = {0.5 * (64 - targetSize) * corners[corner].x, 0.5 * (64 - targetSize) * corners[corner].y}
	else
		offset = {0, 0}
	end
	local layer = {
		icon = layerImg,
		icon_size = layerSize,
		scale = targetSize / layerSize,
		shift = offset,
	}
	return {base, layer}
end

common.recipeIngredientsTable = function(recipeName)
	local recipe = data.raw["recipe"][recipeName]
	if recipe then
		local ingredientTable = common.itemPrototypesFromTable(recipe.ingredients)
		if debugText and (flib_table.size(ingredientTable) == 0) then log("### Could not find ingredients for "..recipeName) end
		return ingredientTable
	else
		log("### Could not find recipe with name "..recipeName)
		return {}
	end
end

common.recipeResultsTable = function(recipeName)
	local recipe = data.raw["recipe"][recipeName]
	if recipe then
		local resultTable = common.itemPrototypesFromTable(recipe.results)
		if debugText and (flib_table.size(resultTable) == 0) then log("### Could not find results for "..recipeName) end
		return resultTable
	else
		log("### Could not find recipe with name "..recipeName)
		return {}
	end
end

common.itemPrototypesFromTable = function(prototypeTable)
	local out = {}
	if type(prototypeTable) ~= "table" then
		return out
	end
	for _, item in pairs(prototypeTable) do
		if item[1] then
			local amount = tonumber(item[2])
			if amount and amount >= 1 then
				out[item[1]] = math.floor(amount)
			end
		elseif item.name then
			local amount = tonumber(item.amount)
			if amount then
				amount = math.floor(amount)
			else
				local min = tonumber(item.amount_min) or 1  -- I don't think the "or 1"s will ever be reached, but playing it safe
				local max = tonumber(item.amount_max) or 1
				amount = (min + math.max(min, max)) / 2
			end
			local probability = tonumber(item.probability)
			if probability then
				probability = math.max(0, math.min(1, probability))  -- Clamp to actual 0 to 1 range
				amount = amount * probability
			end
			if amount > 0 then
				out[item.name] = amount
			end
		end
	end
	return out
end

common.minableResultsTable = function(prototypeTable)  -- Still needed for minable result/results
	if type(prototypeTable) ~= "table" or not prototypeTable.minable then return {} end
	local out = common.itemPrototypesFromTable(prototypeTable.minable.results)
	if (flib_table.size(out) == 0) and prototypeTable.minable.result then
		out[prototypeTable.minable.result] = tonumber(prototypeTable.minable.result_count) or tonumber(prototypeTable.minable.count) or 1
	end
	return out
end

common.makeCollisionMask = function(arrayOfLayers)
	local mask = {layers = {}}
	for _, layer in pairs(arrayOfLayers) do
		mask.layers[layer] = true
	end
	return mask
end

common.technology.addRecipeUnlock = function(technologyName, recipeName)
	if not data.raw.technology[technologyName] or not data.raw.recipe[recipeName] then return end
	if not data.raw["technology"][technologyName].effects then
		data.raw["technology"][technologyName].effects = {}
	end
	for _, effect in pairs(data.raw["technology"][technologyName].effects) do
		if effect.type == "unlock-recipe" and effect.recipe == recipeName then return end
	end
	table.insert(data.raw["technology"][technologyName].effects, {type = "unlock-recipe", recipe = recipeName})
end

common.technology.removeRecipeUnlock = function(technologyName, recipeName)
	if not data.raw.technology[technologyName] or not data.raw.recipe[recipeName] then return end
	if data.raw["technology"][technologyName].effects then
		for index, effect in pairs(data.raw["technology"][technologyName].effects) do
			if effect.type == "unlock-recipe" and effect.recipe == recipeName then
				table.remove(data.raw["technology"][technologyName].effects, index)
				if next(data.raw["technology"][technologyName].effects) == nil then
					data.raw["technology"][technologyName].effects = nil
				end
				break
			end
		end
	end
end

common.technology.addPrerequisite = function(technologyName, prerequisiteToAdd)
	if data.raw["technology"][technologyName] then
		if not data.raw["technology"][technologyName].prerequisites then
			data.raw["technology"][technologyName].prerequisites = {}
		end
		for _, prerequisite in pairs(data.raw["technology"][technologyName].prerequisites) do
			if prerequisite == prerequisiteToAdd then return end
		end
		table.insert(data.raw["technology"][technologyName].prerequisites, prerequisiteToAdd)
	end
end

common.technology.removePrerequisite = function(technologyName, prerequisiteToRemove)
	if data.raw["technology"][technologyName] and data.raw["technology"][technologyName].prerequisites then
		for index, prerequisite in pairs(data.raw["technology"][technologyName].prerequisites) do
			if prerequisite == prerequisiteToRemove then
				table.remove(data.raw["technology"][technologyName].prerequisites, index)
				if next(data.raw["technology"][technologyName].prerequisites) == nil then
					data.raw["technology"][technologyName].prerequisites = nil
				end
				break
			end
		end
	end
end

common.recipe.addIngredient = function(recipeName, ingredientName, ingredientAmount, ingredientType)
	if not data.raw["recipe"][recipeName] then return end

	if data.raw["recipe"][recipeName].ingredients then
		local alreadyPresent = false
		for _,ingredient in pairs(data.raw["recipe"][recipeName].ingredients) do
			if ingredient.name == ingredientName and
				(ingredient.type or "item") == (ingredientType or "item") then
				alreadyPresent = true
				ingredient.amount = ingredientAmount or 1
			end
		end
		if not alreadyPresent then
			table.insert(data.raw["recipe"][recipeName].ingredients, {
				["type"] = ingredientType,
				["name"] = ingredientName,
				["amount"] = ingredientAmount or 1,
			})
		end
	end
end

common.recipe.removeIngredient = function(recipeName, ingredientName)
	if not data.raw["recipe"][recipeName] then return end

	if data.raw["recipe"][recipeName].ingredients then
		for index, ingredient in pairs(data.raw["recipe"][recipeName].ingredients) do
			if (ingredient.name and ingredient.name == ingredientName) or (ingredient[1] and ingredient[1] == ingredientName) then
				table.remove(data.raw["recipe"][recipeName].ingredients, index)
				break
			end
		end
	end
end

common.recipe.editIngredient = function(recipeName, oldIngredientName, newIngredientName, amountMultiplier)
	amountMultiplier = amountMultiplier or 1
	if not data.raw["recipe"][recipeName] then return end

	if data.raw["recipe"][recipeName].ingredients then
		for index, ingredient in pairs(data.raw["recipe"][recipeName].ingredients) do
			if ingredient.name and ingredient.name == oldIngredientName then
				data.raw["recipe"][recipeName].ingredients[index].name = newIngredientName
				data.raw["recipe"][recipeName].ingredients[index].amount = math.floor(0.5 + data.raw["recipe"][recipeName].ingredients[index].amount * amountMultiplier)
				break
			elseif ingredient[1] and ingredient[1] == oldIngredientName then
				data.raw["recipe"][recipeName].ingredients[index][1] = newIngredientName
				data.raw["recipe"][recipeName].ingredients[index][2] = math.floor(0.5 + data.raw["recipe"][recipeName].ingredients[index][2] * amountMultiplier)
				break
			end
		end
	end
end

common.recipe.addResult = function(recipeName, resultName, resultAmount, resultType)
	if not data.raw["recipe"][recipeName] then return end

	if data.raw["recipe"][recipeName].results then
		local alreadyPresent = false
		for _, result in pairs(data.raw["recipe"][recipeName].results) do
			if result.name == resultName then
				result.amount = resultAmount
				alreadyPresent = true
				break
			end
		end
		if not alreadyPresent then
			table.insert(data.raw["recipe"][recipeName].results, {
				["type"] = resultType,
				["name"] = resultName,
				["amount"] = resultAmount,
			})
		end
	end
end

common.recipe.editResult = function(recipeName, oldResultName, newResultName, amountMultiplier)
	amountMultiplier = amountMultiplier or 1
	if not data.raw["recipe"][recipeName] then return end

	if data.raw["recipe"][recipeName].results then
		for _, result in pairs(data.raw["recipe"][recipeName].results) do
			if result.name == oldResultName then
				result.name = newResultName

				if result.amount then
					result.amount = result.amount * amountMultiplier
				end
				if result.amount_min then
					result.amount_min = result.amount_min * amountMultiplier
				end
				if result.amount_max then
					result.amount_max = result.amount_max * amountMultiplier
				end

				break
			end
		end
	end
end

common.recipe.setResultProbability = function(recipeName, resultName, resultProbability)
	if not data.raw["recipe"][recipeName] then return end
	resultProbability = ((resultProbability~=1) and resultProbability) --wtf does this do

	if data.raw["recipe"][recipeName].result then
		data.raw["recipe"][recipeName].results = {{
		name = data.raw["recipe"][recipeName].result,
		amount = data.raw["recipe"][recipeName].result_count or 1,
		}}
		data.raw["recipe"][recipeName].result = nil
		data.raw["recipe"][recipeName].result_count = nil
	end

	if data.raw["recipe"][recipeName].results then
		for index, result in pairs(data.raw["recipe"][recipeName].results) do
			if result.name == resultName then
				result.probability = resultProbability
				break
			end
		end
	end
end

return common
