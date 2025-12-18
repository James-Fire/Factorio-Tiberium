data:extend{
	--Starting settings
	{
		type = "string-setting",
		name = "tiberium-on",
		setting_type = "startup",
		allowed_values = {"nauvis", "pure-nauvis", "tiber", "tiber-start"},
		default_value = "tiber",
		order = "a[startup]1",
	},
	{
		type = "bool-setting",
		name = "tiberium-on-nauvis",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]2",
	},
	{
		type = "bool-setting",
		name = "tiberium-on-vulcanus",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]3",
	},
	{
		type = "bool-setting",
		name = "tiberium-on-gleba",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]4",
	},
	{
		type = "bool-setting",
		name = "tiberium-on-fulgora",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]5",
	},
	{
		type = "bool-setting",
		name = "tiberium-on-aquilo",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]6",
	},
	{
		type = "bool-setting",
		name = "tiberium-on-all-other-planets",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]7",
	},
	{
		type = "bool-setting",
		name = "tiberium-advanced-start",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]8",
	},
	{
		type = "bool-setting",
		name = "tiberium-ore-removal",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]9",
		hidden = true,
	},
	{
		type = "bool-setting",
		name = "tiberium-tier-zero",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]10",
	},
	{
		type = "bool-setting",
		name = "tiberium-starting-area",
		setting_type = "startup",
		default_value = false,
		order = "a[startup]11",
	},
	{
		type = "bool-setting",
		name = "tiberium-technology-triggers",
		setting_type = "startup",
		default_value = true,
		order = "a[startup]12",
	},
	{
		type = "double-setting",
		name = "tiberium-pollution-multiplier",
		setting_type = "startup",
		default_value = 4,
		minimum_value = 1,
		maximum_value = 100,
		order = "a[startup]13",
	},
	--Growth settings
	{
		type = "int-setting",
		name = "tiberium-growth",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 1,
		maximum_value = 100,
		order = "b[growth]1",
	},
	{
		type = "int-setting",
		name = "tiberium-radius",
		setting_type = "startup",
		default_value = 30,
		minimum_value = 10,
		maximum_value = 100,
		order = "b[growth]2",
	},
	{
		type = "bool-setting",
		name = "tiberium-grow-on-landfill",
		setting_type = "startup",
		default_value = true,
		order = "b[growth]3",
	},
	--Refining Recipe Settings
	{
		type = "int-setting",
		name = "tiberium-value",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 1,
		maximum_value = 100,
		order = "c[refining]1"
	},
	{
		type = "bool-setting",
		name = "tiberium-easy-recipes",
		setting_type = "startup",
		default_value = false,
		order = "c[refining]2",
	},
	{
		type = "bool-setting",
		name = "tiberium-byproduct-1",
		setting_type = "startup",
		default_value = true,
		order = "c[refining]3",
	},
	{
		type = "bool-setting",
		name = "tiberium-byproduct-2",
		setting_type = "startup",
		default_value = false,
		order = "c[refining]4",
	},
	--Direct recipe settings
	{
		type = "bool-setting",
		name = "tiberium-direct-catalyst",
		setting_type = "startup",
		default_value = false,
		order = "d[direct]1",
	},
	{
		type = "bool-setting",
		name = "tiberium-byproduct-direct",
		setting_type = "startup",
		default_value = false,
		order = "d[direct]2",
	},
	{
		type = "bool-setting",
		name = "tiberium-direct-surface-condition",
		setting_type = "startup",
		default_value = true,
		order = "d[direct]3",
	},
	{
		type = "bool-setting",
		name = "tiberium-direct-planet-techs",
		setting_type = "startup",
		default_value = true,
		order = "d[direct]4",
	},
	{
		type = "string-setting",
		name = "tiberium-resource-inclusions",
		setting_type = "startup",
		default_value = "",
		allow_blank = true,
		auto_trim = true,
		order = "d[direct]5",
	},
	{
		type = "string-setting",
		name = "tiberium-resource-exclusions",
		setting_type = "startup",
		default_value = "",
		allow_blank = true,
		auto_trim = true,
		order = "d[direct]6",
	},
	--Centrifuging recipe settings
	{
		type = "bool-setting",
		name = "tiberium-force-vanilla-centrifuging",
		setting_type = "startup",
		default_value = false,
		order = "e[centrifuging]0",
	},
	{
		type = "string-setting",
		name = "tiberium-recipe-category-exclusions",
		setting_type = "startup",
		default_value = "",
		allow_blank = true,
		auto_trim = true,
		order = "e[centrifuging]1",
	},
	{
		type = "bool-setting",
		name = "tiberium-centrifuge-alien-ores",
		setting_type = "startup",
		default_value = false,
		order = "e[centrifuging]2",
	},
	{
		type = "string-setting",
		name = "tiberium-centrifuge-override-0",
		localised_name = {"mod-setting-name.tiberium-centrifuge-override", {"technology-name.tiberium-ore-centrifuging"}},
		localised_description = {"mod-setting-description.tiberium-centrifuge-override", {"technology-name.tiberium-ore-centrifuging"}},
		setting_type = "startup",
		default_value = "Vanilla settings example: copper-ore:3,iron-ore:9,coal:1,stone:3",
		allow_blank = true,
		auto_trim = true,
		order = "e[centrifuging]3",
	},
	{
		type = "string-setting",
		name = "tiberium-centrifuge-override-1",
		localised_name = {"mod-setting-name.tiberium-centrifuge-override", {"technology-name.tiberium-slurry-centrifuging"}},
		localised_description = {"mod-setting-description.tiberium-centrifuge-override", {"technology-name.tiberium-slurry-centrifuging"}},
		setting_type = "startup",
		default_value = "Vanilla settings example: copper-ore:5,iron-ore:18,coal:3,stone:6",
		allow_blank = true,
		auto_trim = true,
		order = "e[centrifuging]4",
	},
	{
		type = "string-setting",
		name = "tiberium-centrifuge-override-2",
		localised_name = {"mod-setting-name.tiberium-centrifuge-override", {"technology-name.tiberium-molten-centrifuging"}},
		localised_description = {"mod-setting-description.tiberium-centrifuge-override", {"technology-name.tiberium-molten-centrifuging"}},
		setting_type = "startup",
		default_value = "Vanilla settings example: copper-ore:17,iron-ore:21,coal:2,crude-oil:86,stone:3",
		allow_blank = true,
		auto_trim = true,
		order = "e[centrifuging]5",
	},
	{
		type = "string-setting",
		name = "tiberium-centrifuge-override-3",
		localised_name = {"mod-setting-name.tiberium-centrifuge-override", {"technology-name.tiberium-liquid-centrifuging"}},
		localised_description = {"mod-setting-description.tiberium-centrifuge-override", {"technology-name.tiberium-liquid-centrifuging"}},
		setting_type = "startup",
		default_value = "Vanilla settings example: copper-ore:30,iron-ore:44,coal:5,crude-oil:168,stone:7",
		allow_blank = true,
		auto_trim = true,
		order = "e[centrifuging]6",
	},
	{
		type = "bool-setting",
		name = "tiberium-debug-text-startup",
		setting_type = "startup",
		default_value = false,
		order = "z[debug]1",
	},
}

