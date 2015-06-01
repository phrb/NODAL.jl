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

type Enum{T <: Parameter} <: Parameter
    values::AbstractArray{T}
    current::Int
    name::Symbol
    value::T
    Enum{T <: Parameter}(values::AbstractArray{T}, current::Int, name::Symbol) = begin
        if current > length(values) || current < 1
            error("current is out of bounds.")
        end
        new(values, current, name, values[current])
    end
    Enum{T <: Parameter}(values::AbstractArray{T}, name::Symbol) = begin
        current = rand(1:length(values))
        new(values, current, name, values[current])
    end
end

type StringParameter <: Parameter
    value::String
    name::Symbol
end

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{FloatingPoint}
typealias EnumParameter    Enum{Parameter}

perturbate!(number::NumberParameter) = begin
    number.value = rand_in(number.min, number.max)
end

perturbate!(number::NumberParameter, interval::Number) = begin
    if interval <= 0
        error("interval must be greater than zero.")
    end
    max = number.value + interval > number.max ? number.max : number.value + interval
    min = number.value - interval < number.min ? number.min : number.value - interval
    number.value = rand_in(min, max)
end

perturbate!(enum::Enum) = begin
    enum.current = rand(1:length(enum.values))
    enum.value   = enum.values[enum.current]
end

perturbate_elements!(enum::Enum, element::Int) = begin
    perturbate!(enum.values[element])
end

perturbate_elements!(enum::Enum) = begin
    for parameter in enum.values
        if !(typeof(parameter) <: Enum) && !(typeof(parameter) <: StringParameter)
            perturbate!(parameter)
        end
    end
end

perturbate_elements!(enum::Enum, interval::Array) = begin
    if length(interval) > length(enum.values)
        error("too many intervals.")
    end
    for i = 1:length(interval)            
        parameter = enum.values[i]
        if !(typeof(parameter) <: Enum) && !(typeof(parameter) <: StringParameter)
            perturbate!(enum.values[i], interval[i])
        end
    end
end

perturbate_elements!(enum::Enum, element::Int, interval::Number) = begin
    perturbate!(enum.values[element], interval)
end

include("util.jl")
