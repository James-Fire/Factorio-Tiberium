if mods["finely-crafted-graphics"] then
	-- Replace Tiberium Network Node sprite with Core Extractor sprite
	local extractorPath = "__finely-crafted-graphics__/graphics/core-extractor/core-extractor-"
	data.raw["item"]["tiberium-network-node"].icon = extractorPath.."icon.png"
	data.raw["mining-drill"]["tiberium-network-node"].graphics_set.animation = {
		layers = {
			{
				priority = "high",
				width = 704,
				height = 704,
				frame_count = 120,
				lines_per_file = 8,
				animation_speed = 0.5,
				scale = 0.14,
				stripes = {
					{
						filename = extractorPath.."hr-animation-1.png",
						width_in_frames = 8,
						height_in_frames = 8
					},
					{
						filename = extractorPath.."hr-animation-2.png",
						width_in_frames = 8,
						height_in_frames = 7
					}
				}
			},
			{
				filename = extractorPath.."hr-shadow.png",
				priority = "high",
				width = 1400,
				height = 1400,
				frame_count = 1,
				line_length = 1,
				repeat_count = 120,
				animation_speed = 0.5,
				draw_as_shadow = true,
				scale = 0.14
			}
		}
	}
	data.raw["mining-drill"]["tiberium-network-node"].graphics_set.frozen_patch = nil -- huh, this mod doesn't include the graphics for it
	data.raw["mining-drill"]["tiberium-network-node"].graphics_set.working_visualisations = {
		{
			fadeout = true,
			animation = {
				priority = "high",
				draw_as_glow = true,
				blend_mode = "additive",
				width = 704,
				height = 704,
				frame_count = 120,
				lines_per_file = 8,
				animation_speed = 0.5,
				scale = 0.14,
				stripes = {
					{
						filename = extractorPath.."hr-emission-1.png",
						width_in_frames = 8,
						height_in_frames = 8
					},
					{
						filename = extractorPath.."hr-emission-2.png",
						width_in_frames = 8,
						height_in_frames = 7
					}
				}
			}
		}
	}

	-- Replace Tiberium Centrifuge sprite with Atom Force sprite
	local forgePath = "__finely-crafted-graphics__/graphics/atom-forge/atom-forge-"
	local forgeAnimation = {
		layers = {
			{
				priority = "high",
				width = 400,
				height = 480,
				frame_count = 80,
				lines_per_file = 8,
				animation_speed = 1,
				scale = 0.23,
				stripes = {
					{
						filename = forgePath.."hr-animation-1.png",
						width_in_frames = 8,
						height_in_frames = 8
					},
					{
						filename = forgePath.."hr-animation-2.png",
						width_in_frames = 8,
						height_in_frames = 2
					}
				}
			},
			{
				filename = forgePath.."hr-shadow.png",
				priority = "high",
				width = 900,
				height = 500,
				frame_count = 1,
				line_length = 1,
				repeat_count = 80,
				animation_speed = 1,
				draw_as_shadow = true,
				scale = 0.23
			}
		}
	}

	local forgeWorkingAnimation = {
		{
			fadeout = true,
			animation = {
				priority = "high",
				draw_as_glow = true,
				blend_mode = "additive",
				width = 400,
				height = 480,
				frame_count = 80,
				lines_per_file = 8,
				animation_speed = 1,
				scale = 0.23,
				stripes = {
					{
						filename = forgePath.."hr-emission-1.png",
						width_in_frames = 8,
						height_in_frames = 8
					},
					{
						filename = forgePath.."hr-emission-2.png",
						width_in_frames = 8,
						height_in_frames = 2
					}
				}
			}
		}
	}

	for _, i in pairs({1,2,3}) do
		data.raw["item"]["tiberium-centrifuge-"..i].icons = {
			{
				icon = tiberiumInternalName.."/graphics/icons/fuge"..i..".png",
				icon_size = 32,
			},
			{
				icon = forgePath.."icon.png",
				icon_size = 64,
				scale = 28/64,
			},
		}
		data.raw["assembling-machine"]["tiberium-centrifuge-"..i].graphics_set = {}
		data.raw["assembling-machine"]["tiberium-centrifuge-"..i].graphics_set.always_draw_idle_animation = true
		data.raw["assembling-machine"]["tiberium-centrifuge-"..i].graphics_set.idle_animation = forgeAnimation
		data.raw["assembling-machine"]["tiberium-centrifuge-"..i].graphics_set.working_visualisations = forgeWorkingAnimation
	end

	if data.raw["item"]["tiberium-centrifuge-0"] then
		data.raw["item"]["tiberium-centrifuge-0"].icon = forgePath.."icon.png"
		data.raw["assembling-machine"]["tiberium-centrifuge-0"].graphics_set = {}
		data.raw["assembling-machine"]["tiberium-centrifuge-0"].graphics_set.always_draw_idle_animation = true
		data.raw["assembling-machine"]["tiberium-centrifuge-0"].graphics_set.idle_animation = forgeAnimation
		data.raw["assembling-machine"]["tiberium-centrifuge-0"].graphics_set.working_visualisations = forgeWorkingAnimation
	end
end