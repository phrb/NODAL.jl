unit_value{T <: NumberParameter}(parameter::T) = begin
    (parameter.value - parameter.min) / (parameter.max - parameter.min)
end

unit_value{T <: EnumParameter}(parameter::T) = begin
    (parameter.current - 1) / (length(parameter.values) - 1)
end

unit_value!{T <: EnumParameter}(parameter::T, unit::Float64) = begin
    @assert 0.0 <= unit <= 1.0
    current = round(unit * length(parameter.values))
    parameter.current = max(1, min(current, length(parameter.values)))
    @inbounds parameter.value = parameter.values[parameter.current]
    parameter.current
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
