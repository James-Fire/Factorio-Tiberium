local common = {}

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

common.TiberiumRadius = 20 + settings.startup["tiberium-spread"].value * 0.4 --Translates to 20-60 range

common.hit_effects = require("__base__.prototypes.entity.hit-effects")

common.sounds = require("__base__.prototypes.entity.sounds")

common.tibCraftingTint = {
	primary    = {r = 0.109804, g = 0.721567, b = 0.231373,  a = 1},
	secondary  = {r = 0.098039, g = 1,        b = 0.278431,  a = 1},
	tertiary   = {r = 0.156863, g = 0.156863, b = 0.156863,  a = 0.235294},
	quaternary = {r = 0.160784, g = 0.745098, b = 0.3058824, a = 0.345217},
}

common.tibCraftingBlueTint = {
	primary    = {r = 0.2, g = 0.2, b = 1, a = 1},
	secondary  = {r = 0.04, g = 0.4, b = 1, a = 1},
	tertiary   = {r = 0.3, g = 0.4, b = 1, a = 0.3},
	quaternary = {r = 0.3, g = 0.2, b = 1, a = 0.4},
}

common.scaleUpSprite = function(sprite, scalar)
	if sprite.layers then
		for layerIndex, layerSprite in pairs(sprite.layers) do
			sprite.layers[layerIndex] = common.scaleUpSprite(layerSprite, scalar)
		end
	else
		sprite.scale = scalar * (sprite.scale or 1)
		if sprite.hr_version then
			sprite.hr_version.scale = scalar * (sprite.hr_version.scale or 1)
		end
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
	targetSize = targetSize or 16
	local base = {
		icon = baseImg,
		icon_size = baseSize,
	}
	local corners = {ne = {x = 1, y = -1}, se = {x = 1, y = 1}, sw = {x = -1, y = 1}, nw = {x = -1, y = -1}}
	local offset = {}
	if corner and corners[corner] then
		offset = {0.5 * (32 - targetSize) * corners[corner].x, 0.5 * (32 - targetSize) * corners[corner].y}
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

common.normalIngredients = function(recipeName)
	local recipe = data.raw["recipe"][recipeName]
	if recipe then
		local ingredientTable = common.itemPrototypesFromTable(recipe.normal and recipe.normal.ingredients or recipe.ingredients)
		if debugText and LSlib.utils.table.isEmpty(ingredientTable) then log("### Could not find ingredients for "..recipeName) end
		return ingredientTable
	else
		log("### Could not find recipe with name "..recipeName)
		return {}
	end
end

common.normalResults = function(recipeName)
	local recipe = data.raw["recipe"][recipeName]
	if recipe then
		local resultTable = common.resultsToTable(recipe.normal or recipe)
		if debugText and LSlib.utils.table.isEmpty(resultTable) then log("### Could not find results for "..recipeName) end
		return resultTable
	else
		log("### Could not find recipe with name "..recipeName)
		return {}
	end
end

common.resultsToTable = function(prototypeTable)
	if type(prototypeTable) ~= "table" then	return {} end
	local out = common.itemPrototypesFromTable(prototypeTable.results)
	if LSlib.utils.table.isEmpty(out) and prototypeTable.result then
		out[prototypeTable.result] = tonumber(prototypeTable.result_count) or tonumber(prototypeTable.count) or 1
	end
	return out
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

return common
