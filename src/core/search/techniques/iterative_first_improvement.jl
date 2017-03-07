function iterative_first_improvement(tuning_run::Run,
                                     channel::RemoteChannel;
                                     cutoff::Integer = 10_000)
    function iterate(tuning_run::Run)
        return first_improvement(tuning_run, cutoff = cutoff)
    end

    technique(tuning_run,
              channel,
              iterate,
              name = "Iterative First Improvement")
end
