using StochasticSearch
using FactCheck

include("parameter.jl")
include("configuration.jl")
include("simulated_annealing.jl")
include("iterative_first_improvement.jl")
include("iterative_greedy_construction.jl")
include("optim_interface.jl")
include("unit_value.jl")

FactCheck.exitstatus()
