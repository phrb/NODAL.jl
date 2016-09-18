function initialize_search_tasks!(tuning_run::Run)
    next_proc      = @task chooseproc()

    instance_id    = 1
    results        = RemoteChannel[]

    tuning_run.cost_values    = zeros(tuning_run.cost_evaluations)
    tuning_run.starting_cost  = tuning_run.measurement_method(tuning_run,
                                                              tuning_run.starting_point)
    initial_result            = Result("Initialize",
                                       tuning_run.starting_point,
                                       tuning_run.starting_point,
                                       tuning_run.starting_cost,
                                       1, 1, 1, false)

    for i = 1:size(tuning_run.methods, 1)
        for j = 1:tuning_run.methods[i, 2]
            worker = consume(next_proc)
            push!(results, RemoteChannel(() -> ResultChannel(deepcopy(initial_result)), worker))

            reference = results[instance_id]
            remotecall(worker, eval(tuning_run.methods[i, 1]),
                       deepcopy(tuning_run), reference)
            instance_id += 1
        end
    end
    results
end
