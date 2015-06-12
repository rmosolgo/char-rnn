local Generator = require "util.Generator2"

ngx.say("<pre>" .. Generator.generate(400) .. "</pre>")