using StochasticSearch

function rosenbrock(x::Configuration)
    return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
end

configuration = Configuration([NumberParameter(-2.0, 2.0, 0.0,"i0"),
                               NumberParameter(-2.0, 2.0, 0.0,"i1")],
                               "rosenbrock_config")

iterations   = 150_000
report_after = 1_000
result = @task optimize(rosenbrock,
                        configuration,
                        iterations = iterations)
partial = None
for i = 1:iterations
    partial = consume(result)
    if i % report_after == 0
        print(partial)
    end
end
