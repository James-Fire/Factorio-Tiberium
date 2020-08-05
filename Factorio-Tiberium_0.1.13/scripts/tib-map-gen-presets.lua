local mgp = data.raw["map-gen-presets"].default

mgp["Tib-only"] = {
      order = "t",
      basic_settings =
      {
        property_expression_names = {},
		default_enable_all_autoplace_controls = false,
        autoplace_controls =
        {
			["tibGrowthNode"] = {
				frequency = "high",
				size = "high"
			},
        }
      }
    }