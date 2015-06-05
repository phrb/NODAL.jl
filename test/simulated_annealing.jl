using StochasticSearch, FactCheck

facts("[Search]") do
    context("optimize and simulated_annealing") do
        function rosenbrock(x::Configuration)
            return (1.0 - x[:i0].value)^2 + 100.0 * (x[:i1].value - x[:i0].value^2)^2
        end

        configuration = Configuration([NumberParameter(-2.0,2.0,0.0,:i0),
                                       NumberParameter(-2.0,2.0,0.0,:i1)],
                                       :rosenbrock_config)

        result = optimize(rosenbrock, configuration, iterations = 10_000)

        @fact (configuration[:i0].value != result.minimum[:i0].value)   => true
        @fact (rosenbrock(result.minimum) <= rosenbrock(configuration)) => true
        @fact (rosenbrock(result.minimum) == result.cost_minimum)       => true
        println(result)
        println(rosenbrock(result.minimum))
    end
end
