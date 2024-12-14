-- Change when uploading to main/beta version, include 2 underscores on both sides
tiberiumInternalName = "__Factorio-Tiberium__"

if mods["Factorio-Tiberium"] and mods["Factorio-Tiberium-Beta"] then
	local message = "\n[font=default-large-bold][color=0,255,0]Don't run Tiberium and Tiberium Beta at the same time.[/color][/font]\n"
	error(message)
end

-- Additional fields parsed by this mod that can be set/overridden by other mods
---@class data.ItemPrototype
---@field tiberium_surface string Enter a planet name to lock centrifuging and transmutation of this item to that planet
---@field tiberium_sludge boolean Whether the item should be converted to sludge when doing alternate centrifuging recipes
---@field tiberium_empty_barrel boolean Whether the item should be treated as an empty barrel for purposes of classifying barreling/unbarreling recipes
---@field tiberium_resource_planet string Which planet this resource naturally occurs on for purposes of classifying alien ores for centrifuging
---@field tiberium_resource_exclusion boolean
---@field tiberium_multiplier number

---@class data.FluidPrototype
---@field tiberium_sludge boolean
---@field tiberium_multiplier number
---@field tiberium_resource_planet string Which planet this resource naturally occurs on for purposes of classifying alien ores for centrifuging
---@field tiberium_resource_exclusion boolean

---@class TiberiumPlanetRequirements
---@field restrictions (data.SurfaceCondition)[]
---@field technology string
---@field pack string

---@class data.PlanetPrototype
---@field tiberium_requirements TiberiumPlanetRequirements

---@class ProductDict
---@field [data.ItemID|data.FluidID] number

-- Additional fields used by other mods that we use for compatibility
---@class data.ResourceEntityPrototype
---@field exclude_from_rampant_resources boolean

---@class data.EntityPrototype
---@field se_allow_in_space boolean

---@class data.TechnologyPrototype
---@field check_science_packs_incompatibilities boolean

---@class EventData.dolly_moved_entity_id
---@field moved_entity LuaEntity
---@field start_pos MapPosition

---@class LuaPlayer
---@diagnostic disable-next-line: duplicate-doc-field
---@field physical_vehicle LuaEntity? Physical Vehicle is actually an entity, pls fix api

flib = require("__flib__.data-util")
flib_table = require("__flib__.table")
common = require("prototype.common")

require("prototype.item-groups")
require("prototype.item")
require("prototype.item-settings")
require("prototype.fluid")
require("prototype.sticker")
require("prototype.fire")
require("prototype.stream")
require("prototype.explosion")
require("prototype.planet")
require("prototype.resource")
require("prototype.technology")
require("prototype.technology-settings")
require("prototype.entity.entity-initialization")
require("prototype.ammo-and-projectile")
require("prototype.vehicle")
require("prototype.damage-type")
require("prototype.recipe")
require("prototype.recipe-settings")
require("prototype.sound")
require("prototype.achievement")
if mods["informatron"] then require("scripts.informatron.informatron") end
if mods["rusty-locale"] then require("scripts.localised_description") end
