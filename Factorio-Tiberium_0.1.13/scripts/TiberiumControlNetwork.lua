local tiberiumNodeHarvesterItem = table.deepcopy(data.raw.item["pumpjack"])
tiberiumNodeHarvesterItem.name = "node-harvester"
tiberiumNodeHarvesterItem.subgroup = "a-buildings"
tiberiumNodeHarvesterItem.order = "e"
tiberiumNodeHarvesterItem.place_result = "node-harvester"

local tiberiumNodeHarvesterEntity = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
tiberiumNodeHarvesterEntity.name = "node-harvester"
tiberiumNodeHarvesterEntity.icon = data.raw["mining-drill"]["pumpjack"].icon
tiberiumNodeHarvesterEntity.base_picture = data.raw["mining-drill"]["pumpjack"].base_picture
tiberiumNodeHarvesterEntity.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
tiberiumNodeHarvesterEntity.animations = data.raw["mining-drill"]["pumpjack"].animations
tiberiumNodeHarvesterEntity.mining_speed = 5
tiberiumNodeHarvesterEntity.subgroup = "a-buildings"
tiberiumNodeHarvesterEntity.order = "e"
tiberiumNodeHarvesterEntity.energy_usage = "20000kW"
tiberiumNodeHarvesterEntity.resource_categories = {}
tiberiumNodeHarvesterEntity.minable.result = "node-harvester"
tiberiumNodeHarvesterEntity.resource_searching_radius = 0.49
table.insert(tiberiumNodeHarvesterEntity.resource_categories, "advanced-solid-tiberium")
tiberiumNodeHarvesterEntity.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = 100
}

data:extend{tiberiumNodeHarvesterItem, tiberiumNodeHarvesterEntity,
  {
	type = "recipe",
	name = "node-harvester",
	normal = {
	  energy_required = 20,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients = {
		{"advanced-circuit", 25},
		{"electric-mining-drill", 5},
		{"iron-gear-wheel", 50},
		{"iron-plate", 100}
	  },
	  result = "node-harvester"
	},
	expensive =	{
	  energy_required = 30,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients = {
		{"advanced-circuit", 25},
		{"electric-mining-drill", 5},
		{"iron-gear-wheel", 50},
		{"iron-plate", 100}
	  },
	  result = "node-harvester"
	}
  }
}

local tiberiumSpikeItem = table.deepcopy(data.raw.item["pumpjack"])
tiberiumSpikeItem.name = "tib-spike"
tiberiumSpikeItem.icon = tiberiumInternalName.."/graphics/icons/tiberium-spike.png"
tiberiumSpikeItem.icon_mipmaps = nil
tiberiumSpikeItem.subgroup = "a-buildings"
tiberiumSpikeItem.order = "e"
tiberiumSpikeItem.place_result = "tib-spike"

local tiberiumSpikeEntity = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
tiberiumSpikeEntity.name = "tib-spike"
tiberiumSpikeEntity.icon = tiberiumInternalName.."/graphics/icons/tiberium-spike.png"
tiberiumSpikeEntity.icon_mipmaps = nil
tiberiumSpikeEntity.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
tiberiumSpikeEntity.mining_speed = 5
tiberiumSpikeEntity.subgroup = "a-buildings"
tiberiumSpikeEntity.order = "m"
tiberiumSpikeEntity.resource_categories = {}
tiberiumSpikeEntity.minable.result = "tib-spike"
tiberiumSpikeEntity.resource_searching_radius = 0.49
table.insert(tiberiumSpikeEntity.resource_categories, "advanced-liquid-tiberium")
table.insert(tiberiumSpikeEntity.resource_categories, "advanced-solid-tiberium")
tiberiumSpikeEntity.energy_source = {
	type = "void",
	usage_priority = "secondary-input",
	emissions_per_minute = 20
}

data:extend{tiberiumSpikeItem, tiberiumSpikeEntity,
  {
	type = "recipe",
	name = "tib-spike",
	normal = {
	  energy_required = 20,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients = {
		{"processing-unit", 20},
		{"pumpjack", 5},
		{"solar-panel", 10},
		{"CnC_SonicWall_Hub", 4}
	  },
	  result = "tib-spike"
	},
	expensive =	{
	  energy_required = 30,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients = {
		{"processing-unit", 50},
		{"pumpjack", 10},
		{"solar-panel", 20},
		{"CnC_SonicWall_Hub", 4}
	  },
	  result = "tib-spike"
	}
  }
}

local tiberiumNetworkNodeItem = table.deepcopy(data.raw.item["electric-mining-drill"])
tiberiumNetworkNodeItem.name = "tiberium-network-node"
tiberiumNetworkNodeItem.subgroup = "a-buildings"
tiberiumNetworkNodeItem.order = "b"
tiberiumNetworkNodeItem.place_result = "tiberium-network-node"

