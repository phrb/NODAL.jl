update!(configuration::Configuration) = begin
    for key in keys(configuration.parameters)
        configuration.value[key] = configuration[key].value
    end
    configuration
end

update!{T <: Parameter}(configuration::Configuration, parameters::Array{T}) = begin
    for param in parameters
        configuration[param.name] = deepcopy(param)
    end
    update!(configuration)
    configuration
end

update!{T <: Parameter}(configuration::Configuration, parameters::Dict{Symbol, T}) = begin
    key_set = collect(keys(parameters))
    for key in key_set
        configuration[key] = deepcopy(parameters[key])
    end
    update!(configuration)
    configuration
end

update!{T <: Number}(configuration::Configuration,
                     parameters::Array{T},
                     dict::Array{Symbol}) = begin
    i = 1
    while i <= length(parameters)
        configuration[dict[floor(i / 4) + 1]].value = parameters[i]
        i += 3
    end
    update!(configuration)
    configuration
end
