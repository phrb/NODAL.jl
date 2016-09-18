function iterative_probabilistic_improvement(tuning_run::Run,
                                             reference::RemoteChannel;
                                             threshold::AbstractFloat = 2.)
    cost_calls         = tuning_run.cost_evaluations
    iteration          = 1
    name               = "Iterative Probabilistic Improvement"
    stopping_criterion = @task tuning_run.stopping_criterion(tuning_run.duration)
    stop               = consume(stopping_criterion)

    while !stop
        iteration                 += 1
        result                     = probabilistic_improvement(tuning_run,
                                                               threshold = threshold)
        cost_calls                += result.cost_calls
        result.cost_calls          = cost_calls
        result.start               = tuning_run.starting_point
        result.technique           = name
        result.iterations          = iteration
        result.current_iteration   = iteration
        tuning_run.starting_point  = result.minimum
        tuning_run.starting_cost   = result.cost_minimum
        stop                       = consume(stopping_criterion)
        put!(reference, result)
    end
end
