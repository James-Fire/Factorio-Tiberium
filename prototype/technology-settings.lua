local easyMode = settings.startup["tiberium-easy-recipes"].value

if easyMode then
	data:extend{
		{
			type = "technology",
			name = "tiberium-easy-transmutation-tech",
			icon = tiberiumInternalName.."/graphics/technology/tiberium-transmutation.png",
			icon_size = 128,
			effects = {
				-- Transmutation recipes created and added to this tech by /scripts/DynamicOreRecipes
			},
			prerequisites = {"tiberium-mechanical-research", "oil-processing"},
			unit = {
				count = 10,
				ingredients = {
					{"tiberium-science", 1},
					{"automation-science-pack", 1},
				},
				time = 30
			}
		}
	}
end

if common.tierZero then
	data:extend{
		{
			type = "technology",
			name = "tiberium-ore-centrifuging",
			icon = tiberiumInternalName.."/graphics/icons/tiberium-ore.png",
			icon_size = 64,
			effects = {
				{
					type = "unlock-recipe",
					recipe = "tiberium-centrifuge-0"
				},
				{
					type = "unlock-recipe",
					recipe = "tiberium-ore-centrifuging"
				},
				-- Ore centrifuging with sludge recipe created and added to this tech by /scripts/DynamicOreRecipes
			},
			unit = {
				count = 25,
				ingredients = {
					{"automation-science-pack", 1},
				},
				time = 10
			}
		}
	}
	common.technology.addPrerequisite("tiberium-slurry-centrifuging", "tiberium-ore-centrifuging")
end

if settings.startup["tiberium-technology-triggers"].value then
	data.raw.technology["tiberium-mechanical-research"].unit = nil
	data.raw.technology["tiberium-mechanical-research"].research_trigger = {type = "mine-entity", entity = "tiberium-ore"}

	data.raw.technology["tiberium-slurry-centrifuging"].unit = nil
	data.raw.technology["tiberium-slurry-centrifuging"].research_trigger = {type = "craft-fluid", fluid = "tiberium-slurry"}

	data.raw.technology["tiberium-molten-centrifuging"].unit = nil
	data.raw.technology["tiberium-molten-centrifuging"].research_trigger = {type = "craft-fluid", fluid = "molten-tiberium"}

	data.raw.technology["tiberium-liquid-centrifuging"].unit = nil
	data.raw.technology["tiberium-liquid-centrifuging"].research_trigger = {type = "craft-fluid", fluid = "liquid-tiberium"}

	if common.tierZero then
		data.raw.technology["tiberium-ore-centrifuging"].unit = nil
		data.raw.technology["tiberium-ore-centrifuging"].research_trigger = {type = "mine-entity", entity = "tiberium-tiber-rock"}
	end
end

if common.whichPlanet == "tiber" then
	-- Lock planet behind tech
	data:extend{{
		type = "technology",
		name = "planet-discovery-tiber",
		icons = {
			{
				icon = tiberiumInternalName.."/graphics/icons/tiber-planet.png",
				icon_size = 512,
				scale = 0.5,
			},
			{
				icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
				icon_size = 128,
				scale = 1,
				shift = {100, 100}
			}
		},
		essential = true,
		effects = {{
			type = "unlock-space-location",
			space_location = "tiber",
			use_icon_overlay_constant = true
		}},
		prerequisites = {"space-platform-thruster"},
		unit = {
			count = 1000,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"space-science-pack", 1}
			},
			time = 60
		}
	}}
	-- Lock tech behind planet
	common.technology.addPrerequisite("planet-discovery-aquilo", "planet-discovery-tiber")  -- There should be some final tech to unlock Aquilo instead of just the initial
	for technolgyName in pairs(data.raw.technology) do
		if string.find(technolgyName, "tiberium") == 1 then
			common.technology.addPrerequisite(technolgyName, "planet-discovery-tiber")
		end
	end
elseif common.whichPlanet == "tiber-start" then
	-- Lock Nauvis behind tech
	data:extend{{
		type = "technology",
		name = "planet-discovery-nauvis",
		icons = {
			{
				icon = "__base__/graphics/icons/starmap-planet-nauvis.png",
				icon_size = 512,
				scale = 0.5
			},
			{
				icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
				icon_size = 128,
				scale = 1,
				shift = {100, 100}
			}
		},
		essential = true,
		effects = {{
			type = "unlock-space-location",
			space_location = "nauvis",
			use_icon_overlay_constant = true
		}},
		prerequisites = {"space-platform-thruster"},
		unit = {
			count = 1000,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"space-science-pack", 1}
			},
			time = 60
		}
	}}
	-- Nauvis techs locked behind planet
	common.technology.addPrerequisite("uranium-mining", "planet-discovery-nauvis")
	common.technology.addPrerequisite("captivity", "planet-discovery-nauvis")
	common.technology.addPrerequisite("fish-breeding", "planet-discovery-nauvis")
	common.technology.addPrerequisite("tree-seeding", "planet-discovery-nauvis")
	common.technology.addPrerequisite("planet-discovery-aquilo", "planet-discovery-nauvis")
end
if common.tierZero and (common.whichPlanet == "pure-nauvis" or common.whichPlanet == "tiber-start") then
	-- Do this for tiberium-only starts to make progression clearer
	data.raw.technology["tiberium-ore-centrifuging"].unit = nil
	data.raw.technology["tiberium-ore-centrifuging"].research_trigger = {type = "mine-entity", entity = "tiberium-tiber-rock"}
	common.technology.addPrerequisite("electronics", "tiberium-ore-centrifuging")
	common.technology.addPrerequisite("steam-power", "tiberium-ore-centrifuging")
end
if not mods["space-age"] then
	data.raw.technology["tiberium-artillery"] = nil
	table.insert(data.raw.technology["tiberium-military-3"].effects, {type = "unlock-recipe", recipe = "tiberium-artillery-shell"})
	table.insert(data.raw.technology["tiberium-military-3"].prerequisites, "artillery")
end
