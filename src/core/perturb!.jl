perturb!(bool::BoolParameter) = begin
    bool.value = !(bool.value)
    bool
end

perturb!(number::NumberParameter) = begin
    number.value = rand_in(number.min, number.max)
    number
end

perturb!(number::NumberParameter, interval::Number) = begin
    if interval <= 0
        error("interval must be greater than zero.")
    end
    max = number.value + interval > number.max ? number.max : number.value + interval
    min = number.value - interval < number.min ? number.min : number.value - interval
    number.value = rand_in(min, max)
    number
end

perturb!(enum::EnumParameter) = begin
    enum.value = rand(1:length(enum.values))
    @inbounds enum.current   = enum.values[enum.value]
    enum
end

perturb!(configuration::Configuration) = begin
    for key in keys(configuration.parameters)
        if !(typeof(configuration[key]) <: StringParameter)
            perturb!(configuration[key])
        end
    end
    update!(configuration)
    configuration
end

perturb!(configuration::Configuration, intervals::Dict{ASCIIString, Any}) = begin
    for key in keys(intervals)
        @inbounds perturb!(configuration[key], intervals[key])
    end
    update!(configuration)
    configuration
end
