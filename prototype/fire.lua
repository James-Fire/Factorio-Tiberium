data:extend{
	{
		type = "fire",
		name = "tiberium-chemical-sprayer-flame",
		add_fuel_cooldown = 10,
		burnt_patch_alpha_default = 0.4,
		burnt_patch_alpha_variations = {
			{
				alpha = 0.26000000000000001,
				tile = "stone-path"
			},
			{
				alpha = 0.23999999999999999,
				tile = "concrete"
			}
		},
		burnt_patch_lifetime = 1800,
		burnt_patch_pictures = {},
		damage_multiplier_decrease_per_tick = 0.005,
		damage_multiplier_increase_per_added_fuel = 1,
		damage_per_tick = {
			amount = 0.3,
			type = "tiberium"
		},
		delay_between_initial_flames = 10,
		emissions_per_second = {["pollution"] = 0.005},
		fade_in_duration = 30,
		fade_out_duration = 30,
		flags = {
			"placeable-off-grid",
			"not-on-map"
		},
		flame_alpha = 0.35,
		flame_alpha_deviation = 0.05,
		initial_lifetime = 120,
		lifetime_increase_by = 150,
		lifetime_increase_cooldown = 4,
		light = {
			intensity = 1,
			size = 20
		},
		maximum_damage_multiplier = 6,
		maximum_lifetime = 1800,
		maximum_spread_count = 100,
		pictures = {
			{
				animation_speed = 1,
				blend_mode = "normal",
				direction_count = 1,
				filename = tiberiumInternalName.."/graphics/entity/chemsprayer-stream/fire-flame-13.png",
				frame_count = 25,
				height = 118,
				line_length = 8,
				scale = 0.5,
				shift = {
					-0.01953125,
					-0.453125
				},
				tint = {
					a = 1,
					b = 1,
					g = 1,
					r = 1
				},
				width = 60
			},
		},
		spawn_entity = "fire-flame-on-tree",
		spread_delay = 300,
		spread_delay_deviation = 180,
		working_sound = {
			match_volume_to_activity = true,
			sound = {}
		}
	}
}
if data.raw.fire["fire-flame"] then
	data.raw.fire["tiberium-chemical-sprayer-flame"].burnt_patch_pictures = data.raw.fire["fire-flame"].burnt_patch_pictures
	if data.raw.fire["fire-flame"].working_sound then
		data.raw.fire["tiberium-chemical-sprayer-flame"].working_sound.sound = data.raw.fire["fire-flame"].working_sound.sound
	end
end