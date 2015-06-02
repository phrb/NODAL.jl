module StochasticSearch
    using Optim
    # Types
    export Parameter, NumberParameter, IntegerParameter, 
           FloatParameter, EnumParameter, StringParameter,
           Configuration
    # Methods
    export perturb!, perturb_elements!, neighbor!
    # Types
    include("parameters.jl")
    include("configuration.jl")
    # Methods
    include("perturb!.jl")
    include("perturb_elements!.jl")
    include("update!.jl")
    include("neighbor!.jl")
    # Random values;
    # accessors.
    include("util/random.jl")
    include("util/accessing.jl")
end
