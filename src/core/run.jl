type Run{F <: AbstractFloat, I <: Integer, C <: Configuration}
    cost::Function
    cost_arguments::Dict{Symbol, Any}
    cost_evaluations::I
    cost_values::Array{F, 1}
    starting_point::C
    starting_cost::F
    report_after::I
    measurement_method::Function
    stopping_criterion::Function
    duration::I
    methods::Array{Any, 2}
    channel_size::I

    function call{F <: AbstractFloat, I <: Integer, C <: Configuration}(::Type{Run};
            cost::Function                    = (c(x) = 0),
            cost_arguments::Dict{Symbol, Any} = Dict{Symbol, Any}(),
            cost_evaluations::I               = 1,
            cost_values::Array{F, 1}          = [0.0],
            starting_point::C                 = Configuration("empty"),
            starting_cost::F                  = 0.0,
            report_after::I                   = 333,
            measurement_method::Function      = measure_mean!,
            stopping_criterion::Function      = iterations_criterion,
            duration::I                       = 1_000,
            methods::Array{Any, 2}            = [[:simulated_annealing 2];],
            channel_size::I                   = 4096)

        new{F, I, C}(cost,
                     cost_arguments,
                     cost_evaluations,
                     cost_values,
                     starting_point,
                     starting_cost,
                     report_after,
                     measurement_method,
                     stopping_criterion,
                     duration,
                     methods,
                     channel_size)
    end
end
