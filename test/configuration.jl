using StochasticSearch, FactCheck

facts("[Configuration] constructors") do
    p = [StringParameter("value",  :a),
         IntegerParameter(1, 5, 4, :b)]
    c = Configuration(p, :test)
    @fact (c[:a] == p[1])              => true
    @fact (c[:b] == p[2])              => true
    @fact (c.previous[:a] == p[1])     => true
    @fact (c.previous[:b] == p[2])     => true
    @fact (c.previous == c.parameters) => true
    p = Dict{Symbol, Parameter}()
    p[:c] = StringParameter("value",  :a)
    p[:d] = IntegerParameter(1, 5, 4, :b)
    c = Configuration(p, :test)
    @fact (c[:c] == p[:c])             => true
    @fact (c[:d] == p[:d])             => true
    p = [StringParameter("valuea",  :a),
         StringParameter("valueb", :b)]
    c = Configuration(p, :test)
    @fact (c[:a] == p[1])              => true
    @fact (c[:b] == p[2])              => true
    @fact (c.previous[:a] == p[1])     => true
    @fact (c.previous[:b] == p[2])     => true
    @fact (c.previous == c.parameters) => true
end
