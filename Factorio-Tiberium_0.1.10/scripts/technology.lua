table.insert(data.raw.lab["lab"].inputs, "tiberium-science")

data:extend
{
   {
      type = "technology",
      name = "tiberium-processing-tech",
      icon = "__Factorio-Tiberium__/graphics/technology/tiberium-processing-tech.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "tiberium-ore-centrifuging"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-centrifuge"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-ore-sludge-centrifuging"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-sludge-to-stone-brick"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-armor"
        },
      },
      prerequisites = {"tiberium-mechanical-research"},
      unit =
      {
        count = 200,
        ingredients =
        {
          {"tiberium-science", 1},
        },
        time = 10
      }
   },
   {
      type = "technology",
      name = "advanced-tiberium-processing-tech",
      icon = "__base__/graphics/technology/oil-gathering.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "tiberium-centrifuge-2"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-magazine"
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
            recipe = "tiberium-ore-processing"
        },
		{
			type = "unlock-recipe",
			recipe = "CnC_SonicWall_Hub"
		},
		{
            type = "unlock-recipe",
            recipe = "tib-pumpjack"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-farming"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-slurry-mechanical-data"
        },
		
      },
	  
	  
      prerequisites = {"tiberium-processing-tech", "chemical-science-pack"},
      unit =
      {
        count = 1000,
        ingredients =
        {
          {"tiberium-science", 1},
		  {"automation-science-pack", 1},
		  {"logistic-science-pack", 1},
          {"chemical-science-pack", 1}
        },
        time = 10
      }
   },
   {
      type = "technology",
      name = "tiberium-molten-processing",
      icon = "__Factorio-Tiberium__/graphics/technology/advanced-tiberium-processing-tech.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "tiberium-centrifuge-3"
        },
        {
            type = "unlock-recipe",
            recipe = "advanced-tiberium-ore-processing"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-molten-centrifuging"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-molten-sludge-centrifuging"
        },
		{
            type = "unlock-recipe",
            recipe =  "tiberium-molten-to-crude-oil"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-molten-mechanical-data"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-molten-thermal-data"
        },
      },
	   prerequisites = {"advanced-tiberium-processing-tech", "tiberium-thermal-research"},
      unit =
      {
        count = 1500,
        ingredients =
        {
          {"tiberium-science", 1},
		  {"automation-science-pack", 1},
		  {"logistic-science-pack", 1},
          {"chemical-science-pack", 1}
        },
        time = 10
      }
   },
   {
      type = "technology",
      name = "tiberium-power-tech",
      icon = "__Factorio-Tiberium__/graphics/technology/advanced-tiberium-processing-tech.png",
	  icon_size = 128,
      effects =
      {
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
            recipe = "tiberium-plant"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-ion-core"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-rocket"
        },
		{
            type = "unlock-recipe",
            recipe = "ion-turret"
        }
      },
	  
	  
      prerequisites = {"tiberium-molten-processing", "tiberium-chemical-research"},
      unit =
      {
        count = 2000,
        ingredients =
        {
          {"tiberium-science", 1},
		  {"automation-science-pack", 1},
		  {"logistic-science-pack", 1},
          {"chemical-science-pack", 1}
        },
        time = 10
      }
   },
   {
      type = "technology",
      name = "advanced-tiberium-transmutation-tech",
      icon = "__Factorio-Tiberium__/graphics/technology/advanced-tiberium-processing-tech.png",
	  icon_size = 128,
      effects =
      {
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
            recipe = "tiberium-molten-to-coal"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-molten-to-stone"
        },
      },
	  
	  
      prerequisites = {"tiberium-molten-processing", "tiberium-nuclear-research"},
      unit =
      {
        count = 5000,
        ingredients =
        {
          {"tiberium-science", 1},
		  {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
		  {"production-science-pack", 1},
        },
        time = 10
      }
   },
   
   {
   type = "technology",
      name = "tiberium-growth-acceleration",
      icon = "__base__/graphics/technology/oil-gathering.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "growth-accelerator"
        },
		{
            type = "unlock-recipe",
            recipe = "iron-growth-credit"
        },
		{
            type = "unlock-recipe",
            recipe = "copper-growth-credit"
        },
		{
            type = "unlock-recipe",
            recipe = "coal-growth-credit"
        },
		{
            type = "unlock-recipe",
            recipe = "stone-growth-credit"
        },
		{
            type = "unlock-recipe",
            recipe = "oil-growth-credit"
        },
		{
            type = "unlock-recipe",
            recipe = "uranium-growth-credit"
        },
	  },
	  
	  
      prerequisites = {"tiberium-nuclear-research", "advanced-tiberium-processing-tech"},
      unit =
      {
        count = 2500,
        ingredients =
        {
          {"tiberium-science", 1},
		  {"automation-science-pack", 1},
		  {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
		  {"production-science-pack", 1},
        },
        time = 10
      }
   },
   {
      type = "technology",
      name = "tiberium-control-network-tech",
      icon = "__Factorio-Tiberium__/graphics/technology/tiberium-control-network-tech.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "liquid-tiberium-cell"
        },
		{
            type = "unlock-recipe",
            recipe = "tib-spike"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-network-node"
        },
		{
            type = "unlock-recipe",
            recipe = "energy-growth-credit"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-seed"
        },
		
		{
            type = "unlock-recipe",
            recipe = "tiberium-nuke"
        },
      },
      prerequisites = {"tiberium-power-tech", "tiberium-electromagnetic-research"},
      unit =
      {
        count = 2500,
        ingredients =
        {
          {"tiberium-science", 1},
		  {"automation-science-pack", 1},
		  {"logistic-science-pack", 1},
          {"chemical-science-pack", 1},
		  {"production-science-pack", 1},
          {"utility-science-pack", 1}
        },
        time = 40
      }
   }, 

