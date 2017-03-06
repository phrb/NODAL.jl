function simulated_annealing(tuning_run::Run,
                             channel::RemoteChannel;
                             temperature::Function = log_temperature)
    name      = "Simulated Annealing"
    iteration = 1

    function iterate(tuning_run::Run)
        p          = temperature(iteration)
        iteration += 1
        return probabilistic_improvement(tuning_run, threshold = p)
    end

    technique(tuning_run,
              channel,
              iterate,
              name = name)
end
