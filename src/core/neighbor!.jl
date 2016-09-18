function neighbor!(bool::BoolParameter)
    perturb!(bool)
end

function neighbor!(number::NumberParameter;
                   interval::Number = typeof(number.value) <: Integer ?
                                      rand_in(1,
                                              number.max - number.min) :
                                      rand_in(1.,
                                              number.max - number.min),
                   distance::Int = 1)
    for i = 1:distance
        previous = number.value
        while number.value == previous
            perturb!(number, interval)
        end
    end
    number
end

function neighbor!(enum::EnumParameter; distance::Int = 1)
    for i = 1:distance
        previous = enum.value
        while enum.value == previous
            perturb!(enum)
        end
    end
    enum
end

function neighbor!(permutation::PermutationParameter;
                   interval = rand(1:permutation.size))
    perturb!(permutation, interval)
end

function neighbor!(configuration::Configuration,
                   intervals::Dict{String, Any}; distance::Int = 1)
    key_set = collect(keys(intervals))
    target  = key_set[rand(1:length(key_set))]
    for i = 1:distance
        neighbor!(configuration[target], distance = intervals[target])
    end
    update!(configuration)
    configuration
end

function neighbor!(configuration::Configuration; distance::Int = 1)
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

function neighbor!(configuration::Configuration, target::String;
                   distance::Int = 1)
    for i = 1:distance
        if !(typeof(configuration[target]) <: StringParameter)
            neighbor!(configuration[target])
        end
    end
    update!(configuration)
    configuration
end
