for _, d in pairs(data.raw["damage-type"]) do
	resist = {}
	resist.type = d.name
	resist.percent = 100
	table.insert(data.raw["land-mine"]["node-land-mine"].resistances, resist)
end