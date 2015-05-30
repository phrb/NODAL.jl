using StochasticSearch, FactCheck

facts("[NumberParameter] constructors") do
    context("[NumberParameter] constructor") do
        p = NumberParameter{Int8}(convert(Int8, 0), convert(Int8, 2),
                                  convert(Int8, 1), :test)
        @fact (typeof(p.min)   == Int8)               => true
        @fact (typeof(p.max)   == Int8)               => true
        @fact (typeof(p.value) == Int8)               => true
        @fact (p.name          == :test)              => true 
        @fact (typeof(p) <: NumberParameter{Int8})    => true
        p = NumberParameter{Float32}(convert(Float32, 0), convert(Float32, 2),
                                     convert(Float32, 1), :test)
        @fact (typeof(p.min)   == Float32)            => true
        @fact (typeof(p.max)   == Float32)            => true
        @fact (typeof(p.value) == Float32)            => true
        @fact (typeof(p) <: NumberParameter{Float32}) => true
    end
    context("[IntegerParameter] constructor") do
        @fact (IntegerParameter <: NumberParameter)    => true
        p = IntegerParameter(0, 10, 3, :test)
        @fact (typeof(p) <: NumberParameter{Integer})  => true
        @fact (typeof(p) <: IntegerParameter)          => true
        @fact (p.min   == 0 )                          => true
        @fact (p.max   == 10)                          => true
        @fact (p.value == 3 )                          => true
        @fact (p.name  == :test)                       => true 
        @fact_throws ErrorException IntegerParameter(3, 1, 2, :test)
        @fact_throws ErrorException IntegerParameter(1, 3, 0, :test)
        @fact_throws ErrorException IntegerParameter(1, 3, 4, :test)
        @fact_throws MethodError    IntegerParameter("a", 3, 4, :test)
        @fact_throws MethodError    IntegerParameter(1, 3, 2)
        @fact_throws MethodError    IntegerParameter(1, 3, 2, "test")
        @fact_throws MethodError    IntegerParameter(1.0, 3, 4, :test)
        p = IntegerParameter(convert(Int8, 0), convert(Int8, 2),
                             convert(Int8, 1), :test)
        @fact (typeof(p) == NumberParameter{Integer}) => true
        @fact (typeof(p) <: IntegerParameter)         => true
        @fact (typeof(p.min)   == Int8)               => true
        @fact (typeof(p.max)   == Int8)               => true
        @fact (typeof(p.value) == Int8)               => true
        @fact (p.min   == 0)                          => true
        @fact (p.max   == 2)                          => true
        @fact (p.value == 1)                          => true
    end
    context("[FloatParameter] constructor") do
        p = FloatParameter(0.223, 10.122, 3.12, :test)
        @fact (p.min   == 0.223 ) => true
        @fact (p.max   == 10.122) => true
        @fact (p.value == 3.12  ) => true
        @fact (p.name  == :test) => true 
        @fact_throws ErrorException FloatParameter(3.3, 1.223, 2.4, :test)
        @fact_throws ErrorException FloatParameter(1.443, 3.2332, 1.442, :test)
        @fact_throws ErrorException FloatParameter(1.23, 3.2, 3.23, :test)
        @fact_throws MethodError    FloatParameter("a", 3, 4, :test)
        @fact_throws MethodError    FloatParameter(1, 3, 2, "test")
        @fact_throws MethodError    FloatParameter(1, 3, 2)
        p = FloatParameter(convert(Float32, 0), convert(Float32, 2),
                           convert(Float32, 1), :test)
        @fact (typeof(p.min)   == Float32)                  => true
        @fact (typeof(p.max)   == Float32)                  => true
        @fact (typeof(p.value) == Float32)                  => true
        @fact (typeof(p) == NumberParameter{FloatingPoint}) => true
        @fact (typeof(p) <: FloatParameter)                 => true
        @fact (p.min   == 0)                                => true
        @fact (p.max   == 2)                                => true
        @fact (p.value == 1)                                => true
    end
end

facts("[EnumParameter] constructors") do
    context ("[EnumParameter] constructor") do
        println(methods(EnumParameter))
        p = EnumParameter([IntegerParameter(1, 4, 3, :a), 
            FloatParameter(1.1, 6.2, 3.2, :b)], :test)
        @fact (typeof(p) == EnumParameter)                   => true
        @fact (typeof(p.values) <: AbstractArray{Parameter}) => true
        @fact (typeof(p.values) == Array{Parameter, 1})      => true
        @fact (p.values[1].value == 3)                       => true
        @fact (p.values[2].value == 3.2)                     => true
        @fact (p.values[1].name  == :a)                      => true
        @fact (p.values[2].name  == :b)                      => true
        @fact (p.name            == :test)                   => true
        @fact_throws MethodError    EnumParameter([3, 4], :test)
        @fact_throws MethodError    EnumParameter([IntegerParameter(1, 4, 3, :a),
                                                   2], :test)
        @fact_throws MethodError    EnumParameter([IntegerParameter(1, 4, 3, :a)])
    end
end
