require 'torch'
require 'nn'
require 'nngraph'
require 'util.OneHot'

torch.manualSeed(1223)

local model = "../cv/lm_lstm_epoch11.16_0.4257.t7"

local checkpoint = torch.load(model)
local protos = checkpoint.protos

-- initialize the vocabulary (and its inverted version)
local vocab = checkpoint.vocab
local ivocab = {}
for c,i in pairs(vocab) do ivocab[i] = c end

-- initialize the rnn state
local current_state = {}


for L=1,checkpoint.opt.num_layers do
    -- c and h for all layers
    local h_init = torch.zeros(1, checkpoint.opt.rnn_size)
    table.insert(current_state, h_init:clone())
    table.insert(current_state, h_init:clone())
end

local state_size = #current_state
local seed_text = "----------\n"
local prediction

protos.rnn:evaluate() -- put in eval mode so that dropout works properly
-- do a few seeded timesteps
for c in seed_text:gmatch'.' do
    prev_char = torch.Tensor{vocab[c]}
    local lst = protos.rnn:forward{prev_char, unpack(current_state)}
    -- lst is a list of [state1,state2,..stateN,output]. We want everything but last piece
    current_state = {}
    for i=1,state_size do table.insert(current_state, lst[i]) end
    prediction = lst[#lst] -- last element holds the log probabilities
end

local Generator = {}

function Generator.generate(size)
    local novel_content = ""
    for i=1, size do
        -- use sampling
        prediction:div(0.6) -- scale by temperature
        local probs = torch.exp(prediction):squeeze()
        probs:div(torch.sum(probs)) -- renormalize so probs sum to one
        ngx.log(ngx.ERR, tostring(probs:float()))
        prev_char = torch.multinomial(probs:float(), 1):resize(1):float()

        -- forward the rnn for next character
        local lst = protos.rnn:forward{prev_char, unpack(current_state)}
        current_state = {}
        for i=1,state_size do table.insert(current_state, lst[i]) end
        prediction = lst[#lst] -- last element holds the log probabilities

        novel_content = novel_content .. ivocab[prev_char[1]]
    end
    return novel_content
end

return Generator
