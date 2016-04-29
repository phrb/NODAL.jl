log_temperature(t::Real) = 1 / log(t)

function iterated_local_search(tuning_run::Run,
                               reference::RemoteRef;
                               acceptance_criterion::Function = metropolis,
                               temperature::Function          = log_temperature,
                               subsidiary_iterations::Int     = 30,
                               threshold::AbstractFloat       = 2.)
    name               = "Iterated Local Search"
    iteration          = 1
    cost_calls         = tuning_run.cost_evaluations
    stopping_criterion = @task tuning_run.stopping_criterion(tuning_run.duration)
    stop               = consume(stopping_criterion)

    subsidiary_tuning_run                    = deepcopy(tuning_run)
    subsidiary_tuning_run.stopping_criterion = iterations_criterion
    subsidiary_tuning_run.duration           = subsidiary_iterations

    result = probabilistic_improvement(subsidiary_tuning_run,
                                       threshold = threshold)

    while !stop
        iteration += 1

        for i = 1:subsidiary_tuning_run.duration
            p                         = temperature(iteration)
            result                    = probabilistic_improvement(subsidiary_tuning_run,
                                                                  threshold = p)
            cost_calls               += result.cost_calls
            result.cost_calls         = cost_calls
            result.start              = subsidiary_tuning_run.starting_point
            result.technique          = name
            result.iterations         = iteration
            result.current_iteration  = iteration

            subsidiary_tuning_run.starting_point = result.minimum
            subsidiary_tuning_run.starting_cost  = result.cost_minimum

            put!(reference, result)
        end

        result = probabilistic_improvement(subsidiary_tuning_run,
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
