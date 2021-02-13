-- Change when uploading to main/beta version, include 2 underscores on both sides
tiberiumInternalName = "__Factorio-Tiberium__"

if mods["Factorio-Tiberium"] and mods["Factorio-Tiberium-Beta"] then
	local message = "\n[font=default-large-bold][color=0,255,0]Don't run Tiberium and Tiberium Beta at the same time.[/color][/font]\n"
	error(message)
end

require("__LSlib__/LSlib")
require("prototype/item-groups")
require("prototype/item")
require("prototype/fluid")
require("prototype/resource")
require("prototype/technology")
require("prototype/entity/entity-initialization")
require("prototype/ammo-and-projectile")
require("prototype/equipment")
require("prototype/vehicle")
require("prototype/recipe")
require("prototype/damage-type")
require("prototype/recipe-settings")
require("prototype/sound")
require("scripts/informatron/informatron")
if mods["rusty-locale"] then require("scripts/localised_description") end

table.insert(data.raw.character.character.mining_categories, "basic-solid-tiberium")
