function randomized_first_improvement(tuning_run::Run,
                                      reference::RemoteRef;
                                      cutoff::Integer          = 10_000,
                                      threshold::AbstractFloat = 0.6)
    cost_calls         = tuning_run.cost_evaluations
    name               = "Randomized First Improvement"
    iteration          = 1
    stopping_criterion = @task tuning_run.stopping_criterion(tuning_run.duration)
    stop               = !consume(stopping_criterion)

    while !stop
        iteration += 1
        if rand() <= threshold
            result = random_walk(tuning_run)
        else
            result = first_improvement(tuning_run, cutoff = cutoff)
        end
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