data:extend{--Runtime settings
	{
		type = "bool-setting",
		name = "tiberium-spread-nodes",
		setting_type = "runtime-global",
		default_value = true,
		order = "a[growth]1",
	},
	{
		type = "bool-setting",
		name = "tiberium-auto-scale-performance",
		setting_type = "runtime-global",
		default_value = false,
		order = "a[growth]2",
	},
	{
		type = "int-setting",
		name = "tiberium-damage",
		setting_type = "runtime-global",
		default_value = 10,
		minimum_value = 0,
		maximum_value = 50,
		order = "b[damage]1",
	},
	{
		type = "bool-setting",
		name = "tiberium-item-damage-scale",
		setting_type = "runtime-global",
		default_value = false,
		order = "b[damage]2",
	},
	{
		type = "bool-setting",
		name = "tiberium-enemies-take-environmental-damage",
		setting_type = "runtime-global",
		default_value = false,
		order = "b[damage]3",
	},
	{
		type = "double-setting",
		name = "tiberium-blue-target-evo",
		setting_type = "runtime-global",
		default_value = 0.6,
		minimum_value = 0,
		maximum_value = 1,
		order = "c[blue-tiberium]1",
	},
	{
		type = "int-setting",
		name = "tiberium-blue-saturation-point",
		setting_type = "runtime-global",
		default_value = 25,
		minimum_value = 0,
		maximum_value = 100,
		order = "c[blue-tiberium]2",
	},
	{
		type = "int-setting",
		name = "tiberium-blue-saturation-slowdown",
		setting_type = "runtime-global",
		default_value = 10,
		minimum_value = 0,
		maximum_value = 1000,
		order = "c[blue-tiberium]3",
	},
	{
		type = "bool-setting",
		name = "tiberium-debug-text",
		setting_type = "runtime-global",
		default_value = false,
		order = "z[debug]1",
	},
}

if mods["space-exploration"] then
	data.raw["double-setting"]["tiberium-blue-target-evo"].default_value = 0.3
end

if mods["any-planet-start"] and APS then
	APS.add_choice("tiber")
end

if not mods["space-age"] then
	data.raw["string-setting"]["tiberium-on"].allowed_values = {"nauvis", "pure-nauvis"}
	data.raw["string-setting"]["tiberium-on"].default_value = "nauvis"

	data.raw["bool-setting"]["tiberium-on-nauvis"].hidden = true
	data.raw["bool-setting"]["tiberium-on-vulcanus"].hidden = true
	data.raw["bool-setting"]["tiberium-on-gleba"].hidden = true
	data.raw["bool-setting"]["tiberium-on-fulgora"].hidden = true
	data.raw["bool-setting"]["tiberium-on-aquilo"].hidden = true
	data.raw["bool-setting"]["tiberium-on-all-other-planets"].hidden = true

	data.raw["bool-setting"]["tiberium-direct-surface-condition"].hidden = true
	data.raw["bool-setting"]["tiberium-direct-surface-condition"].default_value = false

	data.raw["bool-setting"]["tiberium-direct-planet-techs"].hidden = true
	data.raw["bool-setting"]["tiberium-direct-planet-techs"].default_value = false

	data.raw["bool-setting"]["tiberium-centrifuge-alien-ores"].hidden = true
end

for _, type in pairs({"int-setting", "bool-setting", "double-setting"}) do
	for name, setting in pairs(data.raw[type]) do
		if string.sub(name, 1, 8) == "tiberium" then
			local default = setting.default_value
			if default == true then  -- Because true/false looks ugly
				default = {"mod-setting-description.tiberium-description-enabled"}
			elseif default == false then
				default = {"mod-setting-description.tiberium-description-disabled"}
			else
				default = tostring(default)
			end
			setting.localised_description = {"mod-setting-description.tiberium-description-template",
					{"mod-setting-description."..name}, {"mod-setting-description.tiberium-description-default"}, default}
		end
	end
end