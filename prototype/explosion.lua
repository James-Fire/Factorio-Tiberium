local greenExplosion = flib.copy_prototype(data.raw.explosion["grenade-explosion"], "tiberium-explosion-green")
local blueExplosion = flib.copy_prototype(data.raw.explosion["grenade-explosion"], "tiberium-explosion-blue")

for i,_ in pairs(greenExplosion.animations) do
    greenExplosion.animations[i].tint = common.tibCraftingTint.primary
    blueExplosion.animations[i].tint = common.tibCraftingBlueTint.secondary
end

data:extend{greenExplosion, blueExplosion}
