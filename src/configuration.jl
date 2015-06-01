type Configuration{T <: Parameter} <: Parameter
    parameters::Dict{Symbol, T}
    previous::Dict{Symbol, T}
    name::Symbol

    Configuration(parameters::Array{T, 1}, name::Symbol) = begin
        params = Dict{Symbol, T}()
        for parameter in parameters
            params[parameter.name] = parameter
        end
        new(params, params, name)
    end

    Configuration(parameters::Dict{Symbol, T}, name::Symbol) = begin
        new(parameters, parameters, name)
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
