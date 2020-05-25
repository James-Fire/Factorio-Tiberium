data:extend(
{
  {
    type = "bool-setting",
    name = "debug-text",
    setting_type = "startup",
    default_value = false,
  },
  {
    type = "bool-setting",
    name = "tiberium-byproduct-1",
    setting_type = "startup",
    default_value = true,
  },
  {
    type = "bool-setting",
    name = "tiberium-byproduct-2",
    setting_type = "startup",
    default_value = false,
  },
  {
    type = "bool-setting",
    name = "waste-recycling",
    setting_type = "startup",
    default_value = true,
  },
  {
    type = "bool-setting",
    name = "tiberium-byproduct-direct",
    setting_type = "startup",
    default_value = false,
  },
  {
    type = "bool-setting",
    name = "biters-immune-to-tiberium-damage",
    setting_type = "startup",
    default_value = false,
  },
  {
	--Unused
    type = "int-setting",
    name = "growth-credit",
    setting_type = "runtime-global",
    default_value = 20,
    minimum_value = 1,
    maximum_value = 100,
  },
  {
    type = "int-setting",
    name = "tiberium-max-per-tile",
    setting_type = "startup",
    default_value = 1000,
    minimum_value = 100,
    maximum_value = 10000,
  },
  {
    type = "int-setting",
    name = "tiberium-damage",
    setting_type = "startup",
    default_value = 10,
    minimum_value = 0,
	maximum_value = 50,
  },
  {
    type = "int-setting",
    name = "tiberium-radius",
    setting_type = "startup",
    default_value = 30,
    minimum_value = 5,
	maximum_value = 100,
  },
  {
    type = "int-setting",
    name = "tiberium-growth",
    setting_type = "startup",
    default_value = 100,
    minimum_value = 1,
	maximum_value = 1000,
  },
  {
    type = "int-setting",
    name = "tiberium-value",
    setting_type = "startup",
    default_value = 10,
    minimum_value = 1,
	maximum_value = 100,
  },
}
)
