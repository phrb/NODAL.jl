module StochasticSearch
    using Optim
    # Types
    export Parameter, NumberParameter, IntegerParameter,
           FloatParameter, EnumParameter, StringParameter,
           Configuration, Result, BoolParameter

    # Methods
    export perturb!, perturb_elements!, neighbor!,
           optimize!, update!, search, unit_value,
           unit_value!

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
    include("core/unit_value.jl")

    # Search
    include("core/search/search.jl")
    include("core/search/techniques/simulated_annealing.jl")

    # Optim.jl Interface
    include("optim/optimize!.jl")

    # Utilities;
    include("util/random.jl")
    include("util/show.jl")
    include("util/chooseproc.jl")
end
