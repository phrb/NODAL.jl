type Configuration{T <: Parameter} <: Parameter
    parameters::Dict{Symbol, T}
    name::Symbol
    value::Dict{Symbol, Any}

    Configuration(parameters::Array{T, 1}, name::Symbol) = begin
        params = Dict{Symbol, T}()
        values = Dict{Symbol, Any}()
        for parameter in parameters
            params[parameter.name] = parameter
            values[parameter.name] = parameter.value
        end
        new(params, name, values)
    end

    Configuration(parameters::Dict{Symbol, T}, name::Symbol) = begin
        values = Dict{Symbol, Any}()
        for key in keys(parameters)
            values[key] = parameters[key].value
        end
        new(parameters, name, values)
    end
end

Configuration{T <: Parameter}(parameters::Array{T, 1}, name::Symbol) = begin
    Configuration{T}(parameters, name)
end

Configuration{T <: Parameter}(parameters::Dict{Symbol, T}, name::Symbol) = begin
    Configuration{T}(parameters, name)
end

getindex(configuration::Configuration, index::Symbol) = begin
    configuration.parameters[index]
end

perturb!(configuration::Configuration) = begin
    result = Dict{Symbol, Any}()
    for key in keys(configuration.parameters)
        if typeof(configuration[key]) <: NumberParameter ||
                typeof(configuration[key]) <: EnumParameter
            perturb!(configuration[key])
        end
        result[key] = configuration[key].value
    end
    update!(configuration)
    result
end

perturb!(configuration::Configuration, intervals::Dict{Symbol, Any}) = begin
    result = Dict{Symbol, Any}()
    for key in keys(intervals)
        perturb!(configuration[key], intervals[key])
        result[key] = configuration[key].value
    end
    update!(configuration)
    result
end

update!(configuration::Configuration) = begin
    for key in keys(configuration.parameters)
        configuration.value[key] = configuration[key].value
    end
end
