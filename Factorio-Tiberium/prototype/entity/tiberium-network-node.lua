local tiberiumNetworkNode = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
tiberiumNetworkNode.name = "tiberium-network-node"
tiberiumNetworkNode.energy_usage = "25000kW"
tiberiumNetworkNode.mining_speed = 10
tiberiumNetworkNode.subgroup = "a-buildings"
tiberiumNetworkNode.order = "h[tiberium-network-node]"
tiberiumNetworkNode.resource_searching_radius = 50
tiberiumNetworkNode.resource_categories = {}
tiberiumNetworkNode.minable.result = "tiberium-network-node"
table.insert(tiberiumNetworkNode.resource_categories, "basic-solid-tiberium")
tiberiumNetworkNode.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = 200
}

data:extend{tiberiumNetworkNode}
