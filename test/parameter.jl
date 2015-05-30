using StochasticSearch, FactCheck

facts("[NumberParameter] constructors") do
    context("[NumberParameter constructor]") do
        p = NumberParameter{Int8}(convert(Int8, 0), convert(Int8, 2),
                                  convert(Int8, 1))
        @fact (typeof(p.min)   == Int8)            => true
        @fact (typeof(p.max)   == Int8)            => true
        @fact (typeof(p.value) == Int8)            => true
        @fact (typeof(p) <: NumberParameter{Int8}) => true
        p = NumberParameter{Float32}(convert(Float32, 0), convert(Float32, 2),
                                     convert(Float32, 1))
        @fact (typeof(p.min)   == Float32)            => true
        @fact (typeof(p.max)   == Float32)            => true
        @fact (typeof(p.value) == Float32)            => true
        @fact (typeof(p) <: NumberParameter{Float32}) => true
    end
    context("[IntegerParameter] constructor") do
        @fact (IntegerParameter <: NumberParameter)    => true
        p = IntegerParameter(0, 10, 3)
        @fact (typeof(p) <: NumberParameter{Integer})  => true
        @fact (typeof(p) <: IntegerParameter)          => true
        @fact (p.min   == 0 )                          => true
        @fact (p.max   == 10)                          => true
        @fact (p.value == 3 )                          => true
        @fact_throws ErrorException IntegerParameter(3, 1, 2)
        @fact_throws ErrorException IntegerParameter(1, 3, 0)
        @fact_throws ErrorException IntegerParameter(1, 3, 4)
        @fact_throws MethodError    IntegerParameter("a", 3, 4)
        @fact_throws MethodError    IntegerParameter(1.0, 3, 4)
        p = IntegerParameter(convert(Int8, 0), convert(Int8, 2),
                             convert(Int8, 1))
        @fact (typeof(p) <: NumberParameter{Integer}) => true
        @fact (typeof(p) <: IntegerParameter)         => true
        @fact (typeof(p.min)   == Int8)               => true
        @fact (typeof(p.max)   == Int8)               => true
        @fact (typeof(p.value) == Int8)               => true
        @fact (p.min   == 0)                          => true
        @fact (p.max   == 2)                          => true
        @fact (p.value == 1)                          => true
    end
    context("[FloatParameter] constructor") do
        p = FloatParameter(0.223, 10.122, 3.12)
        @fact (p.min   == 0.223 ) => true
        @fact (p.max   == 10.122) => true
        @fact (p.value == 3.12  ) => true
        @fact_throws ErrorException FloatParameter(3.3, 1.223, 2.4)
        @fact_throws ErrorException FloatParameter(1.443, 3.2332, 1.442)
        @fact_throws ErrorException FloatParameter(1.23, 3.2, 3.23)
        @fact_throws MethodError    FloatParameter("a", 3, 4)
        p = FloatParameter(convert(Float32, 0), convert(Float32, 2),
                           convert(Float32, 1))
        @fact (typeof(p.min)   == Float32)                  => true
        @fact (typeof(p.max)   == Float32)                  => true
        @fact (typeof(p.value) == Float32)                  => true
        @fact (typeof(p) <: NumberParameter{FloatingPoint}) => true
        @fact (typeof(p) <: FloatParameter)                 => true
        @fact (p.min   == 0)                                => true
        @fact (p.max   == 2)                                => true
        @fact (p.value == 1)                                => true
    end
end
