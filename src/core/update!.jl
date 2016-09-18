function update!(configuration::Configuration)
    for key in keys(configuration.parameters)
        configuration.value[key] = configuration[key].value
    end
    configuration
end

function update!{T <: Parameter}(configuration::Configuration, parameters::Array{T})
    for param in parameters
        configuration[param.name] = deepcopy(param)
    end
    update!(configuration)
    configuration
end

function update!{T <: Parameter}(configuration::Configuration, parameters::Dict{String, T})
    key_set = collect(keys(parameters))
    for key in key_set
        configuration[key] = deepcopy(parameters[key])
    end
    update!(configuration)
    configuration
end
