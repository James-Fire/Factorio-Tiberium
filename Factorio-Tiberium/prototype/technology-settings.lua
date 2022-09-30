local easyMode = settings.startup["tiberium-easy-recipes"].value

if easyMode then
    data:extend{
        {
            type = "technology",
            name = "tiberium-easy-transmutation-tech",
            icon = tiberiumInternalName.."/graphics/technology/tiberium-transmutation.png",
            icon_size = 128,
            effects = {
                -- Transmutation recipes created and added to this tech by /scripts/DynamicOreRecipes
            },
            prerequisites = {"tiberium-mechanical-research", "oil-processing"},
            unit = {
                count = 10,
                ingredients = {
                    {"tiberium-science", 1},
                    {"automation-science-pack", 1},
                },
                time = 30
            }
        }
    }
end

local tierZero = settings.startup["tiberium-tier-zero"].value
if tierZero then
	data:extend{
        {
            type = "technology",
            name = "tiberium-ore-centrifuging",
            icon = tiberiumInternalName.."/graphics/icons/tiberium-ore.png",
            icon_size = 64,
            effects = {
                {
                    type = "unlock-recipe",
                    recipe = "tiberium-centrifuge-0"
                },
                {
                    type = "unlock-recipe",
                    recipe = "tiberium-ore-centrifuging"
                },
                -- Ore centrifuging with sludge recipe created and added to this tech by /scripts/DynamicOreRecipes
            },
            unit = {
                count = 50,
                ingredients = {
                    {"automation-science-pack", 1},
                },
                time = 30
            }
        }
    }
    table.insert(data.raw.technology["tiberium-slurry-centrifuging"].prerequisites, "tiberium-ore-centrifuging")
end