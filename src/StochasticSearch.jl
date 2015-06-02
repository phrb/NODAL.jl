module StochasticSearch

export Parameter, NumberParameter, IntegerParameter, FloatParameter,
       EnumParameter, StringParameter

export Configuration

export perturb!, perturb_elements!

include("util.jl")
include("parameters.jl")
include("configuration.jl")

end
