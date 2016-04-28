function optimize(tuning_run::Run)
    stopping_criterion  = @task tuning_run.stopping_criterion(tuning_run.duration)
    reporting_criterion = @task tuning_run.reporting_criterion(tuning_run.report_after)
    stop                = consume(stopping_criterion)
    results             = initialize_search_tasks!(tuning_run)
    best                = get_new_best(results)
    iteration           = 1
    start_time          = time()
    produce(best)
    while !stop
        best                    = get_new_best(results, best)
        iteration              += 1
        best.current_iteration  = iteration
        stop                    = consume(stopping_criterion)
        if stop
            best.is_final     = true
            best.current_time = time() - start_time
            produce(best)
        elseif consume(reporting_criterion)
            best.current_time = time() - start_time
            produce(best)
        end
    end
end
