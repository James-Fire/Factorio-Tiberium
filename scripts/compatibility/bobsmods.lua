
if mods["bobores"] then
	common.applyTiberiumValue("thorium-ore", 8)
end

if mods["bobplates"] then
	if data.raw.item["bob-gas-canister"] then
		data.raw.item["bob-gas-canister"].tiberium_empty_barrel = true
	end
end

--Bob's Mining Drill
if data.raw.item["bob-mining-drill-2"] then
	common.recipe.editIngredient("tiberium-node-harvester", "electric-mining-drill", "bob-mining-drill-2")
end
if data.raw.item["bob-mining-drill-3"] then
	common.recipe.editIngredient("tiberium-network-node", "electric-mining-drill", "bob-mining-drill-3")
end
--Titanium
if data.raw.item["bob-titanium-plate"] then
	common.recipe.editIngredient("tiberium-ion-core", "steel-plate", "bob-titanium-plate")
	common.recipe.editIngredient("tiberium-marv", "steel-plate", "bob-titanium-plate")
	common.recipe.editIngredient("tiberium-power-plant", "steel-plate", "bob-titanium-plate")
	common.recipe.editIngredient("tiberium-beacon-node", "steel-plate", "bob-titanium-plate")
	common.recipe.editIngredient("tiberium-aoe-node-harvester", "steel-plate", "bob-titanium-plate")
end
--Gold
if data.raw.item["bob-gold-plate"] then
	common.recipe.editIngredient("tiberium-beacon-node", "copper-plate", "bob-gold-plate")
	common.recipe.editIngredient("tiberium-srf-emitter", "copper-plate", "bob-gold-plate")
end
--Steel Pipe
if data.raw.item["bob-steel-pipe"] then
	common.recipe.editIngredient("tiberium-growth-accelerator", "pipe", "bob-steel-pipe")
	common.recipe.editIngredient("tiberium-network-node", "pipe", "bob-steel-pipe")
	common.recipe.editIngredient("tiberium-ion-core", "pipe", "bob-steel-pipe")
end
--Aluminum
if data.raw.item["bob-aluminium-plate"] then
	common.recipe.editIngredient("tiberium-growth-accelerator", "steel-plate", "bob-aluminium-plate")
	common.recipe.editIngredient("tiberium-srf-emitter", "steel-plate", "bob-aluminium-plate")
	common.recipe.editIngredient("tiberium-obelisk-of-light", "steel-plate", "bob-aluminium-plate")
	common.recipe.editIngredient("tiberium-node-harvester", "iron-plate", "bob-aluminium-plate")
end
--Lead
if data.raw.item["bob-lead-plate"] then
	common.recipe.editIngredient("tiberium-empty-cell", "steel-plate", "bob-lead-plate")
end
--Beacon 3
if data.raw.item["bob-beacon-3"] then
	common.recipe.editIngredient("tiberium-beacon-node", "beacon", "bob-beacon-3")
end
--Advanced Processing Units
if data.raw.item["bob-advanced-processing-unit"] then
	common.recipe.editIngredient("tiberium-beacon-node", "processing-unit", "bob-advanced-processing-unit")
	common.recipe.editIngredient("tiberium-spike", "processing-unit", "bob-advanced-processing-unit")
end
--Chemical Plant 2
if data.raw.item["bob-chemical-plant-2"] then
	common.recipe.editIngredient("tiberium-power-plant", "chemical-plant", "bob-chemical-plant-2")
end
--Solar Panel 3
if data.raw.item["bob-solar-panel-3"] then
	common.recipe.editIngredient("tiberium-spike", "solar-panel", "bob-solar-panel-3")
end
--Pumpjack 4
if data.raw.item["bob-pumpjack-3"] then
	common.recipe.editIngredient("tiberium-spike", "pumpjack", "bob-bob-pumpjack-3")
end
