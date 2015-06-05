unit_value{T <: NumberParameter}(parameter::T) = begin
    (parameter.value - parameter.min) / (parameter.max - parameter.min)
end

unit_value{T <: EnumParameter}(parameter::T) = begin
    (parameter.value - 1) / (length(parameter.values) - 1)
end

unit_value!{T <: EnumParameter}(parameter::T, unit::Float64) = begin
    @assert 0.0 <= unit <= 1.0
    value = round(unit * length(parameter.values))
    parameter.value = max(1, min(value, length(parameter.values)))
    @inbounds parameter.current = parameter.values[parameter.value]
    parameter.value
end

unit_value!(parameter::IntegerParameter, unit::Float64) = begin
    @assert 0.0 <= unit <= 1.0
    value = round(unit * parameter.max)
    parameter.value = max(parameter.min, min(value, parameter.max))
    parameter.value
end

unit_value!(parameter::FloatParameter, unit::Float64) = begin
    @assert 0.0 <= unit <= 1.0
    value = unit * parameter.max
    parameter.value = max(parameter.min, min(value, parameter.max))
    parameter.value
end
