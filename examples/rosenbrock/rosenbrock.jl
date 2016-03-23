@everywhere begin
    using StochasticSearch
    function rosenbrock(x::Configuration, parameters::Dict{Symbol, Any})
        return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
    end
end

configuration = Configuration([FloatParameter(-2.0, 2.0, 0.0,"i0"),
                               FloatParameter(-2.0, 2.0, 0.0,"i1")],
                               "rosenbrock_config")

tuning_run = Run(cost               = rosenbrock,
                 starting_point     = configuration,
                 methods            = [[:simulated_annealing 1];
                                       [:iterative_first_improvement 1];
                                       [:randomized_first_improvement 1];
                                       [:iterative_greedy_construction 1];
                                       [:iterative_probabilistic_improvement 1];],
                 stopping_criterion = elapsed_time_criterion,
                 report_after       = 4,
                 duration           = 30,
                 measurement_method = sequential_measure_mean!)

search_task = @task optimize(tuning_run)
result = consume(search_task)
print(result)
while result.is_final == false
    result = consume(search_task)
    print(result)
end
