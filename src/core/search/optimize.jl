function optimize(parameters::Dict{Symbol, Any})
    if !haskey(parameters, :evaluations)
        parameters[:evaluations] = 1
    end
    if !haskey(parameters, :iterations)
        parameters[:iterations] = 1_000
    end
    if !haskey(parameters, :report_after)
        parameters[:report_after] = 333
    end
    if !haskey(parameters, :cost_args)
        parameters[:cost_args] = Dict{Symbol, Any}()
    end
    cost                      = parameters[:cost]
    args                      = parameters[:cost_args]
    initial_x                 = parameters[:initial_config]
    evaluations               = parameters[:evaluations]
    iterations                = parameters[:iterations]
    instances                 = parameters[:instances]
    report_after              = parameters[:report_after]
    methods                   = parameters[:methods]
    costs                     = zeros(evaluations)
    parameters[:costs]        = costs
    parameters[:initial_cost] = measure_mean!(cost, initial_x,
                                              args, evaluations, costs)

    parameters[:results]      = SharedArray(Float64, nprocs())
    search_tasks              = initialize_search_tasks!(parameters)
    #
    # 'Round Robin' of all techniques.
    #
    partial   = consume(search_tasks[rand(1:length(search_tasks))])
    best      = deepcopy(partial)
    iteration = 1
    produce(best)
    while(iteration <= iterations)
        best                   = get_new_best(search_tasks, best)
        iteration             += 1
        best.current_iteration = iteration
        if iteration == iterations
            best.is_final = true
            print(best)
        elseif iteration % report_after == 0
            print(best)
        end
        produce(best)
    end
end
