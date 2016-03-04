using StochasticSearch, FactCheck

facts("[Run]") do
    context("constructors") do
        tuning_run = Run()
        @fact (typeof(tuning_run) <: Run) --> true
    end
end
