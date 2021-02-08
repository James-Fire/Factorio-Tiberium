local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local greenFugeTint = {r = 0.3, g = 0.8, b = 0.3, a = 0.8}

--Tiberium Centrifuge
data:extend{
	{
		type = "assembling-machine",
		name = "tiberium-centrifuge",
		icons = data.raw.item["tiberium-centrifuge"].icons,
		icon_size = 32,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 0.1, result = "tiberium-centrifuge"},
		max_health = 350,
		corpse = "centrifuge-remnants",
		dying_explosion = "centrifuge-explosion",
		fast_replaceable_group = "tib-centrifuge",
		next_upgrade = "tiberium-centrifuge-2",
		resistances = {
			{
				type = "fire",
				percent = 70
			},
			{
				type = "tiberium",
				percent = 70
			}
		},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		damaged_trigger_effect = hit_effects.entity(),
		drawing_box = {{-1.5, -2.2}, {1.5, 1.5}},
		fluid_boxes = {
			{
				production_type = "output",
				pipe_picture = assembler2pipepictures(),
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = 1,
				pipe_connections = {
					{type = "output", position = {1, -2}},
				},
				secondary_draw_orders = {north = -1},
				render_layer = "lower-object-above-shadow",
			},
			{
				production_type = "output",
				pipe_picture = assembler2pipepictures(),
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = 1,
				pipe_connections = {
					{type = "output", position = {-1, -2}}				
				},
				secondary_draw_orders = {north = -1},
				render_layer = "lower-object-above-shadow",
			},
			{
				production_type = "output",
				pipe_picture = assembler2pipepictures(),
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = 1,
				pipe_connections = {
					{type = "output", position = {-1, 2}}				
				},
				secondary_draw_orders = {north = -1},
				render_layer = "lower-object-above-shadow",
			},
			{
				production_type = "input",
				pipe_picture = assembler2pipepictures(),
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = -1,
				pipe_connections = {
					{type = "input", position = {1, 2}}
				},
				secondary_draw_orders = {south = -1},
				render_layer = "lower-object-above-shadow",
			},
			off_when_no_fluid_recipe = true
		},
		always_draw_idle_animation = true,
		idle_animation = {
			layers = {
				-- Centrifuge C
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
					tint = greenFugeTint,
					priority = "high",
					line_length = 8,
					width = 119,
					height = 107,
					frame_count = 64,
					shift = util.by_pixel(-0.5, -26.5),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C.png",
						tint = greenFugeTint,
						priority = "high",
						scale = 0.5,
						line_length = 8,
						width = 237,
						height = 214,
						frame_count = 64,
						shift = util.by_pixel(-0.25, -26.5)
					}
				},
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-C-shadow.png",
					draw_as_shadow = true,
					priority = "high",
					line_length = 8,
					width = 132,
					height = 74,
					frame_count = 64,
					shift = util.by_pixel(20, -10),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-shadow.png",
						draw_as_shadow = true,
						priority = "high",
						scale = 0.5,
						line_length = 8,
						width = 279,
						height = 152,
						frame_count = 64,
						shift = util.by_pixel(16.75, -10)
					}
				},
				-- Centrifuge B
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-B.png",
					priority = "high",
					line_length = 8,
					width = 78,
					height = 117,
					frame_count = 64,
					shift = util.by_pixel(23, 6.5),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B.png",
						priority = "high",
						scale = 0.5,
						line_length = 8,
						width = 156,
						height = 234,
						frame_count = 64,
						shift = util.by_pixel(23, 6.5)
					}
				},
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-B-shadow.png",
					draw_as_shadow = true,
					priority = "high",
					line_length = 8,
					width = 124,
					height = 74,
					frame_count = 64,
					shift = util.by_pixel(63, 16),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B-shadow.png",
						draw_as_shadow = true,
						priority = "high",
						scale = 0.5,
						line_length = 8,
						width = 251,
						height = 149,
						frame_count = 64,
						shift = util.by_pixel(63.25, 15.25)
					}
				},
				-- Centrifuge A
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-A.png",
					priority = "high",
					line_length = 8,
					width = 70,
					height = 123,
					frame_count = 64,
					shift = util.by_pixel(-26, 3.5),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A.png",
						priority = "high",
						scale = 0.5,
						line_length = 8,
						width = 139,
						height = 246,
						frame_count = 64,
						shift = util.by_pixel(-26.25, 3.5)
					}
				},
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-A-shadow.png",
					priority = "high",
					draw_as_shadow = true,
					line_length = 8,
					width = 108,
					height = 54,
					frame_count = 64,
					shift = util.by_pixel(6, 27),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A-shadow.png",
						priority = "high",
						draw_as_shadow = true,
						scale = 0.5,
						line_length = 8,
						width = 230,
						height = 124,
						frame_count = 64,
						shift = util.by_pixel(8.5, 23.5)
					}
				},
			},
		},
		animation = {
			layers = {
				-- Centrifuge C
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-C-light.png",
					priority = "high",
					blend_mode = "additive", -- centrifuge
					line_length = 8,
					width = 96,
					height = 104,
					frame_count = 64,
					shift = util.by_pixel(0, -27),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive", -- centrifuge
						line_length = 8,
						width = 190,
						height = 207,
						frame_count = 64,
						shift = util.by_pixel(0, -27.25)
					}
				},
				-- Centrifuge B
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-B-light.png",
					priority = "high",
					blend_mode = "additive", -- centrifuge
					line_length = 8,
					width = 65,
					height = 103,
					frame_count = 64,
					shift = util.by_pixel(16.5, 0.5),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-B-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive", -- centrifuge
						line_length = 8,
						width = 131,
						height = 206,
						frame_count = 64,
						shift = util.by_pixel(16.75, 0.5)
					}
				},
				-- Centrifuge A
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-A-light.png",
					priority = "high",
					blend_mode = "additive", -- centrifuge
					line_length = 8,
					width = 55,
					height = 98,
					frame_count = 64,
					shift = util.by_pixel(-23.5, -2),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-A-light.png",
						priority = "high",
						scale = 0.5,
						blend_mode = "additive", -- centrifuge
						line_length = 8,
						width = 108,
						height = 197,
						frame_count = 64,
						shift = util.by_pixel(-23.5, -1.75)
					}
				},
			}
		},
		working_visualisations = {
			{
				effect = "uranium-glow", -- changes alpha based on energy source light intensity
				light = {intensity = 0.6, size = 9.9, shift = {0.0, 0.0}, color = {r = 0.0, g = 1.0, b = 0.0}}
			}
		},
		open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.6},
		close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.6},
		vehicle_impact_sound = sounds.generic_impact,
		working_sound = {
			sound = {
				{
					filename = "__base__/sound/centrifuge-1.ogg",
					volume = 0.5
				},
				{
					filename = "__base__/sound/centrifuge-2.ogg",
					volume = 0.5
				}
			},
			fade_in_ticks = 10,
			fade_out_ticks = 30,
			max_sounds_per_type = 2,
			--idle_sound = {filename = "__base__/sound/idle1.ogg", volume = 0.3},
			apparent_volume = 1.5
		},
		crafting_speed = 1,
		crafting_categories = {"tiberium-centrifuge-1"},
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input",
			emissions_per_minute = 4
		},
		energy_usage = tostring(300 * (30 / 31)).."kW",  --Scale for nice max consumption
		module_specification = {module_slots = 0},
		allowed_effects = {"consumption", "speed", "productivity", "pollution"},
		water_reflection = {
			pictures = {
				filename = "__base__/graphics/entity/centrifuge/centrifuge-reflection.png",
				priority = "extra-high",
				width = 28,
				height = 32,
				shift = util.by_pixel(0, 65),
				variation_count = 1,
				scale = 5,
			},
			rotate = false,
			orientation_to_variation = false
		}
	}
}

