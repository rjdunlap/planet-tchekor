-- Tech-tree changes that only apply when this planet is the start planet.
-- Any Planet Start loads this file (see APS.add_planet in data.lua) only in that case.
local utils = require("__any-planet-start__.utils")

utils.set_prerequisites("recycling", nil)
utils.set_prerequisites("tungsten-carbide", nil)
utils.set_prerequisites("calcite-processing", nil)
utils.set_trigger("tungsten-carbide", {type = "mine-entity", entities = {"big-volcanic-rock"}})
utils.set_prerequisites("foundry", {"tungsten-carbide","concrete", "lubricant"})

-- Tchekor has oil oceans but no crude-oil patches, so the vanilla "mine crude oil" trigger could never be met
-- (players could not reach chemical plants / blue science when starting here).
utils.set_trigger("oil-processing", {type = "build-entity", entity = "offshore-pump"})
