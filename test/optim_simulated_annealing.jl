using StochasticSearch, FactCheck

facts("[Optim.jl]") do
    context("[simulated_anealing]") do
        f{T<:Parameter}(x::Array{T}) = begin
            return (x[1].value - x[2].value)
        end
        c = Configuration([NumberParameter(-10.0,10.0,-2.0,:a),
                           NumberParameter(-10.0,10.0,9.0,:b)], 
                           :c)
        a = optimize!(f, c, iterations = 100_000)
        @fact (a.minimum[1].value == c[:b].value) => true
        @fact (a.minimum[2].value == c[:a].value) => true
        @fact_throws ArgumentError optimize!(f, c, method = :nelder_mead)
    end
end
