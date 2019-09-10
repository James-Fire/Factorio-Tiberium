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
tiberiumGrowthNodeItem.place_result = "tib-pumpjack"

local tiberiumGrowthNodeEntity = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
tiberiumGrowthNodeEntity.name = "tib-pumpjack"
tiberiumGrowthNodeEntity.icon = data.raw["mining-drill"]["pumpjack"].icon
tiberiumGrowthNodeEntity.base_picture = data.raw["mining-drill"]["pumpjack"].base_picture
tiberiumGrowthNodeEntity.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
tiberiumGrowthNodeEntity.animations = data.raw["mining-drill"]["pumpjack"].animations
tiberiumGrowthNodeEntity.mining_speed = 1
tiberiumGrowthNodeEntity.energy_usage = "25000kW"
tiberiumGrowthNodeEntity.resource_categories = {}
tiberiumGrowthNodeEntity.minable.result = "tib-pumpjack"
tiberiumGrowthNodeEntity.resource_searching_radius = 0.49
table.insert(tiberiumGrowthNodeEntity.resource_categories, "advanced-solid-tiberium")

data:extend{tiberiumGrowthNodeItem, tiberiumGrowthNodeEntity,
  {
	type = "recipe",
	name = "tib-pumpjack",
	normal =
	{
	  energy_required = 20,
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
	  ingredients =
	  {
		{"electronic-circuit", 5},
		{"iron-gear-wheel", 10},
		{"iron-plate", 20}
	  },
	  result = "tib-pumpjack"
	}
  }
}

local tiberiumNetworkNodeItem = table.deepcopy(data.raw.item["electric-mining-drill"])
tiberiumNetworkNodeItem.name = "tiberium-network-node"
tiberiumNetworkNodeItem.place_result = "tiberium-network-node"

local tibcat = data.raw["resource-category"]["basic-solid-tiberium"]

local tiberiumNetworkNodeEntity = util.table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
tiberiumNetworkNodeEntity.name = "tiberium-network-node"
tiberiumNetworkNodeEntity.energy_usage = "25000kW"
tiberiumNetworkNodeEntity.mining_speed = 10
tiberiumNetworkNodeEntity.resource_searching_radius = 100
tiberiumNetworkNodeEntity.resource_categories = {}
tiberiumNetworkNodeEntity.minable.result = "tiberium-network-node"
table.insert(tiberiumNetworkNodeEntity.resource_categories, tibcat.name)

data:extend({tiberiumNetworkNodeItem,tiberiumNetworkNodeEntity,tibcat,
  {
    type = "recipe",
    name = "tiberium-network-node",
    normal =
    {
      energy_required = 20,
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
      ingredients =
      {
        {"electronic-circuit", 5},
        {"iron-gear-wheel", 10},
        {"iron-plate", 20}
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