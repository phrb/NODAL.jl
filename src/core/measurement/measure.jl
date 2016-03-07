function measure_mean!(tuning_run::Run, x::Configuration)
    next_proc   = @task chooseproc()
    @sync begin
        for i = 1:tuning_run.cost_evaluations
            @async begin
                tuning_run.cost_values[i] = remotecall_fetch(consume(next_proc),
                                                             tuning_run.cost,
                                                             x,
                                                             tuning_run.cost_arguments)
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
