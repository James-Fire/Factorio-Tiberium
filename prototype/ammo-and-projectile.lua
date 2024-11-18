--Tiberium Rounds Magazine
data:extend{
	{
		type = "ammo",
		name = "tiberium-rounds-magazine",
		icon = "__base__/graphics/icons/uranium-rounds-magazine.png",
		icon_size = 64,
		icon_mipmaps = 4,
		ammo_category = "bullet",
		ammo_type = {
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
local genericRocketProjectile = {
	type = "projectile",
	name = "generic-rocket",
	flags = {"not-on-map"},
	acceleration = 0.005,
	action = {},
	light = {intensity = 0.5, size = 4},
	animation = {
		layers = {
			util.sprite_load("__base__/graphics/entity/rocket/rocket", {
				scale = 0.5,
				repeat_count = 8,
				frame_count = 1,
				rotate_shift = true,
				priority = "high"
			}),
			util.sprite_load("__base__/graphics/entity/rocket/rocket-tinted-tip", {
				scale = 0.5,
				repeat_count = 8,
				frame_count = 1,
				rotate_shift = true,
				priority = "high",
			}),
				util.sprite_load("__base__/graphics/entity/rocket/rocket-lights", {
				blend_mode = "additive",
				draw_as_glow = true,
				scale = 0.5,
				frame_count = 8,
				rotate_shift = true,
				priority = "high",
			}),
		}
	},
	shadow = util.sprite_load("__base__/graphics/entity/rocket/rocket", {
		draw_as_shadow = true,
		scale = 0.5,
		frame_count = 1,
		rotate_shift = true,
		priority = "high"
	}),
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
}

local tiberiumRocketProjectile = flib.copy_prototype(genericRocketProjectile, "tiberium-rocket")
tiberiumRocketProjectile.action = {
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
}

data:extend{tiberiumRocketProjectile,
	{
		type = "ammo",
		name = "tiberium-rocket",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-rocket.png",
		icon_size = 64,
		ammo_category = "rocket",
		ammo_type = {
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
}

--Liquid Tiberium Bomb
local tibNukeGroundZero = util.copy(data.raw.projectile["atomic-bomb-ground-zero-projectile"])
tibNukeGroundZero.name = "tiberium-atomic-bomb-ground-zero-projectile"
tibNukeGroundZero.action[1].action_delivery.target_effects.upper_distance_threshold = 50
local groundZeroDamageEffect = util.copy(tibNukeGroundZero.action[1].action_delivery.target_effects)
tibNukeGroundZero.action[1].action_delivery.target_effects = {groundZeroDamageEffect, util.copy(groundZeroDamageEffect)}
tibNukeGroundZero.action[1].action_delivery.target_effects[2].damage = {amount = 250, type = "tiberium"}
tibNukeGroundZero.action[1].radius = 4

local tibNukeWave = util.copy(data.raw.projectile["atomic-bomb-wave"])
tibNukeWave.name = "tiberium-atomic-bomb-wave"
tibNukeWave.action[1].action_delivery.target_effects.upper_distance_threshold = 50
local waveDamageEffect = util.copy(tibNukeWave.action[1].action_delivery.target_effects)
tibNukeWave.action[1].action_delivery.target_effects = {waveDamageEffect, util.copy(waveDamageEffect)}
tibNukeWave.action[1].action_delivery.target_effects[2].damage = {amount = 1000, type = "tiberium"}
tibNukeWave.action[1].radius = 4

local tibNukeProjectile = flib.copy_prototype(genericRocketProjectile, "tiberium-nuke")
tibNukeProjectile.action = {
	type = "direct",
	action_delivery = {
		type = "instant",
		target_effects = {
			{
				type = "script",
				effect_id = "ore-destruction-nuke"
			},
			{
				type = "set-tile",
				tile_name = "nuclear-ground",
				apply_projection = true,
				radius = 12,
				tile_collision_mask = common.makeCollisionMask({"water_tile"})
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
								tile_collision_mask = common.makeCollisionMask({"water_tile"}),
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
}

data:extend{tibNukeGroundZero, tibNukeWave, tibNukeProjectile,
	{
		type = "ammo",
		name = "tiberium-nuke",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-nuke.png",
		icon_size = 64,
		ammo_category = "rocket",
		ammo_type = {
			range_modifier = 5,
			cooldown_modifier = 3,
			target_type = "position",
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
}

--Tiberium Artillery Shell
local tibArtilleryAmmo = flib.copy_prototype(data.raw.ammo["artillery-shell"], "tiberium-artillery-shell")
tibArtilleryAmmo.icon = tiberiumInternalName.."/graphics/icons/tiberium-artillery-shell.png"
tibArtilleryAmmo.icon_mipmaps = 1
tibArtilleryAmmo.subgroup = "a-items"
tibArtilleryAmmo.order = "d[explosive-cannon-shell]-d[tiberium-artillery]"
tibArtilleryAmmo.ammo_type.action.action_delivery.projectile = "tiberium-artillery-projectile"

local tibArtilleryProj = flib.copy_prototype(data.raw["artillery-projectile"]["artillery-projectile"], "tiberium-artillery-projectile")
tibArtilleryProj.action.action_delivery.target_effects = {
	{
		action = {
			action_delivery = {
				target_effects = {
					{
						damage = {
						amount = 500,
						type = "physical"
						},
						type = "damage"
					},
					{
						damage = {
						amount = 500,
						type = "explosion"
						},
						type = "damage"
					},
					{
						damage = {
						amount = 500,
						type = "tiberium"
						},
						type = "damage"
					}
				},
				type = "instant"
			},
			radius = 4,
			type = "area"
		},
		type = "nested-result"
	},
	{
		initial_height = 0,
		max_radius = 3.5,
		offset_deviation = {
			{-4, -4},
			{4, 4}
		},
		repeat_count = 240,
		smoke_name = "artillery-smoke",
		speed_from_center = 0.05,
		speed_from_center_deviation = 0.005,
		type = "create-trivial-smoke"
	},
	{
		entity_name = "big-artillery-explosion",
		type = "create-entity"
	},
	{
		scale = 0.25,
		type = "show-explosion-on-chart"
	},
	{
		type = "script",
		effect_id = "seed-launch"
	}
}

data:extend{tibArtilleryAmmo, tibArtilleryProj}

--Liquid Tiberium Seed
local tibSeedProjectile = flib.copy_prototype(genericRocketProjectile, "tiberium-seed")
tibSeedProjectile.action = {
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
}

data:extend{tibSeedProjectile,
	{
		type = "ammo",
		name = "tiberium-seed",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-seed-rocket.png",
		icon_size = 64,
		ammo_category = "rocket",
		ammo_type = {
			range_modifier = 5,
			cooldown_modifier = 3,
			target_type = "position",
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
}

local tibSeedBlueProjectile = flib.copy_prototype(genericRocketProjectile, "tiberium-seed-blue")
tibSeedBlueProjectile.action = {
	type = "direct",
	action_delivery = {
		type = "instant",
		target_effects = {
			{
				type = "script",
				effect_id = "seed-launch-blue"
			},
		}
	}
}

data:extend{tibSeedBlueProjectile,
	{
		type = "ammo",
		name = "tiberium-seed-blue",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-seed-rocket-blue.png",
		icon_size = 64,
		ammo_category = "rocket",
		ammo_type = {
			range_modifier = 5,
			cooldown_modifier = 3,
			target_type = "position",
			action = {
				type = "direct",
				action_delivery = {
					type = "projectile",
					projectile = "tiberium-seed-blue",
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
}

--Chemsprayer Ammo
data:extend{
	{
		type = "ammo",
		name = "tiberium-chemical-sprayer-ammo",
		ammo_category = "flamethrower",
		ammo_type = {
			{
				action = {
					action_delivery = {
						stream = "tiberium-chemical-sprayer-stream",
						type = "stream"
					},
					type = "direct"
				},
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

local genericGrenadeCapsule = util.copy(data.raw.capsule.grenade) --TODO icons for this
genericGrenadeCapsule.cooldown = 10
genericGrenadeCapsule.subgroup = "a-items"
genericGrenadeCapsule.icon = nil
genericGrenadeCapsule.icon_size = nil

local destroyBlueCapsule = flib.copy_prototype(genericGrenadeCapsule, "tiberium-grenade-blue")
destroyBlueCapsule.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = "tiberium-grenade-blue"
destroyBlueCapsule.icons = common.layeredIcons("__base__/graphics/icons/grenade.png", 64, tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png", 64, "sw")

local destroyGreenCapsule = flib.copy_prototype(genericGrenadeCapsule, "tiberium-grenade-all")
destroyGreenCapsule.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile = "tiberium-grenade-all"
destroyGreenCapsule.icons = common.layeredIcons("__base__/graphics/icons/grenade.png", 64, tiberiumInternalName.."/graphics/icons/tiberium-ore.png", 64, "sw")

local genericGrenadeProjectile = util.copy(data.raw.projectile.grenade)
genericGrenadeProjectile.action = {
	{
		type = "direct",
		action_delivery = {
			type = "instant",
			target_effects = {
				{
					type = "script",
					effect_id = "ore-destruction-blue"
				},
			}
		}
	}
}

local destroyBlueProjectile = flib.copy_prototype(genericGrenadeProjectile, "tiberium-grenade-blue")

local destroyGreenProjectile = flib.copy_prototype(genericGrenadeProjectile, "tiberium-grenade-all")
destroyGreenProjectile.action[1].action_delivery.target_effects[1].effect_id = "ore-destruction-all"

local sonicProjectile = flib.copy_prototype(genericGrenadeProjectile, "tiberium-sonic-emitter-projectile")
sonicProjectile.animation = {
	animation_speed = 0.5,
	--draw_as_glow = true,
	filename = tiberiumInternalName.."/graphics/entity/sonic-emitter/hr-tileable-beam-END-light.png",
	frame_count = 16,
	height = 93,
	width = 91,
	line_length = 4,
	priority = "high",
	shift = {0.03125, 0.03125},
}
sonicProjectile.created_effect = {
	type = "direct",
	action_delivery = {
		type = "instant",
		source_effects = {
			type = "play-sound",
			sound = {
				aggregation = {
					max_count = 3,
					remove = true
				},
				variations = {
					{
						filename = "__base__/sound/fight/robot-explosion-4.ogg",
						volume = 0.5
					},
					{
						filename = "__base__/sound/fight/robot-explosion-5.ogg",
						volume = 0.5
					}
				}
			}
		}
	}
}
sonicProjectile.action[2] = {
	type = "direct",
	action_delivery = {
		type = "instant",
		target_effects = {
			{
				type = "create-entity",
				entity_name = "wall-explosion",
			},
			{
				type = "create-entity",
				check_buildability = true,
				entity_name = "small-scorchmark-tintable",
			},
			-- {
			-- 	type = "invoke-tile-trigger",
			-- 	repeat_count = 1,
			-- },
			{
				type = "destroy-decoratives",
				decoratives_with_trigger_only = false,
				from_render_layer = "decorative",
				include_decals = false,
				include_soft_decoratives = true,
				invoke_decorative_trigger = true,
				radius = 1.5,
				to_render_layer = "object",
			}
		}
	}
}
sonicProjectile.action[1].action_delivery.target_effects[1].effect_id = "ore-destruction-sonic-emitter"

data:extend{destroyBlueCapsule, destroyGreenCapsule, destroyBlueProjectile, destroyGreenProjectile, sonicProjectile}

local invisibleChainReactionBlue = flib.copy_prototype(genericGrenadeProjectile, "tiberium-catalyst-chain-blue")
invisibleChainReactionBlue.acceleration = 0.0005
invisibleChainReactionBlue.animation = common.blankAnimation
invisibleChainReactionBlue.shadow = common.blankAnimation

local invisibleChainReactionAll = flib.copy_prototype(genericGrenadeProjectile, "tiberium-catalyst-chain-all")
invisibleChainReactionAll.action[1].action_delivery.target_effects[1].effect_id = "ore-destruction-all"
invisibleChainReactionAll.acceleration = 0.0005
invisibleChainReactionAll.animation = common.blankAnimation
invisibleChainReactionAll.shadow = common.blankAnimation

local catalystBlue = flib.copy_prototype(genericRocketProjectile, "tiberium-catalyst-missile-blue")
catalystBlue.action = {
	{
		type = "direct",
		action_delivery = {
			type = "instant",
			target_effects = {
				{
					type = "script",
					effect_id = "ore-destruction-blue"
				},
			}
		}
	},
	{
		type = "cluster",
		action_delivery = {
			type = "projectile",
			projectile = "tiberium-catalyst-chain-blue",
			direction_deviation = 0.6,
			starting_speed = 0.01,
			starting_speed_deviation = 0.04
		},
		cluster_count = 16,
		distance = 8,
		distance_deviation = 12,
	}
}

local catalystAll = flib.copy_prototype(genericRocketProjectile, "tiberium-catalyst-missile-all")
catalystAll.action = {
	{
		type = "direct",
		action_delivery = {
			type = "instant",
			target_effects = {
				{
					type = "script",
					effect_id = "ore-destruction-all"
				},
			}
		}
	},
	{
		type = "cluster",
		action_delivery = {
			type = "projectile",
			projectile = "tiberium-catalyst-chain-all",
			direction_deviation = 0.6,
			starting_speed = 0.01,
			starting_speed_deviation = 0.04
		},
		cluster_count = 16,
		distance = 8,
		distance_deviation = 12,
	}
}

data:extend{catalystAll, catalystBlue, invisibleChainReactionAll, invisibleChainReactionBlue,
	{
		type = "ammo",
		name = "tiberium-catalyst-missile-all",
		icons = common.layeredIcons("__base__/graphics/icons/explosive-rocket.png", 64, tiberiumInternalName.."/graphics/icons/tiberium-ore.png", 64, "ne"),
		ammo_category = "rocket",
		ammo_type = {
			range_modifier = 5,
			cooldown_modifier = 3,
			target_type = "position",
			action = {
				type = "direct",
				action_delivery = {
					type = "projectile",
					projectile = "tiberium-catalyst-missile-all",
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
		type = "ammo",
		name = "tiberium-catalyst-missile-blue",
		icons = common.layeredIcons("__base__/graphics/icons/explosive-rocket.png", 64, tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png", 64, "ne"),
		ammo_category = "rocket",
		ammo_type = {
			range_modifier = 5,
			cooldown_modifier = 3,
			target_type = "position",
			action = {
				type = "direct",
				action_delivery = {
					type = "projectile",
					projectile = "tiberium-catalyst-missile-blue",
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
}

-- Tiberium Cliff Explosives
local tibCliffCapsule = flib.copy_prototype(data.raw.capsule["cliff-explosives"], "tiberium-cliff-explosives")
tibCliffCapsule.capsule_action.attack_parameters.ammo_type.action.action_delivery.projectile = "tiberium-cliff-explosives"
tibCliffCapsule.icon = tiberiumInternalName.."/graphics/icons/tiberium-cliff-explosives.png"
tibCliffCapsule.subgroup = "a-items"

local tibCliffProj = flib.copy_prototype(data.raw.projectile["cliff-explosives"], "tiberium-cliff-explosives")
tibCliffProj.action[1].action_delivery.target_effects = {
	{
		entity_name = "ground-explosion",
		type = "create-entity"
	},
	{
		check_buildability = true,
		entity_name = "small-scorchmark-tintable",
		type = "create-entity"
	},
	{
		explosion = "explosion",
		radius = 1.5,
		type = "destroy-cliffs"
	},
	{
		type = "script",
		effect_id = "node-destruction"
	},
	{
		repeat_count = 1,
		type = "invoke-tile-trigger"
	},
	{
		decoratives_with_trigger_only = false,
		from_render_layer = "decorative",
		include_decals = false,
		include_soft_decoratives = true,
		invoke_decorative_trigger = true,
		radius = 2,
		to_render_layer = "object",
		type = "destroy-decoratives"
	}
}
tibCliffProj.animation = {
	animation_speed = 0.25,
	draw_as_glow = true,
	filename = tiberiumInternalName.."/graphics/entity/cliff-explosives/hr-tiberium-cliff-explosives.png",
	frame_count = 16,
	height = 58,
	width = 52,
	scale = 0.5,
	shift = {0.015625, -0.140625},
	line_length = 8,
	priority = "high",
}

data:extend{tibCliffCapsule, tibCliffProj}
