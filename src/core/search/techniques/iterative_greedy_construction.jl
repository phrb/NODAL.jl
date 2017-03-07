function iterative_greedy_construction(tuning_run::Run,
                                       channel::RemoteChannel;
                                       cutoff::Integer = 10_000)
    key_set = collect(keys(tuning_run.starting_point.parameters))

    function iterate(tuning_run::Run)
        for key in key_set
            result = greedy_construction(tuning_run,
                                         key,
                                         cutoff = cutoff)
        end
        shuffle!(key_set)

        return result
    end

    technique(tuning_run,
              channel,
              iterate,
              name = "Iterative Greedy Construction")
end
