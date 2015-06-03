update!(configuration::Configuration) = begin
    for key in keys(configuration.parameters)
        configuration.value[key] = configuration[key].value
    end
end

update!{T <: Parameter}(configuration::Configuration, parameters::Array{T}) = begin
    for param in parameters
        configuration[param.name] = deepcopy(param)
    end
    update!(configuration)
end
