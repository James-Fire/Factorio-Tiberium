if not mods["canal-excavator"] then return end

data:extend({{
  type = "mod-data",
  name = "canex-tiber-config",
  data_type = "canex-surface-config",
  data = {
    surfaceName = "tiber",
    localisation = {"space-location-name.tiber"},
    oreStartingAmount = 5,
    mining_time = 8,
    tint = {r = 82, g = 108, b = 6},
    mineResult = {
      {type="item", name = "stone", probability = 0.98, amount = 1},
      {type="item", name = "tiberium-ore", probability = 0.02, amount = 1},
    },
    icon_data = {
      icon_size = 512,
    }
  }
}})