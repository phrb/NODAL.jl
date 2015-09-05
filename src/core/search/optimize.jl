optimize(f::Function,
         initial_x::Configuration,
         methods::Array{Symbol};
         args::Dict{ASCIIString, Any} = Dict{ASCIIString,Any}(),
         instances::Array{Int}        = [1],
         iterations::Int              = 1_000,
         report_after::Int            = 1_000,
         evaluations::Int             = 3) = begin
    #
    # Alias no-arguments functions.
    #
    if isempty(args)
        f_aliased(configuration, args) = f(configuration)
    else
        f_aliased = f
    end
    initial_f_x = initialize_cost(f_aliased, args, evaluations, initial_x)
    search_tasks = Task[]
    initialize_search_tasks!(f_aliased,
                             initial_x,
                             initial_f_x,
                             methods,
                             args,
                             instances,
                             iterations,
                             evaluations,
                             search_tasks)
    #
    # 'Round Robin' of all techniques.
    #
    partial  = consume(search_tasks[rand(1:length(search_tasks))])
    best     = deepcopy(partial)
    produce(best)
    iteration = 1
    while(iteration <= iterations)
        best = get_new_best(search_tasks, best)
        iteration += 1
        best.current_iteration = iteration
        if iteration == iterations
            best.is_final = true
            print(best)
        elseif iteration % report_after == 0
            print(best)
        end
        produce(best)
    end
    dummy = Task(() -> simulated_annealing(f_aliased,
                                           args,
                                           initial_x,
                                           initial_f_x,
                                           iterations  = iterations,
                                           evaluations = evaluations))
end
