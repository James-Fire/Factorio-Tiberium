for _, d in pairs(data.raw["damage-type"]) do
	resist = {}
	resist.type = d.name
	resist.percent = 100
	table.insert(data.raw["land-mine"]["node-land-mine"].resistances, resist)
end
--Remove resources that aren't Tiberium from Autoplace
--[[data.raw.resource["crude-oil"] = nil
data.raw["autoplace-control"]["crude-oil"] = nil

for _, pre in pairs(data.raw["map-gen-presets"].default) do
	if pre.basic_settings then
		if pre.basic_settings.autoplace_controls then
			pre.basic_settings.autoplace_controls[ore.name] = nil
			pre.basic_settings.autoplace_controls["sulfur"] = nil
			pre.basic_settings.autoplace_controls["infinite-"..ore.name] = nil
		end
	end
end]]

if settings.startup["tiberium-advanced-start"].value then
	--for _, ore in pairs(data.raw["autoplace-control"]) do
		for _, gen in pairs(data.raw["resource"]) do
			if gen.name == "tibGrowthNode" then
			elseif gen.name == "tiberium-ore" then
			else
				data.raw.resource[gen.name] = nil
				data.raw["autoplace-control"][gen.name] = nil
			end
		end
		for _, pre in pairs(data.raw["map-gen-presets"].default) do
			if pre.basic_settings then
				if pre.basic_settings.autoplace_controls then
					pre.basic_settings.autoplace_controls["stone"] = nil
					pre.basic_settings.autoplace_controls["crude-oil"] = nil
					pre.basic_settings.autoplace_controls["uranium-ore"] = nil
					pre.basic_settings.autoplace_controls["copper-ore"] = nil
					pre.basic_settings.autoplace_controls["iron-ore"] = nil
					pre.basic_settings.autoplace_controls["coal"] = nil
					pre.basic_settings.autoplace_controls["sulfur"] = nil
				end
			end
		end
	--end
end