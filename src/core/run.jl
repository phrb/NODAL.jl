mutable struct Run{F <: AbstractFloat, I <: Integer, C <: Configuration}
    cost::Function
    cost_arguments::Dict{Symbol, Any}
    cost_evaluations::I
    cost_values::Array{F, 1}
    starting_point::C
    starting_cost::F
    report_after::I
    reporting_criterion::Function
    measurement_method::Function
    stopping_criterion::Function
    duration::I
    methods::Array{Any, 2}
    channel::RemoteChannel
end

function Run(;cost::Function                    = (c(x) = 0),
              cost_arguments::Dict{Symbol, Any} = Dict{Symbol, Any}(),
              cost_evaluations::I               = 1,
              cost_values::Array{F, 1}          = [0.0],
              starting_point::C                 = Configuration("empty"),
              starting_cost::F                  = 0.0,
              report_after::I                   = 100,
              reporting_criterion::Function     = iterations_reporting_criterion,
              measurement_method::Function      = measure_mean!,
              stopping_criterion::Function      = iterations_criterion,
              duration::I                       = 1_000,
              methods::Array{Any, 2}            = [[:simulated_annealing 2];],
              channel::RemoteChannel            = RemoteChannel(()->Channel{Any}(128))
             ) where {F <: AbstractFloat, I <: Integer, C <: Configuration}

    Run{F, I, C}(cost,
                 cost_arguments,
                 cost_evaluations,
                 cost_values,
                 starting_point,
                 starting_cost,
                 report_after,
                 reporting_criterion,
                 measurement_method,
                 stopping_criterion,
                 duration,
                 methods,
                 channel)
end
