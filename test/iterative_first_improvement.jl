using StochasticSearch, FactCheck, Base.Test

facts("[Search]") do
    context("iterative_first_improvement") do
        function rosenbrock(x::Configuration)
            return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
        end
        configuration = Configuration([NumberParameter(-2.0,2.0,0.0,"i0"),
                                       NumberParameter(-2.0,2.0,0.0,"i1")],
                                       "rosenbrock_config")
        iterations   = 1_000
        report_after = 333
        run_task = @task optimize(rosenbrock,
                                  configuration,
                                  [:iterative_first_improvement],
                                  iterations   = iterations,
                                  report_after = report_after)
        result = None
        for i = 1:iterations
            result = consume(run_task)
        end
        rr = rosenbrock(result.minimum)
        rc = result.cost_minimum
        @test_approx_eq rc rr
        @fact (configuration["i0"].value != result.minimum["i0"].value)   --> true
        @fact (rosenbrock(result.minimum) <= rosenbrock(configuration))   --> true
        @fact_throws Exception optimize(rosenbrock, configuration, [:bozo_search])
        println(rosenbrock(result.minimum))
    end
end
