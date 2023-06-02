local rusty_locale = require("__rusty-locale__.locale")

local prototypes = {}
prototypes["ammo"] = {
	"tiberium-rounds-magazine",
	"tiberium-rocket",
	"tiberium-seed",
	"tiberium-chemical-sprayer-ammo",
}
prototypes["technology"] = {
	"tiberium-slurry-centrifuging",
	"tiberium-molten-centrifuging",
	"tiberium-liquid-centrifuging",
	"tiberium-advanced-molten-processing",
	"tiberium-control-network-tech",
	"tiberium-power-tech",
	"tiberium-sludge-processing",
	"tiberium-sludge-recycling",
	"tiberium-growth-acceleration",
	"tiberium-transmutation-tech",
	"tiberium-mechanical-research",
	"tiberium-thermal-research",
	"tiberium-chemical-research",
	"tiberium-nuclear-research",
	"tiberium-electromagnetic-research",
	"tiberium-molten-processing",
	"tiberium-energy-weapons-damage",
	"tiberium-explosives",
	"tiberium-containment-tech",
	"tiberium-growth-acceleration-acceleration",
	"tiberium-control-network-speed",
	"tiberium-advanced-containment-tech",
}
prototypes["recipe"] = {
	"tiberium-sludge-from-slurry",
	"tiberium-science-thru-thermal",
	"tiberium-science-thru-chemical",
	"tiberium-science-thru-nuclear",
	"tiberium-science-thru-EM",
}
prototypes["car"] = {
	"tiberium-marv",
}
prototypes["item"] = {
	"tiberium-power-plant",
	"tiberium-growth-credit",
	"tiberium-network-node",
	"tiberium-node-harvester",
	"tiberium-srf-emitter",
	"tiberium-spike",
	"tiberium-ion-core",
	"tiberium-centrifuge-1",
	"tiberium-centrifuge-2",
	"tiberium-centrifuge-3",
	"tiberium-empty-cell",
	"tiberium-dirty-cell",
	"tiberium-fuel-cell",
	"tiberium-data-mechanical",
	"tiberium-data-thermal",
	"tiberium-data-chemical",
	"tiberium-data-nuclear",
	"tiberium-data-EM",
}
prototypes["tool"] = {
	"tiberium-science",
}
prototypes["assembling-machine"] = {
	"tiberium-centrifuge-1",
	"tiberium-centrifuge-2",
	"tiberium-centrifuge-3",
	"tiberium-growth-accelerator",
}
prototypes["mining-drill"] = {
	"tiberium-growth-accelerator-node",
	"tiberium-network-node",
	"tiberium-node-harvester",
	"tiberium-aoe-node-harvester",
	"tiberium-spike",
}
prototypes["ammo-turret"] = {
	"tiberium-advanced-guard-tower",
}
prototypes["electric-turret"] = {
	"tiberium-obelisk-of-light",
}
prototypes["beacon"] = {
	"tiberium-beacon-node",
}
prototypes["generator"] = {
	"tiberium-power-plant",
}
prototypes["electric-energy-interface"] = {
	"tiberium-srf-emitter",
}
prototypes["simple-entity"] = {
	"tiberium-srf-wall",
}
prototypes["resource"] = {
	"tibGrowthNode_infinite",
}

for type in pairs(prototypes) do
	for _, name in pairs(prototypes[type]) do
		if data.raw[type][name] then
			local localised = rusty_locale.of(name, type)
			if not data.raw[type][name].localised_description then
				data.raw[type][name].localised_description = localised.description
			end
		end
	end
end
