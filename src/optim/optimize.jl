optimize!(f::Function,
        initial_x::Configuration;
        method::Symbol = :simulated_annealing,
        iterations::Integer = 1_000) = begin
    if method == :simulated_annealing
        result = simulated_annealing(f,
                        convert(Array{Parameter}, initial_x),
                        iterations = iterations)
        update!(initial_x, result.minimum)
        result
    else
        throw(ArgumentError("Unimplemented interface to Optim.jl method: $method"))
    end
end

abstract OptimizationResults

type MultivariateOptimizationResults{T,N} <: OptimizationResults
    method::ASCIIString
    initial_x::Array{T,N}
    minimum::Array{T,N}
    f_minimum::Float64
    iterations::Int
    f_calls::Int
end
