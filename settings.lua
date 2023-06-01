data:extend{
	{
		type = "int-setting",
		name = "tiberium-growth",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 1,
		maximum_value = 100,
		order = "a1",
	},
	{
		type = "int-setting",
		name = "tiberium-spread",
		setting_type = "startup",
		default_value = 30,
		minimum_value = 0,
		maximum_value = 100,
		order = "a2",
	},
	{
		type = "int-setting",
		name = "tiberium-value",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 1,
		maximum_value = 100,
		order = "a3"
	},
	{
		type = "int-setting",
		name = "tiberium-damage",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 0,
		maximum_value = 50,
		order = "a4",
	},
	{
		type = "int-setting",
		name = "tiberium-blue-saturation-point",
		setting_type = "startup",
		default_value = 25,
		minimum_value = 0,
		maximum_value = 100,
		order = "a5",
	},
	{
		type = "int-setting",
		name = "tiberium-blue-saturation-slowdown",
		setting_type = "startup",
		default_value = 10,
		minimum_value = 0,
		maximum_value = 1000,
		order = "a6",
	},
	{
		type = "bool-setting",
		name = "tiberium-starting-area",
		setting_type = "startup",
		default_value = false,
		order = "b1",
	},
	{
		type = "bool-setting",
		name = "tiberium-wont-damage-biters",
		setting_type = "startup",
		default_value = true,
		order = "b2",
	},
	{
		type = "bool-setting",
		name = "tiberium-easy-recipes",
		setting_type = "startup",
		default_value = false,
		order = "b3",
	},
	{
		type = "bool-setting",
		name = "tiberium-byproduct-1",
		setting_type = "startup",
		default_value = true,
		order = "b4",
	},
	{
		type = "bool-setting",
		name = "tiberium-byproduct-2",
		setting_type = "startup",
		default_value = false,
		order = "b5",
	},
	{
		type = "bool-setting",
		name = "tiberium-byproduct-direct",
		setting_type = "startup",
		default_value = false,
		order = "b6",
	},
	{
		type = "bool-setting",
		name = "tiberium-auto-scale-performance",
		setting_type = "startup",
		default_value = false,
		order = "b7",
	},
	{
		type = "bool-setting",
		name = "tiberium-debug-text",
		setting_type = "startup",
		default_value = false,
		order = "c1",
	},
	{
		type = "string-setting",
		name = "tiberium-centrifuge-override-0",
		localised_name = {"mod-setting-name.tiberium-centrifuge-override", {"technology-name.tiberium-ore-centrifuging"}},
		localised_description = {"mod-setting-description.tiberium-centrifuge-override", {"technology-name.tiberium-ore-centrifuging"}},
		setting_type = "startup",
		default_value = "",
		allow_blank = true,
		auto_trim = true,
		order = "d0",
	},
	{
		type = "string-setting",
		name = "tiberium-centrifuge-override-1",
		localised_name = {"mod-setting-name.tiberium-centrifuge-override", {"technology-name.tiberium-slurry-centrifuging"}},
		localised_description = {"mod-setting-description.tiberium-centrifuge-override", {"technology-name.tiberium-slurry-centrifuging"}},
		setting_type = "startup",
		default_value = "",
		allow_blank = true,
		auto_trim = true,
		order = "d1",
	},
	{
		type = "string-setting",
		name = "tiberium-centrifuge-override-2",
		localised_name = {"mod-setting-name.tiberium-centrifuge-override", {"technology-name.tiberium-molten-centrifuging"}},
		localised_description = {"mod-setting-description.tiberium-centrifuge-override", {"technology-name.tiberium-molten-centrifuging"}},
		setting_type = "startup",
		default_value = "",
		allow_blank = true,
		auto_trim = true,
		order = "d2",
	},
	{
		type = "string-setting",
		name = "tiberium-centrifuge-override-3",
		localised_name = {"mod-setting-name.tiberium-centrifuge-override", {"technology-name.tiberium-liquid-centrifuging"}},
		localised_description = {"mod-setting-description.tiberium-centrifuge-override", {"technology-name.tiberium-liquid-centrifuging"}},
		setting_type = "startup",
		default_value = "",
		allow_blank = true,
		auto_trim = true,
		order = "d3",
	},
	{
		type = "string-setting",
		name = "tiberium-resource-exclusions",
		setting_type = "startup",
		default_value = "",
		allow_blank = true,
		auto_trim = true,
		order = "d8",
	},
	{
		type = "double-setting",
		name = "tiberium-blue-target-evo",
		setting_type = "startup",
		default_value = 0.6,
		minimum_value = 0,
		maximum_value = 1,
		order = "z",
	},
	{
		type = "double-setting",
		name = "tiberium-pollution-multiplier",
		setting_type = "startup",
		default_value = 4,
		minimum_value = 1,
		maximum_value = 100,
		order = "z",
	},
	{
		type = "bool-setting",
		name = "tiberium-tier-zero",
		setting_type = "startup",
		default_value = false,
		order = "z",
	},
	{
		type = "bool-setting",
		name = "tiberium-advanced-start",
		setting_type = "startup",
		default_value = false,
		order = "z",
	},
	{
		type = "bool-setting",
		name = "tiberium-ore-removal",
		setting_type = "startup",
		default_value = false,
		order = "z",
	},
	{
		type = "bool-setting",
		name = "tiberium-item-damage-scale",
		setting_type = "runtime-global",
		default_value = false,
		order = "z",
	},
}
if mods["space-exploration"] then
	data.raw["double-setting"]["tiberium-blue-target-evo"].default_value = 0.3
end