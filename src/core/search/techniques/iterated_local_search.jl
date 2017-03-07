function iterated_local_search(tuning_run::Run,
                               channel::RemoteChannel;
                               acceptance_criterion::Function = metropolis,
                               temperature::Function          = log_temperature,
                               subsidiary_iterations::Int     = 30,
                               threshold::AbstractFloat       = 2.)
    iteration  = 1

    function iterate(tuning_run::Run)
        for i = 1:subsidiary_iterations
            p      = temperature(i)
            result = probabilistic_improvement(tuning_run,
                                               threshold = p)
        end

        p          = temperature(i)
        iteration += 1
        return probabilistic_improvement(tuning_run,
                                         threshold = p)
    end

    technique(tuning_run,
              channel,
              iterate,
              name = "Iterated Local Search")
end
