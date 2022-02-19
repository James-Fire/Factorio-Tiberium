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