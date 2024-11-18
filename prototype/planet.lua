if common.whichPlanet == "nauvis" or common.whichPlanet == "pure-nauvis" then return end

--Tiles
local tile1 = flib.copy_prototype(data.raw.tile["highland-dark-rock-2"], "tiber-highland-dark-rock-2")
tile1.autoplace = {probability_expression = "expression_in_range_base(-10, 0.7, 11, 11) + noise_layer_noise(19)"}  --grass-1
local tile2 = flib.copy_prototype(data.raw.tile["midland-cracked-lichen-dark"], "tiber-midland-cracked-lichen-dark")
tile2.autoplace = {probability_expression = "expression_in_range_base(0.45, 0.45, 11, 0.8) + noise_layer_noise(20)"}  --grass-2
local tile3 = flib.copy_prototype(data.raw.tile["midland-cracked-lichen-dull"], "tiber-midland-cracked-lichen-dull")
tile3.autoplace = {probability_expression = "expression_in_range_base(-10, 0.6, 0.65, 0.9) + noise_layer_noise(21)"}  --grass-3
local tile4 = flib.copy_prototype(data.raw.tile["pit-rock"], "tiber-pit-rock")
tile4.autoplace = {probability_expression = "expression_in_range_base(-10, 0.5, 0.55, 0.7) + noise_layer_noise(22)"}  -- grass-4
data:extend{tile1, tile2, tile3, tile4}

