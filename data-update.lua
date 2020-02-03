--Orbital Ion Cannon
if (mods["Orbital Ion Cannon"]) then
	log("found Ion Cannon")
	LSlib.technology.addPrerequisite("orbital-ion-cannon", "tiberium-power-tech")
	LSlib.recipe.editIngredient("orbital-ion-cannon", "laser-turret", "tiberium-ion-core", 1)
end

