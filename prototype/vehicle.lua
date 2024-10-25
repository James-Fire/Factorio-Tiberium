local marvEntity = table.deepcopy(data.raw.car["tank"])
marvEntity.name = "tiberium-marv"
marvEntity.guns = nil
marvEntity.max_health = 5000
table.insert(marvEntity.resistances, {type = "tiberium", decrease = 0, percent = 100})
marvEntity.consumption = "1200kW"
marvEntity.braking_power = "1000kW"
marvEntity.friction = 0.02
marvEntity.rotation_speed = 0.002
marvEntity.minable.result = "tiberium-marv"
marvEntity.turret_animation = nil
marvEntity.turret_return_timeout = nil
marvEntity.turret_rotation_speed = nil
marvEntity.weight = 50000
marvEntity.collision_box = {{-1.4, -1.8}, {1.4, 1.8}}
marvEntity.drawing_box = {{-2.3, -2.3}, {2.3, 2}}
marvEntity.selection_box = {{-1.4, -1.8}, {1.4, 1.8}}
marvEntity.energy_source.emissions_per_minute = common.scaledEmissions(4, 15)
marvEntity.energy_source.smoke[1].position = {0, 2.2}
for _, layer in pairs(marvEntity.animation.layers) do
	layer.scale = 0.75
end

data:extend{marvEntity}
