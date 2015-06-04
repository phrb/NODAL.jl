perturb!(number::NumberParameter) = begin
    number.value = rand_in(number.min, number.max)
end

perturb!(number::NumberParameter, interval::Number) = begin
    if interval <= 0
        error("interval must be greater than zero.")
    end
    max = number.value + interval > number.max ? number.max : number.value + interval
    min = number.value - interval < number.min ? number.min : number.value - interval
    number.value = rand_in(min, max)
end

perturb!(enum::EnumParameter) = begin
    enum.current = rand(1:length(enum.values))
    @inbounds enum.value   = enum.values[enum.current]
end

perturb!(configuration::Configuration) = begin
    result = Dict{Symbol, Any}()
    for key in keys(configuration.parameters)
        if typeof(configuration[key]) <: NumberParameter ||
                typeof(configuration[key]) <: EnumParameter
            perturb!(configuration[key])
        end
        result[key] = configuration[key].value
    end
    update!(configuration)
    result
end

perturb!(configuration::Configuration, intervals::Dict{Symbol, Any}) = begin
    result = Dict{Symbol, Any}()
    for key in keys(intervals)
        @inbounds perturb!(configuration[key], intervals[key])
        result[key] = configuration[key].value
    end
    update!(configuration)
    result
end
