initialize_cost(f::Function,
                args::Dict{ASCIIString, Any},
                evaluations::Int,
                initial_x::Configuration) = begin
    references = RemoteRef[]
    costs      = Float64[]
    for i = 1:evaluations
        push!(references, @spawn f(initial_x, args))
    end
    for ref in references
        push!(costs, fetch(ref))
    end
    mean(costs)
end
initialize_search_tasks!(f::Function,
                         initial_x::Configuration,
                         initial_f_x::Float64,
                         methods::Array{Symbol},
                         args::Dict{ASCIIString, Any},
                         instances::Array{Int},
                         iterations::Int,
                         evaluations::Int,
                         task_list::Array{Task}) = begin
    for i = 1:length(methods)
        if methods[i] == :simulated_annealing
            for j = 1:instances[i]
                push!(task_list, @task simulated_annealing(f,
                                                           args,
                                                           initial_x,
                                                           initial_f_x,
                                                           iterations  = iterations,
                                                           evaluations = evaluations))
            end
        else
            error("Error: Unknown Method.")
        end
    end
end

#
# TODO Extract Methods.
#
optimize(f::Function,
         initial_x::Configuration;
         methods::Array{Symbol}       = [:simulated_annealing],
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
    #
    # Calculate Initial value for all Search Tasks.
    #
    initial_f_x = initialize_cost(f_aliased, args, evaluations, initial_x)
    #
    # Initialize Search Tasks
    #
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
    # TODO Implement tests sharing between methods.
    #      Implement result combination strategies.
    #      Do it 'Round Robin' for now.
    #
    partial  = consume(search_tasks[rand(1:length(search_tasks))])
    best     = deepcopy(partial)
    produce(best)
    iteration = 1
    while(iteration <= iterations)
        for task in search_tasks
            partial = consume(task)
            if partial.cost_minimum < best.cost_minimum
                best = deepcopy(partial)
            end
        end
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
    #
    # TODO  Fix this.
    #
    #       The problem seems to be related to namespaces,
    #       but importing 'simulated_annealing.jl' does not 
    #       solve it.
    #
    #       Using this dummy line solves the problem, even if
    #       the line is never called.
    #
    dummy = @task simulated_annealing(f_aliased,
                                      args,
                                      initial_x,
                                      initial_f_x,
                                      iterations  = iterations,
                                      evaluations = evaluations)
end
