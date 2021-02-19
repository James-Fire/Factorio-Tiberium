local hit_effects = require ("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

--Tiberium Rounds Magazine
data:extend{
	{
		type = "ammo",
		name = "tiberium-rounds-magazine",
		icon = "__base__/graphics/icons/uranium-rounds-magazine.png",
		icon_size = 64,
		icon_mipmaps = 4,
		ammo_type = {
			category = "bullet",
			action = {
				type = "direct",
				action_delivery = {
					type = "instant",
					source_effects = {
						type = "create-explosion",
						entity_name = "explosion-gunshot"
					},
					target_effects = {
						{
							type = "create-entity",
							entity_name = "explosion-hit",
							offsets = {{0, 1}},
							offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}}
						},
						{
							type = "damage",
							damage = {amount = 15 , type = "tiberium"}
						}
					}
				}
			}
		},
		magazine_size = 10,
		subgroup = "a-items",
		order = "b[basic-clips]-d[tiberium-rounds-magazine]",
		stack_size = 200
	}
}

--Tiberium Core Missile
data:extend{
	{
		type = "ammo",
		name = "tiberium-rocket",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-rocket.png",
		icon_size = 64,
		ammo_type = {
			category = "rocket",
			action = {
				type = "direct",
				action_delivery = {
					type = "projectile",
					projectile = "tiberium-rocket",
					starting_speed = 0.1,
					source_effects = {
						type = "create-entity",
						entity_name = "explosion-hit",
					}
				}
			}
		},
		subgroup = "a-items",
		order = "c[rocket-launcher]-a[basic]",
		stack_size = 200
	},
	{
		type = "projectile",
		name = "tiberium-rocket",
		flags = {"not-on-map"},
		acceleration = 0.005,
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "create-entity",
						entity_name = "big-explosion"
					},
					{
						type = "damage",
						damage = {amount = 50, type = "explosion"}
					},
					{
						type = "damage",
						damage = {amount = 100, type = "tiberium"}
					},
					{
						type = "create-entity",
						entity_name = "small-scorchmark",
						check_buildability = true
					},
					{
						type = "nested-result",
						action = {
							type = "area",
							radius = 6.5,
							action_delivery = {
								type = "instant",
								target_effects = {
									{
										type = "damage",
										damage = {amount = 200, type = "tiberium"}
									},
									{
										type = "damage",
										damage = {amount = 100, type = "explosion"}
									},
									{
										type = "create-entity",
										entity_name = "explosion"
									}
								}
							}
						}
					}
				}
			}
		},
		light = {intensity = 0.5, size = 4},
		animation = {
			filename = "__base__/graphics/entity/rocket/rocket.png",
			frame_count = 8,
			line_length = 8,
			width = 9,
			height = 35,
			shift = {0, 0},
			priority = "high"
		},
		shadow = {
			filename = "__base__/graphics/entity/rocket/rocket-shadow.png",
			frame_count = 1,
			width = 7,
			height = 24,
			priority = "high",
			shift = {0, 0}
		},
		smoke = {
			{
				name = "smoke-fast",
				deviation = {0.15, 0.15},
				frequency = 1,
				position = {0, 1},
				slow_down_factor = 1,
				starting_frame = 3,
				starting_frame_deviation = 5,
				starting_frame_speed = 0,
				starting_frame_speed_deviation = 5
			}
		}
	},
}

--Liquid Tiberium Bomb
local tibNukeGroundZero = table.deepcopy(data.raw.projectile["atomic-bomb-ground-zero-projectile"])
tibNukeGroundZero.name = "tiberium-atomic-bomb-ground-zero-projectile"
tibNukeGroundZero.action[1].action_delivery.target_effects.upper_distance_threshold = 50
local groundZeroDamageEffect = table.deepcopy(tibNukeGroundZero.action[1].action_delivery.target_effects)
tibNukeGroundZero.action[1].action_delivery.target_effects = {groundZeroDamageEffect, table.deepcopy(groundZeroDamageEffect)}
tibNukeGroundZero.action[1].action_delivery.target_effects[2].damage = {amount = 250, type = "tiberium"}
tibNukeGroundZero.action[1].radius = 4

local tibNukeWave = table.deepcopy(data.raw.projectile["atomic-bomb-wave"])
tibNukeWave.name = "tiberium-atomic-bomb-wave"
tibNukeWave.action[1].action_delivery.target_effects.upper_distance_threshold = 50
local waveDamageEffect = table.deepcopy(tibNukeWave.action[1].action_delivery.target_effects)
tibNukeWave.action[1].action_delivery.target_effects = {waveDamageEffect, table.deepcopy(waveDamageEffect)}
tibNukeWave.action[1].action_delivery.target_effects[2].damage = {amount = 1000, type = "tiberium"}
tibNukeWave.action[1].radius = 4

