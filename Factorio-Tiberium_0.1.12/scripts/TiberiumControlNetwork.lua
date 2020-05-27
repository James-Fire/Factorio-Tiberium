local function Contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local tiberiumGrowthNodeItem = table.deepcopy(data.raw.item["pumpjack"])
tiberiumGrowthNodeItem.name = "node-harvester"
tiberiumGrowthNodeItem.subgroup = "a-buildings"
tiberiumGrowthNodeItem.order = "e"
tiberiumGrowthNodeItem.place_result = "node-harvester"

local tiberiumGrowthNodeEntity = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
tiberiumGrowthNodeEntity.name = "node-harvester"
tiberiumGrowthNodeEntity.icon = data.raw["mining-drill"]["pumpjack"].icon
tiberiumGrowthNodeEntity.base_picture = data.raw["mining-drill"]["pumpjack"].base_picture
tiberiumGrowthNodeEntity.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
tiberiumGrowthNodeEntity.animations = data.raw["mining-drill"]["pumpjack"].animations
tiberiumGrowthNodeEntity.mining_speed = 5
tiberiumGrowthNodeEntity.subgroup = "a-buildings"
tiberiumGrowthNodeEntity.order = "e"
tiberiumGrowthNodeEntity.energy_usage = "20000kW"
tiberiumGrowthNodeEntity.resource_categories = {}
tiberiumGrowthNodeEntity.minable.result = "node-harvester"

tiberiumGrowthNodeEntity.resource_searching_radius = 0.49
table.insert(tiberiumGrowthNodeEntity.resource_categories, "advanced-solid-tiberium")
tiberiumGrowthNodeEntity.energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions = 20 / 20000
    },
