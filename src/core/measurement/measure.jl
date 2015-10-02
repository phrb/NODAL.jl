function measure_mean!(parameters::Dict{Symbol, Any}, x::Configuration)
    f           = parameters[:cost]
    args        = parameters[:cost_args]
    evaluations = parameters[:evaluations]
    results     = parameters[:costs]
    next_proc   = @task chooseproc()
    @sync begin
        for i = 1:evaluations
            @async begin
                results[i] = remotecall_fetch(consume(next_proc), f, x, args)
            end
        end
    end
    mean(results)
end

function sequential_measure_mean!(parameters::Dict{Symbol, Any}, x::Configuration)
    f           = parameters[:cost]
    args        = parameters[:cost_args]
    evaluations = parameters[:evaluations]
    results     = parameters[:costs]
    for i = 1:evaluations
        results[i] = f(x, args)
    end
    mean(results)
end
