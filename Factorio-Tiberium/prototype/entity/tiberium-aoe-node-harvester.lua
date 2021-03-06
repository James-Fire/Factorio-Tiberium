local TiberiumRadius = 20 + settings.startup["tiberium-spread"].value * 0.4 --Translates to 20-60 range

local tiberiumNodeHarvester = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
tiberiumNodeHarvester.name = "tiberium-aoe-node-harvester"
tiberiumNodeHarvester.icon = data.raw["mining-drill"]["pumpjack"].icon
tiberiumNodeHarvester.icon_size = 64
tiberiumNodeHarvester.base_picture = data.raw["mining-drill"]["pumpjack"].base_picture
tiberiumNodeHarvester.animations = data.raw["mining-drill"]["pumpjack"].animations
tiberiumNodeHarvester.mining_speed = 10
tiberiumNodeHarvester.subgroup = "a-buildings"
tiberiumNodeHarvester.order = "l"
tiberiumNodeHarvester.energy_usage = "25000kW"
tiberiumNodeHarvester.resource_categories = {}
tiberiumNodeHarvester.minable.result = "tiberium-aoe-node-harvester"
tiberiumNodeHarvester.resource_searching_radius = TiberiumRadius * 0.8
table.insert(tiberiumNodeHarvester.resource_categories, "advanced-solid-tiberium")
tiberiumNodeHarvester.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = 200
}
tiberiumNodeHarvester.next_upgrade = nil
tiberiumNodeHarvester.fast_replaceable_group = nil

data:extend{tiberiumNodeHarvester}
