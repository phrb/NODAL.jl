optimize(f::Function,
        initial_x::Configuration;
        method::Symbol = :simulated_annealing,
        iterations::Integer = 1_000) = begin
    if method == :simulated_annealing
        result = simulated_annealing(f,
                        convert(Array{Parameter}, initial_x),
                        iterations = iterations)
        update!(initial_x, result)
        result
    else
        throw(ArgumentError("Unimplemented interface to Optim.jl method: $method"))
    end
end
