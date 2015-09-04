module StochasticSearch
    using Optim
    # Types
    export Parameter, NumberParameter, IntegerParameter,
           FloatParameter, EnumParameter, StringParameter,
           Configuration, Result, BoolParameter

    # Methods
    export perturb!, perturb_elements!, neighbor!,
           optimize!, optimize, initialize_cost,
           initialize_search_tasks!, get_new_best,
           measure_mean!, simulated_annealing, update!,
           optimize, unit_value, unit_value!

    # New Methods for Base Functions
    import Base.convert, Base.show, Base.getindex,
           Base.setindex!

    # Types
    include("core/parameters.jl")
    include("core/configuration.jl")

    # Methods
    include("core/perturb!.jl")
    include("core/perturb_elements!.jl")
    include("core/update!.jl")
    include("core/neighbor!.jl")
    include("core/unit_value.jl")

    # Measurement
    include("core/measurement/measure.jl")
    include("core/measurement/results.jl")

    # Search
    include("core/search/techniques/simulated_annealing.jl")
    include("core/search/tools/initialize_cost.jl")
    include("core/search/tools/initialize_search_tasks!.jl")
    include("core/search/tools/get_new_best.jl")
    include("core/search/optimize.jl")

    # Optim.jl Interface
    include("optim/optimize!.jl")

    # Utilities;
    include("util/random.jl")
    include("util/show.jl")
    include("util/chooseproc.jl")
end
