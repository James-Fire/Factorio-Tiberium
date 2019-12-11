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
            recipe = "tiberium-ore-sludge-centrifuging"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-armor"
        },
		{
            type = "unlock-recipe",
            recipe = "centrifuge"
        }
      },
      prerequisites = {"oil-processing", "sulfur-processing"},
      unit =
      {
        count = 200,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1}
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
            recipe = "tiberium-slurry-centrifuging"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-sludge-to-stone-brick"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-slurry-sludge-centrifuging"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-ore-processing"
        },
		--{
          --  type = "unlock-recipe",
          --  recipe = "sonic-wall-node"
        --},
		{
            type = "unlock-recipe",
            recipe = "tib-pumpjack"
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
            recipe = "uranium-growth-credit"
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
            recipe = "growth-accelerator"
        },
      },
	  
	  
      prerequisites = {"tiberium-processing-tech"},
      unit =
      {
        count = 200,
        ingredients =
        {
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
            recipe = "advanced-tiberium-ore-processing"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-liquid-processing"
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
            recipe =  "tiberium-slurry-to-crude-oil"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-waste-recycling"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-plant"
        }
      },
	  
	  
      prerequisites = {"advanced-tiberium-processing-tech"},
      unit =
      {
        count = 200,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 2}
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
            recipe = "advanced-tiberium-brick-processing"
        },
		{
            type = "unlock-recipe",
            recipe = "liquid-tiberium-cell"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-slurry-to-uranium-ore"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-brick-to-iron-ore"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-brick-to-copper-ore"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-brick-to-coal"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-brick-to-stone"
        },
		--[[{
            type = "unlock-recipe",
            recipe = "tiberium-brick-to-water"
        },]]
        {
            type = "unlock-recipe",
            recipe = "tiberium-molten-to-iron-ore"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-molten-to-copper-ore"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-molten-to-coal"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-molten-to-stone"
        },
        --[[{
            type = "unlock-recipe",
            recipe = "tiberium-molten-to-water"
        },]]
		{
            type = "unlock-recipe",
            recipe = "tiberium-network-node"
        },
		{
            type = "unlock-recipe",
            recipe = "energy-growth-credit"
        },
      },
      prerequisites = {"tiberium-power-tech"},
      unit =
      {
        count = 150,
        ingredients =
        {
          {"automation-science-pack", 2},
          {"logistic-science-pack", 2},
          {"chemical-science-pack", 2},
		  {"production-science-pack", 1},
          {"utility-science-pack", 2}
        },
        time = 40
      }
   },
   
   {
		type = "technology",
		name = "CnC_SonicWall_Hub",
		icon = "__Factorio-Tiberium__/graphics/technology/tiberium-processing-tech.png",
        icon_size = 128,
		unit =
		{
			count = 100,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1}
			},
			time = 10
		},
		prerequisites = {"advanced-tiberium-processing-tech"},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "CnC_SonicWall_Hub"
			}
		},
		order = "a-a-a",
	}
   
   
}
