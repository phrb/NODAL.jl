using StochasticSearch, FactCheck

facts("[Optim.jl]") do
    context("[simulated_anealing]") do
        f(x::Array) = begin
            return (x[1] - x[4])
        end
        c = Configuration([NumberParameter(-10.0,10.0,-2.0,:a),
                           NumberParameter(-10.0,10.0,9.0,:b)],
                           :c)
        a = optimize!(f, c, iterations = 100_000)
        @fact (a[:a].value == c[:a].value)        => true
        @fact (a[:b].value == c[:b].value)        => true
        @fact_throws ArgumentError optimize!(f, c, method = :nelder_mead)
    end
end
