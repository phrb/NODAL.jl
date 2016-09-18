abstract Parameter

type BoolParameter <: Parameter
    value::Bool
    name::String
end

type NumberParameter{T <: Number} <: Parameter
    min::T
    max::T
    value::T
    name::String

    function call{T <: Number}(::Type{NumberParameter{T}}, min::T, max::T, value::T, name::String)
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        end
        new{T}(min, max, value, name)
    end
    
    function call{T <: Number}(::Type{NumberParameter{T}}, value::T, name::String)
        new{T}(value, value, value, name)
    end
    
    function call{T <: Number}(::Type{NumberParameter{T}}, min::T, max::T, name::String)
        if min > max
            error("invalid bounds: min > max")
        end
        new{T}(min, max, rand_in(min, max), name)
    end
end

type EnumParameter{P <: Parameter, T <: AbstractArray} <: Parameter
    values::T
    value::Int
    name::String
    current::P

    function EnumParameter(values::T, value::Int, name::String)
        if value > length(values) || value < 1
            error("value is out of bounds.")
        end
        new(values, value, name, values[value])
    end

    function EnumParameter(values::T, name::String)
        value = rand(1:length(values))
        new(values, value, name, values[value])
    end
end

function EnumParameter{T <: AbstractArray}(values::T, value::Int, name::String)
    EnumParameter{Parameter, T}(values, value, name)
end

function EnumParameter{T <: AbstractArray}(values::T, name::String)
    EnumParameter{Parameter, T}(values, name)
end

type PermutationParameter{T <: AbstractArray} <: Parameter
    value::T
    size::Int
    name::String

    function PermutationParameter(value::T, name::String)
        new(value, length(value), name)
    end
end

function PermutationParameter{T <: AbstractArray}(value::T, name::String)
    PermutationParameter{T}(value, name)
end

type StringParameter <: Parameter
    value::String
    name::String
end

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{AbstractFloat}
