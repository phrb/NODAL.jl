function iterative_probabilistic_improvement(parameters::Dict{Symbol, Any})
    if !haskey(parameters, :t)
        parameters[:t] = 2.0
    end
    initial_x  = parameters[:initial_config]
    cost_calls = parameters[:evaluations]
    iterations = parameters[:iterations]
    x          = deepcopy(initial_x)
    name       = "Iterative Probabilistic Improvement"
    iteration  = 0
    while iteration <= iterations
        iteration                += 1
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
