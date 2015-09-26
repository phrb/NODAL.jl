measure_mean!(f::Function,
              x::Configuration,
              args::Dict{Symbol, Any},
              evaluations::Int,
              results::Array{Float64}) = begin
    @sync begin
        next_proc = @task chooseproc()
        for i = 1:evaluations
            @async begin
                results[i] = remotecall_fetch(consume(next_proc), f, x, args)
            end
        end
    end
    mean(results)
end
