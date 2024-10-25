require("prototype/entity/tiberium-node-harvester")

local monocultureGreenAnimation = {
	layers = {
		{
			filename = tiberiumInternalName.."/graphics/entity/monoculture/monoculture-green.png",
			width = 256,
			height = 256,
			scale = 0.55,
			shift = {0, -0.9},
		},
		{
			filename = tiberiumInternalName.."/graphics/entity/monoculture/monoculture-shadow.png",
			draw_as_shadow = true,
			width = 304,
			height = 156,
			scale = 0.58,
			shift = {1.25, 0},
		}
	}
}
local monocultureBlueAnimation = {
	layers = {
		{	filename = tiberiumInternalName.."/graphics/entity/monoculture/monoculture-blue.png",
			width = 256,
			height = 256,
			scale = 0.55,
			shift = {0, -0.9},
		},
		{
			filename = tiberiumInternalName.."/graphics/entity/monoculture/monoculture-shadow.png",
			draw_as_shadow = true,
			width = 304,
			height = 156,
			scale = 0.58,
			shift = {1.25, 0},
		}
	}
}

--TODO: add shadows
data:extend{
	{
		type = "assembling-machine",
		name = "tiberium-monoculture-green",
		icons = common.layeredIcons(tiberiumInternalName.."/graphics/entity/monoculture/monoculture-green.png", 256, tiberiumInternalName.."/graphics/icons/tiberium-ore.png", 64, "sw"),
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "tiberium-monoculture-green"},
		placeable_by = {item = "tiberium-monoculture-green", count = 1},
		max_health = 250,
		corpse = "centrifuge-remnants",
		dying_explosion = "medium-explosion",
		crafting_speed = 1,
		fixed_recipe = "tiberium-monoculture-green-fixed-recipe",
		open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.85},
		close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.75},
		working_sound = {
			fade_in_ticks = 4,
			fade_out_ticks = 20,
			sound = {
				{
					filename = tiberiumInternalName.."/sound/Accelerator.ogg",
					volume = 0.15
				}
			},
			max_sounds_per_type = 3,
			match_speed_to_activity = true
		},
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		resistances = {
			{
				type = "fire",
				percent = 90
			},
			{
				type = "tiberium",
				percent = 100
			}
		},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		crafting_categories = {"tiberium-monoculture"},
		energy_usage = "50kW",
		energy_source =	{
			type = "electric",
			buffer_capacity = "1MJ",
			usage_priority = "primary-input",
			input_flow_limit = "400kW",
			output_flow_limit = "0kW",
			drain = "200kW",
			emissions_per_minute = common.scaledEmissions(4),
		},
		graphics_set = {
			animation = monocultureGreenAnimation,
			idle_animation = monocultureGreenAnimation,
			always_draw_idle_animation = true,
			working_visualisations = {
				{
					animation = {
						animation_speed = 0.4,
						filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-outer.png",
						frame_count = 47,
						height = 188,
						scale = 0.5,
						width = 90,
						line_length = 16,
						shift = {0, -4.05},
					},
					apply_recipe_tint = "primary",
					constant_speed = true,
					fadeout = true,
					render_layer = "wires",
				},
				{
					animation = {
						animation_speed = 0.4,
						filename = "__base__/graphics/entity/chemical-plant/chemical-plant-smoke-inner.png",
						frame_count = 47,
						height = 84,
						scale = 0.5,
						shift = {0.0625, -3.2375},
						width = 40,
						line_length = 16,
					},
					apply_recipe_tint = "secondary",
					constant_speed = true,
					fadeout = true,
					render_layer = "wires",
				}
			}
		}
	}
}

local monocultureBlue = table.deepcopy(data.raw["assembling-machine"]["tiberium-monoculture-green"])
monocultureBlue.name = "tiberium-monoculture-blue"
monocultureBlue.icons = common.layeredIcons(tiberiumInternalName.."/graphics/entity/monoculture/monoculture-blue.png", 256, tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png", 64, "sw")
monocultureBlue.minable = {mining_time = 2, result = "tiberium-monoculture-blue"}
monocultureBlue.placeable_by = {item = "tiberium-monoculture-blue", count = 1}
monocultureBlue.fixed_recipe = "tiberium-monoculture-blue-fixed-recipe"
monocultureBlue.graphics_set.animation = monocultureBlueAnimation
monocultureBlue.graphics_set.idle_animation = monocultureBlueAnimation

data:extend{monocultureBlue}

local moncultureNode = table.deepcopy(data.raw["mining-drill"]["tiberium-node-harvester"])
moncultureNode.name = "tiberium-monoculture-green-node"
moncultureNode.localised_name = {"entity-name.tiberium-monoculture-green"}
moncultureNode.localised_description = {"entity-description.tiberium-monoculture-green"}
moncultureNode.animations = monocultureGreenAnimation
moncultureNode.base_picture = monocultureGreenAnimation
moncultureNode.icons = table.deepcopy(data.raw["assembling-machine"]["tiberium-monoculture-green"].icons)
moncultureNode.graphics_set = nil
moncultureNode.integration_patch = nil
moncultureNode.wet_mining_graphics_set = nil
moncultureNode.vector_to_place_result = {0, 0}
moncultureNode.energy_usage = "1kW"
moncultureNode.collision_mask = common.makeCollisionMask({"water_tile", "player"})
moncultureNode.energy_source = {
	type = "void",
	emissions_per_minute = common.scaledEmissions(4),
}

local monocultureNodeBlue = table.deepcopy(moncultureNode)
monocultureNodeBlue.name = "tiberium-monoculture-blue-node"
monocultureNodeBlue.localised_name = {"entity-name.tiberium-monoculture-blue"}
monocultureNodeBlue.localised_description = {"entity-description.tiberium-monoculture-blue"}
monocultureNodeBlue.animations = monocultureBlueAnimation
monocultureNodeBlue.base_picture = monocultureBlueAnimation
monocultureNodeBlue.icons = table.deepcopy(data.raw["assembling-machine"]["tiberium-monoculture-blue"].icons)

data:extend{moncultureNode, monocultureNodeBlue}