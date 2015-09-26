@everywhere begin
    using StochasticSearch
    function rosenbrock(x::Configuration, parameters::Dict{Symbol, Any})
        return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
    end
end

configuration = Configuration([NumberParameter(-2.0, 2.0, 0.0,"i0"),
                               NumberParameter(-2.0, 2.0, 0.0,"i1")],
                               "rosenbrock_config")
methods     = [:simulated_annealing,
               :iterative_first_improvement,
               :randomized_first_improvement,
               :iterative_greedy_construction,
               :iterative_probabilistic_improvement]

instances   = [1, 1, 1, 1, 1]
iterations  = 100_000

parameters = Dict(:cost           => rosenbrock,
                  :cost_args      => Dict{Symbol, Any}(),
                  :initial_config => configuration,
                  :iterations     => iterations,
                  :report_after   => 500,
                  :methods        => methods,
                  :instances      => instances,
                  :evaluations    => 1)

result = @task optimize(parameters)

partial = None
for i = 0:iterations
    partial = consume(result)
end
