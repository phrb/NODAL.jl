using StochasticSearch

@everywhere function rosenbrock(x::Configuration)
    return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
end

configuration = Configuration([NumberParameter(-2.0, 2.0, 0.0,"i0"),
                               NumberParameter(-2.0, 2.0, 0.0,"i1")],
                               "rosenbrock_config")

iterations   = 1_000
report_after = 1_00

result = @task optimize(rosenbrock,
                        configuration,
                        [:iterative_first_improvement],
                        iterations   = iterations,
                        report_after = report_after,
                        evaluations  = 1,
                        instances    = [1])
partial = None
for i = 0:iterations
    partial = consume(result)
end
