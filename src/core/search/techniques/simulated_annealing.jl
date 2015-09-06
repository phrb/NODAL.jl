log_temperature(t::Real) = 1 / log(t)

simulated_annealing(cost::Function,
                    args::Dict{ASCIIString, Any},
                    initial_x::Configuration,
                    initial_cost::Float64;
                    temperature::Function = log_temperature,
                    evaluations::Int      = 3,
                    iterations::Int       = 100_000) = begin
    x          = deepcopy(initial_x)
    x_proposal = deepcopy(initial_x)
    name       = "Simulated Annealing"
    f_calls    = 0
    iteration  = 0
    f_xs       = Float64[]
    for i = 1:evaluations
        push!(f_xs, 0.0)
    end
    f_x      = initial_cost
    f_calls += evaluations
    best_x   = deepcopy(x)
    best_f_x = f_x
    while iteration <= iterations
        iteration += 1
        t          = temperature(iteration)
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
