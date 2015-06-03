using StochasticSearch, FactCheck

facts("[Optim.jl]") do
    context("[simulated_anealing]") do
        f{T<:Parameter}(x::Array{T}) = begin
            return (x[1].value - x[2].value)
        end
        c = Configuration([NumberParameter(-10.0,10.0,-2.0,:a),
                           NumberParameter(-10.0,10.0,9.0,:b)], 
                           :c)
        a = optimize(f, c, iterations = 100_000)
        copy(StochasticSearch.convert(Array{Parameter}, c))
        println(a)
        println(c)
    end
end
