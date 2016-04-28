#addprocs(15)

@everywhere begin
    using StochasticSearch
    function tour_cost(x::Configuration, parameters::Dict{Symbol, Any})
        result = float(readall(`./tour_cost $(x["Tour"].value)`))
        result
    end
end

tour = ["1"]
for i = 2:48
    push!(tour, string(i))
end
shuffle!(tour)

configuration = Configuration([PermutationParameter(tour ,"Tour")],
                               "TSP Solution")

tuning_run = Run(cost               = tour_cost,
                 starting_point     = configuration,
                 methods            = [[:iterative_first_improvement 2];
                                       [:iterative_greedy_construction 2];
                                       [:iterative_probabilistic_improvement 2];
                                       [:randomized_first_improvement 2];
                                       [:simulated_annealing 2];],
                 stopping_criterion = elapsed_time_criterion,
                 duration           = 900,
                 report_after       = 10)

search_task = @task optimize(tuning_run)

result = consume(search_task)
print("$(result.current_time) ")
println(result.cost_minimum)
while result.is_final == false
    result = consume(search_task)
    print("$(result.current_time) ")
    println(result.cost_minimum)
end
