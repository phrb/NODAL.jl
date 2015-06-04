module StochasticSearch
    using Optim
    # Types
    export Parameter, NumberParameter, IntegerParameter,
           FloatParameter, EnumParameter, StringParameter,
           Configuration, AbstractResult, Result

    # Methods
    export perturb!, perturb_elements!, neighbor!,
           optimize!, update!

    # New Methods for Base Functions
    import Base.convert, Base.show

    # Types
    include("core/parameters.jl")
    include("core/configuration.jl")
    include("core/results.jl")

    # Methods
    include("core/perturb!.jl")
    include("core/perturb_elements!.jl")
    include("core/update!.jl")
    include("core/neighbor!.jl")

    # Optim.jl Interface
    include("optim/optimize!.jl")

    # Utilities;
    include("util/random.jl")
    include("util/show.jl")
end
