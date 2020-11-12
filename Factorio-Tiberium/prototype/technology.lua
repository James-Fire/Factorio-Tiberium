data:extend{
	{
		type = "technology",
		name = "tiberium-slurry-centrifuging",
		icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-waste.png",
		icon_size = 64,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-centrifuge"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-slurry-centrifuging"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-slurry-sludge-centrifuging"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-sludge-to-stone-brick"
			},
		},
		prerequisites = {"tiberium-mechanical-research"},
		unit = {
			count = 100,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-molten-centrifuging",
		icon = tiberiumInternalName.."/graphics/icons/fluid/molten-tiberium.png",
		icon_size = 64,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-centrifuge-2"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-molten-centrifuging"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-molten-sludge-centrifuging"
			},
		},
		prerequisites = {"tiberium-slurry-centrifuging", "tiberium-thermal-research", "advanced-electronics", "concrete"},
		unit = {
			count = 200,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-advanced-molten-processing",
		icon = tiberiumInternalName.."/graphics/technology/cool-molten-tiberium.png",
		icon_size = 64,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-advanced-molten-processing"
			},
		},
		prerequisites = {"tiberium-thermal-research", "chemical-science-pack"},
		unit = {
			count = 100,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1}
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-liquid-centrifuging",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-processing-tech.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-centrifuge-3"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-liquid-centrifuging"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-liquid-sludge-centrifuging"
			},
		},
		prerequisites = {"tiberium-molten-centrifuging", "tiberium-chemical-research"},
		unit = {
			count = 300,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1}
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-power-tech",
		icon = tiberiumInternalName.."/graphics/icons/td-power-plant.png",
		icon_size = 64,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-power-plant"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-empty-cell"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-fuel-cell"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-cell-cleaning"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-nuclear-fuel"
			},
		},
		prerequisites = {"tiberium-liquid-centrifuging", "tiberium-nuclear-research"},
		unit = {
			count = 600,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-sludge-processing",
		icon = tiberiumInternalName.."/graphics/icons/fluid/tiberium-sludge.png",
		icon_size = 64,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-sludge-from-slurry"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-sludge-to-concrete"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-sludge-to-refined-concrete"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-sludge-to-landfill"
			},
		},
		prerequisites = {"tiberium-slurry-centrifuging", "landfill"},
		unit = {
			count = 100,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-sludge-recycling",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-sludge-recycling.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-waste-recycling"
			},
		},
		prerequisites = {"tiberium-thermal-research", "tiberium-sludge-processing"},
		unit = {
			count = 200,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1}
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-containment-tech",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-containment.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-srf-emitter"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-node-harvester"
			},
		},
		prerequisites = {"tiberium-chemical-research", "battery"},
		unit = {
			count = 200,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-transmutation-tech",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-transmutation.png",
		icon_size = 128,
		effects = {
		},
		prerequisites = {"tiberium-molten-centrifuging", "tiberium-nuclear-research"},
		unit = {
			count = 5000,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-growth-acceleration",
		icon = tiberiumInternalName.."/graphics/technology/growth-accelerator.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-growth-accelerator"
			},
		},
		prerequisites = {"tiberium-chemical-research"},
		unit = {
			count = 800,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-advanced-containment-tech",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-minus.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-network-node"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-aoe-node-harvester"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-spike"
			},
		},
		prerequisites = {"tiberium-electromagnetic-research", "tiberium-containment-tech"},
		unit = {
			count = 1200,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
				{"utility-science-pack", 1}
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-control-network-tech",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-control-network-tech.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-beacon-node"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-farming"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-growth-credit-from-energy"
			},
		},
		prerequisites = {"tiberium-electromagnetic-research", "tiberium-growth-acceleration"},
		unit = {
			count = 1200,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
				{"utility-science-pack", 1}
			},
			time = 30
		}
	},
	--Science Techs
	{
		type = "technology",
		name = "tiberium-mechanical-research",
		icon = tiberiumInternalName.."/graphics/technology/testing-mechanical.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-ore-processing"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-slurry-mechanical-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-mechanical"
			},
		},
		prerequisites = {"automation-2"},
		unit = {
			count = 50,
			ingredients = {
				{"automation-science-pack", 1}
			},
			time = 15
		}
	},
	{
		type = "technology",
		name = "tiberium-thermal-research",
		icon = tiberiumInternalName.."/graphics/technology/testing-thermal.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "molten-tiberium-processing"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-molten-mechanical-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-molten-thermal-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-slurry-thermal-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-thermal"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-thru-thermal"
			},
		},
		prerequisites = {"tiberium-mechanical-research", "oil-processing"},
		unit = {
			count = 100,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1}
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-chemical-research",
		icon = tiberiumInternalName.."/graphics/technology/testing-chemical.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-liquid-processing"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-liquid-mechanical-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-liquid-thermal-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-liquid-chemical-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-slurry-chemical-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-molten-chemical-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-chemical"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-thru-chemical"
			},
		},
		prerequisites = {"tiberium-thermal-research", "chemical-science-pack"},
		unit = {
			count = 200,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1}
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-nuclear-research",
		icon = tiberiumInternalName.."/graphics/technology/testing-nuclear.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-slurry-nuclear-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-molten-nuclear-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-liquid-nuclear-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-nuclear"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-thru-nuclear"
			},
		},
		prerequisites = {"tiberium-chemical-research", "uranium-processing", "production-science-pack"},
		unit = {
			count = 300,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1}
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-electromagnetic-research",
		icon = tiberiumInternalName.."/graphics/technology/testing-EM.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-slurry-EM-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-molten-EM-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-liquid-EM-data"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-EM"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-science-thru-EM"
			},
		},
		prerequisites = {"tiberium-nuclear-research", "utility-science-pack"},
		unit = {
			count = 400,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
				{"utility-science-pack", 1}
			},
			time = 30
		}
	},
	--Military
	{
		type = "technology",
		name = "tiberium-military-1",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-military.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-rounds-magazine"
			},
			{
				type = "nothing",
				effect_description = {"technology-description.tiberium-military-partial-immunity", "80%"}
			}
		},
		prerequisites = {"tiberium-thermal-research", "military-science-pack", "heavy-armor"},
		unit = {
			count = 100,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-military-2",
		icon = tiberiumInternalName.."/graphics/technology/tiberium-military-2.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-ion-core"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-ion-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-rocket"
			},
		},
		prerequisites = {"tiberium-chemical-research", "tiberium-military-1", "rocketry", "laser"},
		unit = {
			count = 300,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 30
		}
	},
	{
		type = "technology",
		name = "tiberium-military-3",
		icon = tiberiumInternalName.."/graphics/icons/tiberium-marv.png",
		icon_size = 128,
		effects = {
			{
				type = "unlock-recipe",
				recipe = "tiberium-nuke"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-seed"
			},
			{
				type = "unlock-recipe",
				recipe = "tiberium-marv"
			},
			{
				type = "nothing",
				effect_description = {"technology-description.tiberium-military-total-immunity"}
			},
		},
		prerequisites = {"tiberium-military-2", "tiberium-containment-tech", "rocket-control-unit", "power-armor-mk2"},
		unit = {
			count = 500,
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"military-science-pack", 1},
				{"chemical-science-pack", 1},
				{"utility-science-pack", 1},
			},
			time = 30
		}
	},
	--Repeatables
	{
		type = "technology",
		name = 	"tiberium-growth-acceleration-acceleration",
		icon = tiberiumInternalName.."/graphics/technology/growth-accelerator-research.png",
		icon_size = 128,
		effects = {
			{
				type = "nothing",
				effect_description = {"technology-description.tiberium-growth-acceleration-acceleration-effect", "+25%"}
			}
		},
		prerequisites = {"tiberium-growth-acceleration", "space-science-pack"},
		unit = {
			count_formula = "2^(L-1)*1000",
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
				{"utility-science-pack", 1},
				{"space-science-pack", 1}
			},
			time = 30
		},
		max_level = "infinite",
		upgrade = true,
		order = "e-l-f"
	},
	{
		type = "technology",
		name = 	"tiberium-control-network-speed",
		icons = {
			{
				icon = tiberiumInternalName.."/graphics/technology/effect-transmission.png",
				icon_size = 128,
			},
			{
				icon = "__core__/graphics/time-editor-icon.png",
				icon_size = 32,
				shift = {-48, 48},
			},
		},
		effects = {
			{
				type = "nothing",
				effect_description = {"technology-description.tiberium-control-network-speed-effect", "+25%"}
			}
		},
		prerequisites = {"tiberium-control-network-tech", "space-science-pack"},
		unit = {
			count_formula = "2^(L-1)*1000",
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1},
				{"utility-science-pack", 1},
				{"space-science-pack", 1}
			},
			time = 30
		},
		max_level = "infinite",
		upgrade = true,
		order = "e-l-f"
	},
	{
		type = "technology",
		name = "tiberium-explosives",
		icon_size = 128,
		icon = "__base__/graphics/technology/stronger-explosives-3.png",
		effects = {
			{
				type = "ammo-damage",
				ammo_category = "rocket",
				modifier = 0.5
			},
			{
				type = "ammo-damage",
				ammo_category = "grenade",
				modifier = 0.2
			},
			{
				type = "ammo-damage",
				ammo_category = "landmine",
				modifier = 0.2
			}
		},
		prerequisites = {"tiberium-military-2", "stronger-explosives-6", "space-science-pack"},
		unit = {
			count_formula = "2^(L-2)*1000",
			ingredients =
			{
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
				{"utility-science-pack", 1},
				{"space-science-pack", 1}
			},
			time = 60
		},
		max_level = "infinite",
		upgrade = true,
		order = "e-l-f"
	},
	{
		type = "technology",
		name = "tiberium-energy-weapons-damage",
		icon_size = 128,
		icon = "__base__/graphics/technology/energy-weapons-damage-3.png",
		effects = {
			{
				type = "ammo-damage",
				ammo_category = "laser-turret",
				modifier = 0.7
			},
			{
				type = "ammo-damage",
				ammo_category = "combat-robot-laser",
				modifier = 0.3
			},
			{
				type = "ammo-damage",
				ammo_category = "combat-robot-beam",
				modifier = 0.3
			}
		},
		prerequisites = {"tiberium-military-2", "energy-weapons-damage-6", "space-science-pack"},
		unit = {
			count_formula = "2^(L-2)*1000",
			ingredients = {
				{"tiberium-science", 1},
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
				{"utility-science-pack", 1},
				{"space-science-pack", 1}
			},
			time = 60
		},
		max_level = "infinite",
		upgrade = true,
		order = "e-l-f"
	},
}
