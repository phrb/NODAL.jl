using StochasticSearch
using FactCheck

include("parameter.jl")
include("configuration.jl")
include("run.jl")
include("simulated_annealing.jl")
include("iterative_first_improvement.jl")
include("iterative_probabilistic_improvement.jl")
include("randomized_first_improvement.jl")
include("iterative_greedy_construction.jl")
include("unit_value.jl")

FactCheck.exitstatus()
