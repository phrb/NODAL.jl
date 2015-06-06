using StochasticSearch, FactCheck

facts("[Configuration]") do
    context("constructors") do
        c = Configuration("test")
        p = [StringParameter("value",  "test1"),
             IntegerParameter(1, 5, 4, "test2")]
        c = Configuration(p, "test")
        @fact (c["test1"] == p[1])                   => true
        @fact (c["test2"] == p[2])                   => true
        p = Dict{ASCIIString, Parameter}()
        p["test1"] = StringParameter("value",  "test")
        p["test2"] = IntegerParameter(1, 5, 4, "test")
        c = Configuration(p, "test")
        @fact (c["test1"] == p["test1"])             => true
        @fact (c["test2"] == p["test2"])             => true
        p = [StringParameter("valuea",  "test1"),
             StringParameter("valueb", "test2"),
             NumberParameter(1, 44, 3, "test3")]
        c = Configuration(p, "test")
        @fact (c["test1"] == p[1])                   => true
        @fact (c["test2"] == p[2])                   => true
    end
    context("perturb!") do
        p = [StringParameter("valuea",  "test1"),
             StringParameter("valueb", "test2"),
             NumberParameter(1, 44, 3, "test3")]
        t = Configuration(p, "test1")
        l = [NumberParameter(1, 38, 3, "i0"),
             NumberParameter(4, 66, 55, "i1"),
             StringParameter("value", "i2"),
             NumberParameter(2.33, 85.33, 22.2, "i3"),
             t]
        c = Configuration(l, "test")
        r = perturb!(c)
        @fact (typeof(r["test1"]) <: Configuration)              => true
        @fact (r["test1"]["test1"].value == "valuea")            => true
        @fact (r["test1"]["test2"].value == "valueb")            => true
        @fact (r["i2"].value             == "value")             => true
        @fact (typeof(r["test1"]["test3"]) <: NumberParameter)   => true
        @fact (typeof(r["i0"])             <: NumberParameter)   => true
        @fact (typeof(r["i1"])             <: NumberParameter)   => true
        @fact (typeof(r["i3"])             <: NumberParameter)   => true
        d = Dict{ASCIIString, Any}()
        d["i0"]             = 3
        d["i1"]             = 4
        d["i3"]             = 2.3
        d["test1"]          = Dict{ASCIIString, Any}()
        d["test1"]["test3"] = 2
        @fact (typeof(perturb!(c, d)) <: Configuration)          => true
        r = perturb!(c, d)
        @fact (r["i0"].value == c["i0"].value)                   => true
        @fact (r["i1"].value == c["i1"].value)                   => true
        @fact (r["i3"].value == c["i3"].value)                   => true
        @fact (r["test1"]["test3"] == c["test1"]["test3"])       => true
        d["test1"]["test1"] = 23
        @fact_throws MethodError perturb!(c, d)
    end
    context("neighbor!") do
        l = [NumberParameter(1, 38, 3, "i0"),
             NumberParameter(4, 66, 55, "i1"),
             StringParameter("value", "i2"),
             NumberParameter(2.33, 85.33, 22.2, "i3")]
        d = Dict{ASCIIString, Any}()
        c = Configuration(l, "test")
        println(c)
        d["i0"] = 5
        v = c["i0"].value
        neighbor!(c, d, 20)
        @fact (v != c["i0"].value)                               => true
        v = c["i0"].value
        neighbor!(c, d, 9)
        d = Dict{ASCIIString, Any}()
        d["i2"] = 5
        @fact_throws MethodError neighbor!(c, d)
        @fact_throws MethodError neighbor!(c, d, 2)
        l = [NumberParameter(1, 38, 3, "i0")]
        c = Configuration(l, "test2")
        v = c["i0"].value
        neighbor!(c, 20)
        @fact (v != c["i0"].value)                           => true
    end
    context("update! and convert!") do
        c     = Configuration("test")
        c["test"] = NumberParameter(1, 2323, 2, "i0")
        a     = convert(Array{Parameter}, c)
        @fact (a[1] == c["test"])                            => true
        push!(a, StringParameter("name", "i2"))
        update!(c, a)
        @fact (c["i2"] != a[1])                              => true
        @fact (c["i2"].value == a[2].value)                  => true
    end
end
