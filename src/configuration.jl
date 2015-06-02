type Configuration{T <: Parameter} <: Parameter
    parameters::Dict{Symbol, T}
    previous::Dict{Symbol, T}
    name::Symbol
    costs::Dict{Symbol, Float64}

    Configuration(parameters::Array{T, 1}, name::Symbol) = begin
        params = Dict{Symbol, T}()
        for parameter in parameters
            params[parameter.name] = parameter
        end
        new(params, params, name, Dict{Symbol, Float64}())
    end

    Configuration(parameters::Dict{Symbol, T}, name::Symbol) = begin
        new(parameters, parameters, name, Dict{Symbol, Float64}())
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

perturbate!(configuration::Configuration) = begin
    new_parameters = deepcopy(configuration.parameters)
    configuration.previous = configuration.parameters
    for key in keys(new_parameters)
        if typeof(new_parameters[key]) <: NumberParameter
            perturbate!(new_parameters[key])
        end
    end
    configuration.parameters = new_parameters
end

perturbate!(configuration::Configuration, intervals::Dict{Symbol, Any}) = begin
    new_parameters = deepcopy(configuration.parameters)
    configuration.previous = configuration.parameters
    for key in keys(intervals)
        perturbate!(new_parameters[key], intervals[key])
    end
    configuration.parameters = new_parameters
end

discard!(configuration::Configuration) = begin
    previous                 = configuration.previous
    configuration.previous   = configuration.parameters
    configuration.parameters = previous
end
