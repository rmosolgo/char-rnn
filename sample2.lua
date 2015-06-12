local Generator = require "util.Generator2"
Generator.start("./cv/lm_lstm_epoch3.51_0.4215.t7", 1234)

io.write(Generator.generate(6000, 0.6))
io.write('\n') io.flush()

