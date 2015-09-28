function initialize_search_tasks!(parameters::Dict{Symbol, Any},
                                  results::Array{RemoteRef})
    instances   = parameters[:instances]
    methods     = parameters[:methods]
    next_proc   = @task chooseproc()
    instance_id = 1
    for i = 1:length(methods)
        for j = 1:instances[i]
            reference    = results[instance_id]
            remotecall(consume(next_proc), eval(methods[i]),
                       deepcopy(parameters), reference)
            instance_id += 1
        end
    end
end
