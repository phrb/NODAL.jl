initialize_cost(f::Function,
                args::Dict{ASCIIString, Any},
                evaluations::Int,
                initial_x::Configuration) = begin
    references = RemoteRef[]
    costs      = Float64[]
    for i = 1:evaluations
        push!(references, @spawn f(initial_x, args))
    end
    for ref in references
        push!(costs, fetch(ref))
    end
    mean(costs)
end
