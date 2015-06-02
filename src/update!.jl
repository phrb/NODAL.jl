update!(configuration::Configuration) = begin
    for key in keys(configuration.parameters)
        configuration.value[key] = configuration[key].value
    end
end
