neighbor!(bool::BoolParameter) = begin
    perturb!(bool)
end

neighbor!(number::NumberParameter, interval::Number = 10, distance::Integer = 1) = begin
    for i = 1:distance
        previous = number.value
        while number.value == previous
            perturb!(number, interval)
        end
    end
    number
end

neighbor!(enum::EnumParameter, distance::Integer = 1) = begin
    for i = 1:distance
        previous = enum.value
        while enum.value == previous
            perturb!(enum)
        end
    end
    enum
end

neighbor!(configuration::Configuration, intervals::Dict{ASCIIString, Any}, distance::Integer = 1) = begin
    key_set = collect(keys(intervals))
    target  = key_set[rand(1:length(key_set))]
    for i = 1:distance
        neighbor!(configuration[target], intervals[target])
    end
    update!(configuration)
    configuration
end

neighbor!(configuration::Configuration, distance::Integer = 1) = begin
    key_set = collect(keys(configuration.parameters))
    target  = key_set[rand(1:length(key_set))]
    for i = 1:distance
        if !(typeof(configuration[target]) <: StringParameter)
            neighbor!(configuration[target])
        end
    end
    update!(configuration)
    configuration
end
