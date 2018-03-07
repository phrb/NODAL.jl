@testset "NumberParameter" begin
    @testset "constructor" begin
        p = NumberParameter{Int8}(convert(Int8, 0), convert(Int8, 2),
                                  convert(Int8, 1), "test")
        @test typeof(p.min)   == Int8
        @test typeof(p.max)   == Int8
        @test typeof(p.value) == Int8
        @test p.name          == "test"
        @test typeof(p) <: NumberParameter{Int8}
        p = NumberParameter{Float32}(convert(Float32, 0), convert(Float32, 2),
                                     convert(Float32, 1), "test")
        @test typeof(p.min)   == Float32
        @test typeof(p.max)   == Float32
        @test typeof(p.value) == Float32
        @test typeof(p) <: NumberParameter{Float32}
        p = NumberParameter{Int64}(1, 7, 2, "test")
        @test typeof(p) == NumberParameter{Int64}
        p = NumberParameter{Float64}(1.2, 7.2, 2.34, "test")
        @test typeof(p) == NumberParameter{Float64}
        p = NumberParameter{Int64}(1, "test")
        @test p.min == 1
        @test p.max == 1
        p = NumberParameter{Int64}(0, 10, "test")
        @test 0 <= p.value <= 10
    end
    @testset "neighbor!" begin
        p = NumberParameter{Int64}(1, 200, 100, "test")
        n = p.value
        neighbor!(p)
        @test n != p.value
        n = p.value
        neighbor!(p, interval = 8)
        @test n != p.value
        n = p.value
        neighbor!(p, interval = 8, distance = 1)
        @test n != p.value
        p = NumberParameter{Float64}(1.332, 60.2, 44.3, "test")
        n = p.value
        neighbor!(p)
        @test n != p.value
        n = p.value
        neighbor!(p, interval = 3.2231)
        @test n != p.value
        n = p.value
        neighbor!(p, interval = 8.332, distance = 1)
        @test n != p.value
        @test_throws MethodError neighbor!(p, 8.332, 20.2)
    end
    @testset "IntegerParameter constructor" begin
        @test IntegerParameter <: NumberParameter
        p = IntegerParameter(0, 10, 3, "test")
        @test typeof(p) <: NumberParameter{Integer}
        @test typeof(p) <: IntegerParameter
        @test p.min   == 0
        @test p.max   == 10
        @test p.value == 3
        @test p.name  == "test"
        @test_throws ErrorException IntegerParameter(3, 1, 2, "test")
        @test_throws ErrorException IntegerParameter(1, 3, 0, "test")
        @test_throws ErrorException IntegerParameter(1, 3, 4, "test")
        @test_throws MethodError    IntegerParameter("a", 3, 4, "test")
        @test_throws MethodError    IntegerParameter(1, 3, 2)
        @test_throws MethodError    IntegerParameter(1.0, 3, 4, "test")
        p = IntegerParameter(convert(Int8, 0), convert(Int8, 2),
                             convert(Int8, 1), "test")
        @test typeof(p)       == NumberParameter{Integer}
        @test typeof(p) <: IntegerParameter
        @test typeof(p.min)   == Int8
        @test typeof(p.max)   == Int8
        @test typeof(p.value) == Int8
        @test p.min           == 0
        @test p.max           == 2
        @test p.value         == 1
    end
    @testset "IntegerParameter perturb!" begin
        value    = 3
        interval = 10
        p = IntegerParameter(0, 100, value, "rand_test")
        perturb!(p, 10)
        @test typeof(p.value) <: Integer
        @test p.value <= p.max
        @test p.value >= p.min
        perturb!(p, interval)
        value = p.value
        @test typeof(p.value) <: Integer
        @test p.value <= p.max
        @test p.value <= value + interval
        @test p.value >= p.min
        @test p.value >= value - interval
        interval = 103
        perturb!(p, interval)
        @test typeof(p.value) <: Integer
        @test p.value <= p.max
        @test p.value >= p.min
        interval = -1
        @test_throws ErrorException perturb!(p, interval)
        interval = 0
        @test_throws ErrorException perturb!(p, interval)
    end
    @testset "FloatParameter constructor" begin
        p = FloatParameter(0.223, 10.122, 3.12, "test")
        @test p.min   == 0.223
        @test p.max   == 10.122
        @test p.value == 3.12
        @test p.name  == "test"
        @test_throws ErrorException FloatParameter(3.3, 1.223, 2.4, "test")
        @test_throws ErrorException FloatParameter(1.443, 3.2332, 1.442, "test")
        @test_throws ErrorException FloatParameter(1.23, 3.2, 3.23, "test")
        @test_throws MethodError    FloatParameter("a", 3, 4, "test")
        @test_throws MethodError    FloatParameter(1, 3, 2, "test")
        @test_throws MethodError    FloatParameter(1, 3, 2)
        p = FloatParameter(convert(Float32, 0), convert(Float32, 2),
                           convert(Float32, 1), "test")
        @test typeof(p.min)   == Float32
        @test typeof(p.max)   == Float32
        @test typeof(p.value) == Float32
        @test typeof(p) == NumberParameter{AbstractFloat}
        @test typeof(p) <: FloatParameter
        @test p.min   == 0
        @test p.max   == 2
        @test p.value == 1
    end
    @testset "FloatParameter perturb!" begin
        value    = 3.2
        interval = 50.6
        p = FloatParameter(0., 1000., value, "rand_test")
        perturb!(p, 10.)
        @test typeof(p.value) <: AbstractFloat
        @test p.value <= p.max
        @test p.value >= p.min
        perturb!(p, interval)
        perturb!(p, interval)
        perturb!(p, interval)
        value = p.value
        @test typeof(p.value) <: AbstractFloat
        @test p.value <= value + interval
        @test p.value <= p.max
        @test p.value >= p.min
        @test p.value >= value - interval
        interval = 103.0
        perturb!(p, interval)
        perturb!(p, interval)
        perturb!(p, interval)
        @test typeof(p.value) <: AbstractFloat
        @test p.value <= p.max
        @test p.value >= p.min
        interval = -1.2
        @test_throws ErrorException perturb!(p, interval)
        interval = 0
        @test_throws ErrorException perturb!(p, interval)
    end
