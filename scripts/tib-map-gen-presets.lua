local mgp = data.raw["map-gen-presets"].default
mgp["Tib-only"] = {
	order = "t",
	basic_settings = {
		--default_enable_all_autoplace_controls = false,
		autoplace_controls = {
			["nauvis_tibGrowthNode"] = {
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
		--water = 1,
	}
}

local autoplaceExceptions = {
	["nauvis_tibGrowthNode"] = true,
	["trees"] = true,
	["enemy-base"] = true,
	["lithia-water"] = true,
	["termal2"] = true,
}

for name in pairs(data.raw.planet.nauvis.map_gen_settings.autoplace_controls) do
	if data.raw["autoplace-control"][name] and data.raw["autoplace-control"][name].category == "resource" then
		if not autoplaceExceptions[name] then
			mgp["Tib-only"].basic_settings.autoplace_controls[name] = {size = 0}
		end
	end
end

if mods["peaceful-plus"] then
	mgp["Tib-only"].basic_settings.autoplace_controls["enemy-base"] = nil
end
