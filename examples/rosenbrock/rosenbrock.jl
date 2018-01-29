using Distributed
import NODAL

addprocs()

@everywhere begin
    using NODAL
    function rosenbrock(x::Configuration, parameters::Dict{Symbol, Any})
        return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
    end
end

function optimize_rosenbrock()
    configuration = Configuration([FloatParameter(-2.0, 2.0, 0.0,"i0"),
                                   FloatParameter(-2.0, 2.0, 0.0,"i1")],
                                   "rosenbrock_config")

    tuning_run = Run(cost                = rosenbrock,
                     starting_point      = configuration,
                     stopping_criterion  = elapsed_time_criterion,
                     report_after        = 10,
                     reporting_criterion = elapsed_time_reporting_criterion,
                     duration            = 60,
                     methods             = [[:simulated_annealing 1];
                                            [:iterative_first_improvement 1];
                                            [:iterated_local_search 1];
                                            [:randomized_first_improvement 1];
                                            [:iterative_greedy_construction 1];
                                            [:iterative_probabilistic_improvement 1];])

    @spawn optimize(tuning_run)
    result = take!(tuning_run.channel)

    print(result)
    while !result.is_final
        result = take!(tuning_run.channel)
        print(result)
    end
end

optimize_rosenbrock()
