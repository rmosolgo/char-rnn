local Generator = require "util.Generator2"

Generator.start("../cv/lm_lstm_epoch11.16_0.4257.t7", 1234)
ngx.say("<pre>" .. Generator.generate(400) .. "</pre>")