local tibcat = data.raw["resource-category"]["basic-solid-tiberium"]

local tiberiumNetworkNodeEntity = util.table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
tiberiumNetworkNodeEntity.name = "tiberium-network-node"
tiberiumNetworkNodeEntity.energy_usage = "25000kW"
tiberiumNetworkNodeEntity.mining_speed = 10
tiberiumNetworkNodeEntity.subgroup = "a-buildings"
tiberiumNetworkNodeEntity.order = "b"
tiberiumNetworkNodeEntity.resource_searching_radius = 50
tiberiumNetworkNodeEntity.resource_categories = {}
tiberiumNetworkNodeEntity.minable.result = "tiberium-network-node"
table.insert(tiberiumNetworkNodeEntity.resource_categories, tibcat.name)
tiberiumNetworkNodeEntity.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = 200
}

data:extend({tiberiumNetworkNodeItem,tiberiumNetworkNodeEntity,tibcat,
  {
    type = "recipe",
    name = "tiberium-network-node",
    normal = {
      energy_required = 20,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "b",
      ingredients = {
        {"processing-unit", 20},
		{"electric-engine-unit", 20},
		{"electric-mining-drill", 20},
		{"pipe", 100},
      },
      result = "tiberium-network-node"
    },
    expensive = {
      energy_required = 30,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "b",
      ingredients = {
        {"processing-unit", 50},
		{"electric-engine-unit", 20},
		{"electric-mining-drill", 20},
		{"pipe", 400},
      },
      result = "tiberium-network-node"
    }
  }
})

data.raw.resource["tiberium-ore"].category = tibcat.name

table.insert(data.raw.character.character.mining_categories, tibcat.name)
for _, drill in pairs(data.raw["mining-drill"]) do
	if LSlib.utils.table.hasValue(drill.resource_categories, "basic-solid") then 
		table.insert(drill.resource_categories, tibcat.name)
	end
end

local growthAcceleratorItem = table.deepcopy(data.raw.item["pumpjack"])
growthAcceleratorItem.name = "growth-accelerator-node"
local growthAcceleratorEntity = table.deepcopy(data.raw["mining-drill"]["node-harvester"])
growthAcceleratorEntity.name = "growth-accelerator-node"

data:extend({growthAcceleratorItem, growthAcceleratorEntity})

local acceleratorSprite = {
	-- Centrifuge A
	filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
	priority = "high",
	line_length = 8,
	width = 119,
	height = 107,
	frame_count = 64,
	shift = util.by_pixel(-0.5, -26.5),
	hr_version = {
		filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C.png",
		priority = "high",
		scale = 0.5,
		line_length = 8,
		width = 237,
		height = 214,
		frame_count = 64,
		shift = util.by_pixel(-0.25, -26.5)
	}
}

