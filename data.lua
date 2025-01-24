--data.lua
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")
local planet_catalogue_vulcanus = require("__space-age__.prototypes.planet.procession-catalogue-vulcanus")

require("tchekor")

--START MAP GEN
function MapGen_Tchekor()
    local map_gen_setting = table.deepcopy(data.raw.planet.fulgora.map_gen_settings)
    map_gen_setting.property_expression_names =
    {
      elevation = "fulgora_elevation",
      temperature = "temperature_basic",
      moisture = "moisture_basic",
      aux = "aux_basic",
      cliffiness = "fulgora_cliffiness",
      cliff_elevation = "cliff_elevation_from_elevation",
      ["entity:sulfuric-acid-geyser:probability"] = "vulcanus_sulfuric_acid_geyser_probability",
      ["entity:sulfuric-acid-geyser:richness"] = "vulcanus_sulfuric_acid_geyser_richness",
    }
    
    map_gen_setting.autoplace_controls = {
        ["tchekor-scrap"] = {frequency = 1, size = 1, richness = 1},
        ["enemy-base"] = { frequency = 3, size = 1.2, richness = 1},
        ["fulgora_islands"] = {},
        ["fulgora_cliff"] = {},
        ["vulcanus_volcanism"] = {},
        ["sulfuric_acid_geyser"] = {},
    }

    map_gen_setting.territory_settings = {
        units = {"small-demolisher", "medium-demolisher", "big-demolisher"},
        territory_index_expression = "demolisher_territory_expression",
        territory_variation_expression = "demolisher_variation_expression",
        minimum_territory_size = 10
      }
    
    map_gen_setting.cliff_settings ={
      name = "cliff-fulgora",
      control = "fulgora_cliff",
      cliff_elevation_0 = 80,
      -- Ideally the first cliff would be at elevation 0 on the coastline, but that doesn't work,
      -- so instead the coastline is moved to elevation 80.
      -- Also there needs to be a large cliff drop at the coast to avoid the janky cliff smoothing
      -- but it also fails if a corner goes below zero, so we need an extra buffer of 40.
      -- So the first cliff is at 80, and terrain near the cliff shouln't go close to 0 (usually above 40).
      cliff_elevation_interval = 40,
      cliff_smoothing = 0, -- This is critical for correct cliff placement on the coast.
      richness = 0.95
    }

    map_gen_setting.autoplace_settings["tile"] =
    {
        settings =
        {
          ["volcanic-soil-dark"] = {},
          ["volcanic-soil-light"] = {},
          ["volcanic-ash-soil"] = {},
          ["volcanic-ash-flats"] = {},
          ["volcanic-ash-light"] = {},
          ["volcanic-ash-dark"] = {},
          ["volcanic-cracks"] = {},
          ["volcanic-cracks-warm"] = {},
          ["volcanic-folds"] = {},
          ["volcanic-folds-flat"] = {},
          ["lava"] = {},
          ["lava-hot"] = {},
          ["volcanic-folds-warm"] = {},
          ["volcanic-pumice-stones"] = {},
          ["volcanic-cracks-hot"] = {},
          ["volcanic-jagged-ground"] = {},
          ["volcanic-smooth-stone"] = {},
          ["volcanic-smooth-stone-warm"] = {},
          ["volcanic-ash-cracks"] = {},

          ["oil-ocean-shallow"] = {},
          ["oil-ocean-deep"] = {},
          ["fulgoran-rock"] = {},
          ["fulgoran-dust"] = {},
          ["fulgoran-sand"] = {},
          ["fulgoran-dunes"] = {},
          ["fulgoran-walls"] = {},
          ["fulgoran-paving"] = {},
          ["fulgoran-conduit"] = {},
          ["fulgoran-machinery"] = {},
        }
    }

    map_gen_setting.autoplace_settings["decorative"] =
    {
      settings =
      {
          -- nauvis decoratives
          ["v-brown-carpet-grass"] = {},
          ["v-green-hairy-grass"] = {},
          ["v-brown-hairy-grass"] = {},
          ["v-red-pita"] = {},
          -- end of nauvis
          ["vulcanus-rock-decal-large"] = {},
          ["vulcanus-crack-decal-large"] = {},
          ["vulcanus-crack-decal-huge-warm"] = {},
          ["vulcanus-dune-decal"] = {},
          ["vulcanus-sand-decal"] = {},
          ["vulcanus-lava-fire"] = {},
          ["calcite-stain"] = {},
          ["calcite-stain-small"] = {},
          ["sulfur-stain"] = {},
          ["sulfur-stain-small"] = {},
          ["sulfuric-acid-puddle"] = {},
          ["sulfuric-acid-puddle-small"] = {},
          ["crater-small"] = {},
          ["crater-large"] = {},
          ["pumice-relief-decal"] = {},
          ["small-volcanic-rock"] = {},
          ["medium-volcanic-rock"] = {},
          ["tiny-volcanic-rock"] = {},
          ["tiny-rock-cluster"] = {},
          ["small-sulfur-rock"] = {},
          ["tiny-sulfur-rock"] = {},
          ["sulfur-rock-cluster"] = {},
          ["waves-decal"] = {},

        ["fulgoran-ruin-tiny"] = {},
        ["fulgoran-gravewort"] = {},
        ["urchin-cactus"] = {},
        ["medium-fulgora-rock"] = {},
        ["small-fulgora-rock"] = {},
        ["tiny-fulgora-rock"] = {},
      }
    }

    map_gen_setting.autoplace_settings["entity"] =  { 
        settings = {
        ["tchekor-scrap"] = {},
        ["fulgoran-ruin-vault"] = { frequency = 2, size = 2, richness = 2},
        ["fulgoran-ruin-attractor"] = { frequency = 2, size = 2, richness = 2},
        ["fulgoran-ruin-colossal"] = { frequency = 2, size = 2, richness = 2},
        ["fulgoran-ruin-huge"] = { frequency = 2, size = 2, richness = 2},
        ["fulgoran-ruin-big"] = { frequency = 2, size = 2, richness = 2},
        ["fulgoran-ruin-stonehenge"] = { frequency = 2, size = 2, richness = 2},
        ["fulgoran-ruin-medium"] = { frequency = 2, size = 2, richness = 2},
        ["fulgoran-ruin-small"] = { frequency = 2, size = 2, richness = 2},
        ["fulgurite"] = {},
        ["big-fulgora-rock"] = {},

        ["sulfuric-acid-geyser"] = {},
        ["huge-volcanic-rock"] = {},
        ["big-volcanic-rock"] = {},
        ["crater-cliff"] = {},
        ["vulcanus-chimney"] = {},
        ["vulcanus-chimney-faded"] = {},
        ["vulcanus-chimney-cold"] = {},
        ["vulcanus-chimney-short"] = {},
        ["vulcanus-chimney-truncated"] = {},
        ["ashland-lichen-tree"] = {},
        ["ashland-lichen-tree-flaming"] = {},
        }
    }
     

    return map_gen_setting
