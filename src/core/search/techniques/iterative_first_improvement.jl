function iterative_first_improvement(parameters::Dict{Symbol, Any})
    if !haskey(parameters, :cutoff)
        parameters[:cutoff] = 10
    end
    initial_x  = parameters[:initial_config]
    cost_calls = parameters[:evaluations]
    iterations = parameters[:iterations]
    name       = "Iterative First Improvement"
    iteration  = 0
    while iteration <= iterations
        iteration                += 1
        result                    = first_improvement(parameters)
        cost_calls               += result.cost_calls
        result.cost_calls         = cost_calls
        result.start              = initial_x
        result.technique          = name
        result.iterations         = iteration
        result.current_iteration  = iteration
        produce(result)
    end
end
