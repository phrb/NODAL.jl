Base.show{T <: NumberParameter}(io::IO, n::T) = begin
    @printf io "\n    [NumberParameter] %s\n" typeof(n)
    @printf io "    (name: %s, " n.name
    @printf io "min: %6f, " n.min
    @printf io "max: %6f, " n.max
    @printf io "value: %6f)\n" n.value
    return
end

Base.show{T <: EnumParameter}(io::IO, n::T) = begin
    @printf io "\n    [EnumParameter]: %s\n" typeof(n)
    @printf io "    (name: %s, " n.name
    @printf io "current:\n"
    show(io, n.current)
    @printf "    )\n"
    @printf io "          [Values]\n"
    @printf io "           ======"
    for v in n.values
        show(io, v)
    end
    @printf io "           ======\n"
    @printf io "    )\n"
    return
end

Base.show{T <: StringParameter}(io::IO, n::T) = begin
    @printf io "\n    [StringParameter]"
    @printf io " (name: %s, " n.name
    @printf io "value: %s)\n" n.value
    return
end

Base.show{T <: BoolParameter}(io::IO, n::T) = begin
    @printf io "\n    [BoolParameter]"
    @printf io " (name: %s, " n.name
    @printf io "value: %s)\n" n.value
    return
end

Base.show{T <: Configuration}(io::IO, n::T) = begin
    @printf io "\n  [Configuration] %s\n" typeof(n)
    @printf io "  (name: %s,\n" n.name
    @printf io "    [Parameters]\n"
    @printf io "     ==========\n    "
    for p in n.parameters
        show(io, p)
        @printf io "\n    "
    end
    @printf io " =========\n"
    @printf io "  )\n"
    return
end

Base.show{T <: Result}(io::IO, n::T) = begin
    if n.is_final
        @printf io "[Final Result]        :\n"
        @printf io "[Technique]           : %s\n" n.technique
        @printf io "[Cost]                : %6f\n" n.cost_minimum
        @printf io "[Found in Iteration]  : %d\n" n.iterations
        @printf io "[Function Calls]      : %d\n" n.cost_calls
        @printf io "[Start Configuration]"
        show(io, n.start)
        @printf io "[Minimum Configuration]"
        show(io, n.minimum)
    else
        @printf io "[Partial Result] [Cost] %6f " n.cost_minimum
        @printf io "[Technique] %s " n.technique
        @printf io "[Found in Iteration] %5d " n.iterations
        @printf io "[Current Iteration] %5d\n" n.current_iteration
    end
    return
end
