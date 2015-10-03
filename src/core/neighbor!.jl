function neighbor!(bool::BoolParameter)
    perturb!(bool)
end

function neighbor!(number::NumberParameter, interval::Number = 10, distance::Int = 1)
    for i = 1:distance
        previous = number.value
        while number.value == previous
            perturb!(number, interval)
        end
    end
    number
end

function neighbor!(enum::EnumParameter, distance::Int = 1)
    for i = 1:distance
        previous = enum.value
        while enum.value == previous
            perturb!(enum)
        end
    end
    enum
end

function neighbor!(permutation::PermutationParameter, distance::Int = 1)
    perturb!(permutation, distance)
end

function neighbor!(configuration::Configuration, 
                   intervals::Dict{ASCIIString, Any}, distance::Int = 1)
    key_set = collect(keys(intervals))
    target  = key_set[rand(1:length(key_set))]
    for i = 1:distance
        neighbor!(configuration[target], intervals[target])
    end
    update!(configuration)
    configuration
end

function neighbor!(configuration::Configuration, distance::Int = 1)
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

function neighbor!(configuration::Configuration, target::ASCIIString,  distance::Int = 1)
    for i = 1:distance
        if !(typeof(configuration[target]) <: StringParameter)
            neighbor!(configuration[target])
        end
    end
    update!(configuration)
    configuration
end
