data:extend{
	{
		type = "item-group",
		name = "tiberium",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-processing-tech.png",
		icon_size = 128,
		inventory_order = "f-m",
		order = "f-m",
	},
	-- Subgroups
	{
		type = "item-subgroup",
		name = "a-buildings",
		group = "tiberium",
		order = "f-0",
	},
	{
		type = "item-subgroup",
		name = "a-refining",
		group = "tiberium",
		order = "f-1",
	},
	{
		type = "item-subgroup",
		name = "a-centrifuging",
		group = "tiberium",
		order = "f-2",
	},
	{
		type = "item-subgroup",
		name = "a-direct-easy",
		group = "tiberium",
		order = "f-3",
	},
	{
		type = "item-subgroup",
		name = "a-direct",
		group = "tiberium",
		order = "f-4",
	},
	{
		type = "item-subgroup",
		name = "a-growth-credits",
		group = "tiberium",
		order = "f-5",
	},
	{
		type = "item-subgroup",
		name = "a-intermediates",
		group = "tiberium",
		order = "f-6",
	},
	{
		type = "item-subgroup",
		name = "a-ore-science",
		group = "tiberium",
		order = "g-0",
	},
	{
		type = "item-subgroup",
		name = "a-slurry-science",
		group = "tiberium",
		order = "g-1",
	},
	{
		type = "item-subgroup",
		name = "a-molten-science",
		group = "tiberium",
		order = "g-2",
	},
	{
		type = "item-subgroup",
		name = "a-liquid-science",
		group = "tiberium",
		order = "g-3",
	},
	{
		type = "item-subgroup",
		name = "a-simple-science",
		group = "tiberium",
		order = "g-4",
	},
	{
		type = "item-subgroup",
		name = "a-mixed-science",
		group = "tiberium",
		order = "g-5",
	},
	{
		type = "item-subgroup",
		name = "a-items",
		group = "tiberium",
		order = "h-0",
	},
	-- Signal for alert
	{
		type = "item-subgroup",
		name = "tiberium-signals",
		group = "signals",
		order = "z",
	},
	{
		type = "virtual-signal",
		name = "tiberium-radiation",
		icon = tiberiumInternalName .. "/graphics/technology/tiberium-tech.png",
		icon_size = 128,
		subgroup = "tiberium-signals",
		order = "a[tiberium-radiation]"
	},
	-- Categories
	{
		type = "recipe-category",
		name = "tiberium-centrifuge-0"
	},
	{
		type = "recipe-category",
		name = "tiberium-centrifuge-1"
	},
	{
		type = "recipe-category",
		name = "tiberium-centrifuge-2"
	},
	{
		type = "recipe-category",
		name = "tiberium-centrifuge-3"
	},
	{
		type = "recipe-category",
		name = "tiberium-reprocessing"
	},
	{
		type = "recipe-category",
		name = "basic-tiberium-science"
	},
	{
		type = "recipe-category",
		name = "tiberium-science"
	},
	{
		type = "recipe-category",
		name = "growth"
	},
	-- Ammo categories
	{
		type = "ammo-category",
		name = "obelisk"
	},
}
