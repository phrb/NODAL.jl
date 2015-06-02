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
