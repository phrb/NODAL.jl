function perturb_elements!(enum::EnumParameter, element::Int)
    perturb!(enum.values[element])
end

function perturb_elements!(enum::EnumParameter)
    for parameter in enum.values
        if !(typeof(parameter) <: StringParameter)
            perturb!(parameter)
        end
    end
end

function perturb_elements!(enum::EnumParameter, interval::Array)
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

function perturb_elements!(enum::EnumParameter, element::Int, interval::Number)
    perturb!(enum.values[element], interval)
end
