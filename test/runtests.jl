using StochasticSearch
using FactCheck

include("parameter.jl")
include("configuration.jl")
include("optim_interface.jl")
include("simulated_annealing.jl")
include("iterative_first_improvement.jl")
include("unit_value.jl")

FactCheck.exitstatus()
