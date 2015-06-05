abstract AbstractResult

type Result{T <: Configuration, R <: Number} <: AbstractResult
    technique::ASCIIString
    start::T
    minimum::T
    cost_minimum::R
    iterations::Int
    cost_calls::Int
end

type PartialResult{T <: Configuration, R <: Number} <: AbstractResult
    technique::ASCIIString
    minimum::T
    cost_minimum::R
    iterations::Int
end
