module StochasticSearch

export Parameter, NumberParameter, IntegerParameter, FloatParameter,
       EnumParameter, StringParameter

export Configuration

export perturbate!, perturbate_elements!, discard!

include("util.jl")
include("parameters.jl")
include("configuration.jl")

end
