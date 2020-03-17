for _, armor in pairs(data.raw.armor) do
		log("found armor")
	for _, resistance in pairs (armor.resistances) do
		if resistance.type = "acid" then
			log("has acid")
			table.insert(armor.resistances, {type= tiberium, decrease = 10, percent = 10})
		end
	end
end


--[[table.insert(data.raw.armor["light-armor"].resistances,
	{
        type = "tiberium",
        decrease = 0,
        percent = 20
    }
)
table.insert(data.raw.armor["heavy-armor"].resistances,
	{
        type = "tiberium",
        decrease = 0,
        percent = 40
    }
)
table.insert(data.raw.armor["modular-armor"].resistances,
    {
		type = "tiberium",
		decrease = 0,
		percent = 50
    }
)
table.insert(data.raw.armor["power-armor"].resistances,
	{
		type = "tiberium",
		decrease = 0,
		percent = 60
    }
)
table.insert(data.raw.armor["power-armor-mk2"].resistances,
	{
		type = "tiberium",
		decrease = 0,
		percent = 70
	}
)]]