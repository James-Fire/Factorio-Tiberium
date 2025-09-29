local tiberiumNetworkNode = flib.copy_prototype(data.raw["mining-drill"]["electric-mining-drill"], "tiberium-network-node")
tiberiumNetworkNode.energy_usage = "10000kW"
tiberiumNetworkNode.mining_speed = 10
tiberiumNetworkNode.subgroup = "a-buildings"
tiberiumNetworkNode.order = "h[tiberium-network-node]"
tiberiumNetworkNode.drops_full_belt_stacks = mods["space-age"] ~= nil  -- Drops stacks of ore if Space Age is enabled
tiberiumNetworkNode.resource_searching_radius = math.floor(common.TiberiumRadius * 0.5) + 0.49
tiberiumNetworkNode.resource_categories = {}
table.insert(tiberiumNetworkNode.resource_categories, "basic-solid-tiberium")
tiberiumNetworkNode.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = common.scaledEmissions(4, 50)
}
tiberiumNetworkNode.next_upgrade = nil
tiberiumNetworkNode.fast_replaceable_group = nil

data:extend{tiberiumNetworkNode}
