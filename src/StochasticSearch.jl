module StochasticSearch

export Parameter, NumberParameter, IntegerParameter, FloatParameter,
       EnumParameter, StringParameter

export Configuration

export perturbate!, perturbate_elements!

include("util.jl")
include("parameters.jl")
include("configuration.jl")

end
