function iterative_probabilistic_improvement(parameters::Dict{Symbol, Any},
                                             reference::RemoteRef)
    if !haskey(parameters, :t)
        parameters[:t] = 2.0
    end
    initial_x  = parameters[:initial_config]
    cost_calls = parameters[:evaluations]
    iterations = parameters[:iterations]
    x          = deepcopy(initial_x)
    name       = "Iterative Probabilistic Improvement"
    iteration  = 0

    criterion_function = parameters[:stopping_criterion]
    if criterion_function == iterations_criterion
        duration = parameters[:iterations]
    elseif criterion_function == elapsed_time_criterion
        duration = parameters[:seconds]
    end

    stopping_criterion = @task criterion_function(duration)
    stop               = !consume(stopping_criterion)

    while !stop
        iteration                += 1
        result                    = probabilistic_improvement(parameters)
        cost_calls               += result.cost_calls
        result.cost_calls         = cost_calls
        result.start              = initial_x
        result.technique          = name
        result.iterations         = iteration
        result.current_iteration  = iteration
        update!(x, result.minimum.parameters)
        stop                      = !consume(stopping_criterion)
        put!(reference, result)
    end
end
