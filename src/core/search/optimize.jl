optimize(f::Function,
         initial_x::Configuration;
         method::Symbol        = :simulated_annealing,
         iterations::Integer   = 100_000,
         report_after::Integer = 10_000,
         verbose::Bool         = true) = begin
    if method == :simulated_annealing
        search = @task simulated_annealing(f,
                                           initial_x,
                                           iterations = iterations)
        results = consume(search)::PartialResult
        if verbose
            print(results)
        end
        while(results.iterations < iterations)
            results = consume(search)::PartialResult
            if results.iterations % report_after == 0 && verbose
                print(results)
            end
        end
        final_results = consume(search)::Result
        if verbose
            print(final_results)
        end
        return final_results
    else
        throw(ArgumentError("Unknown method $method"))
    end
end
