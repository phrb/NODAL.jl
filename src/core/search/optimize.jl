optimize(f::Function,
         initial_x::Configuration;
         methods::Array{Symbol} = [:simulated_annealing],
         instances::Array{Int}  = [1],
         iterations::Integer    = 100_000) = begin
    search_tasks = Task[]
    for i = 1:length(methods)
        #
        # TODO Implement more search techniques.
        #      Use resource sharing for iterations too.
        #
        if methods[i] == :simulated_annealing
            for j = 1:instances[i]
                push!(search_tasks, @task simulated_annealing(f,
                                                              initial_x,
                                                              iterations = iterations))
            end
        else
            error("unknown method.")
        end
    end
    #
    # TODO Implement tests sharing between methods.
    #      Implement result combination strategies.
    #      Do it 'Round Robin' for now, and
    #
    partial  = consume(search_tasks[rand(1:length(search_tasks))])
    best     = deepcopy(partial)
    produce(best)
    while(partial.iterations <= iterations)
        for task in search_tasks
            partial = consume(task)
            if partial.cost_minimum < best.cost_minimum
                best = deepcopy(partial)
            end
        end
        if partial.iterations == iterations
            best.is_final = true
        end
        produce(best)
    end
end
