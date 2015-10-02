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
    iterations   = parameters[:iterations]
    report_after = parameters[:report_after]

    results      = initialize_search_tasks!(parameters)

    best         = get_new_best(results)
    iteration    = 1
    produce(best)
    while(iteration <= iterations)
        best       = get_new_best(results, best)
        iteration += 1
        best.current_iteration = iteration
        if iteration == iterations
            best.is_final = true
            produce(best)
        elseif iteration % report_after == 0
            produce(best)
        end
    end
end
