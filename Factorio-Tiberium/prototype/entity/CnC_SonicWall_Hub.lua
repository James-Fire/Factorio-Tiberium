--Sonic Projection Walls
data:extend{
    {
        type = "electric-energy-interface",
        name = "CnC_SonicWall_Hub",
        icon = tiberiumInternalName.."/graphics/sonic wall/node icon.png",
		icon_size = 32,
        flags = {"placeable-neutral", "player-creation"},
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        minable = {mining_time = 0.5, result = "CnC_SonicWall_Hub"},
		trigger_created_entity= true,
        max_health = 200,
        repair_speed_modifier = 1.5,
        corpse = "wall-remnants",
        repair_sound = {filename = "__base__/sound/manual-repair-simple.ogg"},
        mined_sound = {filename = "__base__/sound/deconstruct-bricks.ogg"},
        vehicle_impact_sound = {filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
        energy_source = {
            type = "electric",
            buffer_capacity = "5MJ",
            usage_priority = "primary-input",
            input_flow_limit = "1500kW",
            output_flow_limit = "0W",
            drain = "500kW"
        },
        picture = {
            layers = {
                {
                    filename = tiberiumInternalName.."/graphics/sonic wall/node.png",
                    priority = "extra-high",
                    frame_count = 1,
                    axially_symmetrical = false,
                    direction_count = 1,
                    width = 256,
                    height = 384,
                    scale = 0.25
                },
                {
                    filename = tiberiumInternalName.."/graphics/sonic wall/node shadow.png",
                    priority = "extra-high",
                    frame_count = 1,
                    axially_symmetrical = false,
                    direction_count = 1,
                    width = 512,
                    height = 512,
                    scale = 0.125,
                    draw_as_shadow = true,
                    shift = {1, 0}
                }
            }
        },
        resistances = {
            {
                type = "physical",
                decrease = 3,
                percent = 20
            },
            {
                type = "impact",
                decrease = 45,
                percent = 60
            },
            {
                type = "explosion",
                decrease = 10,
                percent = 30
            },
            {
                type = "fire",
                percent = 30
            },
            {
                type = "laser",
                percent = 80
            },
			{
                type = "tiberium",
                percent = 100
            }
        }
    },
    {
        type = "simple-entity",
        name = "CnC_SonicWall_Wall",
        icon = tiberiumInternalName.."/graphics/sonic wall/wall icon.png",
		icon_size = 32,
        flags = {"placeable-neutral", "player-creation", "not-repairable"},
        subgroup = "remnants",
        order = "a[remnants]",
		destructible = false,
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		selection_priority = 1,
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		collision_mask = {"layer-15"},
        pictures = {
            {
				filename = tiberiumInternalName.."/graphics/sonic wall/wall horz.png",
				priority = "extra-high",
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
				width = 256,
				height = 256,
				scale = 0.188
			},
			{
				filename = tiberiumInternalName.."/graphics/sonic wall/wall vert.png",
				priority = "extra-high",
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
				width = 192,
				height = 640,
				scale = 0.125
			},
			{
				filename = tiberiumInternalName.."/graphics/sonic wall/wall cross.png",
				priority = "extra-high",
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
				width = 256,
				height = 640,
				scale = 0.125
			}
        },
        resistances = {
            {
                type = "physical",
                decrease = 5
            },
            {
                type = "acid",
                percent = 30
            },
            {
                type = "explosion",
                percent = 70
            },
            {
                type = "fire",
                percent = 100
            },
            {
                type = "laser",
                percent = 100
            },
			{
                type = "tiberium",
                percent = 100
            }
        },
        attack_reaction = {
            {
                range = 99999,
                action = {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        source_effects = {
                            type = "create-entity",
                            entity_name = "CnC_SonicWall_Wall-damage",
                            trigger_created_entity = true
                        }
                    }
                }
            }
        }
    },
    {
        type = "tree",
        name = "CnC_SonicWall_Wall-damage",
        icon = tiberiumInternalName.."/graphics/sonic wall/empty.png",
		icon_size = 32,
        flags = {"placeable-neutral", "not-on-map", "placeable-off-grid"},
        subgroup = "remnants",
        order = "a[remnants]",
        max_health = 1,
        selection_box = {{-0.0, -0.0}, {0.0, 0.0}},
        collision_box = {{-0.0, -0.0}, {0.0, 0.0}},
        collision_mask = {"object-layer"},
        pictures = {
			{
				filename = tiberiumInternalName.."/graphics/sonic wall/empty.png",
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
				width = 32,
				height = 32
			}
		}
    }
}