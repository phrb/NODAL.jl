@testset "Configuration" begin
    @testset "constructors" begin
        c = Configuration("test")
        p = [StringParameter("value",  "test1"),
             IntegerParameter(1, 5, 4, "test2")]
        c = Configuration(p, "test")
        @test c["test1"] == p[1]
        @test c["test2"] == p[2]
        p = Dict{String, Parameter}()
        p["test1"] = StringParameter("value",  "test")
        p["test2"] = IntegerParameter(1, 5, 4, "test")
        c = Configuration(p, "test")
        @test c["test1"] == p["test1"]
        @test c["test2"] == p["test2"]
        p = [StringParameter("valuea",  "test1"),
             StringParameter("valueb", "test2"),
             IntegerParameter(1, 44, 3, "test3")]
        c = Configuration(p, "test")
        @test c["test1"] == p[1]
        @test c["test2"] == p[2]
    end
    @testset "perturb!" begin
        p = [StringParameter("valuea",  "test1"),
             StringParameter("valueb", "test2"),
             IntegerParameter(1, 44, 3, "test3")]
        t = Configuration(p, "test1")
        l = [IntegerParameter(1, 38, 3, "i0"),
             IntegerParameter(4, 66, 55, "i1"),
             StringParameter("value", "i2"),
             FloatParameter(2.33, 85.33, 22.2, "i3"),
             t]
        c = Configuration(l, "test")
        r = perturb!(c)
        r = perturb!(c)
        r = perturb!(c)
        r = perturb!(c)
        @test typeof(r["test1"]) <: Configuration
        @test r["test1"]["test1"].value == "valuea"
        @test r["test1"]["test2"].value == "valueb"
        @test r["i2"].value             == "value"
        @test typeof(r["test1"]["test3"]) <: NumberParameter
        @test typeof(r["i0"])             <: NumberParameter
        @test typeof(r["i1"])             <: NumberParameter
        @test typeof(r["i3"])             <: NumberParameter
        d = Dict{String, Any}()
        d["i0"]                    = 3
        d["i1"]                    = 4
        d["i3"]                    = 2.3
        d["test1"]                 = Dict{String, Any}()
        d["test1"]["test3"]        = 2
        @test (typeof(perturb!(c, d)) <: Configuration)
        r                          = perturb!(c, d)
        r                          = perturb!(c, d)
        r                          = perturb!(c, d)
        r                          = perturb!(c, d)
        @test r["i0"].value       == c["i0"].value
        @test r["i1"].value       == c["i1"].value
        @test r["i3"].value       == c["i3"].value
        @test r["test1"]["test3"] == c["test1"]["test3"]
        d["test1"]["test1"]        = 23
        @test_throws MethodError perturb!(c, d)
    end
    @testset "neighbor!" begin
        l = [IntegerParameter(1, 38, 3, "i0"),
             IntegerParameter(4, 66, 55, "i1"),
             StringParameter("value", "i2"),
             FloatParameter(2.33, 85.33, 22.2, "i3")]
        d        = Dict{String, Any}()
        c        = Configuration(l, "test")
        println(c)
        d["i0"]  = 5
        v        = c["i0"].value
        neighbor!(c, d)
        @test v != c["i0"].value
        v        = c["i0"].value
        neighbor!(c, d, distance = 9)
        d        = Dict{String, Any}()
        d["i2"]  = 5
        @test_throws MethodError neighbor!(c, d)
        @test_throws MethodError neighbor!(c, d, 2)
        l        = [IntegerParameter(1, 38, 3, "i0")]
        c        = Configuration(l, "test2")
        v        = c["i0"].value
        neighbor!(c)
        @test v != c["i0"].value
    end
    @testset "update! and convert" begin
        c                    = Configuration("test")
        c["test"]            = IntegerParameter(1, 2323, 2, "i0")
        a                    = convert(Array{Parameter}, c)
        @test a[1]          == c["test"]
        push!(a, StringParameter("name", "i2"))
        update!(c, a)
        @test c["i2"]       != a[1]
        @test c["i2"].value == a[2].value
    end
end
