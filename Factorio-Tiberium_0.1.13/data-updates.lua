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

TibBasicScience = {"chemical-plant", "assembling-machine-1", "assembling-machine-2", "assembling-machine-3"}
if (mods["bobassembly"]) then
	table.insert(TibBasicScience, "chemical-plant-2")
	table.insert(TibBasicScience, "chemical-plant-3")
	table.insert(TibBasicScience, "chemical-plant-4")
end

if (mods["angelspetrochem"]) then
	table.insert(TibBasicScience, "angels-chemical-plant")
	table.insert(TibBasicScience, "angels-chemical-plant-2")
	table.insert(TibBasicScience, "angels-chemical-plant-3")
	table.insert(TibBasicScience, "angels-chemical-plant-4")
	table.insert(TibBasicScience, "advanced-chemical-plant")
	table.insert(TibBasicScience, "advanced-chemical-plant-2")
end

for i, name in pairs(TibBasicScience) do
	LSlib.entity.addCraftingCategory("assembling-machine", name, "basic-tiberium-science")
end

--table.insert(data.raw["assembling-machine"][entity].crafting_categories, "basic-tiberium-science")
TibScience = {"chemical-plant"}

if (mods["bobassembly"]) then
	table.insert(TibScience, "chemical-plant-2")
	table.insert(TibScience, "chemical-plant-3")
	table.insert(TibScience, "chemical-plant-4")
end

if (mods["angelspetrochem"]) then
	table.insert(TibScience, "angels-chemical-plant")
	table.insert(TibScience, "angels-chemical-plant-2")
	table.insert(TibScience, "angels-chemical-plant-3")
	table.insert(TibScience, "angels-chemical-plant-4")
	table.insert(TibScience, "advanced-chemical-plant")
	table.insert(TibScience, "advanced-chemical-plant-2")
end

for _,TS in pairs(TibScience) do
	LSlib.entity.addCraftingCategory("assembling-machine", TS, "tiberium-science")
end
--table.insert(data.raw["assembling-machine"][entity].crafting_categories, "tiberium-science")


--[[if (mods["bobassembly"]) then
		for _,chemicalName in pairs{
			"chemical-plant",
			"chemical-plant-2",
		    "chemical-plant-3",
			"chemical-plant-4",
		} do
		  table.insert(data.raw["assembling-machine"][chemicalName].crafting_categories, "tiberium-science")
		end
end]]

--[[if (mods["Mining_Drones"]) then
	data.raw["assembling-machine"][names.mining_depot].animation = make_4way_animation_from_spritesheet{
    {
      layers =
      {
        {
          filename = "__Factorio-Tiberium__/graphics/entity/Refinery/Refinery.png",
          width = 450,
          height = 450,
          frame_count = 1,
          --shift = {2.515625, 0.484375},
          hr_version =
          {
            filename = "__Factorio-Tiberium__/graphics/entity/Refinery/Refinery.png",
            width = 450,
			height = 450,
            frame_count = 1,
          --  shift = util.by_pixel(0, -7.5),
            scale = 0.5
          }
        },
        {
          filename = "__Factorio-Tiberium__/graphics/entity/Refinery/RefineryShadow.png",
          width = 450,
          height = 450,
          frame_count = 1,
         -- shift = util.by_pixel(82.5, 26.5),
          draw_as_shadow = true,
          hr_version =
          {
            filename = "__Factorio-Tiberium__/graphics/entity/Refinery/RefineryShadow.png",
			width = 450,
			height = 450,
            frame_count = 1,
           -- shift = util.by_pixel(82.5, 26.5),
            draw_as_shadow = true,
            force_hr_shadow = true,
            scale = 0.5
          }
        }
      }
    }
	}
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

--[[for _, poles in pairs(data.raw.electric-pole) do
	table.insert(electric-pole.resistances, {type= "tiberium", decrease = 10, percent = 50})
end]]