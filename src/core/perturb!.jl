function perturb!(bool::BoolParameter)
    bool.value = !(bool.value)
    bool
end

function perturb!(number::NumberParameter)
    typeof(number.value) <: Integer ?
    perturb!(number, 1) : perturb!(number, 1.)
end

function perturb!(number::NumberParameter, interval::Number)
    if interval <= 0
        error("interval must be greater than zero.")
    end
    max = number.value + interval > number.max ? number.max : number.value + interval
    min = number.value - interval < number.min ? number.min : number.value - interval
    number.value = rand_in(min, max)
    number
end

function perturb!(enum::EnumParameter)
    enum.value = rand(1:length(enum.values))
    @inbounds enum.current = enum.values[enum.value]
    enum
end

function perturb!(permutation::PermutationParameter)
    shuffle!(permutation.value)
    permutation
end

function perturb!(permutation::PermutationParameter, interval::Int)
    for i = 1:interval
        a = rand(1:permutation.size)
        b = rand(1:permutation.size)
        while b == a
            b = rand(1:permutation.size)
        end
        permutation.value[a], permutation.value[b] = permutation.value[b],
                                                     permutation.value[a]
    end
    permutation
end

function perturb!(configuration::Configuration)
    for key in keys(configuration.parameters)
        if !(typeof(configuration[key]) <: StringParameter)
            perturb!(configuration[key])
        end
    end
    update!(configuration)
    configuration
end

function perturb!(configuration::Configuration, intervals::Dict{String, Any})
    for key in keys(intervals)
        @inbounds perturb!(configuration[key], intervals[key])
    end
    update!(configuration)
    configuration
end
