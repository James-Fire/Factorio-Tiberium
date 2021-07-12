local common = {}

common.blankAnimation = {
    filename =  "__core__/graphics/empty.png",
    width = 1,
    height = 1,
    line_length = 1,
    frame_count = 1,
    variation_count = 1,
}

common.blankPicture = {
    filename = "__core__/graphics/empty.png",
    width = 1,
    height = 1
}

common.TiberiumRadius = 20 + settings.startup["tiberium-spread"].value * 0.4 --Translates to 20-60 range

common.hit_effects = require("__base__.prototypes.entity.hit-effects")

common.sounds = require("__base__.prototypes.entity.sounds")

common.tibCraftingTint = {
	primary    = {r = 0.109804, g = 0.721567, b = 0.231373,  a = 1},
	secondary  = {r = 0.098039, g = 1,        b = 0.278431,  a = 1},
	tertiary   = {r = 0.156863, g = 0.156863, b = 0.156863,  a = 0.235294},
	quaternary = {r = 0.160784, g = 0.745098, b = 0.3058824, a = 0.345217},
}

return common
