local Generator = require "util.Generator2"
Generator.start("./cv/lm_lstm_epoch11.16_0.4257.t7", 1234)

io.write(Generator.generate(400))
io.write("\n\n" .. Generator.generate(40))
io.write('\n') io.flush()

