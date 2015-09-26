using StochasticSearch, FactCheck

facts("[NumberParameter]") do
    context("constructor") do
        p = NumberParameter{Int8}(convert(Int8, 0), convert(Int8, 2),
                                  convert(Int8, 1), "test")
        @fact (typeof(p.min)   == Int8)               --> true
        @fact (typeof(p.max)   == Int8)               --> true
        @fact (typeof(p.value) == Int8)               --> true
        @fact (p.name          == "test")              --> true
        @fact (typeof(p) <: NumberParameter{Int8})    --> true
        p = NumberParameter{Float32}(convert(Float32, 0), convert(Float32, 2),
                                     convert(Float32, 1), "test")
        @fact (typeof(p.min)   == Float32)            --> true
        @fact (typeof(p.max)   == Float32)            --> true
        @fact (typeof(p.value) == Float32)            --> true
        @fact (typeof(p) <: NumberParameter{Float32}) --> true
        p = NumberParameter(1, 7, 2, "test")
        @fact (typeof(p) == NumberParameter{Int64})   --> true
        p = NumberParameter(1.2, 7.2, 2.34, "test")
        @fact (typeof(p) == NumberParameter{Float64}) --> true
        p = NumberParameter(1, "test")
        @fact (p.min == 1)                            --> true
        @fact (p.max == 1)                            --> true
        p = NumberParameter(0, 10, "test")
        @fact (0 <= p.value <= 10)                    --> true
    end
    context("neighbor!") do
        p = NumberParameter(1, 200, 100, "test")
        n = p.value
        neighbor!(p)
        @fact n                                       --> not(exactly(p.value))
        n = p.value
        neighbor!(p, 8)
        @fact n                                       --> not(exactly(p.value))
        n = p.value
        neighbor!(p, 8, 1)
        @fact n                                       --> not(exactly(p.value))
        p = NumberParameter(1.332, 60.2, 44.3, "test")
        n = p.value
        neighbor!(p)
        @fact n                                       --> not(exactly(p.value))
        n = p.value
        neighbor!(p, 3.2231)
        @fact n                                       --> not(exactly(p.value))
        n = p.value
        neighbor!(p, 8.332, 1)
        @fact n                                       --> not(exactly(p.value))
        @fact_throws MethodError neighbor!(p, 8.332, 20.2)
    end
    context("constructor") do
        @fact (IntegerParameter <: NumberParameter)   --> true
        p = IntegerParameter(0, 10, 3, "test")
        @fact (typeof(p) <: NumberParameter{Integer}) --> true
        @fact (typeof(p) <: IntegerParameter)         --> true
        @fact (p.min   == 0 )                         --> true
        @fact (p.max   == 10)                         --> true
        @fact (p.value == 3 )                         --> true
        @fact (p.name  == "test")                      --> true
        @fact_throws ErrorException IntegerParameter(3, 1, 2, "test")
        @fact_throws ErrorException IntegerParameter(1, 3, 0, "test")
        @fact_throws ErrorException IntegerParameter(1, 3, 4, "test")
        @fact_throws MethodError    IntegerParameter("a", 3, 4, "test")
        @fact_throws MethodError    IntegerParameter(1, 3, 2)
        @fact_throws MethodError    IntegerParameter(1.0, 3, 4, "test")
        p = IntegerParameter(convert(Int8, 0), convert(Int8, 2),
                             convert(Int8, 1), "test")
        @fact (typeof(p) == NumberParameter{Integer}) --> true
        @fact (typeof(p) <: IntegerParameter)         --> true
        @fact (typeof(p.min)   == Int8)               --> true
        @fact (typeof(p.max)   == Int8)               --> true
        @fact (typeof(p.value) == Int8)               --> true
        @fact (p.min   == 0)                          --> true
        @fact (p.max   == 2)                          --> true
        @fact (p.value == 1)                          --> true
    end
    context("perturb!") do
        value    = 3
        interval = 10
        p = IntegerParameter(0, 100, value, "rand_test")
        perturb!(p)
        @fact (typeof(p.value) <: Integer)  --> true
        @fact (p.value <= p.max)            --> true
        @fact (p.value >= p.min)            --> true
        perturb!(p, interval)
        value = p.value
        @fact (typeof(p.value) <: Integer)  --> true
        @fact (p.value <= p.max)            --> true
        @fact (p.value <= value + interval) --> true
        @fact (p.value >= p.min)            --> true
        @fact (p.value >= value - interval) --> true
        interval = 103
        perturb!(p, interval)
        @fact (typeof(p.value) <: Integer)  --> true
        @fact (p.value <= p.max)            --> true
        @fact (p.value >= p.min)            --> true
        interval = -1
        @fact_throws ErrorException perturb!(p, interval)
        interval = 0
        @fact_throws ErrorException perturb!(p, interval)
    end
    context("constructor") do
        p = FloatParameter(0.223, 10.122, 3.12, "test")
        @fact (p.min   == 0.223 ) --> true
        @fact (p.max   == 10.122) --> true
        @fact (p.value == 3.12  ) --> true
        @fact (p.name  == "test")  --> true
        @fact_throws ErrorException FloatParameter(3.3, 1.223, 2.4, "test")
        @fact_throws ErrorException FloatParameter(1.443, 3.2332, 1.442, "test")
        @fact_throws ErrorException FloatParameter(1.23, 3.2, 3.23, "test")
        @fact_throws MethodError    FloatParameter("a", 3, 4, "test")
        @fact_throws MethodError    FloatParameter(1, 3, 2, "test")
        @fact_throws MethodError    FloatParameter(1, 3, 2)
        p = FloatParameter(convert(Float32, 0), convert(Float32, 2),
                           convert(Float32, 1), "test")
        @fact (typeof(p.min)   == Float32)                  --> true
        @fact (typeof(p.max)   == Float32)                  --> true
        @fact (typeof(p.value) == Float32)                  --> true
        @fact (typeof(p) == NumberParameter{FloatingPoint}) --> true
        @fact (typeof(p) <: FloatParameter)                 --> true
        @fact (p.min   == 0)                                --> true
        @fact (p.max   == 2)                                --> true
        @fact (p.value == 1)                                --> true
    end
    context("perturb!") do
        value    = 3.2
        interval = 50.6
        p = FloatParameter(0., 1000., value, "rand_test")
        perturb!(p)
        @fact (typeof(p.value) <: FloatingPoint) --> true
        @fact (p.value <= p.max)                 --> true
        @fact (p.value >= p.min)                 --> true
        perturb!(p, interval)
        perturb!(p, interval)
        perturb!(p, interval)
        value = p.value
        @fact (typeof(p.value) <: FloatingPoint) --> true
        @fact (p.value <= value + interval)      --> true
        @fact (p.value <= p.max)                 --> true
        @fact (p.value >= p.min)                 --> true
        @fact (p.value >= value - interval)      --> true
        interval = 103.0
        perturb!(p, interval)
        perturb!(p, interval)
        perturb!(p, interval)
        @fact (typeof(p.value) <: FloatingPoint) --> true
        @fact (p.value <= p.max)                 --> true
        @fact (p.value >= p.min)                 --> true
        interval = -1.2
        @fact_throws ErrorException perturb!(p, interval)
        interval = 0
        @fact_throws ErrorException perturb!(p, interval)
    end
