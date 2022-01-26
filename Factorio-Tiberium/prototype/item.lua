data:extend{
	--Science stuff
	{
		type = "item",
		name = "tiberium-data-mechanical",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-data-mechanical.png",
		icon_size = 32,
		flags = {},
		localised_name = {"item-name.tiberium-data-generic", {"recipe-name.tiberium-testing-mechanical"}},
		localised_description = {"item-description.tiberium-data"},
		subgroup = "a-items",
		order = "a[science]-a[mechanical-data]",
		stack_size = 200
	},
	{
		type = "item",
		name = "tiberium-data-thermal",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-data-thermal.png",
		icon_size = 32,
		flags = {},
		localised_name = {"item-name.tiberium-data-generic", {"recipe-name.tiberium-testing-thermal"}},
		localised_description = {"item-description.tiberium-data"},
		subgroup = "a-items",
		order = "a[science]-b[thermal-data]",
		stack_size = 200
	},
	{
		type = "item",
		name = "tiberium-data-chemical",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-data-chemical.png",
		icon_size = 32,
		flags = {},
		localised_name = {"item-name.tiberium-data-generic", {"recipe-name.tiberium-testing-chemical"}},
		localised_description = {"item-description.tiberium-data"},
		subgroup = "a-items",
		order = "a[science]-c[chemical-data]",
		stack_size = 200
	},
	{
		type = "item",
		name = "tiberium-data-nuclear",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-data-nuclear.png",
		icon_size = 32,
		flags = {},
		localised_name = {"item-name.tiberium-data-generic", {"recipe-name.tiberium-testing-nuclear"}},
		localised_description = {"item-description.tiberium-data"},
		subgroup = "a-items",
		order = "a[science]-d[nuclear-data]",
		stack_size = 200
	},
	{
		type = "item",
		name = "tiberium-data-EM",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-data-EM.png",
		icon_size = 32,
		flags = {},
		localised_name = {"item-name.tiberium-data-generic", {"recipe-name.tiberium-testing-EM"}},
		localised_description = {"item-description.tiberium-data"},
		subgroup = "a-items",
		order = "a[science]-e[EM-data]",
		stack_size = 200
	},
	{
		type = "tool",
		name = "tiberium-science",
		icon = tiberiumInternalName.."/graphics/icons/tacitus.png",
		icon_size = 32,
		flags = {},
		subgroup = "a-items",
		order = "a[science]-f[science-pack]",
		durability = 1,
		durability_description_key = "description.science-pack-remaining-amount-key",
		durability_description_value = "description.science-pack-remaining-amount-value",
		stack_size = 200,
	},
	--Structures
	{
		type = "item",
		name = "tiberium-growth-accelerator",
		icon = tiberiumInternalName.."/graphics/technology/growth-accelerator.png",
		icon_size = 128,
		subgroup = "a-buildings",
		order = "d[tiberium-growth-accelerator]",
		place_result = "tiberium-growth-accelerator-node",
		stack_size = 15,
	},
	{
		type = "item",
		name = "tiberium-power-plant",
		icon = tiberiumInternalName.."/graphics/icons/td-power-plant.png",
		icon_size = 64,
		flags = {},
		subgroup = "a-buildings",
		order = "e[tiberium-power-plant]",
		place_result = "tiberium-power-plant",
		stack_size = 20
	},
	{
		type = "item",
		name = "tiberium-centrifuge",
		icons = {
			{
				icon = tiberiumInternalName.."/graphics/icons/fuge1.png",
				icon_size = 32,
			},
			{
				icon = "__base__/graphics/icons/centrifuge.png",
				icon_size = 64,
				scale = 28/64,
			},
		},
		icon_size = 32,
		flags = {},
		subgroup = "a-buildings",
		order = "a[tiberium-centrifuge]-1",
		place_result = "tiberium-centrifuge",
		stack_size = 20
	},
	{
		type = "item",
		name = "tiberium-centrifuge-2",
		icons = {
			{
				icon = tiberiumInternalName.."/graphics/icons/fuge2.png",
				icon_size = 32,
			},
			{
				icon = "__base__/graphics/icons/centrifuge.png",
				icon_size = 64,
				scale = 28/64,
			},
		},
		icon_size = 32,
		flags = {},
		subgroup = "a-buildings",
		order = "a[tiberium-centrifuge]-2",
		place_result = "tiberium-centrifuge-2",
		stack_size = 20
	},
	{
		type = "item",
		name = "tiberium-centrifuge-3",
		icons = {
			{
				icon = tiberiumInternalName.."/graphics/icons/fuge3.png",
				icon_size = 32,
			},
			{
				icon = "__base__/graphics/icons/centrifuge.png",
				icon_size = 64,
				scale = 28/64,
			},
		},
		icon_size = 32,
		flags = {},
		subgroup = "a-buildings",
		order = "a[tiberium-centrifuge]-3",
		place_result = "tiberium-centrifuge-3",
		stack_size = 20
	},
	{
		type = "item",
		name = "tiberium-srf-emitter",
		icon = tiberiumInternalName.."/graphics/sonic wall/node icon.png",
		icon_size = 32,
		subgroup = "a-buildings",
		order = "b[srf]",
		place_result = "tiberium-srf-connector",
		stack_size = 50
	},
	{
		type = "item",
		name = "tiberium-sonic-emitter",
		icons =  common.layeredIcons(tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png", 128,
			tiberiumInternalName.."/graphics/icons/tiberium-ore.png", 64, "ne", 12),
		icon_size = 128,
		subgroup = "a-buildings",
		order = "b[srf]-2",
		place_result = "tiberium-sonic-emitter",
		stack_size = 50
	},
	{
		type = "item",
		name = "tiberium-sonic-emitter-blue",
		icons =  common.layeredIcons(tiberiumInternalName.."/graphics/entity/sonic-emitter/CNCTW_Sonic_Emitter_Cameo.png", 128,
			tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png", 64, "ne", 12),
		subgroup = "a-buildings",
		order = "b[srf]-3",
		place_result = "tiberium-sonic-emitter-blue",
		stack_size = 50
	},
	{
		type = "item",
		name = "tiberium-network-node",
		icon = "__base__/graphics/icons/electric-mining-drill.png",
		icon_mipmaps = 4,
		icon_size = 64,
		order = "h[tiberium-network-node]",
		place_result = "tiberium-network-node",
		stack_size = 50,
		subgroup = "a-buildings",
	},
	{
		type = "item",
		name = "tiberium-node-harvester",
		icon = "__base__/graphics/icons/pumpjack.png",
		icon_mipmaps = 4,
		icon_size = 64,
		order = "c[node-harvester]",
		place_result = "tiberium-node-harvester",
		stack_size = 20,
		subgroup = "a-buildings",
	},
	{
		type = "item",
		name = "tiberium-spike",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-spike.png",
		icon_size = 128,
		order = "g[tiberium-spike]",
		place_result = "tiberium-spike",
		stack_size = 20,
		subgroup = "a-buildings",
	},
	{
		type = "item",
		name = "tiberium-beacon-node",
		icon = tiberiumInternalName.."/graphics/icons/beacon.png",
		icon_size = 32,
		order = "g[tiberium-beacon-node]",
		place_result = "tiberium-beacon-node",
		stack_size = 20,
		subgroup = "a-buildings",
	},
	{
		type = "item",
		name = "tiberium-aoe-node-harvester",
		icon = "__base__/graphics/icons/pumpjack.png",
		icon_mipmaps = 4,
		icon_size = 32,
		order = "c[aoe-node-harvester]",
		place_result = "tiberium-aoe-node-harvester",
		stack_size = 20,
		subgroup = "a-buildings",
	},
	{
		type = "item",
		name = "tiberium-ion-turret",
		icon = "__base__/graphics/icons/laser-turret.png",
		icon_size = 64,
		subgroup = "a-buildings",
		order = "f[tiberium-ion-turret]",
		place_result = "tiberium-ion-turret",
		stack_size = 50
	},
	{
		type = "item",
		name = "tiberium-obelisk-of-light",
		icon = tiberiumInternalName.."/graphics/entity/obelisk-of-light/obelisk-of-light-222.png",
		icon_size = 222,
		subgroup = "a-buildings",
		order = "f[tiberium-obelisk-of-light]",
		place_result = "tiberium-obelisk-of-light",
		stack_size = 50
	},
	{
		type = "item",
		name = "tiberium-advanced-guard-tower",
		icon = tiberiumInternalName.."/graphics/entity/advanced-guard-tower/advanced-guard-tower-256.png",
		icon_size = 256,
		subgroup = "a-buildings",
		order = "f[tiberium-advanced-guard-tower]",
		place_result = "tiberium-advanced-guard-tower",
		stack_size = 50
	},
	--Military
	{
		type = "item-with-entity-data",
		name = "tiberium-marv",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-marv.png",
		icon_size = 128,
		order = "e[personal-transport]-a[marv]",
		place_result = "tiberium-marv",
		stack_size = 1,
		subgroup = "a-items",
	},
	--Power
	{
		type = "item",
		name = "tiberium-empty-cell",
		icon = tiberiumInternalName.."/graphics/icons/empty-fuel-cell.png",
		icon_size = 64,
		flags = {},
		order = "c[tiberium-fuel-cell]-a[empty-cell]",
		subgroup = "a-intermediates",
		stack_size = 100
	},
	{
		type = "item",
		name = "tiberium-dirty-cell",
		icon = tiberiumInternalName.."/graphics/icons/dirty-fuel-cell.png",
		icon_size = 64,
		flags = {},
		order = "c[tiberium-fuel-cell]-c[dirty-cell]",
		subgroup = "a-intermediates",
		stack_size = 5
	},
	{
		type = "item",
		name = "tiberium-fuel-cell",
		icon = "__base__/graphics/icons/uranium-fuel-cell.png",
		icon_size = 64,
		flags = {},
		order = "c[tiberium-fuel-cell]-b[fuel-cell]",
		subgroup = "a-intermediates",
		fuel_category = "nuclear",
		burnt_result = "tiberium-dirty-cell",
		fuel_value = "4GJ",
		stack_size = 50
	},
	--Other
	{
		type = "item",
		name = "tiberium-growth-credit",
		icon = tiberiumInternalName.."/graphics/icons/growth-credit.png",
		icon_size = 64,
		flags = {},
		subgroup = "a-items",
		order = "a[tiberium-ore]",
		stack_size = 200,
	},
	{
		type = "item",
		name = "tiberium-ion-core",
		icon = tiberiumInternalName.."/graphics/icons/nuclear-reactor.png",
		icon_size = 32,
		flags = {},
		subgroup = "a-intermediates",
		order = "a[tiberium-ore]",
		stack_size = 200
	},
	{
		type = "item",
		name = "tiberium-blue-explosives",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-brick.png",
		icon_size = 32,
		flags = {},
		subgroup = "a-intermediates",
		order = "a[tiberium-ore]",
		stack_size = 100
	},
	{
		type = "item",
		name = "tiberium-ore",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-ore-basic.png",
		icon_size = 64,
		icon_mipmaps = 4,
		flags = {},
		fuel_value = "2MJ",
		fuel_category = "chemical",
		fuel_emissions_multiplier = 5,
		pictures =
		{
			{
				layers =
				{
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore.png",
					size = 64,
					scale = 0.25,
					mipmap_count = 4
				  },
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-glow.png",
					blend_mode = "additive",
					draw_as_light = true,
					tint = {r = 0.3, g = 0.6, b = 0.3, a = 0.3},
					size = 64,
					scale = 0.25,
					mipmap_count = 4
		    },
        }
      },
      {
			  layers =
				{
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-2.png",
					size = 64,
					scale = 0.25,
					mipmap_count = 4
				  },
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-glow-2.png",
					blend_mode = "additive",
					draw_as_light = true,
					tint = {r = 0.3, g = 0.6, b = 0.3, a = 0.3},
					size = 64,
					scale = 0.25,
					mipmap_count = 4
		    },
        }
      },
      {
			layers =
				{
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-3.png",
					size = 64,
					scale = 0.25,
					mipmap_count = 4
				  },
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-glow-3.png",
					blend_mode = "additive",
					draw_as_light = true,
					tint = {r = 0.3, g = 0.6, b = 0.3, a = 0.3},
					size = 64,
					scale = 0.25,
					mipmap_count = 4
          },
        }
      }
    },
		subgroup = "raw-resource",
		order = "a[tiberium-ore]",
		stack_size = 50
	},
			
			
			
	{
		type = "item",
		name = "tiberium-ore-blue",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-20-114-10.png",
		icon_size = 64,
		icon_mipmaps = 4,
		flags = {},
		subgroup = "raw-resource",
		order = "a[tiberium-ore]",
		stack_size = 50,
		fuel_value = "8MJ",
		fuel_category = "chemical",
		fuel_emissions_multiplier = 5, 
				pictures =
		{
			{
				layers =
				{
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue.png",
					size = 64,
					scale = 0.25,
					mipmap_count = 4
				  },
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-glow.png",
					blend_mode = "additive",
					draw_as_light = true,
					tint = {r = 0.3, g = 0.3, b = 0.6, a = 0.3},
					size = 64,
					scale = 0.25,
					mipmap_count = 4
		    },
        }
      },
      {
			  layers =
				{
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-2.png",
					size = 64,
					scale = 0.25,
					mipmap_count = 4
				  },
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-glow-2.png",
					blend_mode = "additive",
					draw_as_light = true,
					tint = {r = 0.3, g = 0.3, b = 0.6, a = 0.3},
					size = 64,
					scale = 0.25,
					mipmap_count = 4
		    },
        }
      },
      {
			layers =
				{
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-3.png",
					size = 64,
					scale = 0.25,
					mipmap_count = 4
				  },
				  {
					filename = tiberiumInternalName.."/graphics/icons/tiberium-ore-blue-glow-3.png",
					blend_mode = "additive",
					draw_as_light = true,
					tint = {r = 0.3, g = 0.3, b = 0.6, a = 0.3},
					size = 64,
					scale = 0.25,
					mipmap_count = 4
          },
        }
      }
    },
		subgroup = "raw-resource",
		order = "a[tiberium-ore]",
		stack_size = 50
	},
			
			
			
	--Dummy Items
	{
		type = "item",
		name = "tiberium-growth-credit-void",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-ore.png",
		icon_size = 64,
		flags = {"hidden"},
		subgroup = "a-items",
		stack_size = 200
	},
}
