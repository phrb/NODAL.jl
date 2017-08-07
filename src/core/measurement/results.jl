abstract type AbstractResult end

mutable struct Result{T <: Configuration, R <: Number} <: AbstractResult
    technique::String
    start::T
    minimum::T
    cost_minimum::R
    iterations::Int
    current_iteration::Int
    cost_calls::Int
    is_final::Bool
    current_time::Float64

    function Result{T, R}(technique::String,
                          start::T,
                          minimum::T,
                          cost_minimum::R,
                          iterations::Int,
                          current_iteration::Int,
                          cost_calls::Int,
                          is_final::Bool) where {T <: Configuration, R <: Number}
        new(technique, start, minimum, cost_minimum,
            iterations, current_iteration, cost_calls, is_final)
    end
end

function Result(technique::String,
                start::T,
                minimum::T,
                cost_minimum::R,
                iterations::Int,
                current_iteration::Int,
                cost_calls::Int,
                is_final::Bool) where {T <: Configuration, R <: Number}
    Result{T, R}(technique, start, minimum, cost_minimum,
                 iterations, current_iteration, cost_calls, is_final)
end
