iterative_probabilistic_improvement(cost::Function,
                                    args::Dict{ASCIIString, Any},
                                    initial_x::Configuration,
                                    initial_cost::Float64;
                                    t::Float64       = 2.0,
                                    evaluations::Int = 3,
                                    iterations::Int  = 100_000) = begin
    x         = deepcopy(initial_x)
    name      = "Iterative Probabilistic Improvement"
    f_calls   = 0
    iteration = 0
    f_xs      = Float64[]
    for i = 1:evaluations
        push!(f_xs, 0.0)
    end
    f_x      = initial_cost
    f_calls += evaluations
    while iteration <= iterations
        iteration += 1
        result     = probabilistic_improvement(cost, args, x, f_x,
                                               evaluations, f_xs, t)
        f_calls                 += result.cost_calls
        result.cost_calls        = f_calls
        result.start             = initial_x
        result.technique         = name
        result.iterations        = iteration
        result.current_iteration = iteration
        update!(x, result.minimum.parameters)
        produce(result)
    end
end
