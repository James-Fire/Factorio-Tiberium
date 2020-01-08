--Orbital Ion Cannon
if (mods["Orbital Ion Cannon"]) then
	log("found Ion Cannon")
	data.raw.recipe["orbital-ion-cannon"].normal.ingredients = {{name="low-density-structure",amount=100,type="item"},{name="solar-panel",amount=100,type="item"},{name="accumulator",amount=200,type="item"},{name="radar",amount=10,type="item"},{name="processing-unit",amount=200,type="item"},{name="electric-engine-unit",amount=25,type="item"},{name="tiberium-ion-core",amount=20,type="item"},{name="rocket-fuel",amount=50,type="item"}}
	data.raw.recipe["orbital-ion-cannon"].expensive.ingredients = {{name="low-density-structure",amount=250,type="item"},{name="solar-panel",amount=250,type="item"},{name="accumulator",amount=500,type="item"},{name="radar",amount=25,type="item"},{name="processing-unit",amount=500,type="item"},{name="electric-engine-unit",amount=50,type="item"},{name="tiberium-ion-core",amount=40,type="item"},{name="rocket-fuel",amount=100,type="item"}}


	data:extend(
	{
	{
		type = "technology",
		name = "orbital-ion-cannon",
		icon = "__Orbital Ion Cannon__/graphics/icon64.png",
		icon_size = 64,
		prerequisites = {"rocket-silo", "energy-weapons-damage-6", "tiberium-power-tech"},
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "orbital-ion-cannon"
			},
			{
				type = "unlock-recipe",
				recipe = "ion-cannon-targeter"
			}
		},
		unit =
		{
			count = 2500,
			ingredients =
			{
				{"automation-science-pack", 2},
				{"logistic-science-pack", 2},
				{"chemical-science-pack", 2},
				{"military-science-pack", 2},
				{"utility-science-pack", 2},
				{"production-science-pack", 2},
				{"space-science-pack", 1}
			},
			time = 60
		},
		order = "k-a"
	},
}
)
end

