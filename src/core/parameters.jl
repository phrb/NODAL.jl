abstract Parameter

type NumberParameter{T <: Number} <: Parameter
    min::T
    max::T
    value::T
    name::ASCIIString

    NumberParameter(min::T, max::T, value::T, name::ASCIIString) = begin
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        else
            new(min, max, value, name)
        end
    end
end

NumberParameter{T <: Number}(min::T, max::T, value::T, name::ASCIIString) = begin
    NumberParameter{T}(min, max, value, name)
end

type EnumParameter{P <: Parameter, T <: AbstractArray} <: Parameter
    values::T
    value::Int
    name::ASCIIString
    current::P

    EnumParameter(values::T, value::Int, name::ASCIIString) = begin
        if value > length(values) || value < 1
            error("value is out of bounds.")
        end
        new(values, value, name, values[value])
    end

    EnumParameter(values::T, name::ASCIIString) = begin
        value = rand(1:length(values))
        new(values, value, name, values[value])
    end
end

EnumParameter{T <: AbstractArray}(values::T, value::Int, name::ASCIIString) = begin
    EnumParameter{Parameter, T}(values, value, name)
end

EnumParameter{T <: AbstractArray}(values::T, name::ASCIIString) = begin
    EnumParameter{Parameter, T}(values, name)
end

type StringParameter <: Parameter
    value::ASCIIString
    name::ASCIIString
end

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{FloatingPoint}
