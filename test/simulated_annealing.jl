using StochasticSearch, FactCheck

facts("[Search]") do
    context("optimize and simulated_annealing") do
        function rosenbrock(x::Configuration)
            return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
        end
        configuration = Configuration([NumberParameter(-2.0,2.0,0.0,"i0"),
                                       NumberParameter(-2.0,2.0,0.0,"i1")],
                                       "rosenbrock_config")
        run_task = @task optimize(rosenbrock,
                                  configuration,
                                  iterations = 100_000)
        result = None
        for i = 1:100_000
            result = consume(run_task)
            if i == 443
                print(result)
            end
        end
        print(result)
        @fact (configuration["i0"].value != result.minimum["i0"].value)   => true
        @fact (rosenbrock(result.minimum) <= rosenbrock(configuration))   => true
        @fact (rosenbrock(result.minimum) == result.cost_minimum)         => true
        @fact_throws ErrorException optimize(rosenbrock, configuration, methods = [:bozo_optimize])
        println(rosenbrock(result.minimum))
    end
end