end

@testset "EnumParameter" begin
    @testset "constructor" begin
        p = EnumParameter([IntegerParameter(1, 3, 2, "test")], "test")
        @test typeof(p.current) == IntegerParameter
        @test typeof(p)         <: EnumParameter
        p = EnumParameter([IntegerParameter(1, 3, 2, "test"),
                           FloatParameter(1.1,2.3,1.4, "test")],
                           "test")
        @test typeof(p.current) <: NumberParameter
        @test typeof(p)         <: EnumParameter
        p = EnumParameter([IntegerParameter(1, 3, 2, "test"),
                           FloatParameter(1.1,2.3,1.4, "test"),
                           StringParameter("value", "test")],
                           "test")
        @test typeof(p.current) <: Parameter
        @test typeof(p)         <: EnumParameter
        p = EnumParameter([EnumParameter([StringParameter("a", "test")], "test"),
                           EnumParameter([StringParameter("b", "test")], "test"),
                           EnumParameter([StringParameter("c", "test")], "test")],
                           "test")
        @test typeof(p)       <: EnumParameter
        p = EnumParameter([EnumParameter([StringParameter("a", "test")], "test"),
                           StringParameter("b", "test"),
                           EnumParameter([StringParameter("c", "test")], "test")],
                           "test")
        print(p)
        @test typeof(p)       <: EnumParameter
        p = EnumParameter([IntegerParameter(1, 4, 3, "test"),
                           IntegerParameter(1, 6, 3, "test")], "test")
        @test typeof(p)         <: EnumParameter
        @test typeof(p.values)  <: AbstractArray
        @test typeof(p.values)  == Array{IntegerParameter, 1}
        @test p.values[1].value == 3
        @test p.values[2].value == 3
        @test p.values[1].name  == "test"
        @test p.values[2].name  == "test"
        @test p.name            == "test"
        p = EnumParameter([IntegerParameter(1, 4, 3, "test"),
                           IntegerParameter(1, 6, 2, "test")], 1, "test")
        @test p.value           == 1
        @test p.current.value   == 3
        p = EnumParameter([FloatParameter(1.2, 4.3, 3.2, "test"),
                           IntegerParameter(1, 6, 2, "test")], 1, "test")
        @test typeof(p)         <: EnumParameter
        p = EnumParameter([FloatParameter(1.2, 4.3, 3.2, "test"),
                           IntegerParameter(1, 6, 2, "test"),
                           StringParameter("value", "test")], "test")
        @test typeof(p)         <: EnumParameter
        @test_throws MethodError    EnumParameter([3, 4], "test")
        @test_throws MethodError    EnumParameter([IntegerParameter(1, 4, 3, "test")])
        @test_throws ErrorException EnumParameter([IntegerParameter(1, 4, 3, "test"),
                                                   IntegerParameter(1, 6, 3, "test")], 3, "test")
    end
    @testset "perturb! and perturb_elements!" begin
        p = EnumParameter([IntegerParameter(1, 4, 3, "test"),
                           StringParameter("b", "test"),
                           IntegerParameter(1, 6, 3, "test")], 2, "test")
        perturb_elements!(p)
        perturb_elements!(p)
        perturb_elements!(p)
        @test p.value == 2
        p = EnumParameter([FloatParameter(1.1, 4.2, 3.221, "test"),
                           FloatParameter(2.3, 4.4, 3.1, "test")], "test")
        perturb!(p)
        perturb!(p)
        perturb!(p)
        @test p.values[1].value == 3.221
        p = EnumParameter([StringParameter("valuea", "test"),
                           StringParameter("valueb", "test")], "test")
        perturb!(p)
        perturb!(p)
        perturb!(p)
        @test p.values[1].value == "valuea"
        p = EnumParameter([EnumParameter([StringParameter("a", "test")], "test"),
                           StringParameter("b", "test"),
                           IntegerParameter(1, 4, 3, "test"),
                           EnumParameter([StringParameter("c", "test")], "test")],
                           "test")
        v = p.current
        perturb_elements!(p, 3, 2)
        perturb_elements!(p, 3, 2)
        perturb_elements!(p, 3, 2)
        @test p.current == v
        v = p.values[3]
        @test v.value <= v.max
        @test v.value >= v.min
        perturb_elements!(p, [2, 3, 4])
        v = p.values[3]
        @test v.value <= v.max
        @test v.value >= v.min
        @test_throws MethodError    perturb_elements!(p, 2, 2)
        @test_throws MethodError    perturb_elements!(p, 2)
        @test_throws ErrorException perturb_elements!(p, [1,3,4,5,6,3])
    end
    @testset "neighbor!" begin
        p = EnumParameter([IntegerParameter(1, 4, 3, "test"),
                           StringParameter("b", "test"),
                           IntegerParameter(1, 6, 3, "test")], 2, "test")
        n = p.current
        neighbor!(p)
        @test n != p.value
        @test_throws MethodError neighbor!(p, 8, 20)
        @test_throws MethodError neighbor!(p, 3.2231)
    end