end

facts("[EnumParameter]") do
    p = EnumParameter([IntegerParameter(1, 3, 2, "test")], "test")
    @fact (typeof(p.current) == IntegerParameter)               --> true
    @fact (typeof(p)         <: EnumParameter)                  --> true
    p = EnumParameter([IntegerParameter(1, 3, 2, "test"),
                       FloatParameter(1.1,2.3,1.4, "test")],
                       "test")
    @fact (typeof(p.current) <: NumberParameter)                --> true
    @fact (typeof(p)         <: EnumParameter)                  --> true
    p = EnumParameter([IntegerParameter(1, 3, 2, "test"),
                       FloatParameter(1.1,2.3,1.4, "test"),
                       StringParameter("value", "test")],
                       "test")
    @fact (typeof(p.current) <: Parameter)                      --> true
    @fact (typeof(p)         <: EnumParameter)                  --> true
    p = EnumParameter([EnumParameter([StringParameter("a", "test")], "test"),
                       EnumParameter([StringParameter("b", "test")], "test"),
                       EnumParameter([StringParameter("c", "test")], "test")],
                       "test")
    @fact (typeof(p)       <: EnumParameter)                    --> true
    p = EnumParameter([EnumParameter([StringParameter("a", "test")], "test"),
                       StringParameter("b", "test"),
                       EnumParameter([StringParameter("c", "test")], "test")],
                       "test")
    println(p)
    @fact (typeof(p)       <: EnumParameter)                    --> true
    context("constructors") do
        p = EnumParameter([IntegerParameter(1, 4, 3, "test"),
                           IntegerParameter(1, 6, 3, "test")], "test")
        @fact (typeof(p)         <: EnumParameter)              --> true
        @fact (typeof(p.values)  <: AbstractArray)              --> true
        @fact (typeof(p.values)  == Array{IntegerParameter, 1}) --> true
        @fact (p.values[1].value == 3)                          --> true
        @fact (p.values[2].value == 3)                          --> true
        @fact (p.values[1].name  == "test")                         --> true
        @fact (p.values[2].name  == "test")                         --> true
        @fact (p.name            == "test")                      --> true
        p = EnumParameter([IntegerParameter(1, 4, 3, "test"),
                           IntegerParameter(1, 6, 2, "test")], 1, "test")
        @fact (p.value           == 1)                          --> true
        @fact (p.current.value   == 3)                          --> true
        p = EnumParameter([FloatParameter(1.2, 4.3, 3.2, "test"),
                           IntegerParameter(1, 6, 2, "test")], 1, "test")
        @fact (typeof(p)         <: EnumParameter)              --> true
        p = EnumParameter([FloatParameter(1.2, 4.3, 3.2, "test"),
                           IntegerParameter(1, 6, 2, "test"),
                           StringParameter("value", "test")], "test")
        @fact (typeof(p)         <: EnumParameter)              --> true
        @fact_throws MethodError    EnumParameter([3, 4], "test")
        @fact_throws MethodError    EnumParameter([IntegerParameter(1, 4, 3, "test")])
        @fact_throws ErrorException EnumParameter([IntegerParameter(1, 4, 3, "test"),
                                                   IntegerParameter(1, 6, 3, "test")], 3, "test")
    end
    context("perturb! and perturb_elements!") do
        p = EnumParameter([IntegerParameter(1, 4, 3, "test"),
                           StringParameter("b", "test"),
                           IntegerParameter(1, 6, 3, "test")], 2, "test")
        perturb_elements!(p)
        perturb_elements!(p)
        perturb_elements!(p)
        @fact (p.value == 2)                                --> true
        p = EnumParameter([FloatParameter(1.1, 4.2, 3.221, "test"),
                           FloatParameter(2.3, 4.4, 3.1, "test")], "test")
        perturb!(p)
        perturb!(p)
        perturb!(p)
        @fact (p.values[1].value == 3.221)                  --> true
        p = EnumParameter([StringParameter("valuea", "test"),
                           StringParameter("valueb", "test")], "test")
        perturb!(p)
        perturb!(p)
        perturb!(p)
        @fact (p.values[1].value == "valuea")               --> true
        p = EnumParameter([EnumParameter([StringParameter("a", "test")], "test"),
                           StringParameter("b", "test"),
                           IntegerParameter(1, 4, 3, "test"),
                           EnumParameter([StringParameter("c", "test")], "test")],
                           "test")
        v = p.current
        perturb_elements!(p, 3, 2)
        perturb_elements!(p, 3, 2)
        perturb_elements!(p, 3, 2)
        @fact (p.current == v)                              --> true
        v = p.values[3]
        @fact (v.value <= v.max)                            --> true
        @fact (v.value >= v.min)                            --> true
        perturb_elements!(p, [2, 3, 4])
        v = p.values[3]
        @fact (v.value <= v.max)                            --> true
        @fact (v.value >= v.min)                            --> true
        @fact_throws MethodError    perturb_elements!(p, 2, 2)
        @fact_throws MethodError    perturb_elements!(p, 2)
        @fact_throws ErrorException perturb_elements!(p, [1,3,4,5,6,3])
    end
    context("neighbor!") do
        p = EnumParameter([IntegerParameter(1, 4, 3, "test"),
                           StringParameter("b", "test"),
                           IntegerParameter(1, 6, 3, "test")], 2, "test")
        n = p.current
        neighbor!(p)
        @fact (n != p.value)                          --> true
        @fact_throws MethodError neighbor!(p, 8, 20)
        @fact_throws MethodError neighbor!(p, 3.2231)
    end
end

facts("[StringParameter]") do
    p = StringParameter("value", "test")
    @fact (typeof(p) == StringParameter) --> true
    @fact (typeof(p) <: Parameter)       --> true
    @fact (p.value == "value")           --> true
    @fact (p.name  == "test")            --> true
    @fact_throws MethodError perturb!(p)
    @fact_throws MethodError StringParameter(2, "test")
    @fact_throws MethodError StringParameter("value")
end

facts("[BoolParameter]") do
    p = BoolParameter(false, "test")
    @fact (typeof(p.value) == Bool)      --> true
    p = BoolParameter(0, "test")
    @fact (p.value == false)             --> true
    p = BoolParameter(1, "test")
    @fact (p.value == true)              --> true
    @fact_throws MethodError BoolParameter("must have start value")
    context("perturb!") do
        p = BoolParameter(false, "test")
        perturb!(p)
        @fact (p.value == true)          --> true
    end
    context("neighbor!") do
        p = BoolParameter(false, "test")
        neighbor!(p)
        @fact (p.value == true)          --> true
        print(p)
    end
end
