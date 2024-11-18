local Informatron = {} -- informatron pages implementation.

function Informatron.menu(player_index)
	local player = game.players[player_index]
	local menu = {
		tiberium_growth = {
			nodes = 1,
			growth_accelerator = 1,
			tiberium_seed = 1,
		},
		harvesting = {
			node_harvester = 1,
			tiberium_spike = 1,
			tiberium_control_node = 1,
			aoe_node_harvester = 1,
			tiberium_control_network = 1,
		},
		refining = {
			tiberium_ore = 1,
			sludge = 1,
			slurry = 1,
			molten = 1,
			liquid = 1,
			centrifuging = 1,
		},
		containment = {
			armor = 1,
			sonic_fences = 1,
			MARV = 1,
		},
		weaponry = {
			ion_projector = 1,
			tiberium_missiles = 1,
		},
	}
	return menu
end

function Informatron.page_content(page_name, player_index, element)
  local player = game.players[player_index]

	if page_name == tiberiumInternalName then
		element.add{type="button", name="image_1", style="tiberium"}
		element.add{type = "label", name="text_1", caption={tiberiumInternalName..".mod_page"}}


	elseif page_name == "tiberium_growth" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".tiberium_growth"}}
	elseif page_name == "nodes" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".nodes"}}
	elseif page_name == "growth_accelerator" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".growth_accelerator"}}
	elseif page_name == "tiberium_seed" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".tiberium_seed"}}

	elseif page_name == "harvesting" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".harvesting"}}
	elseif page_name == "node_harvester" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".node_harvester"}}
	elseif page_name == "tiberium_spike" then
		element.add{type="button", name="image_1", style="tiberium_spike"}
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".tiberium_spike"}}
	elseif page_name == "tiberium_control_node" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".tiberium_control_node"}}
	elseif page_name == "aoe_node_harvester" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".aoe_node_harvester"}}
	elseif page_name == "tiberium_control_network" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".tiberium_control_network"}}

	elseif page_name == "refining" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".refining"}}
	elseif page_name == "tiberium_ore" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".tiberium_ore"}}
	elseif page_name == "sludge" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".sludge"}}
	elseif page_name == "slurry" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".slurry"}}
	elseif page_name == "molten" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".molten"}}
	elseif page_name == "liquid" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".liquid"}}
	elseif page_name == "centrifuging" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".centrifuging"}}

	elseif page_name == "containment" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".containment"}}
		elseif page_name == "armor" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".armor"}}
	elseif page_name == "sonic_fences" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".sonic_fences"}}
	elseif page_name == "MARV" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".MARV"}}

	elseif page_name == "weaponry" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".weaponry"}}
		elseif page_name == "ion_projector" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".ion_projector"}}
	elseif page_name == "tiberium_missiles" then
		element.add{type="label", name="text_1", caption={tiberiumInternalName..".tiberium_missiles"}}
	end
end

return Informatron
