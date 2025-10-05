data:extend{
	{
		type = "change-surface-achievement",
		name = "visit-tiber",
		icon = tiberiumInternalName.."/graphics/icons/tiber-planet.png",
		icon_size = 512,
		hidden = true,
		order = "a[progress]-g[visit-planet]-a[tiber]",
		surface = "tiber",
	},
	{
		type = "player-damaged-achievement",
		name = "tiberium-floor-is-lava",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128,
		minimum_damage = 0,
		should_survive = true,
		type_of_dealer = "resource"
	},
	{
		type = "dont-research-before-researching-achievement",
		name = "tiberium-before-uranium",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128,
		dont_research = "centrifuge",
		research_with = "tiberium-science"
	},
	{
		type = "achievement",
		name = "tiberium-hot-potato",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128
	},
	{
		type = "achievement",
		name = "tiberium-seed-node",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128
	},
	{
		type = "achievement",
		name = "tiberium-spill",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128
	},
	{
		type = "achievement",
		name = "tiberium-generator",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128
	},
	{
		type = "achievement",
		name = "tiberium-forgot-armor",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128
	},
	{
		type = "achievement",
		name = "tiberium-marv",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128
	},
	{
		type = "build-entity-achievement",
		name = "tiberium-srf",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128,
		to_build = "tiberium-srf-connector",
		amount = 2
	},
	{
		type = "build-entity-achievement",
		name = "tiberium-spike",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128,
		to_build = "tiberium-spike"
	},
	{
		type = "complete-objective-achievement",
		name = "tiberium-escape",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-tech.png",
		icon_size = 128,
		objective_condition = "rocket-launched",
		hidden = true
	},
}

if common.whichPlanet == "tiber-start" or common.whichPlanet == "pure-nauvis"
		or (mods["any-planet-start"] and settings.startup["aps-planet"] == "tiber") then
	data.raw["complete-objective-achievement"]["tiberium-escape"].hidden = false
end
if common.whichPlanet == "tiber" then
	data.raw["change-surface-achievement"]["visit-tiber"].hidden = false
end
