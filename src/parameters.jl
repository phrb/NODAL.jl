abstract Parameter

type NumberParameter{T <: Number} <: Parameter
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

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{FloatingPoint}

perturbate!(n::NumberParameter) = begin
    n.value = rand_in(n.min, n.max)
end

perturbate!(number::NumberParameter, interval::Number) = begin
    if interval <= 0
        error("interval must be greater than zero.")
    end
    max = number.value + interval > number.max ? number.max : number.value + interval
    min = number.value - interval < number.min ? number.min : number.value + interval
    number.value = rand_in(min, max)
end

type EnumParameter <: Parameter
    values::AbstractArray{Parameter}
    name::Symbol
end

type StringParameter <: Parameter
    value::String
    name::Symbol
end

include("util.jl")
