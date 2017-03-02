function elapsed_time_criterion(duration::Number, channel::RemoteChannel)
    start = time()
    while true
        try
            put!(channel, (time() - start) >= duration)
        catch
            break
        end
    end
end

function iterations_criterion(duration::Number, channel::RemoteChannel)
    start = 0
    while true
        try
            put!(channel, start >= duration)
            start += 1
        catch
            break
        end
    end
end
