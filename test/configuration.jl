using StochasticSearch, FactCheck

facts("[Configuration]") do
    context("[Configuration] constructors") do
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
    context("[Configuration] perturb!") do
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
        @fact (typeof(r[:test1][:c]) <: Number)             => true
        @fact (r[:i2]        == "value")                    => true
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
end
