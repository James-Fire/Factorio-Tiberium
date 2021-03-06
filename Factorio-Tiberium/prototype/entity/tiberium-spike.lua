local tiberiumSpike = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
tiberiumSpike.name = "tiberium-spike"
tiberiumSpike.icon_size = 128
tiberiumSpike.icon = tiberiumInternalName.."/graphics/icons/tiberium-spike.png"
tiberiumSpike.icon_mipmaps = nil
tiberiumSpike.radius_visualisation_picture = data.raw["mining-drill"]["pumpjack"].radius_visualisation_picture
tiberiumSpike.mining_speed = 5
tiberiumSpike.subgroup = "a-buildings"
tiberiumSpike.order = "g[tiberium-spike]"
tiberiumSpike.resource_categories = {}
tiberiumSpike.minable.result = "tiberium-spike"
tiberiumSpike.resource_searching_radius = 0.49
tiberiumSpike.collision_mask = {"water-tile", "player-layer"}
table.insert(tiberiumSpike.resource_categories, "advanced-liquid-tiberium")
table.insert(tiberiumSpike.resource_categories, "advanced-solid-tiberium")
tiberiumSpike.energy_source = {
	type = "void",
	usage_priority = "secondary-input",
	emissions_per_minute = 20
}
tiberiumSpike.next_upgrade = nil
tiberiumSpike.fast_replaceable_group = nil

data:extend{tiberiumSpike}
