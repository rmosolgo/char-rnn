local Generator = require "util.Generator2"

local seed = tonumber(ngx.var["arg_seed"])

if not seed then
  seed = math.floor(math.random() * os.time())
end


Generator.start("./scripts/snapshot_1", seed)
local card = Generator.card(0.6)

card = card:gsub("}$",', "seed" : ' .. seed .. "}")

ngx.say(card)