__precompile__()

module NODAL
    using Distributed, Statistics, Random, Printf

    # New Methods for Base Functions
    import Base: convert,
                 show,
                 getindex,
                 setindex!,
                 put!,
                 take!,
                 fetch,
                 isready

    # Types
    include("core/parameters.jl")
    include("core/configuration.jl")
    include("core/run.jl")

    # Methods
    include("core/perturb!.jl")
    include("core/perturb_elements!.jl")
    include("core/update!.jl")
    include("core/neighbor!.jl")
    include("core/unit_value.jl")

    # Measurement
    include("core/measurement/measure.jl")
    include("core/measurement/results.jl")

    # Search Blocks
    include("core/search/blocks/first_improvement.jl")
    include("core/search/blocks/probabilistic_improvement.jl")
    include("core/search/blocks/greedy_construction.jl")
    include("core/search/blocks/random_walk.jl")

    # Techniques
    include("core/search/techniques/technique.jl")
    include("core/search/techniques/iterative_first_improvement.jl")
    include("core/search/techniques/iterative_probabilistic_improvement.jl")
    include("core/search/techniques/randomized_first_improvement.jl")
    include("core/search/techniques/iterative_greedy_construction.jl")
    include("core/search/techniques/simulated_annealing.jl")
    include("core/search/techniques/iterated_local_search.jl")

    # Tools
    include("core/search/tools/initialize_search_tasks!.jl")
    include("core/search/tools/end_search_tasks!.jl")
    include("core/search/tools/get_new_best.jl")
    include("core/search/tools/stopping_criteria.jl")
    include("core/search/tools/reporting_criteria.jl")
    include("core/search/tools/temperatures.jl")

    # Optimize
    include("core/search/optimize.jl")

    # Utilities
    include("util/random.jl")
    include("util/show.jl")
    include("util/resultchannel.jl")

    # Types
    export Parameter,
           NumberParameter,
           IntegerParameter,
           FloatParameter,
           PermutationParameter,
           EnumParameter,
           StringParameter,
           BoolParameter,
           Configuration,
           Result,
           ResultChannel,
           Run

    # Methods
    export perturb!,
           perturb_elements!,
           neighbor!,
           optimize,
           test_names,
           test_A,
           update!,
           unit_value,
           unit_value!

    # Measurement Tools
    export measure_mean!,
           sequential_measure_mean!

    # Search Building Blocks
    export first_improvement,
           probabilistic_improvement,
           greedy_construction,
           random_walk

    # Search Techniques
    export technique,
           simulated_annealing,
           iterative_gredy_construction,
           iterative_first_improvement,
           randomized_first_improvement,
           iterative_probabilistic_improvement,
           iterated_local_search

    # Search Tools
    export initialize_search_tasks!,
           end_search_tasks!,
           get_new_best,
           elapsed_time_criterion,
           iterations_criterion,
           iterations_reporting_criterion,
           elapsed_time_reporting_criterion,
           log_temperature
end
