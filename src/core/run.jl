type Run
    cost::Function
    cost_arguments::Dict{Symbol, Any}
    cost_evaluations::Int
    starting_point::Configuration
    starting_cost::AbstractFloat
    report_after::Int
    measurement_method::Function
    stopping_criterion::Function
    duration_seconds::Int
    duration_iterations::Int
    methods::Array{Any, 2}
    channel_size::Int

    function call(::Type{Run};
                  cost::Function                    = (c(x) = 0),
                  cost_arguments::Dict{Symbol, Any} = Dict{Symbol, Any}(),
                  cost_evaluations::Int             = 1,
                  starting_point::Configuration     = Configuration("empty"),
                  starting_cost::Int                = 0,
                  report_after::Int                 = 333,
                  measurement_method::Function      = measure_mean!,
                  stopping_criterion::Function      = iterations_criterion,
                  duration_seconds::Int             = 0,
                  duration_iterations::Int          = 1_000,
                  methods::Array{Any, 2}            = [[:simulated_annealing 2];],
                  channel_size::Int                 = 4096)
        new(cost,
            cost_arguments,
            cost_evaluations,
            starting_point,
            starting_cost,
            report_after,
            measurement_method,
            stopping_criterion,
            duration_seconds,
            duration_iterations,
            methods,
            channel_size)
    end
end
