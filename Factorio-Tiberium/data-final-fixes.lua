-- Ease into early techs for Tib Only runs
if settings.startup["tiberium-advanced-start"].value or settings.startup["tiberium-ore-removal"].value then
	data.raw.technology["tiberium-processing-tech"].unit.count = 100
	data.raw.technology["tiberium-molten-processing"].unit.count = 400
end

require("scripts/DynamicOreRecipes")