data:extend{tiberiumGrowthNodeItem, tiberiumGrowthNodeEntity,
  {
	type = "recipe",
	name = "node-harvester",
	normal =
	{
	  energy_required = 20,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients =
	  {
		{"advanced-circuit", 25},
		{"electric-mining-drill", 5},
		{"iron-gear-wheel", 50},
		{"iron-plate", 100}
	  },
	  result = "node-harvester"
	},
	expensive =
	{
	  energy_required = 30,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients =
	  {
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
tiberiumSpikeItem.icon = "__Factorio-Tiberium__/graphics/icons/tiberium-spike.png"
tiberiumSpikeItem.subgroup = "a-buildings"
tiberiumSpikeItem.order = "e"
tiberiumSpikeItem.place_result = "tib-spike"

local tiberiumSpikeEntity = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
tiberiumSpikeEntity.name = "tib-spike"
tiberiumSpikeEntity.icon = "__Factorio-Tiberium__/graphics/icons/tiberium-spike.png"
tiberiumSpikeEntity.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
tiberiumSpikeEntity.mining_speed = 5
tiberiumSpikeEntity.subgroup = "a-buildings"
tiberiumSpikeEntity.order = "m"
tiberiumGrowthNodeEntity.energy_usage = "20000kW"
tiberiumSpikeEntity.resource_categories = {}
tiberiumSpikeEntity.minable.result = "tib-spike"

tiberiumSpikeEntity.resource_searching_radius = 0.49
table.insert(tiberiumSpikeEntity.resource_categories, "advanced-liquid-tiberium")
table.insert(tiberiumSpikeEntity.resource_categories, "advanced-solid-tiberium")
tiberiumSpikeEntity.energy_source = {
        type = "void",
        usage_priority = "secondary-input",
        emissions = 2
    },
data:extend{tiberiumSpikeItem, tiberiumSpikeEntity,
  {
	type = "recipe",
	name = "tib-spike",
	normal =
	{
	  energy_required = 20,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients =
	  {
		{"processing-unit", 25},
		{"iron-gear-wheel", 50},
		{"electric-mining-drill", 5},
		{"steel-plate", 100},
		{"CnC_SonicWall_Hub", 2}
	  },
	  result = "tib-spike"
	},
	expensive =
	{
	  energy_required = 30,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients =
	  {
		{"processing-unit", 25},
		{"iron-gear-wheel", 50},
		{"electric-mining-drill", 5},
		{"steel-plate", 100},
		{"CnC_SonicWall_Hub", 2}
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
tiberiumNetworkNodeItem.order = "b"
tiberiumNetworkNodeEntity.resource_searching_radius = 50
tiberiumNetworkNodeEntity.resource_categories = {}
tiberiumNetworkNodeEntity.minable.result = "tiberium-network-node"
table.insert(tiberiumNetworkNodeEntity.resource_categories, tibcat.name)
tiberiumGrowthNodeEntity.energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions = 10 / 25000
    },

data:extend({tiberiumNetworkNodeItem,tiberiumNetworkNodeEntity,tibcat,
  {
    type = "recipe",
    name = "tiberium-network-node",
	
    normal =
    {
      energy_required = 20,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "b",
      ingredients =
      {
        {"processing-unit", 25},
        {"iron-gear-wheel", 50},
		{"electric-engine-unit", 10},
		{"electric-mining-drill", 5},
		{"pipe", 100},
        {"steel-plate", 100}
      },
      result = "tiberium-network-node"
    },
    expensive =
    {
      energy_required = 30,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "b",
      ingredients =
      {
        {"advanced-circuit", 25},
		{"iron-gear-wheel", 50},
		{"iron-plate", 100}
      },
      result = "tiberium-network-node"
    }
  }})

data.raw.resource["tiberium-ore"].category = tibcat.name

table.insert(data.raw.character.character.mining_categories, tibcat.name)
for _, drill in pairs(data.raw["mining-drill"]) do
	if Contains(drill.resource_categories, "basic-solid") then 
		table.insert(drill.resource_categories, tibcat.name)
	end
end

local growthSpikeEntity = table.deepcopy(data.raw["mining-drill"]["node-harvester"])
growthSpikeEntity.name = "growth-accelerator-node"
local growthSpikeItem = table.deepcopy(data.raw.item["pumpjack"])
growthSpikeItem.name = "growth-accelerator-node"

data:extend({growthSpikeItem,growthSpikeEntity})

data:extend({
	{
		type = "container",
		name = "growth-accelerator",
		icon = "__Factorio-Tiberium__/graphics/icons/growth-accelerator.png",
		icon_size = 64,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "growth-accelerator"},
		max_health = 250,
		corpse = "centrifuge-remnants",
		dying_explosion = "medium-explosion",
		open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
		close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
		vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		resistances =
		{
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
		fast_replaceable_group = "container",
		inventory_size = 10,
		picture =
		{
			filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
			priority = "high",
			width = 129,
			height = 100,
			shift = {0.421875, 0},
		},
		circuit_wire_max_distance = 7.5,
		circuit_wire_connection_point =
		{
			shadow =
			{
				red = {0.56, -0.6},
				green = {0.26, -0.6}
			},
			wire =
			{
				red = {0.16, -0.9},
				green = {-0.16, -0.9}
			}
		},
	},
	{ -- Basic Warehouse
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
		icon = "__Factorio-Tiberium__/graphics/icons/growth-accelerator.png",
		icon_size = 64,
		subgroup = "a-buildings",
		order = "g",
		place_result = "growth-accelerator-node",
		stack_size = 15,
	},
	{
		type = "item",
		name = "growth-accelerator-node",
		icon = "__Factorio-Tiberium__/graphics/icons/growth-accelerator.png",
		icon_size = 64,
		subgroup = "a-buildings",
		order = "g",
		place_result = "growth-accelerator",
		stack_size = 15,
	},
	})

local centrifuge = table.deepcopy(data.raw["assembling-machine"]["centrifuge"])

-- CnC Walls local var setup
local nullimg = {
    filename = "__Factorio-Tiberium__/graphics/sonic wall/empty.png",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 32,
    height = 32
}

local wall_segment_horz = {
    filename = "__Factorio-Tiberium__/graphics/sonic wall/wall horz.png",
    priority = "extra-high",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 256,
    height = 256,
    scale = 0.188
}
local wall_segment_vert = {
    filename = "__Factorio-Tiberium__/graphics/sonic wall/wall vert.png",
    priority = "extra-high",
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    width = 192,
    height = 640,
    scale = 0.125
}
local wall_segment_cross = {
    filename = "__Factorio-Tiberium__/graphics/sonic wall/wall cross.png",
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
        icon = "__Factorio-Tiberium__/graphics/sonic wall/node icon.png",
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
        icon = "__Factorio-Tiberium__/graphics/sonic wall/node icon.png",
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
                    filename = "__Factorio-Tiberium__/graphics/sonic wall/node.png",
                    priority = "extra-high",
                    frame_count = 1,
                    axially_symmetrical = false,
                    direction_count = 1,
                    width = 256,
                    height = 384,
                    scale = 0.25
                },
                {
                    filename = "__Factorio-Tiberium__/graphics/sonic wall/node shadow.png",
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
        icon = "__Factorio-Tiberium__/graphics/sonic wall/wall icon.png",
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
        icon = "__Factorio-Tiberium__/graphics/sonic wall/empty.png",
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