end

@testset "PermutationParameter" begin
    @testset "constructor" begin
        a = [1, 2, 3, 4, 5, 6]
        p = PermutationParameter(a, "test")
        @test typeof(p) <: PermutationParameter
        @test p.value == a
        @test p.size == length(a)
    end
    @testset "neighbor!" begin
        a = [1, 2, 3, 4, 5, 6]
        b = [1, 2, 3, 4, 5, 6]
        p = PermutationParameter(a, "test")
        @test p.value == b
        print(p)
        neighbor!(p)
        print(p)
        print(p)
        neighbor!(p, interval = 2)
        print(p)
        @test p.value != b
        @test p.size == length(b)
    end
    @testset "perturb!" begin
        a = [1, 2, 3, 4, 5, 6]
        b = [1, 2, 3, 4, 5, 6]
        p = PermutationParameter(a, "test")
        @test p.value == b
        print(p)
        perturb!(p)
        print(p)
        @test p.value != b
        @test p.size == length(b)
    end
end

@testset "StringParameter" begin
    @testset "constructor" begin
        p = StringParameter("value", "test")
        @test typeof(p) == StringParameter
        @test typeof(p) <: Parameter
        @test p.value == "value"
        @test p.name  == "test"
        @test_throws MethodError perturb!(p)
        @test_throws MethodError StringParameter(2, "test")
    end
end

@testset "BoolParameter" begin
    @testset "constructor" begin
        p = BoolParameter(false, "test")
        @test typeof(p.value) == Bool
        p = BoolParameter(0, "test")
        @test p.value == false
        p = BoolParameter(1, "test")
        @test p.value == true
        @test_throws MethodError BoolParameter("must have start value")
    end
    @testset "perturb!" begin
        p = BoolParameter(false, "test")
        perturb!(p)
        @test p.value == true
    end
    @testset "neighbor!" begin
        p = BoolParameter(false, "test")
        neighbor!(p)
        @test p.value == true
        print(p)
    end
end
