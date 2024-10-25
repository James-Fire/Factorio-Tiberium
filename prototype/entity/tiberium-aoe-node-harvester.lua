local tiberiumNodeHarvester = flib.copy_prototype(data.raw["mining-drill"]["electric-mining-drill"], "tiberium-aoe-node-harvester")
tiberiumNodeHarvester.icons = table.deepcopy(data.raw["mining-drill"]["pumpjack"].icons)
tiberiumNodeHarvester.icon_size = 64
tiberiumNodeHarvester.base_picture = data.raw["mining-drill"]["pumpjack"].base_picture
tiberiumNodeHarvester.animations = data.raw["mining-drill"]["pumpjack"].animations
tiberiumNodeHarvester.mining_speed = 10
tiberiumNodeHarvester.subgroup = "a-buildings"
tiberiumNodeHarvester.order = "l"
tiberiumNodeHarvester.energy_usage = "25000kW"
tiberiumNodeHarvester.resource_categories = {}
tiberiumNodeHarvester.resource_searching_radius = math.floor(common.TiberiumRadius * 0.8) + 0.49
table.insert(tiberiumNodeHarvester.resource_categories, "advanced-solid-tiberium")
tiberiumNodeHarvester.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = common.scaledEmissions(4, 50)
}
tiberiumNodeHarvester.next_upgrade = nil
tiberiumNodeHarvester.fast_replaceable_group = nil

data:extend{tiberiumNodeHarvester}
