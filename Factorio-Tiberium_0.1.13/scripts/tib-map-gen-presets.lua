local mgp = data.raw["map-gen-presets"].default
mgp["Tib-only"] = {
	order = "t",
	basic_settings =
	{
	--default_enable_all_autoplace_controls = false,
	autoplace_controls =
	{
		["tibGrowthNode"] = {
			frequency = "high",
			size = "high"
		},
		["trees"] = {
			frequency = "high",
			size = "high"
		},
		["enemy-base"] = {
			frequency = "high",
			size = "high"
		},
	},
	water = 1,
	}
}

for name,resource in pairs(data.raw.resource) do
	if resource.autoplace then
		if resource.name == "lithia-water" then
		else
		if resource.name == "tibGrowthNode" then
		else
		if resource.name == "trees" then
		else
		if resource.name == "enemy-base" then
		else
		mgp["Tib-only"].basic_settings.autoplace_controls[name] = {size = 0}
		end
		end
		end
		end
	end  
end