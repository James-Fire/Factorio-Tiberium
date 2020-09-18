local rusty_locale = require("__rusty-locale__.locale")

local prototypes = {}
prototypes["ammo"] = {
	"tiberium-rounds-magazine",
	"tiberium-rocket",
	"tiberium-seed",
}
prototypes["technology"] = {
	"tiberium-separation-tech",
	"tiberium-processing-tech",
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
}
prototypes["recipe"] = {
	"tiberium-power-armor",
	"tiberium-sludge-from-slurry",
}
prototypes["armor"] = {
	"tiberium-armor",
	"tiberium-power-armor",
}
prototypes["car"] = {
	"tiberium-marv",
}
prototypes["item"] = {
	"tiberium-power-plant",
	"tiberium-growth-credit",
	"tiberium-growth-accelerator",
	"tiberium-network-node",
	"tiberium-node-harvester",
	"tiberium-srf-emitter",
	"tiberium-spike",
	"tiberium-ion-turret",
	"tiberium-ion-core",
	"tiberium-centrifuge",
	"tiberium-centrifuge-2",
	"tiberium-centrifuge-3",
	"tiberium-empty-cell",
	"tiberium-dirty-cell",
	"tiberium-fuel-cell",
	"tiberium-data",
	"tiberium-aoe-node-harvester",
	"tiberium-beacon-node",
}
prototypes["tool"] = {
	"tiberium-science",
}
prototypes["assembling-machine"] = {
	"tiberium-centrifuge",
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
prototypes["electric-turret"] = {
	"tiberium-ion-turret",
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
