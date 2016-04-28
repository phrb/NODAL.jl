function iterated_local_search(tuning_run::Run,
                               reference::RemoteRef;
                               acceptance_criterion::Function = metropolis,
                               subsidiary_search::Function    = simulated_annealing,
                               subsidiary_iterations::Int     = 400,
                               threshold::AbstractFloat       = 3.)
    name               = "Iterated Local Search"
    iteration          = 1
    cost_calls         = tuning_run.cost_evaluations
    stopping_criterion = @task tuning_run.stopping_criterion(tuning_run.duration)
    stop               = consume(stopping_criterion)

    subsidiary_tuning_run                    = deepcopy(tuning_run)
    subsidiary_tuning_run.stopping_criterion = iterations_criterion
    subsidiary_tuning_run.duration           = 500

    while !stop
        iteration                += 1
        subsidiary_initial_result = Result("Iterated Local Search",
                                           subsidiary_tuning_run.starting_point,
                                           subsidiary_tuning_run.starting_point,
                                           subsidiary_tuning_run.starting_cost,
                                           1, 1, 1, false)
        channel = RemoteRef(() -> ResultChannel(subsidiary_initial_result), myid())

        subsidiary_search(subsidiary_tuning_run, channel)

        result                                = take!(channel)
        cost_calls                           += result.cost_calls
        result.cost_calls                     = cost_calls
        result.start                          = subsidiary_tuning_run.starting_point
        result.technique                      = name
        result.iterations                     = iteration
        result.current_iteration              = iteration
        subsidiary_tuning_run.starting_point  = result.minimum
        subsidiary_tuning_run.starting_cost   = result.cost_minimum
        put!(reference, result)

        result                     = probabilistic_improvement(subsidiary_tuning_run,
                                                               threshold = threshold)

        cost_calls                           += result.cost_calls
        result.cost_calls                     = cost_calls
        result.start                          = subsidiary_tuning_run.starting_point
        result.technique                      = name
        result.iterations                     = iteration
        result.current_iteration              = iteration

        subsidiary_tuning_run.starting_point  = result.minimum
        subsidiary_tuning_run.starting_cost   = result.cost_minimum
        stop                                  = consume(stopping_criterion)
        put!(reference, result)
    end
end
