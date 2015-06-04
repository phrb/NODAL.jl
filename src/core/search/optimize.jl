optimize(f::Function,
         initial_x::Configuration;
         method::Symbol      = :simulated_annealing,
         iterations::Integer = 1_000) = begin
    if method == :simulated_annealing
        return simulated_annealing(f,
                                   initial_x,
                                   iterations = iterations)
    else
        throw(ArgumentError("Unknown method $method"))
    end
end
