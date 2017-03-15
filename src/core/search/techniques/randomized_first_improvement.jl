function randomized_first_improvement(tuning_run::Run,
                                      channel::RemoteChannel;
                                      cutoff::Integer          = 10_000,
                                      threshold::AbstractFloat = 0.6)
    function iterate(tuning_run::Run)
        if rand() <= threshold
            return random_walk(tuning_run)
        else
            return first_improvement(tuning_run, cutoff = cutoff)
        end
    end

    technique(tuning_run,
              channel,
              iterate,
              name = "Randomized First Improvement")
end
