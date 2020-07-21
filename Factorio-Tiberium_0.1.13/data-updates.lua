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


if mods["Krastorio2"] then
	-- Make Krastorio stop removing Tiberium Science Packs from our techs
	for technology_name, technology in pairs(data.raw.technology) do
		if string.sub(technology_name, 1, 9) == "tiberium-" then
			technology.check_science_packs_incompatibilities = false
		end
	end
	
	-- Make Tiberium Magazines usable with rifles again
	LSlib.recipe.editIngredient("tiberium-rounds-magazine", "piercing-rounds-magazine", "rifle-magazine", 1)
	local oldTibRounds = data.raw.ammo["tiberium-rounds-magazine"]
	local newTibRounds = table.deepcopy(data.raw.ammo["uranium-rifle-magazine"])
	--newTibRounds.icon = oldTibRounds.icon  -- I guess we'll keep the Krastorio icon to blend in
	newTibRounds.name = oldTibRounds.name
	newTibRounds.order = oldTibRounds.order
	newTibRounds.subgroup = "a-items"
	local oldProjectile
	for _, action in pairs(newTibRounds.ammo_type.action[1].action_delivery) do -- This is probably bad, but supporting optionally nested tables is annoying
		if action.type == "projectile" then
			oldProjectile = action.projectile
			action.projectile = "tiberium-ammo"
			break
		end
	end
	data.raw.ammo["tiberium-rounds-magazine"] = newTibRounds
	-- Update projectile to do Tiberium damage
	if oldProjectile then
		local tibProjectile = table.deepcopy(data.raw.projectile[oldProjectile])
		tibProjectile.name = "tiberium-ammo"
		local tibRoundsDamage = 0
		for _, effect in pairs(tibProjectile.action.action_delivery.target_effects) do
			if effect.type == "damage" then
				tibRoundsDamage = tibRoundsDamage + effect.damage.amount
				effect.damage.amount = 0
			end
		end
		table.insert(tibProjectile.action.action_delivery.target_effects, {type = "damage", damage = {amount = tibRoundsDamage, type = "tiberium"}})
		data.raw.projectile["tiberium-ammo"] = tibProjectile
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

if (mods["omnimatter"]) then
	LSlib.recipe.editIngredient("tib-spike", "pumpjack", "offshore-pump", 1)
end

--Helper function
--Returns the key for a given value in a given table or false if it doesn't exist
function find_value_in_table(list, value)
	if not list then return false end
	if not value then return false end
	for k, v in pairs(list) do
		if v == value then return k end
	end
	return false
end

--Adding Tib Science to all labs
local tibComboPacks = {}  -- List of packs that need to be processed in the same lab as Tib Science
for _, tech in pairs({"tiberium-control-network-tech", "tiberium-explosives"}) do
	for _, ingredient in pairs(data.raw.technology[tech].unit.ingredients) do
		local pack = ingredient[1]
		if pack == "tiberium-science" then -- Don't add Tib Science
		elseif not find_value_in_table(tibComboPacks, pack) then  -- Don't add duplicates
			table.insert(tibComboPacks, pack)
		end
	end
end

for labName, labData in pairs(data.raw.lab) do
	local addTib = false
	if not find_value_in_table(labData.inputs, "tiberium-science") then -- Must not already allow Tib Science
		for _, pack in pairs(tibComboPacks) do  -- Must use packs from combo list so we don't hit things like module labs
			if find_value_in_table(labData.inputs, pack) then
				addTib = true
				break
			end
		end
	end
	if addTib then table.insert(data.raw.lab[labName].inputs, "tiberium-science") end
end

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
          filename = "__Factorio-Tiberium-Beta__/graphics/entity/Refinery/Refinery.png",
          width = 450,
          height = 450,
          frame_count = 1,
          --shift = {2.515625, 0.484375},
          hr_version =
          {
            filename = "__Factorio-Tiberium-Beta__/graphics/entity/Refinery/Refinery.png",
            width = 450,
			height = 450,
            frame_count = 1,
          --  shift = util.by_pixel(0, -7.5),
            scale = 0.5
          }
        },
        {
          filename = "__Factorio-Tiberium-Beta__/graphics/entity/Refinery/RefineryShadow.png",
          width = 450,
          height = 450,
          frame_count = 1,
         -- shift = util.by_pixel(82.5, 26.5),
          draw_as_shadow = true,
          hr_version =
          {
            filename = "__Factorio-Tiberium-Beta__/graphics/entity/Refinery/RefineryShadow.png",
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
			elseif armor==data.raw.armor["tiberium-power-armor"] then
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