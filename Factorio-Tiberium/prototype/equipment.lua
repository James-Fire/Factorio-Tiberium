local tiberiumArmor = table.deepcopy(data.raw.armor["heavy-armor"])
tiberiumArmor.name = "tiberium-armor"
table.insert(tiberiumArmor.resistances, {type = "tiberium", decrease = 10, percent = 99})
tiberiumArmor.order = "c[tiberium-armor]"
tiberiumArmor.subgroup = "a-items"
tiberiumArmor.icons = {
   {
      icon = tiberiumArmor.icon,
      tint = {r = 0.3, g = 0.9, b = 0.3, a = 0.9}
   }
}

data:extend{tiberiumArmor}

local tiberiumPowerArmor = table.deepcopy(data.raw.armor["power-armor-mk2"])
tiberiumPowerArmor.name = "tiberium-power-armor"
tiberiumPowerArmor.order = "d[tiberium-power-armor]"
tiberiumPowerArmor.subgroup = "a-items"
tiberiumPowerArmor.icons= {
   {
      icon = tiberiumInternalName.."/graphics/icons/tiberium-field-suit.png",
      tint = {r = 0.3, g = 0.9, b = 0.3, a = 0.9}
   }
}

local updatedResist = false
for _, resist in pairs(tiberiumPowerArmor.resistances) do
	if resist.type == "tiberium" then
		resist.percent = 100
		updatedResist = true
		break
	end
end
if not updatedResist then
	tiberiumPowerArmor.resistances[#tiberiumPowerArmor.resistances + 1] = {
		type = "tiberium",
		decrease = 0,
		percent = 100
	}
end

data:extend{tiberiumPowerArmor}
