using StochasticSearch

function rosenbrock(x::Array)
    return (1.0 - x[1])^2 + 100.0 * (x[4] - x[1]^2)^2
end

configuration = Configuration([NumberParameter(-2.0,2.0,0.0,:a), 
                               NumberParameter(-2.0,2.0,0.0,:b)],
                               :rosenbrock_config)

result = optimize!(rosenbrock, configuration, iterations = 100_000)

println(result)

a = Symbol[]
c = convert(Array{Number}, configuration, a)
println(rosenbrock(c))
