data:extend{
	{
		type = "fluid",
		name = "liquid-tiberium",
		base_color = {
			b = 0,
			g = 1,
			r = 0
		},
		default_temperature = 75,
		flow_color = {
			b = 0.1,
			g = 1.0,
			r = 0.1
		},
		flow_to_energy_ratio = 0.3,
		heat_capacity = "1kJ",
		icon = tiberiumInternalName.."/graphics/icons/fluid/liquid-tiberium.png",
		icon_size = 64,
		max_temperature = 1000,
		order = "a[fluid]-c[crude-oil]",
		fuel_value = "12.5MJ",
		emissions_multiplier = common.emissionMultiplier(3),
		pressure_to_speed_ratio = 0.4,
	},
	{
		type = "fluid",
		name = "molten-tiberium",
		base_color = {
			b = 0,
			g = 1,
			r = 0
		},
		default_temperature = 75,
		flow_color = {
			b = 0.1,
			g = 1.0,
			r = 0.1
		},
		flow_to_energy_ratio = 0.3,
		heat_capacity = "1kJ",
		icon = tiberiumInternalName.."/graphics/icons/fluid/molten-tiberium.png",
		icon_size = 64,
		max_temperature = 1000,
		order = "a[fluid]-c[crude-oil]",
		pressure_to_speed_ratio = 0.4,
	},
	{
		type = "fluid",
		name = "tiberium-sludge",
		base_color = {
			b = 0.3,
			g = 0.5,
			r = 0.3
		},
		default_temperature = 75,
		flow_color = {
			b = 0.3,
			g = 0.5,
			r = 0.3
		},
		flow_to_energy_ratio = 0.2,
		heat_capacity = "1kJ",
		icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-sludge.png",
		icon_size = 64,
		max_temperature = 1000,
		order = "a[fluid]-d[crude-oil]",
		pressure_to_speed_ratio = 0.2,
	},
	{
		type = "fluid",
		name = "tiberium-slurry",
		base_color = {
			b = 0,
			g = 0.7,
			r = 0
		},
		default_temperature = 50,
		flow_color = {
			b = 0,
			g = 0.7,
			r = 0
		},
		flow_to_energy_ratio = 0.5,
		heat_capacity = "1kJ",
		icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-waste.png",
		icon_size = 64,
		max_temperature = 1000,
		order = "a[fluid]-d[crude-oil]",
		pressure_to_speed_ratio = 0.05,
	},
	{
		type = "fluid",
		name = "tiberium-slurry-blue",
		base_color = {
			b = 1.0,
			g = 0.9,
			r = 0.1
		},
		default_temperature = 50,
		flow_color = {
			b = 1.0,
			g = 0.9,
			r = 0.1
		},
		flow_to_energy_ratio = 0.5,
		heat_capacity = "4kJ",
		icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-slurry-blue.png",
		icon_size = 64,
		max_temperature = 1000,
		order = "a[fluid]-d[crude-oil]",
		pressure_to_speed_ratio = 0.05,
	},
}