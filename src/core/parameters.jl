abstract Parameter

type BoolParameter <: Parameter
    value::Bool
    name::ASCIIString
end

type NumberParameter{T <: Number} <: Parameter
    min::T
    max::T
    value::T
    name::ASCIIString

    function NumberParameter(min::T, max::T, value::T, name::ASCIIString)
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        else
            new(min, max, value, name)
        end
    end
end

function NumberParameter{T <: Number}(min::T, max::T, value::T, name::ASCIIString)
    NumberParameter{T}(min, max, value, name)
end

function NumberParameter{T <: Number}(value::T, name::ASCIIString)
    NumberParameter{T}(value, value, value, name)
end

function NumberParameter{T <: Number}(min::T, max::T, name::ASCIIString)
    NumberParameter{T}(min, max, rand_in(min, max), name)
end

type EnumParameter{P <: Parameter, T <: AbstractArray} <: Parameter
    values::T
    value::Int
    name::ASCIIString
    current::P

    function EnumParameter(values::T, value::Int, name::ASCIIString)
        if value > length(values) || value < 1
            error("value is out of bounds.")
        end
        new(values, value, name, values[value])
    end

    function EnumParameter(values::T, name::ASCIIString)
        value = rand(1:length(values))
        new(values, value, name, values[value])
    end
end

function EnumParameter{T <: AbstractArray}(values::T, value::Int, name::ASCIIString)
    EnumParameter{Parameter, T}(values, value, name)
end

function EnumParameter{T <: AbstractArray}(values::T, name::ASCIIString)
    EnumParameter{Parameter, T}(values, name)
end

type PermutationParameter{T <: AbstractArray} <: Parameter
    value::T
    size::Int
    name::ASCIIString

    function PermutationParameter(value::T, name::ASCIIString)
        new(value, length(value), name)
    end
end

function PermutationParameter{T <: AbstractArray}(value::T, name::ASCIIString)
    PermutationParameter{T}(value, name)
end

type StringParameter <: Parameter
    value::ASCIIString
    name::ASCIIString
end

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{AbstractFloat}
