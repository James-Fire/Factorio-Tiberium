local sonic_sprite = {
	layers = {
		{
			filename = tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png",
			priority = "extra-high",
			frame_count = 1,
			direction_count = 1,
			width = 128,
			height = 128,
			scale = 0.65,
			shift = {-0.1, -0.5},
		},
		{
			filename = tiberiumInternalName.."/graphics/entity/sonic-emitter/sonic-emitter-shadow.png",
			--priority = "extra-high",
			frame_count = 1,
			direction_count = 1,
			width = 155,
			height = 96,
			scale = 0.65,
			draw_as_shadow = true,
			shift = {1.3, 0.5}
		}
	}
}

data:extend{
	{
		type = "electric-energy-interface",
		name = "tiberium-sonic-emitter",
		icons = common.layeredIcons(tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png", 128,
				tiberiumInternalName.."/graphics/icons/tiberium-ore.png", 64, "ne"),
		flags = {"placeable-neutral", "player-creation"},
		collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
		selection_box = {{-1, -1}, {1, 1}},
		minable = {mining_time = 0.5, result = "tiberium-sonic-emitter"},
		max_health = 250,
		corpse = "laser-turret-remnants",
		dying_explosion = "laser-turret-explosion",
		working_sound =	{
			sound = {
			  filename = "__base__/sound/substation.ogg",
			  volume = 0.4
			},
			idle_sound = {
			  filename = "__base__/sound/accumulator-idle.ogg",
			  volume = 0.4
			},
			max_sounds_per_type = 3,
			audible_distance_modifier = 0.5,
			fade_in_ticks = 30,
			fade_out_ticks = 40,
			use_doppler_shift = false
		},
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		energy_source = {
			type = "electric",
			buffer_capacity = "2MJ",
			usage_priority = "secondary-input",
			input_flow_limit = "1200kW",
			output_flow_limit = "0W",
			drain = "200kW"
		},
		picture = sonic_sprite,
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
		radius_visualisation_specification = {
			sprite = {
				filename = "__core__/graphics/shoot-cursor-green.png",
				height = 183,
				width = 258,
			},
			distance = 15, --Need to scale this beyond the range because the circle in the sprite doesn't reach the edge
		},
	},
	{
		type = "fish",
		name = "tiberium-target-dummy",
		flags = {"placeable-off-grid", "placeable-neutral"},
		hidden = true,
		icon = common.blankPicture.filename,
		icon_size = 1,
		pictures = {common.blankPicture},
	},
}

local emitterBlue = flib.copy_prototype(data.raw["electric-energy-interface"]["tiberium-sonic-emitter"], "tiberium-sonic-emitter-blue")
emitterBlue.icons = common.layeredIcons(tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png", 128,
		tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png", 64, "ne")

data:extend{emitterBlue}