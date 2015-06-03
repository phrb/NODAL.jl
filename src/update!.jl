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

update!{T <: Number}(configuration::Configuration, 
                     parameters::Array{T}, 
                     dict::Array{Symbol}) = begin
    i = 1
    while i <= length(parameters)
        configuration[dict[floor(i / 4) + 1]].value = parameters[i]
        i += 3
    end
    update!(configuration)
end
