data:extend({
    {
        type = "generator-equipment",
        name = "tiberium-generator-equipment",
        categories = {"armor"},
        energy_source = {
            type = "electric",
            usage_priority = "primary-output"
        },
        power = "200kW",
        shape = {
            type = "full",
            height = 3,
            width = 3
        },
        sprite = {
            filename = tiberiumInternalName.."/graphics/icons/NuclearBatteryOff.png",
            height = 128,
            width = 128,
            priority = "medium",
        },
    },
    {
        type = "generator-equipment",
        name = "tiberium-generator-equipment-on",
        take_result = "tiberium-generator-equipment",
        categories = {"armor"},
        energy_source = {
            type = "electric",
            usage_priority = "primary-output"
        },
        power = "3200kW",
        shape = {
            type = "full",
            height = 3,
            width = 3
        },
        sprite = {
            filename = tiberiumInternalName.."/graphics/icons/NuclearBatteryOn.png",
            height = 128,
            width = 120,
            priority = "medium",
        },
    }
})