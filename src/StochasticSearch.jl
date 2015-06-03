module StochasticSearch
    using Optim
    # Types
    export Parameter, NumberParameter, IntegerParameter,
           FloatParameter, EnumParameter, StringParameter,
           Configuration

    # Methods
    export perturb!, perturb_elements!, neighbor!,
           optimize!, update!

    # New Methods for Base Functions
    import Base.convert

    # Types
    include("parameters.jl")
    include("configuration.jl")

    # Methods
    include("perturb!.jl")
    include("perturb_elements!.jl")
    include("update!.jl")
    include("neighbor!.jl")

    # Optim.jl Interface
    include("optim/optimize!.jl")

    # Utilities;
    include("util/random.jl")
end
