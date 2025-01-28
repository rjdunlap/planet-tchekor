local utils = require("__any-planet-start__.utils")
local resource_autoplace = require("resource-autoplace")
local sounds = require("__base__.prototypes.entity.sounds")
local simulations = require("__space-age__.prototypes.factoriopedia-simulations")
local item_sounds = require("__base__.prototypes.item_sounds")

data.raw.technology["planet-discovery-vulcanus"].hidden = true
data.raw.technology["planet-discovery-fulgora"].hidden = true

utils.set_prerequisites("recycling", nil)
utils.set_prerequisites("tungsten-carbide", nil)
utils.set_prerequisites("calcite-processing", nil)

utils.set_trigger("tungsten-carbide", {type = "mine-entity", entity = "big-volcanic-rock"})

utils.set_prerequisites("foundry", {"tungsten-carbide","concrete", "lubricant"})

local merge = require("lib").merge

-- Custom Scrap

data:extend({
	merge(data.raw.resource["scrap"], {
		name = "tchekor-scrap",
		icon_size = 64,
		order = "w-a[tchekor-scrap]",
		minable = merge(data.raw.resource["scrap"].minable, {
			mining_time = 0.33,
			result = "tchekor-scrap",
		}),
		map_color = { 0.18, 0.22, 0.2 },
		map_grid = true,
		factoriopedia_simulation = "nil",
	}),})

data:extend{{
    type = "item",
    name = "tchekor-scrap",
    icon = "__space-age__/graphics/icons/scrap.png",
    pictures =
    {
      { size = 64, filename = "__space-age__/graphics/icons/scrap.png",   scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-1.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-2.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-3.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-4.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-5.png", scale = 0.5, mipmap_count = 4 }
    },
    subgroup = "fulgora-processes",
    order = "a[tchekor-scrap]-a[tchekor-scrap]",
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    stack_size = 50,
    default_import_location = "tchekor",
    weight = 2*kg
  }
}

data:extend{
{
    type = "recipe",
    name = "tchekor-scrap-recycling",
    icons = {
      {
        icon = "__quality__/graphics/icons/recycling.png"
      },
      {
        icon = "__space-age__/graphics/icons/scrap.png",
        scale = 0.4
      },
      {
        icon = "__quality__/graphics/icons/recycling-top.png"
      }
    },
    category = "recycling-or-hand-crafting",
    subgroup = "fulgora-processes",
    order = "a[trash]-a[trash-recycling]",
    enabled = false,
    auto_recycle = false,
    energy_required = 0.4,
    ingredients = {{type = "item", name = "tchekor-scrap", amount = 1}},
    results =
    {
      {type = "item", name = "inserter",               amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false},
      {type = "item", name = "medium-electric-pole",   amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false},
      {type = "item", name = "splitter",               amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false},
      {type = "item", name = "assembling-machine-1",   amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false},
      {type = "item", name = "rail",                   amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false},
      {type = "item", name = "tungsten-ore",           amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false},
      {type = "item", name = "ice",                    amount = 1, probability = 0.12, show_details_in_recipe_tooltip = false},
      {type = "item", name = "sulfur",                 amount = 1, probability = 0.06, show_details_in_recipe_tooltip = false},
      {type = "item", name = "scrap",                  amount = 1, probability = 0.20, show_details_in_recipe_tooltip = false},
      {type = "item", name = "calcite",                amount = 1, probability = 0.05, show_details_in_recipe_tooltip = false},
      {type = "item", name = "coal",                   amount = 1, probability = 0.08, show_details_in_recipe_tooltip = false},
      {type = "item", name = "holmium-ore",            amount = 1, probability = 0.06, show_details_in_recipe_tooltip = false},
    }
  }
}

