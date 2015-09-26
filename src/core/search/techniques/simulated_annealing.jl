log_temperature(t::Real) = 1 / log(t)

function simulated_annealing(parameters::Dict{Symbol, Any})
    if !haskey(parameters, :temperature)
        parameters[:temperature] = log_temperature
    end
    initial_x   = parameters[:initial_config]
    x           = deepcopy(initial_x)
    x_proposal  = deepcopy(initial_x)
    name        = "Simulated Annealing"
    iteration   = 0
    cost_calls  = parameters[:evaluations]
    iterations  = parameters[:iterations]
    temperature = parameters[:temperature]
    while iteration <= iterations
        iteration                += 1
        parameters[:t]            = temperature(iteration)
        result                    = probabilistic_improvement(parameters)
        cost_calls               += result.cost_calls
        result.cost_calls         = cost_calls
        result.start              = initial_x
        result.technique          = name
        result.iterations         = iteration
        result.current_iteration  = iteration
        update!(x, result.minimum.parameters)
        produce(result)
    end
end
