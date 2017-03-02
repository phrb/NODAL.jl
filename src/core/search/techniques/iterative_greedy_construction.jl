function iterative_greedy_construction(tuning_run::Run,
                                       channel::RemoteChannel;
                                       cutoff::Integer = 10_000)
    key_set    = collect(keys(tuning_run.starting_point.parameters))
    name       = "Iterative Greedy Construction"
    iteration  = 1
    cost_calls = tuning_run.cost_evaluations
    stop       = RemoteChannel(()->Channel{Bool}(1))

    @spawn tuning_run.stopping_criterion(tuning_run.duration, stop)

    while !take!(stop)
        iteration += 1
        for key in key_set
            result                     = greedy_construction(tuning_run,
                                                             key,
                                                             cutoff = cutoff)
            cost_calls                += result.cost_calls
            result.cost_calls          = cost_calls
            result.start               = tuning_run.starting_point
            result.technique           = name
            result.iterations          = iteration
            result.current_iteration   = iteration
            tuning_run.starting_point  = result.minimum
            tuning_run.starting_cost   = result.cost_minimum
            put!(channel, result)
        end
        shuffle!(key_set)
    end

    close(stop)
end
