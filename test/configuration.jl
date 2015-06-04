using StochasticSearch, FactCheck

facts("[Configuration]") do
    context("constructors") do
        p = [StringParameter("value",  :a),
             IntegerParameter(1, 5, 4, :b)]
        c = Configuration(p, :test)
        @fact (c[:a] == p[1])                    => true
        @fact (c[:b] == p[2])                    => true
        p = Dict{Symbol, Parameter}()
        p[:c] = StringParameter("value",  :a)
        p[:d] = IntegerParameter(1, 5, 4, :b)
        c = Configuration(p, :test)
        @fact (c[:c] == p[:c])                   => true
        @fact (c[:d] == p[:d])                   => true
        p = [StringParameter("valuea",  :a),
             StringParameter("valueb", :b),
             NumberParameter(1, 44, 3, :c)]
        c = Configuration(p, :test)
        @fact (c[:a] == p[1])                    => true
        @fact (c[:b] == p[2])                    => true
    end
    context("perturb!") do
        p = [StringParameter("valuea",  :a),
             StringParameter("valueb", :b),
             NumberParameter(1, 44, 3, :c)]
        t = Configuration(p, :test1)
        l = [NumberParameter(1, 38, 3, :i0),
             NumberParameter(4, 66, 55, :i1),
             StringParameter("value", :i2),
             NumberParameter(2.33, 85.33, 22.2, :i3),
             t]
        c = Configuration(l, :test)
        r = perturb!(c)
        @fact (typeof(r[:test1])) == Dict{Symbol, Any}      => true
        @fact (r[:test1][:a] == "valuea")                   => true
        @fact (r[:test1][:b] == "valueb")                   => true
        @fact (r[:i2]        == "value")                    => true
        @fact (typeof(r[:test1][:c]) <: Number)             => true
        @fact (typeof(r[:i0])        <: Number)             => true
        @fact (typeof(r[:i1])        <: Number)             => true
        @fact (typeof(r[:i3])        <: Number)             => true
        d = Dict{Symbol, Any}()
        d[:i0]        = 3
        d[:i1]        = 4
        d[:i3]        = 2.3
        d[:test1]     = Dict{Symbol, Any}()
        d[:test1][:c] = 2
        @fact (typeof(perturb!(c, d)) == Dict{Symbol, Any}) => true
        r = perturb!(c, d)
        @fact (r[:i0] == c[:i0].value)                      => true
        @fact (r[:i1] == c[:i1].value)                      => true
        @fact (r[:i3] == c[:i3].value)                      => true
        @fact (r[:test1][:c] == c[:test1][:c].value)        => true
        d[:test1][:b] = 23
        @fact_throws MethodError perturb!(c, d)
    end
    context("neighbor!") do
        l = [NumberParameter(1, 38, 3, :i0),
             NumberParameter(4, 66, 55, :i1),
             StringParameter("value", :i2),
             NumberParameter(2.33, 85.33, 22.2, :i3)]
        d = Dict{Symbol, Any}()
        c = Configuration(l, :test)
        println(c)
        d[:i0] = 5
        v = c[:i0].value
        neighbor!(c, d)
        @fact (v != c[:i0].value)                           => true
        v = c[:i0].value
        neighbor!(c, d, 9)
        d = Dict{Symbol, Any}()
        d[:i2] = 5
        @fact_throws MethodError neighbor!(c, d)
        @fact_throws MethodError neighbor!(c, d, 2)
        @fact_throws MethodError neighbor!(c)
    end
    context("update! and convert!") do
        c     = Configuration(:test)
        c[:a] = NumberParameter(1, 2323, 2, :i0)
        a     = convert(Array{Parameter}, c)
        @fact (a[1] == c[:a])                              => true
        push!(a, StringParameter("name", :i2))
        update!(c, a)
        @fact (c[:i2] != a[1])                             => true
        @fact (c[:i2].value == a[2].value)                 => true
    end
end
