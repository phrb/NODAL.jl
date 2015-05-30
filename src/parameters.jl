abstract Parameter

type NumberParameter{T<:Number} <: Parameter
    min::T
    max::T
    value::T
    name::Symbol
    function NumberParameter(min::T, max::T, value::T, name::Symbol)
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        else
            new(min, max, value, name)
        end
    end
end

type EnumParameter <: Parameter
    values::AbstractArray{Parameter}
    name::Symbol
end

type StringParameter <: Parameter
    value::String
    name::Symbol
end

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{FloatingPoint}
