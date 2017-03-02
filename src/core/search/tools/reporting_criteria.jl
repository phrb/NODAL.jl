function elapsed_time_reporting_criterion(report_after::Number, channel::RemoteChannel)
    previous_time = time()
    while true
        current_time = time()
        try
            if current_time - previous_time >= report_after
                previous_time = time()
                put!(channel, true)
            else
                put!(channel, false)
            end
        catch
            break
        end
    end
end

function iterations_reporting_criterion(report_after::Number, channel::RemoteChannel)
    previous_iteration = 0
    current_iteration  = previous_iteration
    while true
        current_iteration += 1
        try
            if current_iteration - previous_iteration >= report_after
                previous_iteration = current_iteration
                put!(channel, true)
            else
                put!(channel, false)
            end
        catch
            break
        end
    end
end