data:extend{
	{
		type = "planet",
		name = "tiber",
		asteroid_spawn_definitions = {
			{
				angle_when_stopped = 1,
				asteroid = "metallic-asteroid-chunk",
				probability = 0.0125,
				speed = 0.016666666666666665,
				type = "asteroid-chunk"
			},
			{
				angle_when_stopped = 1,
				asteroid = "carbonic-asteroid-chunk",
				probability = 0.0083333333333333321,
				speed = 0.016666666666666665,
				type = "asteroid-chunk"
			},
			{
				angle_when_stopped = 1,
				asteroid = "oxide-asteroid-chunk",
				probability = 0.0041666666666666661,
				speed = 0.016666666666666665,
				type = "asteroid-chunk"
			}
		},
		asteroid_spawn_influence = 1,
		distance = 15,
		gravity_pull = 10,
		icon = tiberiumInternalName.."/graphics/icons/tiber-planet.png",
		icon_size = 512,
		magnitude = 1,
		map_gen_settings = {
			autoplace_controls = {
				--coal = {},
				--["copper-ore"] = {},
				--["crude-oil"] = {},
				--["enemy-base"] = {},
				--["iron-ore"] = {},
				nauvis_cliff = {},
				rocks = {},
				starting_area_moisture = {},
				--stone = {},
				trees = {},
				--["uranium-ore"] = {},
				water = {}
			},
			autoplace_settings = {
				decorative = {
					settings = {
						["brown-asterisk"] = {},
						["brown-asterisk-mini"] = {},
						["brown-carpet-grass"] = {},
						["brown-fluff"] = {},
						["brown-fluff-dry"] = {},
						["brown-hairy-grass"] = {},
						["cracked-mud-decal"] = {},
						["dark-mud-decal"] = {},
						--garballo = {},
						["garballo-mini-dry"] = {},
						--["green-asterisk"] = {},
						--["green-asterisk-mini"] = {},
						--["green-bush-mini"] = {},
						--["green-carpet-grass"] = {},
						--["green-croton"] = {},
						--["green-desert-bush"] = {},
						--["green-hairy-grass"] = {},
						--["green-pita"] = {},
						--["green-pita-mini"] = {},
						--["green-small-grass"] = {},
						["light-mud-decal"] = {},
						["medium-rock"] = {},
						["medium-sand-rock"] = {},
						["red-asterisk"] = {},
						["red-croton"] = {},
						["red-desert-bush"] = {},
						["red-desert-decal"] = {},
						["red-pita"] = {},
						["sand-decal"] = {},
						["sand-dune-decal"] = {},
						["small-rock"] = {},
						["small-sand-rock"] = {},
						["tiny-rock"] = {},
						["white-desert-bush"] = {}
					}
				},
				entity = {
					settings = {
						["big-rock"] = {},
						["big-sand-rock"] = {},
						--coal = {},
						--["copper-ore"] = {},
						--["crude-oil"] = {},
						fish = {},
						["huge-rock"] = {},
						--["iron-ore"] = {},
						--stone = {},
						--["uranium-ore"] = {},
						["tiberium-tiber-rock"] = {}
					}
				},
				tile = {
					settings = {
						deepwater = {},
						["dirt-1"] = {},
						["dirt-2"] = {},
						["dirt-3"] = {},
						["dirt-4"] = {},
						["dirt-5"] = {},
						["dirt-6"] = {},
						["dirt-7"] = {},
						["dry-dirt"] = {},
						--["grass-1"] = {},
						--["grass-2"] = {},
						--["grass-3"] = {},
						--["grass-4"] = {},
						["red-desert-0"] = {},
						["red-desert-1"] = {},
						["red-desert-2"] = {},
						["red-desert-3"] = {},
						["sand-1"] = {},
						["sand-2"] = {},
						["sand-3"] = {},
						water = {},
						--Borrowed from other planets
						["tiber-highland-dark-rock-2"] = {},
						["tiber-midland-cracked-lichen-dark"] = {},
						["tiber-midland-cracked-lichen-dull"] = {},
						["tiber-pit-rock"] = {},
						--["dust-patchy"] = {},
						--["dust-lumpy"] = {},
					}
				}
			},
			aux_climate_control = true,
			cliff_settings = {
				cliff_smoothing = 0,
				control = "nauvis_cliff",
				name = "cliff"
			},
			moisture_climate_control = true,
			property_expression_names = {}
		},
		map_seed_offset = 0,
		order = "a[tiber]",
		orientation = 0.375,
		persistent_ambient_sounds = {
			base_ambience = {
				filename = "__base__/sound/world/world_base_wind.ogg",
				volume = 0.3
			},
			crossfade = {
				curve_type = "cosine",
				from = {
					control = 0.35,
					volume_percentage = 0
				},
				order = {
					"wind",
					"base_ambience"
				},
				to = {
					control = 2,
					volume_percentage = 100
				}
			},
			wind = {
				filename = "__base__/sound/wind/wind.ogg",
				volume = 0.8
			}
		},
		planet_procession_set = {
			arrival = {
				"platform-to-planet-b"
			},
			departure = {
				"planet-to-platform-a"
			}
		},
		platform_procession_set = {
			arrival = {
				"planet-to-platform-b"
			},
			departure = {
				"platform-to-planet-a"
			}
		},
		pollutant_type = "pollution",
		procession_graphic_catalogue = {
			{
				index = 400,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/procession/clouds/nauvis-cloudscape.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 960,
					line_length = 1,
					priority = "no-atlas",
					scale = 0.5,
					shift = {
						0.703125,
						-0.3125
					},
					width = 960
				},
				type = "sprite"
			},
			{
				index = 401,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/procession/clouds/mask-cloudscape.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 960,
					line_length = 1,
					priority = "no-atlas",
					scale = 0.5,
					shift = {
						-1.21875,
						0.265625
					},
					width = 960
				},
				type = "sprite"
			},
			{
				index = 402,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/procession/clouds/nauvis-cloudscape-layered-0.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 1500,
					line_length = 1,
					priority = "no-atlas",
					scale = 0.5,
					shift = {
						0.015625,
						-0.96875
					},
					width = 2000
				},
				type = "sprite"
			},
			{
				index = 403,
				sprite = {
					filename = "__space-age__/graphics/procession/clouds/mask-cloudscape-layered-0.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 1500,
					priority = "no-atlas",
					width = 2000
				},
				type = "sprite"
			},
			{
				index = 404,
				sprite = {
					filename = "__space-age__/graphics/procession/clouds/nauvis-cloudscape-layered-1.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 1200,
					priority = "no-atlas",
					width = 1600
				},
				type = "sprite"
			},
			{
				index = 405,
				sprite = {
					filename = "__space-age__/graphics/procession/clouds/mask-cloudscape-layered-1.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 1200,
					priority = "no-atlas",
					width = 1600
				},
				type = "sprite"
			},
			{
				index = 406,
				sprite = {
					filename = "__space-age__/graphics/procession/clouds/nauvis-cloudscape-layered-2.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 1050,
					priority = "no-atlas",
					width = 1400
				},
				type = "sprite"
			},
			{
				index = 407,
				sprite = {
					filename = "__space-age__/graphics/procession/clouds/mask-cloudscape-layered-2.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 1050,
					priority = "no-atlas",
					width = 1400
				},
				type = "sprite"
			},
			{
				index = 408,
				sprite = {
					filename = "__space-age__/graphics/procession/clouds/nauvis-cloudscape-layered-3.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 900,
					priority = "no-atlas",
					width = 1200
				},
				type = "sprite"
			},
			{
				index = 409,
				sprite = {
					filename = "__space-age__/graphics/procession/clouds/mask-cloudscape-layered-3.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 900,
					priority = "no-atlas",
					width = 1200
				},
				type = "sprite"
			},
			{
				index = 301,
				sprite = {
					filename = "__space-age__/graphics/procession/space-rear-star.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 1024,
					priority = "no-atlas",
					width = 1024
				},
				type = "sprite"
			},
			{
				index = 450,
				sprite = {
					filename = "__space-age__/graphics/procession/clouds/nauvis-sky-tint.png",
					flags = {
						"group=effect-texture",
						"linear-minification",
						"linear-magnification"
					},
					height = 16,
					priority = "no-atlas",
					width = 16
				},
				type = "sprite"
			},
			{
				index = 509,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/entity/cargo-hubs/hatches/shared-cargo-bay-pod-emission.png",
					height = 120,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						0.21062500000000002,
						0.109375
					},
					width = 196
				}
			},
			{
				index = 500,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/entity/cargo-hubs/hatches/platform-lower-hatch-pod-emission-A.png",
					height = 268,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						0.75,
						-0.359375
					},
					width = 302
				}
			},
			{
				index = 501,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/entity/cargo-hubs/hatches/platform-lower-hatch-pod-emission-B.png",
					height = 286,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						-0.4375,
						-0.703125
					},
					width = 276
				}
			},
			{
				index = 502,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/entity/cargo-hubs/hatches/platform-lower-hatch-pod-emission-C.png",
					height = 308,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						1.046875,
						-1.125
					},
					width = 322
				}
			},
			{
				index = 503,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/entity/cargo-hubs/hatches/platform-upper-hatch-pod-emission-A.png",
					height = 310,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						0.84375,
						-0.375
					},
					width = 340
				}
			},
			{
				index = 504,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/entity/cargo-hubs/hatches/platform-upper-hatch-pod-emission-B.png",
					height = 318,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						-1.234375,
						-0.28125
					},
					width = 402
				}
			},
			{
				index = 505,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__space-age__/graphics/entity/cargo-hubs/hatches/platform-upper-hatch-pod-emission-C.png",
					height = 318,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						0.078125,
						-1.359375
					},
					width = 348
				}
			},
			{
				index = 506,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-A.png",
					height = 316,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						0.703125,
						-0.3125
					},
					width = 356
				}
			},
			{
				index = 507,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-B.png",
					height = 388,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						-1.21875,
						0.265625
					},
					width = 402
				}
			},
			{
				index = 508,
				sprite = {
					blend_mode = "additive",
					draw_as_glow = true,
					filename = "__base__/graphics/entity/cargo-hubs/hatches/planet-lower-hatch-pod-emission-C.png",
					height = 358,
					line_length = 1,
					priority = "medium",
					scale = 0.5,
					shift = {
						0.015625,
						-0.96875
					},
					width = 350
				}
			}
		},
		solar_power_in_space = 300,
		starmap_icon = tiberiumInternalName.."/graphics/icons/tiber-planet.png",
		starmap_icon_size = 512,
		subgroup = "planets",
		surface_properties = {
			["day-night-cycle"] = 28800,
			pressure = 900,
		},
		surface_render_parameters = {
			clouds = {
				additional_density_sample = {
					scale = 0.0084375,
					wind_speed_factor = 1.77
				},
				detail_noise_texture = {
					filename = "__core__/graphics/clouds-detail-noise.png",
					size = 2048
				},
				detail_sample_1 = {
					scale = 0.053406250000000002,
					wind_speed_factor = 0.11702750146284377
				},
				detail_sample_2 = {
					scale = 0.068093749999999993,
					wind_speed_factor = 0.091785222579164767
				},
				detail_sample_morph_duration = 256,
				movement_speed_multiplier = 0.75,
				opacity = 0.25,
				scale = 1,
				shape_noise_texture = {
					filename = "__core__/graphics/clouds-noise.png",
					size = 2048
				},
				shape_warp_strength = 0.06,
				shape_warp_weight = 0.4,
				warp_sample_1 = {
					scale = 0.05
				},
				warp_sample_2 = {
					scale = 0.09375,
					wind_speed_factor = 0
				},
				warped_shape_sample = {
					scale = 0.01125
				}
			}
		},
	},
	{
		type = "space-connection",
		name = "tiber-fulgora",
		from = "tiber",
		to = "fulgora",
		length = 15000,
		icons = {
			{
				icon = "__space-age__/graphics/icons/planet-route.png"
			},
			{
				icon = tiberiumInternalName.."/graphics/icons/tiber-planet.png",
				icon_size = 512,
				scale = 0.33300000000000001 * 64 / 512,
				shift = {
					-6,
					-6
				}
			},
			{
				icon = "__space-age__/graphics/icons/fulgora.png",
				icon_size = 64,
				scale = 0.33300000000000001,
				shift = {
					6,
					6
				}
			}
		},
		order = "c",
		subgroup = "planet-connections",
		asteroid_spawn_definitions = {
			{
				asteroid = "metallic-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0125,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.0025,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "carbonic-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0083333333333333321,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.001875,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "oxide-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0041666666666666661,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.000625,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "medium-metallic-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0075,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.0025,
						speed = 0.016666666666666665
					}
				}
			},
			{
				asteroid = "medium-carbonic-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0053124999999999991,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.001875,
						speed = 0.016666666666666665
					}
				}
			},
			{
				asteroid = "medium-oxide-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0021875,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.000625,
						speed = 0.016666666666666665
					}
				}
			}
		},
	},
	{
		type = "space-connection",
		name = "tiber-nauvis",
		from = "tiber",
		to = "nauvis",
		length = 15000,
		icons = {
			{
				icon = "__space-age__/graphics/icons/planet-route.png"
			},
			{
				icon = tiberiumInternalName.."/graphics/icons/tiber-planet.png",
				icon_size = 512,
				scale = 0.33300000000000001 * 64 / 512,
				shift = {
					-6,
					-6
				}
			},
			{
				icon = "__base__/graphics/icons/nauvis.png",
				icon_size = 64,
				scale = 0.33300000000000001,
				shift = {
					6,
					6
				}
			}
		},
		order = "c",
		subgroup = "planet-connections",
		asteroid_spawn_definitions = {
			{
				asteroid = "metallic-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0125,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.0025,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "carbonic-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0083333333333333321,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.001875,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "oxide-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0041666666666666661,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.000625,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "medium-metallic-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0075,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.0025,
						speed = 0.016666666666666665
					}
				}
			},
			{
				asteroid = "medium-carbonic-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0053124999999999991,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.001875,
						speed = 0.016666666666666665
					}
				}
			},
			{
				asteroid = "medium-oxide-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0021875,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.000625,
						speed = 0.016666666666666665
					}
				}
			}
		},
	},
	{
		type = "space-connection",
		name = "tiber-vulcanus",
		from = "tiber",
		to = "vulcanus",
		length = 15000,
		icons = {
			{
				icon = "__space-age__/graphics/icons/planet-route.png"
			},
			{
				icon = tiberiumInternalName.."/graphics/icons/tiber-planet.png",
				icon_size = 512,
				scale = 0.33300000000000001 * 64 / 512,
				shift = {
					-6,
					-6
				}
			},
			{
				icon = "__space-age__/graphics/icons/vulcanus.png",
				icon_size = 64,
				scale = 0.33300000000000001,
				shift = {
					6,
					6
				}
			}
		},
		order = "c",
		subgroup = "planet-connections",
		asteroid_spawn_definitions = {
			{
				asteroid = "metallic-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0125,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.0025,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "carbonic-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0083333333333333321,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.001875,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "oxide-asteroid-chunk",
				spawn_points = {
					{
						angle_when_stopped = 1,
						distance = 0.1,
						probability = 0.0041666666666666661,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 1,
						distance = 0.9,
						probability = 0.000625,
						speed = 0.016666666666666665
					}
				},
				type = "asteroid-chunk"
			},
			{
				asteroid = "medium-metallic-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0075,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.0025,
						speed = 0.016666666666666665
					}
				}
			},
			{
				asteroid = "medium-carbonic-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0053124999999999991,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.001875,
						speed = 0.016666666666666665
					}
				}
			},
			{
				asteroid = "medium-oxide-asteroid",
				spawn_points = {
					{
						angle_when_stopped = 0.6,
						distance = 0.1,
						probability = 0,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.5,
						probability = 0.0021875,
						speed = 0.016666666666666665
					},
					{
						angle_when_stopped = 0.6,
						distance = 0.9,
						probability = 0.000625,
						speed = 0.016666666666666665
					}
				}
			}
		},
	},
}

if common.whichPlanet == "tiber-start" then
	data.raw.planet["tiber"].order = "![tiber]"  -- Before Nauvis
end