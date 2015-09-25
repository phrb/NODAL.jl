@everywhere begin
    using StochasticSearch
    function rosenbrock(x::Configuration)
        return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
    end
end

configuration = Configuration([NumberParameter(-2.0, 2.0, 0.0,"i0"),
                               NumberParameter(-2.0, 2.0, 0.0,"i1")],
                               "rosenbrock_config")
iterations   = 10_000
report_after = 1_00

methods     = [:simulated_annealing,
               :iterative_first_improvement,
               :randomized_first_improvement,
               :iterative_greedy_construction,
               :iterative_probabilistic_improvement]

instances   = [1, 1, 1, 1, 1]
evaluations = 1

result = @task optimize(rosenbrock,
                        configuration,
                        methods,
                        iterations   = iterations,
                        report_after = report_after,
                        evaluations  = evaluations,
                        instances    = instances)
partial = None
for i = 0:iterations
    partial = consume(result)
end
