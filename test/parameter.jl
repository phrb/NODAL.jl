using StochasticSearch, FactCheck

facts("[RealParameter] constructors") do
    context("[IntParameter] constructor") do
        p = IntParameter(0, 10, 3)
        @fact (p.min   == 0 )       => true
        @fact (p.max   == 10)       => true
        @fact (p.value == 3 )       => true
        @fact_throws ErrorException IntParameter(3, 1, 2)
        @fact_throws ErrorException IntParameter(1, 3, 0)
        @fact_throws ErrorException IntParameter(1, 3, 4)
        @fact_throws MethodError    IntParameter("a", 3, 4)
        @fact_throws MethodError    IntParameter(1.0, 3, 4)
    end
    context("[FloatParameter] constructor") do
        p = FloatParameter(0.223, 10.122, 3.12)
        @fact (p.min   == 0.223 )   => true
        @fact (p.max   == 10.122)   => true
        @fact (p.value == 3.12  )   => true
        @fact_throws ErrorException FloatParameter(3.3, 1.223, 2.4)
        @fact_throws ErrorException FloatParameter(1.443, 3.2332, 1.442)
        @fact_throws ErrorException FloatParameter(1.23, 3.2, 3.23)
        @fact_throws MethodError    FloatParameter("a", 3, 4)
    end
end
