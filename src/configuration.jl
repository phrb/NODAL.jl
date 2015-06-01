type Configuration <: Parameter
    parameters::Dict{Symbol, Parameter}
    previous::Dict{Symbol, Parameter}
    name::Symbol
    Configuration(parameters::Array{Parameter, 1}, name::Symbol) = begin
        params = Dict{Symbol, Parameter}()
        for parameter in parameters
            params[parameter.name] = parameter
        end
        new(params, params, name)
    end
    Configuration(parameters::Dict{Symbol, Parameter}, name::Symbol) = begin
        new(parameters, parameters, name)
    end
end

getindex(configuration::Configuration, index::Symbol) = begin
    configuration.parameters[index]
end
