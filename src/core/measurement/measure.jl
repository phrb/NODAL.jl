function measure_mean!(tuning_run::Run, x::Configuration)
    i = 1
    next_index() = (index = i; i += 1; index)

    @sync begin
        for p = 1:nprocs()
            if p != myid() || nprocs() == 1
                @async begin
                    while true
                        index = next_index()
                        if index > tuning_run.cost_evaluations
                            break
                        end
                        tuning_run.cost_values[index] = remotecall_fetch(tuning_run.cost,
                                                                         p,
                                                                         x,
                                                                         tuning_run.cost_arguments)
                    end
                end
            end
        end
    end
    mean(tuning_run.cost_values)
end

function sequential_measure_mean!(tuning_run::Run, x::Configuration)
    for i = 1:tuning_run.cost_evaluations
        tuning_run.cost_values[i] = tuning_run.cost(x, tuning_run.cost_arguments)
    end
    mean(tuning_run.cost_values)
end
