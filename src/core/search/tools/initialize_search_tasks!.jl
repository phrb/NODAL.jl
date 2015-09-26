function initialize_search_tasks!(parameters::Dict{Symbol, Any})
    instances = parameters[:instances]
    methods   = parameters[:methods]
    task_list = Task[]
    for i = 1:length(methods)
        for j = 1:instances[i]
            method = Expr(:call, methods[i], deepcopy(parameters))
            push!(task_list, @task (eval(method)))
        end
    end
    task_list
end
