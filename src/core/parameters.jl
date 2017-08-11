abstract type Parameter end

mutable struct BoolParameter <: Parameter
    value::Bool
    name::String
end

mutable struct NumberParameter{T <: Number} <: Parameter
    min::T
    max::T
    value::T
    name::String

    function NumberParameter{T}(min::T, max::T, value::T, name::String) where T <: Number
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        end
        new(min, max, value, name)
    end

    function NumberParameter{T}(min::T, max::T, name::String) where T <: Number
        if min > max
            error("invalid bounds: min > max")
        end
        new(min, max, rand_in(min, max), name)
    end

    function NumberParameter{T}(value::T, name::String) where T <: Number
        new(value, value, value, name)
    end
end

mutable struct EnumParameter{P <: Parameter, T <: AbstractArray} <: Parameter
    values::T
    value::Int
    name::String
    current::P

    function EnumParameter{P, T}(values::T, value::Int, name::String) where {P <: Parameter, T <: AbstractArray}
        if value > length(values) || value < 1
            error("value is out of bounds.")
        end
        new{P, T}(values, value, name, values[value])
    end

    function EnumParameter{P, T}(values::T, name::String) where {P <: Parameter, T <: AbstractArray}
        value = rand(1:length(values))
        new{P, T}(values, value, name, values[value])
    end
end

function EnumParameter(values::T, value::Int, name::String) where T <: AbstractArray
    EnumParameter{Parameter, T}(values, value, name)
end

function EnumParameter(values::T, name::String) where T <: AbstractArray
    EnumParameter{Parameter, T}(values, name)
end

mutable struct PermutationParameter{T <: AbstractArray} <: Parameter
    value::T
    size::Int
    name::String

    function PermutationParameter{T}(value::T, name::String) where T <: AbstractArray
        new(value, length(value), name)
    end
end

function PermutationParameter(value::T, name::String) where T <: AbstractArray
    PermutationParameter{T}(value, name)
end

mutable struct StringParameter <: Parameter
    value::String
    name::String
end

function StringParameter(value::String)
    StringParameter(value, value)
end

const IntegerParameter = NumberParameter{Integer}
const FloatParameter   = NumberParameter{AbstractFloat}
