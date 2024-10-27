if mods["pump"] then
	if data.raw["selection-tool"]["pump-selection-tool"] then
		if data.raw["selection-tool"]["pump-selection-tool"].select.entity_filters then
			table.insert(data.raw["selection-tool"]["pump-selection-tool"].select.entity_filters, "tibGrowthNode")
		end
		if data.raw["selection-tool"]["pump-selection-tool"].alt_select.entity_filters then
			table.insert(data.raw["selection-tool"]["pump-selection-tool"].alt_select.entity_filters, "tibGrowthNode")
		end
	end
end
