type Configuration{T <: Parameter} <: Parameter
    parameters::Dict{ASCIIString, T}
    name::ASCIIString
    value::Dict{ASCIIString, Any}

    function call{T <: Parameter}(::Type{Configuration}, parameters::Dict{ASCIIString, T}, name::ASCIIString)
        values = Dict{ASCIIString, Any}()
        for key in keys(parameters)
            @inbounds values[key] = parameters[key].value
        end
        new{T}(parameters, name, values)

    end

    function call{T <: Parameter}(::Type{Configuration}, parameters::Array{T, 1}, name::ASCIIString)
        params = Dict{ASCIIString, T}()
        values = Dict{ASCIIString, Any}()
        for parameter in parameters
            @inbounds params[parameter.name] = parameter
            @inbounds values[parameter.name] = parameter.value
        end
        new{T}(params, name, values)
    end

    function call(::Type{Configuration}, name::ASCIIString)
        params = Dict{ASCIIString, Parameter}()
        new{Parameter}(params, name, params)
    end
end

function Base.convert{T <: Parameter}(::Type{Array{T}}, configuration::Configuration)
    parameter_array = T[]
    for key in collect(keys(configuration.parameters))
        push!(parameter_array, configuration[key])
    end
    parameter_array
end

function getindex(configuration::Configuration, index::ASCIIString)
    configuration.parameters[index]
end

function setindex!{T <: Parameter}(configuration::Configuration, value::T, index::ASCIIString)
    configuration.parameters[index] = value
end
