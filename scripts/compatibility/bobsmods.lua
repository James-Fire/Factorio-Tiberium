
if mods["bobores"] then
	common.applyTiberiumValue("thorium-ore", 8)
end

if mods["bobplates"] then
	if data.raw.item["gas-canister"] then
		data.raw.item["gas-canister"].tiberium_empty_barrel = true
	end
end

--Bob's Mining Drill
if data.raw.item["bob-mining-drill-2"] then
	common.recipe.editIngredient("tiberium-node-harvester", "electric-mining-drill", "bob-mining-drill-2", 1)
end
if data.raw.item["bob-mining-drill-3"] then
	common.recipe.editIngredient("tiberium-network-node", "electric-mining-drill", "bob-mining-drill-3", 1)
end
--Titanium
if data.raw.item["titanium-plate"] then
	common.recipe.editIngredient("tiberium-ion-core", "steel-plate", "titanium-plate", 1)
	common.recipe.editIngredient("tiberium-marv", "steel-plate", "titanium-plate", 1)
	common.recipe.editIngredient("tiberium-power-plant", "steel-plate", "titanium-plate", 1)
	common.recipe.editIngredient("tiberium-beacon-node", "steel-plate", "titanium-plate", 1)
	common.recipe.editIngredient("tiberium-aoe-node-harvester", "steel-plate", "titanium-plate", 1)
end
--Gold
if data.raw.item["gold-plate"] then
	common.recipe.editIngredient("tiberium-beacon-node", "copper-plate", "gold-plate", 1)
	common.recipe.editIngredient("tiberium-srf-emitter", "copper-plate", "gold-plate", 1)
end
--Steel Pipe
if data.raw.item["steel-pipe"] then
	common.recipe.editIngredient("tiberium-growth-accelerator", "pipe", "steel-pipe", 1)
	common.recipe.editIngredient("tiberium-network-node", "pipe", "steel-pipe", 1)
	common.recipe.editIngredient("tiberium-ion-core", "pipe", "steel-pipe", 1)
end
--Aluminum
if data.raw.item["aluminium-plate"] then
	common.recipe.editIngredient("tiberium-growth-accelerator", "steel-plate", "aluminium-plate", 1)
	common.recipe.editIngredient("tiberium-srf-emitter", "steel-plate", "aluminium-plate", 1)
	common.recipe.editIngredient("tiberium-obelisk-of-light", "steel-plate", "aluminium-plate", 1)
	common.recipe.editIngredient("tiberium-node-harvester", "iron-plate", "aluminium-plate", 1)
end
--Lead
if data.raw.item["lead-plate"] then
	common.recipe.editIngredient("tiberium-empty-cell", "steel-plate", "lead-plate", 1)
end
--Beacon 3
if data.raw.item["beacon-3"] then
	common.recipe.editIngredient("tiberium-beacon-node", "beacon", "beacon-3", 1)
end
--Advanced Processing Units
if data.raw.item["advanced-processing-unit"] then
	common.recipe.editIngredient("tiberium-beacon-node", "processing-unit", "advanced-processing-unit", 1)
	common.recipe.editIngredient("tiberium-spike", "processing-unit", "advanced-processing-unit", 1)
end
--Chemical Plant 2
if data.raw.item["chemical-plant-2"] then
	common.recipe.editIngredient("tiberium-power-plant", "chemical-plant", "chemical-plant-2", 1)
end
--Solar Panel 3
if data.raw.item["solar-panel-3"] then
	common.recipe.editIngredient("tiberium-spike", "solar-panel", "solar-panel-3", 1)
end
--Pumpjack 4
if data.raw.item["bob-pumpjack-3"] then
	common.recipe.editIngredient("tiberium-spike", "pumpjack", "bob-pumpjack-3", 1)
end
