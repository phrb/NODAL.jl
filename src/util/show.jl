Base.show{T <: NumberParameter}(io::IO, n::T) = begin
    @printf io "\n      *NumberParameter:     %s\n" typeof(n)
    @printf io "                  name:     %s\n" n.name
    @printf io "                   min:     %f\n" n.min
    @printf io "                   max:     %f\n" n.max
    @printf io "         current value:     %f\n" n.value
    return
end

Base.show{T <: EnumParameter}(io::IO, n::T) = begin
    @printf io "\n        *EnumParameter:     %s\n" typeof(n)
    @printf io "                  name:     %s\n" n.name
    @printf io "         current value:     \n"
    show(io, n.value)
    @printf io "\n               *Values:\n"
    for v in n.values
        show(io, v)
    end
    return
end

Base.show{T <: StringParameter}(io::IO, n::T) = begin
    @printf io "\n      *StringParameter:     %s\n" typeof(n)
    @printf io "                  name:     %s\n" n.name
    @printf io "         current value:     %s\n" n.value
    return
end

Base.show{T <: Configuration}(io::IO, n::T) = begin
    @printf io "\n        *Configuration: %s\n" typeof(n)
    @printf io "                  name: %s\n" n.name
    @printf io "           *Parameters:\n"
    for p in n.parameters
        show(io, p)
    end
    return
end

Base.show{T <: Result}(io::IO, n::T) = begin
    @printf io "*Result               :\n"
    @printf io "*Technique            : %s\n" n.technique
    @printf io "*Cost                 : %f\n" n.cost_minimum
    @printf io "*Iterations           : %d\n" n.iterations
    @printf io "*Function Calls       : %d\n" n.cost_calls
    @printf io "*Start Configuration  :\n"
    show(io, n.start)
    @printf io "\n*Minimum Configuration:\n"
    show(io, n.minimum)
    return
end
