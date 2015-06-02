perturb_elements!(enum::EnumParameter, element::Int) = begin
    perturb!(enum.values[element])
end

perturb_elements!(enum::EnumParameter) = begin
    for parameter in enum.values
        if typeof(parameter) <: NumberParameter ||
                typeof(parameter) <: EnumParameter
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
            perturb!(parameter, interval[i])
        end
    end
end

perturb_elements!(enum::EnumParameter, element::Int, interval::Number) = begin
    perturb!(enum.values[element], interval)
end
