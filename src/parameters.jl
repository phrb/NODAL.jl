abstract Parameter

type NumberParameter{T <: Number} <: Parameter
    min::T
    max::T
    value::T
    name::Symbol

    NumberParameter(min::T, max::T, value::T, name::Symbol) = begin
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        else
            new(min, max, value, name)
        end
    end
end

NumberParameter{T <: Number}(min::T, max::T, value::T, name::Symbol) = begin
    NumberParameter{T}(min, max, value, name)
end

type EnumParameter{P <: Parameter, T <: AbstractArray} <: Parameter
    values::T
    current::Int
    name::Symbol
    value::P

    EnumParameter(values::T, current::Int, name::Symbol) = begin
        if current > length(values) || current < 1
            error("current is out of bounds.")
        end
        new(values, current, name, values[current])
    end

    EnumParameter(values::T, name::Symbol) = begin
        current = rand(1:length(values))
        new(values, current, name, values[current])
    end
end

EnumParameter{T <: AbstractArray}(values::T, current::Int, name::Symbol) = begin
    EnumParameter{Parameter, T}(values, current, name)
end

EnumParameter{T <: AbstractArray}(values::T, name::Symbol) = begin
    EnumParameter{Parameter, T}(values, name)
end

type StringParameter <: Parameter
    value::String
    name::Symbol
end

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{FloatingPoint}
