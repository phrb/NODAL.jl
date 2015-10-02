function optimize(parameters::Dict{Symbol, Any})
    if !haskey(parameters, :stopping_criterion)
        parameters[:stopping_criterion] = iterations_criterion
    end
    if !haskey(parameters, :measurement_method)
        parameters[:measurement_method] = measure_mean!
    end
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

    criterion_function = parameters[:stopping_criterion]
    if criterion_function == iterations_criterion
        duration = parameters[:iterations]
    elseif criterion_function == elapsed_time_criterion
        duration = parameters[:seconds]
    end
    stopping_criterion = @task criterion_function(duration)
    report_after = parameters[:report_after]

    results      = initialize_search_tasks!(parameters)

    best         = get_new_best(results)
    iteration    = 1
    stop         = !consume(stopping_criterion)
    produce(best)
    while !stop
        best       = get_new_best(results, best)
        iteration += 1
        best.current_iteration = iteration
        stop = !consume(stopping_criterion)
        if stop
            best.is_final = true
            produce(best)
        elseif iteration % report_after == 0
            produce(best)
        end
    end
end