data:extend({
	--Void recipe for consuming energy credits
	{
		type = "recipe",
		name = "tiberium-growth",
		enabled = "false",
		category = "growth",
		ingredients = {{"growth-credit", 1}},
		energy_required = 15,  -- 20 credits every 5 minutes
		results = {
			{
				name = "growth-credit-void",
				amount = 1,
				probability = 0
			}
		},
    },
	{
		type = "item",
		name = "growth-credit-void",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-ore.png",
		icon_size = 32,
		flags = {"hidden"},
		subgroup = "a-items",
		stack_size = 200
	},
	--Floating text for displaying growth amount
	{
		type = "flying-text",
		name = "growth-accelerator-text",
		flags = {"not-on-map", "placeable-off-grid"},
		time_to_live = 180,
		speed = 1 / 60,
	},
	{
		type = "assembling-machine",
		name = "growth-accelerator",
		icon = tiberiumInternalName.."/graphics/technology/growth-accelerator.png",
		icon_size = 128,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "growth-accelerator"},
		max_health = 250,
		corpse = "centrifuge-remnants",
		dying_explosion = "medium-explosion",
		energy_usage = "1kW",
		crafting_speed = 1,
		fixed_recipe = "tiberium-growth",
		allowed_effects = { "speed", "consumption" },
		open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
		close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
		vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
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
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		always_draw_idle_animation = true,
		animation = {
			layers = {
				{
					blend_mode = "additive",
					filename = "__base__/graphics/entity/centrifuge/centrifuge-C-light.png",
					frame_count = 64,
					height = 104,
					hr_version = {
						blend_mode = "additive",
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-light.png",
						frame_count = 64,
						height = 207,
						line_length = 8,
						priority = "high",
						scale = 0.5,
						shift = {0, -0.8515625},
						width = 190
					},
					line_length = 8,
					priority = "high",
					shift = {0, -0.84375},
					width = 96
				},
			},
		},
		idle_animation = {
			layers = {
				{
					-- Centrifuge A
					filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
					priority = "high",
					line_length = 8,
					width = 119,
					height = 107,
					frame_count = 64,
					shift = util.by_pixel(-0.5, -26.5),
					hr_version = {
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C.png",
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
			},
		},
		circuit_wire_max_distance = 7.5,
		circuit_wire_connection_point = {
			shadow = {
				red = {0.56, -0.6},
				green = {0.26, -0.6}
			},
			wire = {
				red = {0.16, -0.9},
				green = {-0.16, -0.9}
			}
		},
		crafting_categories = {"growth"},
		energy_source =	{
			type = "void",
			emissions_per_minute = 2,
		},
	},
	{
		type = "recipe",
		name = "growth-accelerator",
		enabled = "false",
		subgroup = "a-buildings",
		order = "g",
		ingredients =
		{
			{"steel-plate", 25},
			{"advanced-circuit", 15},
			{"pipe", 10}
		},
		energy_required = 30,
		result = "growth-accelerator",
	},
	{
		type = "item",
		name = "growth-accelerator",
		icon = tiberiumInternalName.."/graphics/technology/growth-accelerator.png",
		icon_size = 128,
		subgroup = "a-buildings",
		order = "g",
		place_result = "growth-accelerator-node",
		stack_size = 15,
	},
	{
		type = "item",
		name = "growth-accelerator-node",
		icon = tiberiumInternalName.."/graphics/technology/growth-accelerator.png",
		icon_size = 128,
		subgroup = "a-buildings",
		order = "g",
		place_result = "growth-accelerator",
		stack_size = 15,
	},
	{
    type = "beacon",
    name = "growth-accelerator-beacon",
    energy_usage = "10W",
    -- 0.17 supports "no-automated-item-removal", "no-automated-item-insertion"
    flags = { "hide-alt-info", "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map", "no-automated-item-removal", "no-automated-item-insertion" },
    collision_mask = { "resource-layer" }, -- disable collision
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
    animation = {
      filename =  "__core__/graphics/empty.png",
      width = 1,
      height = 1,
      line_length = 1,
      frame_count = 1,
    },
    animation_shadow = {
        filename = "__core__/graphics/empty.png",
        width = 1,
        height = 1,
        line_length = 1,
        frame_count = 1,
    },
    -- 0.17 supports 0W entities
    energy_source = {type="void"},
    base_picture =
    {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1,
    },
    supply_area_distance = 0,
    radius_visualisation_picture =
    {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1
    },
    distribution_effectivity = 1,
    module_specification =
    {
      module_slots = 65535,
    },
    allowed_effects = { "speed", "consumption" },
    selection_box = {{0, 0}, {0, 0}},
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}}, -- reduce size preventing inserters from picking modules, will not power unless center is covered
  },
  -- hidden speed modules matching infinite tech bonus size
  {
    type = "module",
    name = "growth-accelerator-speed-module",
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    flags = { "hidden" },
    subgroup = "module",
    category = "speed",
    tier = 0,
    stack_size = 1,
    effect = { speed = {bonus = 0.1}, consumption = {bonus = 0.1}},
  },
})

-- CnC Walls local var setup
local nullimg = {
    filename = tiberiumInternalName.."/graphics/sonic wall/empty.png",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 32,
    height = 32
}

local wall_segment_horz = {
    filename = tiberiumInternalName.."/graphics/sonic wall/wall horz.png",
    priority = "extra-high",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 256,
    height = 256,
    scale = 0.188
}
local wall_segment_vert = {
    filename = tiberiumInternalName.."/graphics/sonic wall/wall vert.png",
    priority = "extra-high",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 192,
    height = 640,
    scale = 0.125
}
local wall_segment_cross = {
    filename = tiberiumInternalName.."/graphics/sonic wall/wall cross.png",
    priority = "extra-high",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 256,
    height = 640,
    scale = 0.125
}


--Sonic Projection Walls

data:extend({
    {
        type = "item",
        name = "CnC_SonicWall_Hub",
        icon = tiberiumInternalName.."/graphics/sonic wall/node icon.png",
		icon_size = 32,
        subgroup = "a-buildings",
        order = "a[stone-wall]-b[hardlight]",
        place_result = "CnC_SonicWall_Hub",
        stack_size = 50
    }
})

data:extend({
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
        repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
        mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
        vehicle_impact_sound =    { filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0 },
        energy_source =
        {
            type = "electric",
            buffer_capacity = "5MJ",
            usage_priority = "primary-input",
            input_flow_limit = "1500kW",
            output_flow_limit = "0W",
            drain = "500kW"
        },
        picture =
        {
            layers =
            {
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
        max_health = 10000,
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
		collision_mask = {"layer-15"},
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
            },
			{
                type = "tiberium",
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
        pictures = {nullimg}
    }
})
