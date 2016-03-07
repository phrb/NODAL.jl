function optimize(tuning_run::Run)
    stopping_criterion = @task tuning_run.stopping_criterion(tuning_run.duration)
    stop               = !consume(stopping_criterion)
    results            = initialize_search_tasks!(tuning_run)
    best               = get_new_best(results)
    iteration          = 1
    report             = false
    start_time         = time()
    produce(best)
    while !stop
        best                    = get_new_best(results, best)
        iteration              += 1
        best.current_iteration  = iteration
        stop                    = !consume(stopping_criterion)
        delta_t                 = round(Int, time()) % tuning_run.report_after
        if stop
            best.is_final     = true
            best.current_time = time() - start_time
            produce(best)
        elseif delta_t == 0 && report
            report            = false
            best.current_time = time() - start_time
            produce(best)
        end
        if !report && delta_t > 0
            report = true
        end
    end
end
