abstract Parameter

abstract NumberParameter{T<:Number} <: Parameter

abstract RealParameter{T<:Real} <: NumberParameter

type IntParameter <: RealParameter
    min::Int64
    max::Int64
    value::Int64
    function IntParameter(min::Int64, max::Int64, value::Int64)
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        else
            new(min, max, value)
        end
    end
end

type FloatParameter <: RealParameter
    min::Float64
    max::Float64
    value::Float64
    function FloatParameter(min, max, value)
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        else
            new(min, max, value)
        end
    end
end
