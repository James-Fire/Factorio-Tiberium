local tiberiumArmor = table.deepcopy(data.raw.armor["heavy-armor"])

tiberiumArmor.name = "tiberium-armor"
tiberiumArmor.icons= {
   {
      icon=tiberiumArmor.icon,
      tint={r=0.2,g=0.8,b=0.2,a=0.9}
   },
}

tiberiumArmor.resistances = {
   {
      type = "physical",
      decrease = 6,
      percent = 10
   },
   {
      type = "explosion",
      decrease = 10,
      percent = 10
   },
   {
      type = "acid",
      decrease = 100,
      percent = 100
   }
}

local recipe = table.deepcopy(data.raw.recipe["heavy-armor"])
recipe.name = "tiberium-armor"
recipe.ingredients = {{"copper-plate",200},{"steel-plate",50}}
recipe.result = "tiberium-armor"

data:extend{tiberiumArmor,recipe}