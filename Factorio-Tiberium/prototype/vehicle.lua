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
marvEntity.burner.emissions_per_minute = 60
marvEntity.burner.smoke[1].position = {0, 2.2}
for _, layer in pairs(marvEntity.animation.layers) do
	layer.scale = 0.75
	if layer.hr_version then
		layer.hr_version.scale = 0.75
	end
end

data:extend{marvEntity}
