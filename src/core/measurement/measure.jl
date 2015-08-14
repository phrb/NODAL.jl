measure_mean!(f::Function,
              x::Configuration,
              args::Dict{ASCIIString, Any},
              evaluations::Int,
              results::Array{Float64}) = begin
    next_proc = @task chooseproc()
    for i = 1:evaluations
        results[i] = remotecall_fetch(consume(next_proc), f, x, args)
    end
    mean(results)
end
