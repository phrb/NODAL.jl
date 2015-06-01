type GenericConfiguration{T <: Parameter} <: Parameter
    parameters::Dict{Symbol, T}
    previous::Dict{Symbol, T}
    name::Symbol
    GenericConfiguration{T <: Parameter}(parameters::Array{T, 1}, name::Symbol) = begin
        params = Dict{Symbol, T}()
        for parameter in parameters
            params[parameter.name] = parameter
        end
        new(params, params, name)
    end
    GenericConfiguration{T <: Parameter}(parameters::Dict{Symbol, T}, name::Symbol) = begin
        new(parameters, parameters, name)
    end
end

typealias Configuration GenericConfiguration{Parameter}

getindex(configuration::GenericConfiguration, index::Symbol) = begin
    configuration.parameters[index]
end
