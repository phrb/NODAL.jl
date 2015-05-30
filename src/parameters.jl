abstract Parameter

type NumberParameter{T<:Number} <: Parameter
    min::T
    max::T
    value::T
    function NumberParameter(min::T, max::T, value::T)
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        else
            new(min, max, value)
        end
    end
end

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{FloatingPoint}
