-- Adding Tib Science to all labs
local tibComboPacks = {}  -- List of packs that need to be processed in the same lab as Tib Science
for name, technology in pairs(data.raw.technology) do
	if string.sub(name, 1, 9) == "tiberium-" then
		for _, ingredient in pairs(technology.unit.ingredients) do
			local pack = ingredient[1] and ingredient[1] or ingredient.name
			if (pack ~= "tiberium-science") and data.raw.tool[pack] then -- Don't add Tib Science
				tibComboPacks[pack] = true
			end
		end
	end
end

for labName, labData in pairs(data.raw.lab) do
	local addTib = false
	if not LSlib.utils.table.hasValue(labData.inputs or {}, "tiberium-science") then -- Must not already allow Tib Science
		for pack in pairs(tibComboPacks) do  -- Must use packs from combo list so we don't hit things like module labs
			if LSlib.utils.table.hasValue(labData.inputs or {}, pack) then
				addTib = true
				break
			end
		end
	end
	if addTib then table.insert(data.raw.lab[labName].inputs, "tiberium-science") end
end

if mods["alien-biomes"] then  -- Reverting this change so Tiberium can grow on landfill again
	for k,v in pairs(data.raw.tile.landfill.collision_mask) do
		if v == "resource-layer" then
			table.remove(data.raw.tile.landfill.collision_mask, k)
			break
		end
	end
end

require("scripts/DynamicOreRecipes")
