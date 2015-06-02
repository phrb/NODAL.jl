using StochasticSearch, FactCheck

facts("[Configuration]") do
    context("[Configuration] constructors") do
        p = [StringParameter("value",  :a),
             IntegerParameter(1, 5, 4, :b)]
        c = Configuration(p, :test)
        @fact (c[:a] == p[1])                    => true
        @fact (c[:b] == p[2])                    => true
        @fact (c.previous[:a] == p[1])           => true
        @fact (c.previous[:b] == p[2])           => true
        @fact (c.previous == c.parameters)       => true
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
        @fact (c.previous[:a] == p[1])           => true
        @fact (c.previous[:b] == p[2])           => true
        @fact (c.previous == c.parameters)       => true
    end
    context("[Configuration] perturbate!") do
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
        perturbate!(c)
        @fact (c.parameters != c.previous)       => true
        d = Dict{Symbol, Any}()
        d[:i0]        = 3
        d[:i1]        = 4
        d[:i3]        = 2.3
        d[:test1]     = Dict{Symbol, Any}()
        d[:test1][:c] = 2
        perturbate!(c, d)
        meta = c[:test1]
        @fact (meta.parameters != meta.previous) => true
        @fact (c.parameters != c.previous)       => true
        d[:test1][:b] = 23
        @fact_throws MethodError perturbate!(c, d)
    end
    context("[Configuration] discard!") do
        l = [NumberParameter(1, 38, 3, :i0),
             NumberParameter(4, 66, 55, :i1),
             StringParameter("value", :i2)]
        c = Configuration(l, :test)
        p = c.parameters
        perturbate!(c)
        @fact (is(c.previous, p))                => true
        discard!(c)
        @fact (!is(c.previous, p))               => true
        @fact (is(c.parameters, p))              => true
    end
end