--Tiberium Centrifuge 2
local centrifuge2Entity = util.table.deepcopy(data.raw["assembling-machine"]["tiberium-centrifuge"])
centrifuge2Entity.name = "tiberium-centrifuge-2"
centrifuge2Entity.next_upgrade = "tiberium-centrifuge-3"
centrifuge2Entity.energy_usage = tostring(500 * (30 / 31)).."kW"  -- Scale for nice max consumption
centrifuge2Entity.crafting_speed = 2
centrifuge2Entity.crafting_categories = {"tiberium-centrifuge-1", "tiberium-centrifuge-2"}
centrifuge2Entity.energy_source.emissions_per_minute = 8
centrifuge2Entity.icons = data.raw.item["tiberium-centrifuge-2"].icons
centrifuge2Entity.minable.result = "tiberium-centrifuge-2"
centrifuge2Entity.module_specification.module_slots = 2
for k, v in pairs(centrifuge2Entity.idle_animation.layers) do
	if v.filename == "__base__/graphics/entity/centrifuge/centrifuge-B.png" then
		v.tint = greenFugeTint
		if v.hr_version then
			v.hr_version.tint = greenFugeTint
		end
	end
end

--Tiberium Centrifuge 3
local centrifuge3Entity = util.table.deepcopy(data.raw["assembling-machine"]["tiberium-centrifuge"])
centrifuge3Entity.name = "tiberium-centrifuge-3"
centrifuge3Entity.next_upgrade = nil
centrifuge3Entity.energy_usage = tostring(700 * (30 / 31)).."kW"  -- Scale for nice max consumption
centrifuge3Entity.crafting_speed = 3
centrifuge3Entity.crafting_categories = {"tiberium-centrifuge-1", "tiberium-centrifuge-2", "tiberium-centrifuge-3"}
centrifuge3Entity.energy_source.emissions_per_minute = 12
centrifuge3Entity.icons = data.raw.item["tiberium-centrifuge-3"].icons
centrifuge3Entity.minable.result = "tiberium-centrifuge-3"
centrifuge3Entity.module_specification.module_slots = 4
for k, v in pairs(centrifuge3Entity.idle_animation.layers) do
	if (v.filename == "__base__/graphics/entity/centrifuge/centrifuge-A.png") or (v.filename == "__base__/graphics/entity/centrifuge/centrifuge-B.png") then
		v.tint = greenFugeTint
		if v.hr_version then
			v.hr_version.tint = greenFugeTint
		end
	end
end

data:extend{centrifuge2Entity, centrifuge3Entity}