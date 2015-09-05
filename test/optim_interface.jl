using StochasticSearch, FactCheck

facts("[Interface] with Optim.jl") do
    context("simulated_anealing and nelder_mead") do
        function rosenbrock(x::Array)
            return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
        end
        c = Configuration([NumberParameter(-10.0,10.0,-2.0,"a"),
                           NumberParameter(-10.0,10.0,9.0,"b")],
                           "c")
        r = optimize!(rosenbrock, c, iterations = 10_000)
        a = r.minimum
        println(r)
        @fact (a["a"].value == c["a"].value)        --> true
        @fact (a["b"].value == c["b"].value)        --> true
        r = optimize!(rosenbrock, c, method = :nelder_mead, iterations = 10_000)
        a = r.minimum
        println(r)
        @fact (a["a"].value == c["a"].value)        --> true
        @fact (a["b"].value == c["b"].value)        --> true
        @fact_throws ArgumentError optimize!(rosenbrock, c, method = :torczon)
    end
end
