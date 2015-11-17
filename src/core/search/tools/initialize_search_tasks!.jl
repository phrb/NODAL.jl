function initialize_search_tasks!(parameters::Dict{Symbol, Any})
    cost         = parameters[:cost]
    args         = parameters[:cost_args]
    instances    = parameters[:instances]
    methods      = parameters[:methods]
    initial_x    = parameters[:initial_config]
    evaluations  = parameters[:evaluations]
    measurement  = parameters[:measurement_method]
    next_proc    = @task chooseproc()

    instance_id  = 1
    results      = RemoteRef[]

    for i = 1:length(methods)
        for j = 1:instances[i]
            costs                       = zeros(evaluations)
            parameters[:costs]          = costs

            initial_x                   = perturb!(initial_x)
            parameters[:initial_config] = initial_x

            initial_cost                = measurement(parameters, initial_x)
            parameters[:initial_cost]   = initial_cost

            initial_result              = Result("Initialize", initial_x, 
                                                 initial_x, initial_cost, 
                                                 1, 1, 1, false)

            push!(results, RemoteRef(() -> ResultChannel(initial_result)))

            reference                   = results[instance_id]
            remotecall(consume(next_proc), eval(methods[i]),
                       deepcopy(parameters), reference)
            instance_id += 1
        end
    end
    results
end
