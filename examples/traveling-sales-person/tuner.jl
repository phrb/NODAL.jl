using Distributed
using Random

import NODAL

addprocs()

@everywhere begin
    using NODAL

    function tour_cost(x::Configuration, parameters::Dict{Symbol, Any})
        result = parse(Float64, read(`./tour_cost $(x["Tour"].value)`, String))
        result
    end

end

function tsp()
    !isfile("tour_cost") && run(`make`)

    tour = ["1"]
    for i = 2:48
        push!(tour, string(i))
    end
    shuffle!(tour)

    configuration = Configuration([PermutationParameter(tour ,"Tour")],
                                   "TSP Solution")

    tuning_run = Run(cost                = tour_cost,
                     starting_point      = configuration,
                     stopping_criterion  = elapsed_time_criterion,
                     duration            = 60,
                     reporting_criterion = elapsed_time_reporting_criterion,
                     report_after        = 5,
                     methods             = [[:iterative_first_improvement 2];
                                            [:iterative_greedy_construction 2];
                                            [:iterative_probabilistic_improvement 2];
                                            [:randomized_first_improvement 2];
                                            [:simulated_annealing 2];])

    @spawn optimize(tuning_run)
    result = take!(tuning_run.channel)

    print("$(result.current_time) ")
    println(result.cost_minimum)

    while !result.is_final
        result = take!(tuning_run.channel)
        print("$(result.current_time) ")
        println(result.cost_minimum)
    end
end

tsp()
