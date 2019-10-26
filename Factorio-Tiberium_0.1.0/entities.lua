local centrifuge = table.deepcopy(data.raw["assembling-machine"]["centrifuge"])

centrifuge.fluid_boxes = 
{
	off_when_no_fluid_recipe = true,
	{
		production_type = "input",
		pipe_picture = assembler2pipepictures(),
		pipe_covers = pipecoverspictures(),
		base_area = 10,
		base_level = -1,
		pipe_connections = {{ type="input", position = {0, -2} }},
		secondary_draw_orders = { north = -1 }
	},
	{
		production_type = "output",
		pipe_picture = assembler2pipepictures(),
		pipe_covers = pipecoverspictures(),
		base_area = 10,
		base_level = 1,
		pipe_connections = {{ type="output", position = {0, 2} }},
		secondary_draw_orders = { north = -1 }
	},
}

data:extend({centrifuge,})
