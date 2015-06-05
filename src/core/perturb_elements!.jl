perturb_elements!(enum::EnumParameter, element::Int) = begin
    perturb!(enum.values[element])
end

perturb_elements!(enum::EnumParameter) = begin
    for parameter in enum.values
        if !(typeof(parameter) <: StringParameter)
            perturb!(parameter)
        end
    end
end

perturb_elements!(enum::EnumParameter, interval::Array) = begin
    if length(interval) > length(enum.values)
        error("too many intervals.")
    end
    for i = 1:length(interval)
        parameter = enum.values[i]
        if typeof(parameter) <: NumberParameter
            @inbounds interv = interval[i]
            perturb!(parameter, interv)
        end
    end
end

perturb_elements!(enum::EnumParameter, element::Int, interval::Number) = begin
    perturb!(enum.values[element], interval)
end
