function iterative_greedy_construction(tuning_run::Run,
                                       reference::RemoteRef;
                                       cutoff::Integer = 10_000)
    initial_x          = tuning_run.starting_point
    key_set            = collect(keys(initial_x.parameters))
    name               = "Iterative Greedy Construction"
    iteration          = 1
    cost_calls         = tuning_run.cost_evaluations
    stopping_criterion = @task tuning_run.stopping_criterion(tuning_run.duration)
    stop               = !consume(stopping_criterion)

    while !stop
        iteration += 1
        for key in key_set
            result                     = greedy_construction(tuning_run,
                                                             key,
                                                             cutoff = cutoff)
            cost_calls                += result.cost_calls
            result.cost_calls          = cost_calls
            result.start               = initial_x
            result.technique           = name
            result.iterations          = iteration
            result.current_iteration   = iteration
            tuning_run.starting_point  = result.minimum
            tuning_run.starting_cost   = result.cost_minimum
            put!(reference, result)
        end
        stop = !consume(stopping_criterion)
        shuffle!(key_set)
    end
end
