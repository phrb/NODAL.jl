@testset "unit_value" begin
    @testset "EnumParameter" begin
        p = EnumParameter([StringParameter("value", "i0"),
                           FloatParameter(1.3, 56.3, 3.3, "i1"),
                           IntegerParameter(1, 40, 3, "i3")],
                           "test")
        c = p.value
        u = unit_value(p)
        v = unit_value!(p, u)
        @test unit_value!(p, u) == c
        @test 1 <= v <= length(p.values)
    end
    @testset "IntegerParameter" begin
        p = IntegerParameter(1, 40, 23, "i0")
        c = p.value
        u = unit_value(p)
        v = unit_value!(p, u)
        @test unit_value!(p, u) == c
        @test p.min <= v <= p.max
    end
    @testset "FloatParameter" begin
        p = FloatParameter(1.0, 40.0, 23.0, "i0")
        c = p.value
        u = unit_value(p)
        v = unit_value!(p, u)
        # Inexact conversion.
        @test p.min <= v <= p.max
        @test unit_value!(p, u) == c
    end
end
