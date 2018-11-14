function optimize(tuning_run::Run)
    stop       = RemoteChannel(()->Channel{Bool}(1))
    report     = RemoteChannel(()->Channel{Bool}(1))

    @spawn tuning_run.stopping_criterion(tuning_run.duration, stop)
    @spawn tuning_run.reporting_criterion(tuning_run.report_after, report)

    results    = initialize_search_tasks!(tuning_run)
    best       = get_new_best(results)
    iteration  = 1
    start_time = time()
    put!(tuning_run.channel, best)

    while !take!(stop)
        best                   = get_new_best(results, best)
        iteration             += 1
        best.current_iteration = iteration

        if take!(report)
            best.current_time = time() - start_time
            put!(tuning_run.channel, best)
        end
    end

    best.is_final     = true
    best.current_time = time() - start_time
    put!(tuning_run.channel, best)

    end_search_tasks!(results)
    close(tuning_run.channel)
    close(stop)
    close(report)
end
