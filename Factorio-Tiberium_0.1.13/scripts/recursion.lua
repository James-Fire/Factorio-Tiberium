data:extend({
	{
		name = "rainbow-science-pack",
		type = "item",
		icon = "__base__/graphics/icons/uranium-rounds-magazine.png",
		icon_size = 64, icon_mipmaps = 4,
		--category = "default",
		subgroup = "a-items",
		order = "a[basic-clips]-d[tiberium-magazine]",
		stack_size = 200
	},
})

data:extend({
	{
		name = "rainbow-science-pack",
		type = "recipe",
    	ingredients = {{"automation-science-pack",1}},
    	result = "rainbow-science-pack",
		category = "chemistry",
		enabled = true,
		energy_required = 12,
	},
})





-- returns the non-fluid ingredients for the recipe

function get_ingredients(recipeName)
	local recipe = data.raw.recipe[recipeName]
	if not recipe then
		return nil
	end
	if recipe.category == "smelting" then
		return false
	end
	local ingredientList = recipe.ingredients or recipe.normal.ingredients
	local ingredients = {}
	local result_count = recipe.result_count or 1
	for _,ing in pairs(ingredientList) do
		local name = ing[1] or ing.name
		local amount = ing[2] or ing.amount
		--if ing.type ~= "fluid" then
			ingredients[name] = amount/result_count
		--end
	end
	return ingredients
end

function expand_list(ingredients)
	local didExpansion = false
	outList = {}
	for name,amount in pairs(ingredients) do
		innerlist = get_ingredients(name)
		if innerlist then
			for innerName,innerAmount in pairs(innerlist) do
				outList[innerName] = (outList[innerName] or 0) + innerAmount * amount
			end
			didExpansion = true 
		else
			outList[name] = amount
		end
	end
	return didExpansion, outList
end

local sciencePackPrototype = {
	name = "rainbow-science-pack",
	type = "recipe",
	result = "rainbow-science",
	order = "zzz",
	always_show_products = true,
	category = "chemistry",
}


local craftingTimeArray = {5,6,5,12,7,7}
--sciencePackPrototype.energy_required = lcm(craftingTimeArray)
--sciencePackPrototype.result_count = sciencePackPrototype.energy_required/math.max(unpack(craftingTimeArray))


local ingredients = {}
for _,recipe in pairs(data.raw.recipe) do
	if recipe.result then
	end
	if recipe.result and string.find(recipe.result, "science%-pack") then
		ingredients[recipe.result] = sciencePackPrototype.result_count
	end
end
ingredients["satellite"] = 0.001
ingredients["rocket-part"] = 0.1

local doAgain = true
repeat
	doAgain, ingredients = expand_list(ingredients)
	log(serpent.block(ingredients))
until(doAgain == false)


ingredients["light-oil"] = (ingredients["light-oil"] or 0) + 10 * (ingredients["solid-fuel"] or 0)
ingredients["solid-fuel"] = nil

local petrogas = (ingredients["petroleum-gas"] or 0) / .55
local light = (ingredients["light-oil"] or 0) / .45
local heavy = (ingredients["heavy-oil"] or 0) / .25
ingredients["petroleum-gas"], ingredients["light-oil"], ingredients["heavy-oil"] = nil, nil, nil
local crude = math.max(petrogas,light,heavy)
ingredients["crude-oil"] = crude
ingredients["water"] = (ingredients["water"] or 0) + crude/2

local formattedIngredients = {}
for name,amount in pairs(ingredients) do
	if name == "sulfuric-acid" or name == "petroleum-gas" or name == "water" or name == "heavy-oil" or name == "light-oil" or name == "crude-oil" or name=="steam" then
		table.insert(formattedIngredients,{type = "fluid",name = name,amount = math.ceil(amount)})
	else
		table.insert(formattedIngredients,{type = "item", name=name,amount = math.ceil(amount)})
	end
end
data.raw["recipe"]["rainbow-science-pack"].ingredients = formattedIngredients


--data:extend({sciencePackPrototype})
