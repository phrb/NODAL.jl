function iterative_probabilistic_improvement(tuning_run::Run,
                                             channel::RemoteChannel;
                                             threshold::AbstractFloat = 2.)
    function iterate(tuning_run::Run)
        return probabilistic_improvement(tuning_run,
                                         threshold = threshold)
    end

    technique(tuning_run,
              channel,
              iterate,
              name = "Iterative Probabilistic Improvement")
end
