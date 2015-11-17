abstract AbstractResult

type Result{T <: Configuration, R <: Number} <: AbstractResult
    technique::ASCIIString
    start::T
    minimum::T
    cost_minimum::R
    iterations::Int
    current_iteration::Int
    cost_calls::Int
    is_final::Bool
    current_time::Float64

    function call{T <: Configuration, R <: Number}(::Type{Result},
                                                   technique::ASCIIString,
                                                   start::T,
                                                   minimum::T,
                                                   cost_minimum::R,
                                                   iterations::Int,
                                                   current_iteration::Int,
                                                   cost_calls::Int, is_final::Bool)
        new{T, R}(technique, start, minimum, cost_minimum,
                  iterations, current_iteration, cost_calls, is_final)
    end
end
