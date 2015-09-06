random_walk(cost::Function,
            args::Dict{ASCIIString, Any},
            initial_x::Configuration,
            evaluations::Int,
            f_xs::Array{Float64}) = begin
    x          = deepcopy(initial_x)
    name       = "Random Walk"
    f_calls    = 0
    neighbor!(x)
    f_x = @fetch (measure_mean!(cost, x, args,
                                evaluations, f_xs))
    f_calls += evaluations
    return Result(name, initial_x, x, f_x, 1,
                  1, f_calls, false)
end
