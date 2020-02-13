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
    type = "int-setting",
    name = "growth-credit",
    setting_type = "runtime-global",
    default_value = 20,
    maximum_value = 100,
    minimum_value = 1
  },
  {
    type = "int-setting",
    name = "tiberium-damage",
    setting_type = "startup",
    default_value = 10,
    minimum_value = 5,
  },
  {
    type = "int-setting",
    name = "tiberium-radius",
    setting_type = "startup",
    default_value = 30,
    minimum_value = 5,
  },
  {
    type = "int-setting",
    name = "tiberium-growth",
    setting_type = "startup",
    default_value = 100,
    minimum_value = 1,
  },
  {
    type = "int-setting",
    name = "tiberium-value",
    setting_type = "startup",
    default_value = 10,
    minimum_value = 1,
  },
}
)