end

--END MAP GEN

local nauvis = data.raw["planet"]["nauvis"]
local planet_lib = require("__PlanetsLib__.lib.planet")

local start_astroid_spawn_rate =
{
  probability_on_range_chunk =
  {
    {position = 0.1, probability = asteroid_util.nauvis_chunks, angle_when_stopped = asteroid_util.chunk_angle},
    {position = 0.9, probability = asteroid_util.nauvis_chunks, angle_when_stopped = asteroid_util.chunk_angle}
  },
  type_ratios =
  {
    {position = 0.1, ratios = asteroid_util.nauvis_ratio},
    {position = 0.9, ratios = asteroid_util.nauvis_ratio},
  }
}
local start_astroid_spawn = asteroid_util.spawn_definitions(start_astroid_spawn_rate, 0.1)


local tchekor = 
{
    type = "planet",
    name = "tchekor", 
    solar_power_in_space = 300,
    icon = "__planet-tchekor__/graphics/planet-tchekor.png",
    icon_size = 512,
    label_orientation = 0.55,
    starmap_icon = "__planet-tchekor__/graphics/planet-tchekor.png",
    starmap_icon_size = 512,
    magnitude = nauvis.magnitude,
    platform_procession_set =
    {
      arrival = {"planet-to-platform-b"},
      departure = {"platform-to-planet-a"}
    },
    planet_procession_set =
    {
      arrival = {"platform-to-planet-b"},
      departure = {"planet-to-platform-a"}
    },
    procession_graphic_catalogue = planet_catalogue_vulcanus,
    surface_properties = {
        ["day-night-cycle"] = 3 * minute,
        ["magnetic-field"] = 99,
        ["solar-power"] = 200,
        pressure = 4000,
        gravity = 40
    },
    map_gen_settings = MapGen_Tchekor(),
    asteroid_spawn_influence = 1,
    asteroid_spawn_definitions = start_astroid_spawn,
    pollutant_type = "pollution",
    persistent_ambient_sounds =
    {
      base_ambience = {filename = "__space-age__/sound/wind/base-wind-vulcanus.ogg", volume = 0.8},
      wind = {filename = "__space-age__/sound/wind/wind-vulcanus.ogg", volume = 0.8},
      crossfade =
      {
        order = {"wind", "base_ambience"},
        curve_type = "cosine",
        from = {control = 0.35, volume_percentage = 0.0},
        to = {control = 2, volume_percentage = 100.0}
      },
      semi_persistent =
      {
        {
          sound = {variations = sound_variations("__space-age__/sound/world/semi-persistent/distant-rumble", 3, 0.5)},
          delay_mean_seconds = 10,
          delay_variance_seconds = 5
        },
        {
          sound = {variations = sound_variations("__space-age__/sound/world/semi-persistent/distant-flames", 5, 0.6)},
          delay_mean_seconds = 15,
          delay_variance_seconds = 7.0
        }
      }
    },
    lightning_properties =
    {
      lightnings_per_chunk_per_tick = 1 / (60 * 10), --cca once per chunk every 10 seconds (600 ticks)
      search_radius = 10.0,
      lightning_types = {"lightning"},
      priority_rules =
      {
        {
          type = "id",
          string = "lightning-collector",
          priority_bonus = 10000
        },
        {
          type = "prototype",
          string = "lightning-attractor",
          priority_bonus = 1000
        },
        {
          type = "id",
          string = "fulgoran-ruin-vault",
          priority_bonus = 95
        },
        {
          type = "id",
          string = "fulgoran-ruin-colossal",
          priority_bonus = 94
        },
        {
          type = "id",
          string = "fulgoran-ruin-huge",
          priority_bonus = 93
        },
        {
          type = "id",
          string = "fulgoran-ruin-big",
          priority_bonus = 92
        },
        {
          type = "id",
          string = "fulgoran-ruin-medium",
          priority_bonus = 91
        },
        {
          type = "prototype",
          string = "pipe",
          priority_bonus = 1
        },
        {
          type = "prototype",
          string = "pump",
          priority_bonus = 1
        },
        {
          type = "prototype",
          string = "offshore-pump",
          priority_bonus = 1
        },
        {
          type = "prototype",
          string = "electric-pole",
          priority_bonus = 10
        },
        {
          type = "prototype",
          string = "power-switch",
          priority_bonus = 10
        },
        {
          type = "prototype",
          string = "logistic-robot",
          priority_bonus = 100
        },
        {
          type = "prototype",
          string = "construction-robot",
          priority_bonus = 100
        },
        {
          type = "impact-soundset",
          string = "metal",
          priority_bonus = 1
        }
      },
      exemption_rules =
      {
        {
          type = "prototype",
          string = "rail-support",
        },
        {
          type = "prototype",
          string = "legacy-straight-rail",
        },
        {
          type = "prototype",
          string = "legacy-curved-rail",
        },
        {
          type = "prototype",
          string = "straight-rail",
        },
        {
          type = "prototype",
          string = "curved-rail-a",
        },
        {
          type = "prototype",
          string = "curved-rail-b",
        },
        {
          type = "prototype",
          string = "half-diagonal-rail",
        },
        {
          type = "prototype",
          string = "rail-ramp",
        },
        {
          type = "prototype",
          string = "elevated-straight-rail",
        },
        {
          type = "prototype",
          string = "elevated-curved-rail-a",
        },
        {
          type = "prototype",
          string = "elevated-curved-rail-b",
        },
        {
          type = "prototype",
          string = "elevated-half-diagonal-rail",
        },
        {
          type = "prototype",
          string = "rail-signal",
        },
        {
          type = "prototype",
          string = "rail-chain-signal",
        },
        {
          type = "prototype",
          string = "locomotive",
        },
        {
          type = "prototype",
          string = "artillery-wagon",
        },
        {
          type = "prototype",
          string = "cargo-wagon",
        },
        {
          type = "prototype",
          string = "fluid-wagon",
        },
        {
          type = "prototype",
          string = "land-mine",
        },
        {
          type = "prototype",
          string = "wall",
        },
        {
          type = "prototype",
          string = "tree",
        },
        {
          type = "countAsRockForFilteredDeconstruction",
          string = "true",
        },
      }
    }
}

