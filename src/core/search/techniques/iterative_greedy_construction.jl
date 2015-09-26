function iterative_greedy_construction(parameters::Dict{Symbol, Any})
    if !haskey(parameters, :cutoff)
        parameters[:cutoff] = 10
    end
    initial_x  = parameters[:initial_config]
    cost_calls = parameters[:evaluations]
    iterations = parameters[:iterations]
    x          = deepcopy(initial_x)
    name       = "Iterative Greedy Construction"
    iteration  = 0
    key_set    = collect(keys(x.parameters))
    while iteration <= iterations
        iteration += 1
        for key in key_set
            parameters[:target]       = key
            result                    = greedy_construction(parameters)
            cost_calls               += result.cost_calls
            result.cost_calls         = cost_calls
            result.start              = initial_x
            result.technique          = name
            result.iterations         = iteration
            result.current_iteration  = iteration
            update!(x, result.minimum.parameters)
            produce(result)
        end
        shuffle!(key_set)
    end
end
