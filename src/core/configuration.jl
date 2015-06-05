type Configuration{T <: Parameter} <: Parameter
    parameters::Dict{ASCIIString, T}
    name::ASCIIString
    value::Dict{ASCIIString, Any}

    Configuration(parameters::Array{T, 1}, name::ASCIIString) = begin
        params = Dict{ASCIIString, T}()
        values = Dict{ASCIIString, Any}()
        for parameter in parameters
            @inbounds params[parameter.name] = parameter
            @inbounds values[parameter.name] = parameter.value
        end
        new(params, name, values)
    end

    Configuration(parameters::Dict{ASCIIString, T}, name::ASCIIString) = begin
        values = Dict{ASCIIString, Any}()
        for key in keys(parameters)
            @inbounds values[key] = parameters[key].value
        end
        new(parameters, name, values)
    end
end

Configuration{T <: Parameter}(parameters::Array{T, 1}, name::ASCIIString) = begin
    Configuration{T}(parameters, name)
end

Configuration{T <: Parameter}(parameters::Dict{ASCIIString, T}, name::ASCIIString) = begin
    Configuration{T}(parameters, name)
end

Configuration(name::ASCIIString) = begin
    params = Dict{ASCIIString, Parameter}()
    Configuration{Parameter}(params, name)
end

Base.convert{T <: Parameter}(::Type{Array{T}}, configuration::Configuration) = begin
    parameter_array = T[]
    for key in collect(keys(configuration.parameters))
        push!(parameter_array, configuration[key])
    end
    parameter_array
end

Base.convert{T <: Any}(::Type{Array{T}}, configuration::Configuration, legend::Array{ASCIIString}) = begin
    parameter_array = T[]
    for key in collect(keys(configuration.value))
        parameter = configuration[key]
        push!(parameter_array, parameter.value)
        push!(legend, key)
    end
    parameter_array
end

getindex(configuration::Configuration, index::ASCIIString) = begin
    configuration.parameters[index]
end

setindex!{T <: Parameter}(configuration::Configuration, value::T, index::ASCIIString) = begin
    configuration.parameters[index] = value
end
