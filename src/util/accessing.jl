getindex(configuration::Configuration, index::Symbol) = begin
    configuration.parameters[index]
end
