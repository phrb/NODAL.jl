using StochasticSearch, FactCheck, Base.Test

facts("[Search]") do
    context("iterative_greedy_construction") do
        function rosenbrock(x::Configuration, parameters::Dict{Symbol, Any} = Dict{Symbol, Any}())
            return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
        end
        configuration = Configuration([NumberParameter(-2.0,2.0,0.0,"i0"),
                                       NumberParameter(-2.0,2.0,0.0,"i1")],
                                       "rosenbrock_config")
        methods       = [:iterative_greedy_construction]
        instances     = [1]
        parameters    = Dict(:cost           => rosenbrock,
                             :initial_config => configuration,
                             :methods        => methods,
                             :instances      => instances)

        run_task = @task optimize(parameters)
        result   = None
        for i = 1:1_000
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
