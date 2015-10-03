function iterative_greedy_construction(parameters::Dict{Symbol, Any},
                                       reference::RemoteRef)
    if !haskey(parameters, :cutoff)
        parameters[:cutoff] = 1000
    end
    initial_x  = parameters[:initial_config]
    cost_calls = parameters[:evaluations]
    iterations = parameters[:iterations]
    x          = deepcopy(initial_x)
    name       = "Iterative Greedy Construction"
    iteration  = 0
    key_set    = collect(keys(x.parameters))

    criterion_function = parameters[:stopping_criterion]
    if criterion_function == iterations_criterion
        duration = parameters[:iterations]
    elseif criterion_function == elapsed_time_criterion
        duration = parameters[:seconds]
    end

    stopping_criterion = @task criterion_function(duration)
    stop               = !consume(stopping_criterion)

    while !stop
        iteration += 1
        for key in key_set
            parameters[:target]          = key
            result                       = greedy_construction(parameters)
            cost_calls                  += result.cost_calls
            result.cost_calls            = cost_calls
            result.start                 = initial_x
            result.technique             = name
            result.iterations            = iteration
            result.current_iteration     = iteration
            parameters[:initial_config]  = result.minimum
            parameters[:initial_cost]    = result.cost_minimum
            update!(x, result.minimum.parameters)
            put!(reference, result)
        end
        stop = !consume(stopping_criterion)
        shuffle!(key_set)
    end
end
