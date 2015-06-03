using StochasticSearch
using FactCheck

include("parameter.jl")
include("configuration.jl")
include("optim_simulated_annealing.jl")

FactCheck.exitstatus()