tchekor.orbit = {
    parent = {
        type = "space-location",
        name = "star",
    },
    distance = 12,
    orientation = 0.26
}

local tchekor_connection = {
    type = "space-connection",
    name = "nauvis-tchekor",
    from = "nauvis",
    to = "tchekor",
    subgroup = data.raw["space-connection"]["nauvis-vulcanus"].subgroup,
    length = 15000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus),
  }

PlanetsLib.borrow_music(data.raw["planet"]["vulcanus"], tchekor)

PlanetsLib:extend({tchekor})


data:extend{tchekor_connection}



data:extend {{
    type = "technology",
    name = "planet-discovery-tchekor",
    icons = util.technology_icon_constant_planet("__planet-tchekor__/graphics/planet-tchekor.png"),
    icon_size = 512,
    essential = true,
    localised_description = {"space-location-description.tchekor"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "tchekor",
            use_icon_overlay_constant = true
        },
        {
            type = "unlock-recipe",
            recipe = "lightning-rod",
        },
        {
            type = "unlock-recipe",
            recipe = "tchekor-scrap-recycling",
        },
    },
    prerequisites = {
        "space-science-pack",
    },
    unit = {
        count = 200,
        ingredients = {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"space-science-pack",           1}
        },
        time = 60,
    },
    order = "ea[tchekor]",
}}


APS.add_planet{name = "tchekor", filename = "__planet-tchekor__/tchekor.lua", technology = "planet-discovery-tchekor"}