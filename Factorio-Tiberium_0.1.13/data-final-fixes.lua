for _, d in pairs(data.raw["damage-type"]) do
	resist = {}
	resist.type = d.name
	resist.percent = 100
	table.insert(data.raw["land-mine"]["node-land-mine"].resistances, resist)
end

--Remove resources that aren't Tiberium from Autoplace
--[[data.raw.resource["crude-oil"] = nil
data.raw["autoplace-control"]["crude-oil"] = nil

for _, pre in pairs(data.raw["map-gen-presets"].default) do
	if pre.basic_settings then
		if pre.basic_settings.autoplace_controls then
			pre.basic_settings.autoplace_controls[ore.name] = nil
		end
	end
end]]

require("science")
require("scripts/tib-map-gen-presets")
-- Ease into early techs for Tib Only runs
if settings.startup["tiberium-advanced-start"].value or settings.startup["tiberium-ore-removal"].value then
	data.raw.technology["tiberium-processing-tech"].unit.count = 100
	data.raw.technology["tiberium-molten-processing"].unit.count = 400
end

require("scripts/DynamicOreRecipes")
