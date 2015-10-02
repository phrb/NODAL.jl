function randomized_first_improvement(parameters::Dict{Symbol, Any},
                                      reference::RemoteRef)
    if !haskey(parameters, :cutoff)
        parameters[:cutoff] = 10
    end
    if !haskey(parameters, :walk)
        parameters[:walk] = 0.6
    end
    initial_x  = parameters[:initial_config]
    cost_calls = parameters[:evaluations]
    iterations = parameters[:iterations]
    walk       = parameters[:walk]
    name       = "Randomized First Improvement"
    iteration  = 0
    while true
        iteration += 1
        if rand() <= walk
            result = random_walk(parameters)
        else
            result = first_improvement(parameters)
        end
        cost_calls              += result.cost_calls
        result.cost_calls        = cost_calls
        result.start             = initial_x
        result.technique         = name
        result.iterations        = iteration
        result.current_iteration = iteration
        put!(reference, result)
    end
end
