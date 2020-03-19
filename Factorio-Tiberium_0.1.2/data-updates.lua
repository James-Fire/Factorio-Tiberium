--Orbital Ion Cannon
if (mods["Orbital Ion Cannon"]) then
	log("found Ion Cannon")
	LSlib.technology.addPrerequisite("orbital-ion-cannon", "tiberium-power-tech")
	if (mods["bobwarfare"]) then
		LSlib.recipe.editIngredient("orbital-ion-cannon", "bob-laser-turret-5", "tiberium-ion-core", 1)
	else
		LSlib.recipe.editIngredient("orbital-ion-cannon", "laser-turret", "tiberium-ion-core", 1)
	end
end

table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "basic-tiberium-science")
table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "tiberium-science")

for _,assemblingName in pairs{
	"assembling-machine",
	"assembling-machine-2",
	"assembling-machine-3",
} do
  table.insert(data.raw["assembling-machine"][assemblingName].crafting_categories, "basic-tiberium-science")
end



if (mods["bobassembly"]) then
		for _,assemblingName in pairs{
			"chemical-plant",
			"chemical-plant-2",
		    "chemical-plant-3",
			"chemical-plant-4",
		} do
		  table.insert(data.raw["assembling-machine"][assemblingName].crafting_categories, "tiberium-science")
		end
end

--[[if (mods["Mining_Drones"]) then
	data.raw["assembling-machine"][names.mining_depot].animation = make_4way_animation_from_spritesheet(
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/oil-refinery/oil-refinery.png",
          width = 337,
          height = 255,
          frame_count = 1,
          shift = {2.515625, 0.484375},
          hr_version =
          {
            filename = "__base__/graphics/entity/oil-refinery/hr-oil-refinery.png",
            width = 386,
            height = 430,
            frame_count = 1,
            shift = util.by_pixel(0, -7.5),
            scale = 0.5
          }
        },
        {
          filename = "__base__/graphics/entity/oil-refinery/oil-refinery-shadow.png",
          width = 337,
          height = 213,
          frame_count = 1,
          shift = util.by_pixel(82.5, 26.5),
          draw_as_shadow = true,
          hr_version =
          {
            filename = "__base__/graphics/entity/oil-refinery/hr-oil-refinery-shadow.png",
            width = 674,
            height = 426,
            frame_count = 1,
            shift = util.by_pixel(82.5, 26.5),
            draw_as_shadow = true,
            force_hr_shadow = true,
            scale = 0.5
          }
        }
      }
    }
	)
		--data.raw["unit"][bot_name].icon = 
end]]

for _, armor in pairs(data.raw.armor) do
	log("found armor")
	for _, resistance in pairs (armor.resistances) do
		if resistance.type == "acid" then
			if armor==data.raw.armor["tiberium-armor"] then
			else
				log("has acid")
				table.insert(armor.resistances, {type= "tiberium", decrease = resistance.decrease, percent = resistance.percent})
			end
		end
	end
end