--Samples

{
      type = "technology",
      name = "tiberium-mechanical-research",
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-mechanical.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "tiberium-science"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-ore-mechanical-data"
        },
		
      },
      prerequisites = {},
      unit =
      {
        count = 50,
        ingredients =
        {
          {"automation-science-pack", 1}
        },
        time = 40
      }
   }, 
{
      type = "technology",
      name = "tiberium-thermal-research",
      icon = "__Factorio-Tiberium__/graphics/icons/Tiberium-thermal.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "tiberium-ore-thermal-data"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-slurry-thermal-data"
        },
      },
      prerequisites = {"tiberium-mechanical-research", "advanced-material-processing"},
      unit =
      {
        count = 100,
        ingredients =
        {
          {"automation-science-pack", 1},
		  {"logistic-science-pack", 1}
        },
        time = 40
      }
   }, 
   {
      type = "technology",
      name = "tiberium-chemical-research",
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-chemistry.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "tiberium-ore-chemical-data"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-slurry-chemical-data"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-molten-chemical-data"
        },
      },
      prerequisites = {"tiberium-thermal-research", "sulfur-processing"},
	  
      unit =
      {
        count = 200,
        ingredients =
        {
          {"automation-science-pack", 1},
		  {"logistic-science-pack", 1},
		  {"chemical-science-pack", 1}
        },
        time = 40
      }
   }, 
{
      type = "technology",
      name = "tiberium-nuclear-research",
      icon = "__Factorio-Tiberium__/graphics/icons/tiberium-nuclear.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "tiberium-ore-nuclear-data"
        },
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
      },
      prerequisites = {"tiberium-chemical-research", "kovarex-enrichment-process"},
      unit =
      {
        count = 500,
        ingredients =
        {
          {"automation-science-pack", 1},
		  {"logistic-science-pack", 1},
		  {"chemical-science-pack", 1},
		  {"production-science-pack", 1}
        },
        time = 40
      }
   },
   {
      type = "technology",
      name = "tiberium-electromagnetic-research",
      icon = "__Factorio-Tiberium__/graphics/icons/Tiberium-EM.png",
	  icon_size = 128,
      effects =
      {
		{
            type = "unlock-recipe",
            recipe = "tiberium-ore-EM-data"
        },
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
      },
      prerequisites = {"tiberium-nuclear-research", "utility-science-pack"},
      unit =
      {
        count = 1000,
        ingredients =
        {
          {"automation-science-pack", 1},
		  {"logistic-science-pack", 1},
		  {"chemical-science-pack", 1},
		  {"production-science-pack", 1},
		  {"utility-science-pack", 1}
        },
        time = 40
      }
   },
   
  --Repeatables
  {
    type = "technology",
    name = "tiberium-explosives",
    icon_size = 128,
    icon = "__base__/graphics/technology/stronger-explosives-3.png",
    effects =
    {
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
    prerequisites = {"stronger-explosives-6", "space-science-pack"},
    unit =
    {
      count_formula = "2^(L-7)*1000",
      ingredients =
      {
        {"tiberium-science", 1},
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
		{"production-science-pack", 1},
		{"utility-science-pack", 1}
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
    effects =
    {
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
    prerequisites = {"energy-weapons-damage-6", "space-science-pack"},
    unit =
    {
      count_formula = "2^(L-7)*1000",
      ingredients =
      {
        {"tiberium-science", 1},
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
		{"production-science-pack", 1},
		{"utility-science-pack", 1}
		{"space-science-pack", 1}
      },
      time = 60
    },
    max_level = "infinite",
    upgrade = true,
    order = "e-l-f"
  },
}