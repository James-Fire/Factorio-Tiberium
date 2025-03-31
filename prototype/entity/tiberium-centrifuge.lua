local greenFugeTint = {r = 0.3, g = 0.8, b = 0.3, a = 0.8}

--Tiberium Centrifuge
data:extend{
	{
		type = "assembling-machine",
		name = "tiberium-centrifuge-1",
		icons = data.raw.item["tiberium-centrifuge-1"].icons,
		icon_size = 32,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 0.1, result = "tiberium-centrifuge-1"},
		max_health = 350,
		corpse = "centrifuge-remnants",
		dying_explosion = "centrifuge-explosion",
		drawing_box_vertical_extension = 0.7,
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
		damaged_trigger_effect = common.hit_effects.entity(),
		fluid_boxes_off_when_no_fluid_recipe = true,
		fluid_boxes = {
			{
				production_type = "output",
				pipe_picture = assembler2pipepictures(),
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = 1,
				volume = 100,
				pipe_connections = {
					{flow_direction = "output", direction = defines.direction.north, position = {1, -1}},
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
				volume = 100,
				pipe_connections = {
					{flow_direction = "output", direction = defines.direction.north, position = {-1, -1}}
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
				volume = 100,
				pipe_connections = {
					{flow_direction = "output", direction = defines.direction.south, position = {-1, 1}}
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
				volume = 200,
				pipe_connections = {
					{flow_direction = "input", direction = defines.direction.south, position = {1, 1}}
				},
				secondary_draw_orders = {south = -1},
				render_layer = "lower-object-above-shadow",
			},
		},
		graphics_set = data.raw["assembling-machine"]["centrifuge"] and util.copy(data.raw["assembling-machine"]["centrifuge"].graphics_set) or {},
		open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.6},
		close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.6},
		impact_category = "metal-large",
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
			emissions_per_minute = common.scaledEmissions(4),
		},
		energy_usage = tostring(300 * (30 / 31)).."kW",  --Scale for nice max consumption
		module_slots = 0,
		allowed_effects = {"consumption", "speed", "productivity", "pollution"},
		water_reflection = data.raw["assembling-machine"]["centrifuge"] and util.copy(data.raw["assembling-machine"]["centrifuge"].water_reflection) or {},
	}
}

for _, layer in pairs(data.raw["assembling-machine"]["tiberium-centrifuge-1"].graphics_set.idle_animation.layers) do
	if layer.filename == "__base__/graphics/entity/centrifuge/centrifuge-C.png" then
		layer.tint = greenFugeTint
	end
end

--Tiberium Centrifuge 2
local centrifuge2Entity = util.copy(data.raw["assembling-machine"]["tiberium-centrifuge-1"])
centrifuge2Entity.name = "tiberium-centrifuge-2"
centrifuge2Entity.next_upgrade = "tiberium-centrifuge-3"
centrifuge2Entity.energy_usage = tostring(500 * (30 / 31)).."kW"  -- Scale for nice max consumption
centrifuge2Entity.crafting_speed = 2
centrifuge2Entity.crafting_categories = {"tiberium-centrifuge-1", "tiberium-centrifuge-2"}
centrifuge2Entity.energy_source.emissions_per_minute = common.scaledEmissions(4, 2)
centrifuge2Entity.icons = data.raw.item["tiberium-centrifuge-2"].icons
centrifuge2Entity.minable.result = "tiberium-centrifuge-2"
centrifuge2Entity.module_slots = 2
for k, v in pairs(centrifuge2Entity.graphics_set.idle_animation.layers) do
	if v.filename == "__base__/graphics/entity/centrifuge/centrifuge-B.png" then
		v.tint = greenFugeTint
	end
end

--Tiberium Centrifuge 3
local centrifuge3Entity = util.copy(data.raw["assembling-machine"]["tiberium-centrifuge-1"])
centrifuge3Entity.name = "tiberium-centrifuge-3"
centrifuge3Entity.next_upgrade = nil
centrifuge3Entity.energy_usage = tostring(700 * (30 / 31)).."kW"  -- Scale for nice max consumption
centrifuge3Entity.crafting_speed = 3
centrifuge3Entity.crafting_categories = {"tiberium-centrifuge-1", "tiberium-centrifuge-2", "tiberium-centrifuge-3"}
centrifuge3Entity.energy_source.emissions_per_minute = common.scaledEmissions(4, 3)
centrifuge3Entity.icons = data.raw.item["tiberium-centrifuge-3"].icons
centrifuge3Entity.minable.result = "tiberium-centrifuge-3"
centrifuge3Entity.module_slots = 4
for k, v in pairs(centrifuge3Entity.graphics_set.idle_animation.layers) do
	if (v.filename == "__base__/graphics/entity/centrifuge/centrifuge-A.png") or (v.filename == "__base__/graphics/entity/centrifuge/centrifuge-B.png") then
		v.tint = greenFugeTint
	end
end

data:extend{centrifuge2Entity, centrifuge3Entity}

if common.tierZero then
	local centrifuge0Entity = util.copy(data.raw["assembling-machine"]["tiberium-centrifuge-1"])
	centrifuge0Entity.name = "tiberium-centrifuge-0"
	centrifuge0Entity.next_upgrade = "tiberium-centrifuge-1"
	centrifuge0Entity.energy_usage = "150kW"
	centrifuge0Entity.crafting_speed = 0.5
	centrifuge0Entity.crafting_categories = {"tiberium-centrifuge-0"}
	centrifuge0Entity.energy_source = {
		type = "burner",
		usage_priority = "secondary-input",
		emissions_per_minute = common.scaledEmissions(4),
		fuel_inventory_size = 1,
		smoke = {
			{
				deviation = {0.1, 0.1},
				frequency = 5,
				name = "smoke",
				position = {0, -1},
				starting_frame_deviation = 60,
				starting_vertical_speed = 0.08
			}
		}
	}
	centrifuge0Entity.icons = nil
	centrifuge0Entity.icon = tiberiumInternalName.."/graphics/icons/centrifuge.png"
	centrifuge0Entity.icon_size = 64
	centrifuge0Entity.module_slots = 0
	centrifuge0Entity.minable.result = "tiberium-centrifuge-0"
	centrifuge0Entity.graphics_set.idle_animation = data.raw["assembling-machine"].centrifuge.graphics_set.idle_animation
	data:extend{centrifuge0Entity}

	for _, fuge in pairs({"tiberium-centrifuge-1", "tiberium-centrifuge-2", "tiberium-centrifuge-3"}) do
		table.insert(data.raw["assembling-machine"][fuge].crafting_categories, "tiberium-centrifuge-0")
	end
end
