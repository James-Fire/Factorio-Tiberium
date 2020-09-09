require("prototype/entity/CnC_SonicWall_Hub")
require("prototype/entity/growth-accelerator")
require("prototype/entity/ion-turret")
require("prototype/entity/tiberium-node-harvester")
require("prototype/entity/tiberium-centrifuge")
require("prototype/entity/tiberium-network-node")
require("prototype/entity/tiberium-power-plant")
require("prototype/entity/tiberium-spike")
require("prototype/entity/tiberium-beacon-node")
require("prototype/entity/tiberium-aoe-node-harvester")

table.insert(data.raw.character.character.mining_categories, "basic-solid-tiberium")
for _, drill in pairs(data.raw["mining-drill"]) do
	if LSlib.utils.table.hasValue(drill.resource_categories, "basic-solid") then 
		table.insert(drill.resource_categories, "basic-solid-tiberium")
	end
end
