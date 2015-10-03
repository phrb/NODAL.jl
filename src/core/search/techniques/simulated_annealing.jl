log_temperature(t::Real) = 1 / log(t)

function simulated_annealing(parameters::Dict{Symbol, Any},
                             reference::RemoteRef)
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
        parameters[:t]            = temperature(iteration)
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
