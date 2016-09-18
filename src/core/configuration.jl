type Configuration{T <: Parameter} <: Parameter
    parameters::Dict{String, T}
    name::String
    value::Dict{String, Any}

    function Configuration(parameters::Dict{String, T}, name::String, values::Dict{String, Any})
        for key in keys(parameters)
            @inbounds values[key] = parameters[key].value
        end
        new(parameters, name, values)
    end
end

function Configuration{T <: Parameter}(parameters::Dict{String, T}, name::String)
    Configuration{T}(parameters, name, Dict{String, Any}())
end

function Configuration{T <: Parameter}(parameters::Array{T, 1}, name::String)
    params = Dict{String, T}()
    for parameter in parameters
        @inbounds params[parameter.name] = parameter
    end
    Configuration{T}(params, name, Dict{String, Any}())
end

function Configuration(name::String)
    params = Dict{String, Parameter}()
    Configuration{Parameter}(params, name, Dict{String, Any}())
end

function Base.convert{T <: Parameter}(::Type{Array{T}}, configuration::Configuration)
    parameter_array = T[]
    for key in collect(keys(configuration.parameters))
        push!(parameter_array, configuration[key])
    end
    parameter_array
end

function getindex(configuration::Configuration, index::String)
    configuration.parameters[index]
end

function setindex!{T <: Parameter}(configuration::Configuration, value::T, index::String)
    configuration.parameters[index] = value
end
