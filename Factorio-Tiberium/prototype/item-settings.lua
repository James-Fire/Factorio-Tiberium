local tierZero = settings.startup["tiberium-tier-zero"].value
if tierZero then
    data:extend{
        {
            type = "item",
            name = "tiberium-centrifuge-0",
            icon = "__base__/graphics/icons/centrifuge.png",
            icon_size = 64,
            flags = {},
            subgroup = "a-buildings",
            order = "a[tiberium-centrifuge]-0",
            place_result = "tiberium-centrifuge-0",
            stack_size = 20
        },
    }
end