function elapsed_time_reporting_criterion(report_after::Number)
    previous_time = time()
    while true
        current_time = time()
        if current_time - previous_time >= report_after
            previous_time = time()
            produce(true)
        else
            produce(false)
        end
    end
end

function iterations_reporting_criterion(report_after::Number)
    previous_iteration = 0
    current_iteration  = previous_iteration
    while true
        current_iteration += 1
        if current_iteration - previous_iteration >= report_after
            previous_iteration = current_iteration
            produce(true)
        else
            produce(false)
        end
    end
end
