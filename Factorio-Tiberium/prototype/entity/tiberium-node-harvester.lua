local tiberiumNodeHarvester = flib.copy_prototype(data.raw["mining-drill"]["electric-mining-drill"], "tiberium-node-harvester")
tiberiumNodeHarvester.icons = LSlib.item.getIcons("mining-drill", "pumpjack")
tiberiumNodeHarvester.icon_size = 64
tiberiumNodeHarvester.icon_mipmaps = nil
tiberiumNodeHarvester.base_picture = data.raw["mining-drill"]["pumpjack"].base_picture
tiberiumNodeHarvester.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
tiberiumNodeHarvester.animations = data.raw["mining-drill"]["pumpjack"].animations
tiberiumNodeHarvester.mining_speed = 5
tiberiumNodeHarvester.subgroup = "a-buildings"
tiberiumNodeHarvester.order = "e"
tiberiumNodeHarvester.energy_usage = "5000kW"
tiberiumNodeHarvester.resource_categories = {}
tiberiumNodeHarvester.resource_searching_radius = 0.49
tiberiumNodeHarvester.collision_mask = {"water-tile", "player-layer"}
table.insert(tiberiumNodeHarvester.resource_categories, "advanced-solid-tiberium")
tiberiumNodeHarvester.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = 25 * common.scalePollution(4)
}
tiberiumNodeHarvester.next_upgrade = nil
tiberiumNodeHarvester.fast_replaceable_group = nil

data:extend{tiberiumNodeHarvester}
