--Orbital Ion Cannon
if (mods["Orbital Ion Cannon"]) then
	log("found Ion Cannon")
	LSlib.technology.addPrerequisite("orbital-ion-cannon", "tiberium-power-tech")
	LSlib.recipe.editIngredient("orbital-ion-cannon", "laser-turret", "tiberium-ion-core", 1)
end

for _, armor in pairs(data.raw.armor) do
	log("found armor")
	for _, resistance in pairs (armor.resistances) do
		if resistance.type == "acid" then
			log("has acid")
			table.insert(armor.resistances, {type= "tiberium", decrease = resistance.decrease, percent = resistance.percent})
		end
	end
end