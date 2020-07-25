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

require("science")

if settings.startup["tiberium-ore-removal"].value then
	--for _, ore in pairs(data.raw["autoplace-control"]) do
	 --[[if data.raw["recipe"][recipeName].result then
      data.raw["recipe"][recipeName].results = {{
        name = data.raw["recipe"][recipeName].result,
        amount = data.raw["recipe"][recipeName].result_count or 1,
      }}
      data.raw["recipe"][recipeName].result = nil
      data.raw["recipe"][recipeName].result_count = nil
    end]]
	for _, gen in pairs(data.raw["resource"]) do
		if gen.name == "tibGrowthNode" then
		elseif gen.name == "tibGrowthNode_infinite" then
		elseif gen.name == "tiberium-ore" then
		else
			data.raw.resource[gen.name] = nil
			data.raw["autoplace-control"][gen.name] = nil
		end
		for _, pre in pairs(data.raw["map-gen-presets"].default) do
			if pre.basic_settings then
				if pre.basic_settings.autoplace_controls then
					if pre.basic_settings.autoplace_controls["tibGrowthNode"] then
					elseif pre.basic_settings.autoplace_controls["tiberium-ore"] then
					elseif pre.basic_settings.autoplace_controls["tibGrowthNode_infinite"] then
					else
					pre.basic_settings.autoplace_controls[gen.name] = nil
					--pre.basic_settings.autoplace_controls["crude-oil"] = nil
					--pre.basic_settings.autoplace_controls["uranium-ore"] = nil
					--pre.basic_settings.autoplace_controls["copper-ore"] = nil
					--pre.basic_settings.autoplace_controls["iron-ore"] = nil
					--pre.basic_settings.autoplace_controls["coal"] = nil
					--pre.basic_settings.autoplace_controls["sulfur"] = nil
					end
				end
			end
		end
	end
end
