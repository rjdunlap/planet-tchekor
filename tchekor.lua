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

-- Custom Scrap

data:extend{
    {
        type = "autoplace-control",
        name = "tchekor-scrap",
        localised_name = {"", "[entity=tchekor-scrap] ", {"entity-name.tchekor-scrap"}},
        richness = true,
        order = "d-a",
        category = "resource"
      },
}

function TResource(resource_parameters, autoplace_parameters)
    return
    {
      type = "resource",
      name = resource_parameters.name,
      icon = "__space-age__/graphics/icons/scrap.png",
      flags = {"placeable-neutral"},
      order="a-b-"..resource_parameters.order,
      tree_removal_probability = 0.8,
      tree_removal_max_distance = 32 * 32,
      minable = resource_parameters.minable or
      {
        mining_particle = "scrap-particle",
        mining_time = resource_parameters.mining_time,
        result = resource_parameters.name
      },
      category = resource_parameters.category,
      subgroup = resource_parameters.subgroup,
      walking_sound = resource_parameters.walking_sound,
      collision_mask = resource_parameters.collision_mask,
      collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      resource_patch_search_radius = resource_parameters.resource_patch_search_radius,
      autoplace = autoplace_parameters.probability_expression ~= nil and
      {
        --control = resource_parameters.name,
        order = resource_parameters.order,
        probability_expression = autoplace_parameters.probability_expression,
        richness_expression = autoplace_parameters.richness_expression
      }
      or resource_autoplace.resource_autoplace_settings
      {
        name = resource_parameters.name,
        order = resource_parameters.order,
        autoplace_control_name = resource_parameters.autoplace_control_name,
        base_density = autoplace_parameters.base_density,
        base_spots_per_km = autoplace_parameters.base_spots_per_km2,
        regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier,
        starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier,
        candidate_spot_count = autoplace_parameters.candidate_spot_count,
        tile_restriction = autoplace_parameters.tile_restriction
      },
      stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
      stages =
      {
        sheet =
        {
          filename = "__space-age__/graphics/entity/scrap/scrap.png",
          priority = "extra-high",
          size = 128,
          frame_count = 8,
          variation_count = 8,
          scale = 0.5
        }
      },
      map_color = resource_parameters.map_color,
      mining_visualisation_tint = resource_parameters.mining_visualisation_tint,
      factoriopedia_simulation = resource_parameters.factoriopedia_simulation
    }
  end

data:extend({
    TResource(
    {
      name = "tchekor-scrap",
      order = "c",
      map_color = {0.9, 0.9, 0.9},
      mining_time = 0.5,
      walking_sound = sounds.ore,
      resource_patch_search_radius = 12,
      mining_visualisation_tint = {r = 0.77, g = 0.77, b = 0.9, a = 1.000}, -- #fae1a4ff
      factoriopedia_simulation = simulations.factoriopedia_scrap,
    },
    {
      probability_expression = data.raw["autoplace-control"]["scrap"].probability_expression
    }
  )
})

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
      {type = "item", name = "iron-gear-wheel",        amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false},
      {type = "item", name = "copper-wire",            amount = 1, probability = 0.04, show_details_in_recipe_tooltip = false},
      {type = "item", name = "tungsten-ore",           amount = 1, probability = 0.10, show_details_in_recipe_tooltip = false},
      {type = "item", name = "sulfur",                 amount = 1, probability = 0.10, show_details_in_recipe_tooltip = false},
      {type = "item", name = "concrete",               amount = 1, probability = 0.03, show_details_in_recipe_tooltip = false},
      {type = "item", name = "calcite",                amount = 1, probability = 0.10, show_details_in_recipe_tooltip = false},
      {type = "item", name = "holmium-ore",            amount = 1, probability = 0.10, show_details_in_recipe_tooltip = false},
    }
  }
}

