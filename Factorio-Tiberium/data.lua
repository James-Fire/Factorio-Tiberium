-- Change when uploading to main/beta version, include 2 underscores on both sides
tiberiumInternalName = "__Factorio-Tiberium__"

if mods["Factorio-Tiberium"] and mods["Factorio-Tiberium-Beta"] then
	local message = "\n[font=default-large-bold][color=0,255,0]Don't run Tiberium and Tiberium Beta at the same time.[/color][/font]\n"
	error(message)
end

require("__LSlib__/LSlib")
require("scripts/item-groups")
require("scripts/TiberiumOre")
require("scripts/recipe")
require("scripts/technology")
require("scripts/TiberiumControlNetwork")
require("scripts/TiberiumPowerPlant")
require("scripts/Tiberium Combat")
require("scripts/damage-type")
require("scripts/recipe_autogeneration")
require("scripts/informatron/informatron")
require("scripts/tib-map-gen-presets")
