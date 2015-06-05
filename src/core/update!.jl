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

update!{T <: Parameter}(configuration::Configuration, parameters::Dict{ASCIIString, T}) = begin
    key_set = collect(keys(parameters))
    for key in key_set
        configuration[key] = deepcopy(parameters[key])
    end
    update!(configuration)
    configuration
end

update!{T <: Any}(configuration::Configuration,
                     parameters::Array{T},
                     legend::Array{ASCIIString}) = begin
    for i in 1:length(parameters)
        @inbounds symbol = legend[i]
        configuration[symbol].value = parameters[i]
    end
    update!(configuration)
    configuration
end
