local nullimg = {
    filename = "__Factorio-Tiberium__/graphics/empty.png",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 32,
    height = 32
}

local wall_segment_horz = {
    filename = "__Factorio-Tiberium__/graphics/solid light wall/wall horz.png",
    priority = "extra-high",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 256,
    height = 256,
    scale = 0.188
}
local wall_segment_vert = {
    filename = "__Factorio-Tiberium__/graphics/solid light wall/wall vert.png",
    priority = "extra-high",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 192,
    height = 640,
    scale = 0.125
}
local wall_segment_cross = {
    filename = "__Factorio-Tiberium__/graphics/solid light wall/wall cross.png",
    priority = "extra-high",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 256,
    height = 640,
    scale = 0.125
}

function laser_turret_extension(inputs)
    return
    {
        filename = "__base__/graphics/entity/laser-turret/laser-turret-gun-start.png",
        priority = "medium",
        width = 66,
        height = 67,
        frame_count = inputs.frame_count and inputs.frame_count or 15,
        line_length = inputs.line_length and inputs.line_length or 0,
        run_mode = inputs.run_mode and inputs.run_mode or "forward",
        axially_symmetrical = false,
        direction_count = 4,
        scale = 0.5,
        shift = {-0.03125, -0.984375}
    }
end

function laser_turret_extension_shadow(inputs)
    return
    {
        filename = "__base__/graphics/entity/laser-turret/laser-turret-gun-start-shadow.png",
        width = 92,
        height = 50,
        frame_count = inputs.frame_count and inputs.frame_count or 15,
        line_length = inputs.line_length and inputs.line_length or 0,
        run_mode = inputs.run_mode and inputs.run_mode or "forward",
        axially_symmetrical = false,
        direction_count = 4,
        draw_as_shadow = true,
        scale = 0.5,
        shift = {1.375, 0}
    }
end

function laser_turret_extension_mask(inputs)
    return
    {
        filename = "__base__/graphics/entity/laser-turret/laser-turret-gun-start-mask.png",
        flags = { "mask" },
        width = 51,
        height = 47,
        frame_count = inputs.frame_count and inputs.frame_count or 15,
        line_length = inputs.line_length and inputs.line_length or 0,
        run_mode = inputs.run_mode and inputs.run_mode or "forward",
        axially_symmetrical = false,
        apply_runtime_tint = true,
        direction_count = 4,
        scale = 0.5,
        shift = {-0.015625, -1.26563}
    }
end

data:extend({
    {
        type = "electric-energy-interface",
        name = "sonic-wall-node",
        icon = "__Factorio-Tiberium__/graphics/solid light wall/node icon.png",
		icon_size = 32,
        flags = {"placeable-neutral", "player-creation"},
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        minable = {mining_time = 0.5, result = "sonic-wall-node"},
        max_health = 200,
        repair_speed_modifier = 1.5,
        corpse = "wall-remnants",
        repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
        mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
        vehicle_impact_sound =    { filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0 },
        energy_source =
        {
            type = "electric",
            buffer_capacity = "25MJ",
            usage_priority = "primary-input",
            input_flow_limit = "2750kW",
            output_flow_limit = "0W",
            drain = "250kW"
        },
        picture =
        {
            layers =
            {
                {
                    filename = "__Factorio-Tiberium__/graphics/solid light wall/node.png",
                    priority = "extra-high",
                    frame_count = 1,
                    axially_symmetrical = false,
                    direction_count = 1,
                    width = 256,
                    height = 384,
                    scale = 0.25
                },
                {
                    filename = "__Factorio-Tiberium__/graphics/solid light wall/node shadow.png",
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
        resistances =
        {
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
            }
        }
    },
    {
        type = "simple-entity",
        name = "sonic-wall",
        icon = "__Factorio-Tiberium__/graphics/solid light wall/wall icon.png",
		icon_size = 32,
        flags = {"placeable-neutral", "player-creation", "not-repairable"},
        subgroup = "remnants",
        order = "a[remnants]",
        max_health = 10000,
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		collision_mask = {"object-layer"},
        pictures = {
            wall_segment_horz,
            wall_segment_vert,
            wall_segment_cross
        },
        resistances =
        {
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
            }
        },
        attack_reaction =
        {
            {
                range = 99999,
                action =
                {
                    type = "direct",
                    action_delivery =
                    {
                        type = "instant",
                        source_effects =
                        {
                            type = "create-entity",
                            entity_name = "sonic-wall-damage",
                            trigger_created_entity = true
                        }
                    }
                }
            }
        }
    },
    {
        type = "tree",
        name = "sonic-wall-damage",
        icon = "__Factorio-Tiberium__/graphics/empty.png",
		icon_size = 32,
        flags = {"placeable-neutral", "not-on-map", "placeable-off-grid"},
        subgroup = "remnants",
        order = "a[remnants]",
        max_health = 1,
        selection_box = {{-0.0, -0.0}, {0.0, 0.0}},
        collision_box = {{-0.0, -0.0}, {0.0, 0.0}},
        collision_mask = {"object-layer"},
        pictures = {nullimg}
    }
})