data:extend{tibNukeGroundZero, tibNukeWave,
	{
		type = "ammo",
		name = "tiberium-nuke",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-nuke.png",
		icon_size = 64,
		ammo_type = {
			range_modifier = 5,
			cooldown_modifier = 3,
			target_type = "position",
			category = "rocket",
			action = {
				type = "direct",
				action_delivery = {
					type = "projectile",
					projectile = "tiberium-nuke",
					starting_speed = 0.05,
					source_effects = {
						type = "create-entity",
						entity_name = "explosion-hit"
					}
				}
			}
		},
		subgroup = "a-items",
		order = "c[rocket-launcher]-b[atomic-bomb]",
		stack_size = 10
	},
	{
		type = "projectile",
		name = "tiberium-nuke",
		flags = {"not-on-map"},
		acceleration = 0.005,
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
			{
						type = "set-tile",
						tile_name = "nuclear-ground",
						apply_projection = true,
						radius = 12,
						tile_collision_mask = {"water-tile"}
					},
			{
						type = "destroy-cliffs",
						explosion = "explosion",
						radius = 12
					},
			{
						type = "camera-effect",
						delay = 0,
						duration = 60,
						ease_in_duration = 5,
						ease_out_duration = 60,
						effect = "screen-burn",
						full_strength_max_distance = 200,
						max_distance = 800,
						strength = 6,
					},
					{
						type = "play-sound",
						audible_distance_modifier = 3,
						max_distance = 1000,
						play_on_target_position = false,
						sound = {
							aggregation = {
								max_count = 1,
								remove = true
							},
							variations = {
								{
									filename = "__base__/sound/fight/nuclear-explosion-1.ogg",
									volume = 0.9
								},
								{
									filename = "__base__/sound/fight/nuclear-explosion-2.ogg",
									volume = 0.9
								},
								{
									filename = "__base__/sound/fight/nuclear-explosion-3.ogg",
									volume = 0.9
								}
							}
						}
					},
					{
						type = "play-sound",
						audible_distance_modifier = 3,
						max_distance = 1000,
						play_on_target_position = false,
						sound = {
							aggregation = {
								max_count = 1,
								remove = true
							},
							variations = {
								{
									filename = "__base__/sound/fight/nuclear-explosion-aftershock.ogg",
									volume = 0.4
								}
							}
						}
					},
					{
						type = "create-entity",
						entity_name = "nuke-explosion"
					},
					{
						type = "damage",
						damage = {amount = 400, type = "explosion"}
					},
			{
						type = "damage",
						damage = {amount = 1000, type = "tiberium"}
					},
			{
						type = "destroy-decoratives",
						decoratives_with_trigger_only = false,
						include_decals = true,
						include_soft_decoratives = true,
						invoke_decorative_trigger = true,
						radius = 14
					},
					{
						type = "create-decorative",
						apply_projection = true,
						decorative = "nuclear-ground-patch",
						spawn_max = 40,
						spawn_max_radius = 12.5,
						spawn_min = 30,
						spawn_min_radius = 11.5,
						spread_evenly = true
					},
					{
						type = "create-entity",
						entity_name = "huge-scorchmark",
						check_buildability = true
					},
			{
						type = "nested-result",
						action = {
							type = "area",
							action_delivery = {
								type = "projectile",
								projectile = "tiberium-atomic-bomb-ground-zero-projectile",
								starting_speed = 0.47999999999999998,
								starting_speed_deviation = 0.075,
							},
							radius = 10,
							repeat_count = 1000,
							target_entities = false,
							trigger_from_target = true,
						},
					},
					{
						type = "nested-result",
						action = {
							type = "area",
							action_delivery = {
								type = "projectile",
								projectile = "tiberium-atomic-bomb-wave",
								starting_speed = 0.35,
								starting_speed_deviation = 0.075,
							},
							radius = 50,
							repeat_count = 2000,
							target_entities = false,
							trigger_from_target = true,
						},
					},
					{
						type = "nested-result",
						action = {
							type = "area",
							action_delivery = {
								type = "projectile",
								projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
								starting_speed = 0.35,
								starting_speed_deviation = 0.075,
							},
							radius = 37,
							repeat_count = 1000,
							show_in_tooltip = false,
							target_entities = false,
							trigger_from_target = true,
						},
					},
					{
						type = "nested-result",
						action = {
							type = "area",
							action_delivery = {
								type = "projectile",
								projectile = "atomic-bomb-wave-spawns-fire-smoke-explosion",
								starting_speed = 0.325,
								starting_speed_deviation = 0.075,
							},
							radius = 5,
							repeat_count = 700,
							show_in_tooltip = false,
							target_entities = false,
							trigger_from_target = true,
						},
					},
					{
						type = "nested-result",
						action = {
							type = "area",
							action_delivery = {
								type = "projectile",
								projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
								starting_speed = 0.325,
								starting_speed_deviation = 0.075,
							},
							radius = 10,
							repeat_count = 1000,
							show_in_tooltip = false,
							target_entities = false,
							trigger_from_target = true,
						},
					},
					{
						type = "nested-result",
						action = {
							type = "area",
							action_delivery = {
								type = "projectile",
								projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
								starting_speed = 0.325,
								starting_speed_deviation = 0.075,
							},
							radius = 37,
							repeat_count = 300,
							show_in_tooltip = false,
							target_entities = false,
							trigger_from_target = true,
						},
					},
					{
						type = "nested-result",
						action = {
							type = "area",
							action_delivery = {
								type = "instant",
								target_effects = {
									{
										type = "create-entity",
										entity_name = "nuclear-smouldering-smoke-source",
										tile_collision_mask = {"water-tile"},
									}
								},
							},
							radius = 10,
							repeat_count = 10,
							show_in_tooltip = false,
							target_entities = false,
							trigger_from_target = true,
						},
					}
				}
			}
		},
		light = {intensity = 0.8, size = 15},
		animation = {
			filename = "__base__/graphics/entity/rocket/rocket.png",
			frame_count = 8,
			line_length = 8,
			width = 9,
			height = 35,
			shift = {0, 0},
			priority = "high"
		},
		shadow = {
			filename = "__base__/graphics/entity/rocket/rocket-shadow.png",
			frame_count = 1,
			width = 7,
			height = 24,
			priority = "high",
			shift = {0, 0}
		},
		smoke = {
			{
				name = "smoke-fast",
				deviation = {0.15, 0.15},
				frequency = 1,
				position = {0, 1},
				slow_down_factor = 1,
				starting_frame = 3,
				starting_frame_deviation = 5,
				starting_frame_speed = 0,
				starting_frame_speed_deviation = 5
			}
		}
	},
}

