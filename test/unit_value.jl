using StochasticSearch, FactCheck

facts("[unit_value]") do
    context("EnumParameter") do
        p = EnumParameter([StringParameter("value", "i0"),
                           NumberParameter(1.3, 56.3, 3.3, "i1"),
                           NumberParameter(1, 40, 3, "i3")],
                           "test")
        c = p.value
        u = unit_value(p)
        v = unit_value!(p, u)
        @fact (unit_value!(p, u) == c)     --> true
        @fact (1 <= v <= length(p.values)) --> true
    end
    context("IntegerParameter") do
        p = IntegerParameter(1, 40, 23, "i0")
        c = p.value
        u = unit_value(p)
        v = unit_value!(p, u)
        @fact (unit_value!(p, u) == c)     --> true
        @fact (p.min <= v <= p.max)        --> true
    end
    context("FloatParameter") do
        p = FloatParameter(1.0, 40.0, 23.0, "i0")
        c = p.value
        u = unit_value(p)
        v = unit_value!(p, u)
        # Inexact conversion.
        @fact (p.min <= v <= p.max)        --> true
        @fact (unit_value!(p, u) == c)     --> true
    end
end
