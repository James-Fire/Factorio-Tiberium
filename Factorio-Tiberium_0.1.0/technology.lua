data:extend
{
   {
      type = "technology",
      name = "tiberium-processing-tech",
      icon = "__Fixed_Tiberium_okta__/graphics/technology/tiberium-processing-tech.png",
	  icon_size = 128,
      effects =
      {
        {
            type = "unlock-recipe",
            recipe = "tiberium-ore-processing"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-brick-processing"
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
        {
            type = "unlock-recipe",
            recipe = "tiberium-brick-to-crude-oil"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-brick-to-water"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-armor"
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
      icon = "__Fixed_Tiberium_okta__/graphics/technology/advanced-tiberium-processing-tech.png",
	  icon_size = 128,
      effects =
      {
        {
            type = "unlock-recipe",
            recipe = "advanced-tiberium-ore-processing"
        },
        {
            type = "unlock-recipe",
            recipe = "advanced-tiberium-brick-processing"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-brick-to-uranium-ore"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-wall"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-plant"
        }
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
      name = "tiberium-control-network-tech",
      icon = "__Fixed_Tiberium_okta__/graphics/technology/tiberium-control-network-tech.png",
	  icon_size = 128,
      effects =
      {
        --{
        --    type = "unlock-recipe",
        --    recipe = "advanced-tiberium-ore-processing"
        --}
        {
            type = "unlock-recipe",
            recipe = "tiberium-liquid-to-iron-ore"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-liquid-to-copper-ore"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-liquid-to-coal"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-liquid-to-stone"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-liquid-to-uranium-ore"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-liquid-to-crude-oil"
        },
        {
            type = "unlock-recipe",
            recipe = "tiberium-liquid-to-water"
        },
		{
            type = "unlock-recipe",
            recipe = "tiberium-network-node"
        },
      },
      prerequisites = {"advanced-tiberium-processing-tech"},
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
   }
}