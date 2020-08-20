local mgp = data.raw["map-gen-presets"].default
mgp["Tib-only"] = {
	order = "t",
	basic_settings = {
		--default_enable_all_autoplace_controls = false,
		autoplace_controls = {
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

local autoplaceExceptions = {
	["tibGrowthNode"] = true,
	["trees"] = true,
	["enemy-base"] = true,
	["lithia-water"] = true,
	["termal2"] = true,
}

for name, resource in pairs(data.raw.resource) do
	if resource.autoplace then
		if not autoplaceExceptions[resource.name] then
			mgp["Tib-only"].basic_settings.autoplace_controls[name] = {size = 0}
		end
	end
end

if mods["peaceful-plus"] then
	mgp["Tib-only"].basic_settings.autoplace_controls["enemy-base"] = nil
end
