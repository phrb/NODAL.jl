function iterative_first_improvement(tuning_run::Run,
                                     reference::RemoteChannel;
                                     cutoff::Integer = 10_000)
    name       = "Iterative First Improvement"
    iteration  = 1
    cost_calls = tuning_run.cost_evaluations
    stop       = RemoteChannel(()->Channel{Bool}(1))

    @spawn tuning_run.stopping_criterion(tuning_run.duration, stop)

    while !take!(stop)
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
        put!(reference, result)
    end

    close(stop)
end
