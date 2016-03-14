function iterative_first_improvement(tuning_run::Run,
                                     reference::RemoteRef;
                                     cutoff::Integer = 10_000)
    name               = "Iterative First Improvement"
    iteration          = 1
    cost_calls         = tuning_run.cost_evaluations
    stopping_criterion = @task tuning_run.stopping_criterion(tuning_run.duration)
    stop               = !consume(stopping_criterion)

    while !stop
        iteration                 += 1
        result                     = first_improvement(tuning_run, cutoff = cutoff)
        cost_calls                += result.cost_calls
        result.cost_calls          = cost_calls
        result.start               = tuning_run.starting_point
        result.technique           = name
        result.iterations          = iteration
        result.current_iteration   = iteration
        tuning_run.starting_point  = result.minimum
        tuning_run.starting_cost   = result.cost_minimum
        stop                       = !consume(stopping_criterion)
        put!(reference, result)
    end
end
