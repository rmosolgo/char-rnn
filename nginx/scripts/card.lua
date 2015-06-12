local Generator = require "util.Generator2"

local seed = tonumber(ngx.var["arg_seed"])
Generator.start("./scripts/snapshot", seed)
local card = Generator.card(0.6)


ngx.say(card)