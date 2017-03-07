function technique(tuning_run::Run,
                   channel::RemoteChannel,
                   iterate::Function;
                   name = "Technique Base")
    iteration  = 1
    cost_calls = tuning_run.cost_evaluations

    stop       = RemoteChannel(()->Channel{Bool}(1))
    report     = RemoteChannel(()->Channel{Bool}(1))

    @spawn tuning_run.stopping_criterion(tuning_run.duration, stop)
    @spawn tuning_run.reporting_criterion(tuning_run.report_after / 2, report)

    while !take!(stop)
        result                     = iterate(tuning_run)
        iteration                 += 1

        cost_calls                += result.cost_calls
        result.cost_calls          = cost_calls
        result.start               = tuning_run.starting_point
        result.technique           = name
        result.iterations          = iteration
        result.current_iteration   = iteration

        tuning_run.starting_point  = result.minimum
        tuning_run.starting_cost   = result.cost_minimum

        if take!(report)
            put!(channel, result)
        end
    end

    close(stop)
end
