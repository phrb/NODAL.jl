function elapsed_time_criterion(duration::Number)
    start = time()
    while true
        produce((time() - start) >= duration)
    end
end

function iterations_criterion(duration::Number)
    start = 0
    while true
        produce(start >= duration)
        start += 1
    end
end
