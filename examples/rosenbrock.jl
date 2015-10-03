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
iterations  = 1_000

parameters = Dict(:cost               => rosenbrock,
                  :cost_args          => Dict{Symbol, Any}(),
                  :initial_config     => configuration,
                  :iterations         => iterations,
                  :report_after       => 50,
                  :measurement_method => sequential_measure_mean!,
                  :methods            => methods,
                  :instances          => instances,
                  :evaluations        => 1)

search_task = @task optimize(parameters)

result = consume(search_task)
print(result)
while result.is_final == false
    result = consume(search_task)
    print(result)
end
