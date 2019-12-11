local function Contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local tiberiumGrowthNodeItem = table.deepcopy(data.raw.item["pumpjack"])
tiberiumGrowthNodeItem.name = "tib-pumpjack"
tiberiumGrowthNodeItem.subgroup = "a-buildings"
tiberiumGrowthNodeItem.order = "e"
tiberiumGrowthNodeItem.place_result = "tib-pumpjack"

local tiberiumGrowthNodeEntity = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
tiberiumGrowthNodeEntity.name = "tib-pumpjack"
tiberiumGrowthNodeEntity.icon = data.raw["mining-drill"]["pumpjack"].icon
tiberiumGrowthNodeEntity.base_picture = data.raw["mining-drill"]["pumpjack"].base_picture
tiberiumGrowthNodeEntity.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
tiberiumGrowthNodeEntity.animations = data.raw["mining-drill"]["pumpjack"].animations
tiberiumGrowthNodeEntity.mining_speed = 5
tiberiumGrowthNodeEntity.subgroup = "a-buildings"
tiberiumGrowthNodeEntity.order = "e"
tiberiumGrowthNodeEntity.energy_usage = "25000kW"
tiberiumGrowthNodeEntity.resource_categories = {}
tiberiumGrowthNodeEntity.minable.result = "tib-pumpjack"

tiberiumGrowthNodeEntity.resource_searching_radius = 0.49
table.insert(tiberiumGrowthNodeEntity.resource_categories, "advanced-solid-tiberium")
tiberiumGrowthNodeEntity.energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions = 10 / 25000
    },
data:extend{tiberiumGrowthNodeItem, tiberiumGrowthNodeEntity,
  {
	type = "recipe",
	name = "tib-pumpjack",
	normal =
	{
	  energy_required = 20,
	  enabled = false,
	  subgroup = "a-buildings",
	  order = "e",
	  ingredients =
	  {
		{"advanced-circuit", 25},
		{"iron-gear-wheel", 50},
		{"iron-plate", 100}
	  },
	  result = "tib-pumpjack"
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
		{"iron-gear-wheel", 50},
		{"iron-plate", 100}
	  },
	  result = "tib-pumpjack"
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
tiberiumNetworkNodeEntity.resource_searching_radius = 100
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
        {"advanced-circuit", 25},
        {"iron-gear-wheel", 50},
        {"iron-plate", 100}
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

data:extend({
	{
		type = "container",
		name = "growth-accelerator",
		icon = "__base__/graphics/icons/accumulator.png",
		icon_size = 32,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 2, result = "growth-accelerator"},
		max_health = 250,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
		close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
		vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		resistances =
		{
			{
				type = "fire",
				percent = 90
			}
		},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		fast_replaceable_group = "container",
		inventory_size = 10,
		picture =
		{
			filename = "__base__/graphics/entity/electric-mining-drill/hr-electric-mining-drill-N-patch.png",
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
			{"electric-engine-unit", 10},
			{"advanced-circuit", 15},
			{"pipe", 10},
			{"chemical-plant", 1}
		},
		energy_required = 30,
		result = "growth-accelerator",
	},
	{
		type = "item",
		name = "growth-accelerator",
		icon = "__base__/graphics/icons/accumulator.png",
		icon_size = 32,
		subgroup = "a-buildings",
		order = "g",
		place_result = "growth-accelerator",
		stack_size = 15,
	},
	})
