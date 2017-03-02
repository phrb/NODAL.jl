function simulated_annealing(tuning_run::Run,
                             channel::RemoteChannel;
                             temperature::Function = log_temperature)
    name       = "Simulated Annealing"
    iteration  = 1
    cost_calls = tuning_run.cost_evaluations
    stop       = RemoteChannel(()->Channel{Bool}(1))

    @spawn tuning_run.stopping_criterion(tuning_run.duration, stop)

    while !take!(stop)
        iteration                 += 1
        p                          = temperature(iteration)
        result                     = probabilistic_improvement(tuning_run, threshold = p)
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

    close(stop)
end