--Liquid Tiberium Seed
data:extend{
	{
		type = "ammo",
		name = "tiberium-seed",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-seed-rocket.png",
		icon_size = 64,
		ammo_type = {
			range_modifier = 5,
			cooldown_modifier = 3,
			target_type = "position",
			category = "rocket",
			action = {
				type = "direct",
				action_delivery = {
					type = "projectile",
					projectile = "tiberium-seed",
					starting_speed = 0.05,
					source_effects = {
						type = "create-entity",
						entity_name = "explosion-hit"
					}
				}
			}
		},
		subgroup = "a-items",
		order = "c[rocket-launcher]-c[seed-missile]",
		stack_size = 10
	},
	{
		type = "projectile",
		name = "tiberium-seed",
		flags = {"not-on-map"},
		acceleration = 0.005,
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "script",
						effect_id = "seed-launch"
					},
				}
			}
		},
		light = {intensity = 0.8, size = 15},
		animation = {
			filename = "__base__/graphics/entity/rocket/rocket.png",
			frame_count = 8,
			line_length = 8,
			width = 9,
			height = 35,
			shift = {0, 0},
			priority = "high"
		},
		shadow = {
			filename = "__base__/graphics/entity/rocket/rocket-shadow.png",
			frame_count = 1,
			width = 7,
			height = 24,
			priority = "high",
			shift = {0, 0}
		},
		smoke = {
			{
				name = "smoke-fast",
				deviation = {0.15, 0.15},
				frequency = 1,
				position = {0, 1},
				slow_down_factor = 1,
				starting_frame = 3,
				starting_frame_deviation = 5,
				starting_frame_speed = 0,
				starting_frame_speed_deviation = 5
			}
		}
	},
}

--Chemsprayer Ammo
data:extend{
	{
		type = "ammo",
		name = "tiberium-chemical-sprayer-ammo",
		ammo_type = {
			{
				action = {
					action_delivery = {
						stream = "tiberium-chemical-sprayer-stream",
						type = "stream"
					},
					type = "direct"
				},
				category = "flamethrower",
				clamp_position = true,
				source_type = "default",
				target_type = "position"
			},
			{
				action = {
					action_delivery = {
						stream = "tiberium-chemical-sprayer-stream",
						type = "stream"
					},
					type = "direct"
				},
				category = "flamethrower",
				clamp_position = true,
				consumption_modifier = 1.125,
				source_type = "vehicle",
				target_type = "position"
			}
		},
		icon = tiberiumInternalName.."/graphics/icons/chemical-sprayer-ammo.png",
		icon_size = 190,
		magazine_size = 100,
		order = "e[flamethrower]",
		stack_size = 100,
		subgroup = "a-items",
	},
}