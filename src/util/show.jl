Base.show{T <: NumberParameter}(io::IO, n::T) = begin
    @printf io "\n    *NumberParameter: %s\n" typeof(n)
    @printf io "    (name: %s, " n.name
    @printf io "min: %f, " n.min
    @printf io "max: %f, " n.max
    @printf io "value: %f)\n" n.value
    return
end

Base.show{T <: EnumParameter}(io::IO, n::T) = begin
    @printf io "\n    *EnumParameter: %s\n" typeof(n)
    @printf io "    (name: %s, " n.name
    @printf io "current:\n"
    show(io, n.current)
    @printf "    )\n"
    @printf io "         *Values:\n"
    @printf io "          =begin="
    for v in n.values
        show(io, v)
    end
    @printf io "          ==end==\n"
    @printf io "    )\n"
    return
end

Base.show{T <: StringParameter}(io::IO, n::T) = begin
    @printf io "\n    *StringParameter: %s\n" typeof(n)
    @printf io "    (name: %s, " n.name
    @printf io "current value: %s)\n" n.value
    return
end

Base.show{T <: Configuration}(io::IO, n::T) = begin
    @printf io "\n  *Configuration: %s\n" typeof(n)
    @printf io "  (name: %s,\n" n.name
    @printf io "    *Parameters:\n"
    @printf io "     ===begin===\n    "
    for p in n.parameters
        show(io, p)
        @printf io "\n    "
    end
    @printf io " ====end====\n"
    @printf io "  )\n"
    return
end

Base.show{T <: Result}(io::IO, n::T) = begin
    @printf io "*Result               :\n"
    @printf io "*Technique            : %s\n" n.technique
    @printf io "*Cost                 : %f\n" n.cost_minimum
    @printf io "*Iterations           : %d\n" n.iterations
    @printf io "*Function Calls       : %d\n" n.cost_calls
    @printf io "*Start Configuration  :"
    show(io, n.start)
    @printf io "*Minimum Configuration:"
    show(io, n.minimum)
    return
end
