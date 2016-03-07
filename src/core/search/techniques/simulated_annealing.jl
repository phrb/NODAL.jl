log_temperature(t::Real) = 1 / log(t)

function simulated_annealing(tuning_run::Run,
                             reference::RemoteRef;
                             temperature::Function = log_temperature)
    initial_x          = tuning_run.starting_point
    name               = "Simulated Annealing"
    iteration          = 1
    cost_calls         = tuning_run.cost_evaluations
    stopping_criterion = @task tuning_run.stopping_criterion(tuning_run.duration)
    stop               = !consume(stopping_criterion)

    while !stop
        iteration                 += 1
        p                          = temperature(iteration)
        result                     = probabilistic_improvement(tuning_run, threshold = p)
        cost_calls                += result.cost_calls
        result.cost_calls          = cost_calls
        result.start               = initial_x
        result.technique           = name
        result.iterations          = iteration
        result.current_iteration   = iteration
        tuning_run.starting_point  = result.minimum
        tuning_run.starting_cost    = result.cost_minimum
        stop                       = !consume(stopping_criterion)
        put!(reference, result)
    end
end
