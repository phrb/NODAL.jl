function Base.show(io::IO, n::T) where T <: NumberParameter
    @printf io "    ["
    printstyled(io, "NumberParameter", color = :blue)
    @printf io "]\n"

    printstyled(io, "    name", color = :blue)
    @printf io " : "
    printstyled(io, "$(n.name)\n", color = :bold)

    printstyled(io, "    min", color = :green)
    @printf io "  : %6f\n" n.min

    printstyled(io, "    max", color = :red)
    @printf io "  : %6f\n" n.max

    printstyled(io, "    value", color = :yellow)
    @printf io ": %6f\n" n.value
    return
end

function Base.show(io::IO, n::T) where T <: EnumParameter
    @printf io "    ["
    printstyled(io, "EnumParameter", color = :blue)
    @printf io "]\n"
    printstyled(io, "    name", color = :blue)
    @printf io "   : "
    printstyled(io, "$(n.name)\n", color = :bold)
    printstyled(io, "    current", color = :yellow)
    @printf io ": "
    printstyled(io, "$(n.current.name)\n", color = :bold)
    printstyled(io, "    values", color = :green)
    @printf io " : \n"
    for i = 1:length(n.values)
        show(io, n.values[i])
        if i < length(n.values) && length(n.values) > 1
            printstyled(io, "    ***\n", color = :blue)
        end
    end
    return
end

function Base.show(io::IO, n::T) where T <: PermutationParameter
    @printf io "    ["
    printstyled(io, "PermutationParameter", color = :blue)
    @printf io "]\n"

    printstyled(io, "    name", color = :blue)
    @printf io " : "
    printstyled(io, "$(n.name)\n", color = :bold)

    printstyled(io, "    value", color = :yellow)
    @printf io ": "
    show(io, n.value)
    @printf io "\n"

    printstyled(io, "    size", color = :green)
    @printf io " : %d\n" n.size
    return
end

function Base.show(io::IO, n::T) where T <: StringParameter
    @printf io "    ["
    printstyled(io, "StringParameter", color = :blue)
    @printf io "]\n"
    printstyled(io, "    name", color = :blue)
    @printf io " : "
    printstyled(io, "$(n.name)\n", color = :bold)
    printstyled(io, "    value", color = :yellow)
    @printf io ": \"%s\"\n" n.value
    return
end

function Base.show(io::IO, n::T) where T <: BoolParameter
    @printf io "    ["
    printstyled(io, "BoolParameter", color = :blue)
    @printf io "]\n"
    printstyled(io, "    name", color = :blue)
    @printf io " : "
    printstyled(io, "$(n.name)\n", color = :bold)
    printstyled(io, "    value", color = :yellow)
    @printf io ": %s\n" n.value
    return
end

function Base.show(io::IO, n::T) where T <: Configuration
    @printf io "  ["
    printstyled(io, "Configuration", color = :blue)
    @printf io "]\n"
    printstyled(io, "  name", color = :blue)
    @printf io "      : "
    printstyled(io, "$(n.name)\n", color = :bold)
    printstyled(io, "  parameters", color = :blue)
    @printf io ":\n"
    p = collect(keys(n.parameters))
    for i = 1:length(p)
        show(io, n[p[i]])
        if i < length(p) && length(p) > 1
            printstyled(io, "    ***\n", color = :blue)
        end
    end
    return
end

function Base.show(io::IO, n::T) where T <: Result
    if n.is_final
        @printf io "["
        printstyled(:bio, "Final Result", color = :blue)
        @printf io "]\n"
        printstyled(io, "Cost", color = :yellow)
        @printf io "                  : "
        printstyled(io, "$(n.cost_minimum)\n", color = :bold)
        printstyled(io, "Found in Iteration", color = :yellow)
        @printf io "    : "
        printstyled(io, "$(n.iterations)\n", color = :bold)
        printstyled(io, "Current Iteration", color = :blue)
        @printf io "     : "
        printstyled(io, "$(n.current_iteration)\n", color = :bold)
        printstyled(io, "Technique", color = :blue)
        @printf io "             : "
        printstyled(io, "$(n.technique)\n", color = :bold)
        printstyled(io, "Function Calls", color = :blue)
        @printf io "        : "
        printstyled(io, "$(n.cost_calls)\n", color = :bold)
        printstyled(io, "Starting Configuration", color = :blue)
        @printf io ":\n"
        show(io, n.start)
        printstyled(io, "Minimum Configuration", color = :blue)
        @printf io " :\n"
        show(io, n.minimum)
    else
        @printf io "["
        printstyled(io, "Result", color = :blue)
        @printf io "]\n"
        printstyled(io, "Cost", color = :yellow)
        @printf io "              : "
        printstyled(io, "$(n.cost_minimum)\n", color = :bold)
        printstyled(io, "Found in Iteration", color = :yellow)
        @printf io ": "
        printstyled(io, "$(n.iterations)\n", color = :bold)
        printstyled(io, "Current Iteration", color = :blue)
        @printf io " : "
        printstyled(io, "$(n.current_iteration)\n", color = :bold)
        printstyled(io, "Technique", color = :blue)
        @printf io "         : "
        printstyled(io, "$(n.technique)\n", color = :bold)
        printstyled(io, "Function Calls", color = :blue)
        @printf io "    : "
        printstyled(io, "$(n.cost_calls)\n", color = :bold)
        printstyled(io, "  ***\n", color = :blue)
    end
    return
end
