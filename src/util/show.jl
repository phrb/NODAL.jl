function Base.show(io::IO, n::T) where T <: NumberParameter
    @printf io "    ["
    print_with_color(:blue, io, "NumberParameter")
    @printf io "]\n"

    print_with_color(:blue, io, "    name")
    @printf io " : "
    print_with_color(:bold, io, "$(n.name)\n")

    print_with_color(:green, io, "    min")
    @printf io "  : %6f\n" n.min

    print_with_color(:red, io, "    max")
    @printf io "  : %6f\n" n.max

    print_with_color(:yellow, io, "    value")
    @printf io ": %6f\n" n.value
    return
end

function Base.show(io::IO, n::T) where T <: EnumParameter
    @printf io "    ["
    print_with_color(:blue, io, "EnumParameter")
    @printf io "]\n"
    print_with_color(:blue, io, "    name")
    @printf io "   : "
    print_with_color(:bold, io, "$(n.name)\n")
    print_with_color(:yellow, io, "    current")
    @printf io ": "
    print_with_color(:bold, io, "$(n.current.name)\n")
    print_with_color(:green, io, "    values")
    @printf io " : \n"
    for i = 1:length(n.values)
        show(io, n.values[i])
        if i < length(n.values) && length(n.values) > 1
            print_with_color(:blue, io, "    ***\n")
        end
    end
    return
end

function Base.show(io::IO, n::T) where T <: PermutationParameter
    @printf io "    ["
    print_with_color(:blue, io, "PermutationParameter")
    @printf io "]\n"

    print_with_color(:blue, io, "    name")
    @printf io " : "
    print_with_color(:bold, io, "$(n.name)\n")

    print_with_color(:yellow, io, "    value")
    @printf io ": "
    show(io, n.value)
    @printf io "\n"

    print_with_color(:green, io, "    size")
    @printf io " : %d\n" n.size
    return
end

function Base.show(io::IO, n::T) where T <: StringParameter
    @printf io "    ["
    print_with_color(:blue, io, "StringParameter")
    @printf io "]\n"
    print_with_color(:blue, io, "    name")
    @printf io " : "
    print_with_color(:bold, io, "$(n.name)\n")
    print_with_color(:yellow, io, "    value")
    @printf io ": \"%s\"\n" n.value
    return
end

function Base.show(io::IO, n::T) where T <: BoolParameter
    @printf io "    ["
    print_with_color(:blue, io, "BoolParameter")
    @printf io "]\n"
    print_with_color(:blue, io, "    name")
    @printf io " : "
    print_with_color(:bold, io, "$(n.name)\n")
    print_with_color(:yellow, io, "    value")
    @printf io ": %s\n" n.value
    return
end

function Base.show(io::IO, n::T) where T <: Configuration
    @printf io "  ["
    print_with_color(:blue, io, "Configuration")
    @printf io "]\n"
    print_with_color(:blue, io, "  name")
    @printf io "      : "
    print_with_color(:bold, io, "$(n.name)\n")
    print_with_color(:blue, io, "  parameters")
    @printf io ":\n"
    p = collect(keys(n.parameters))
    for i = 1:length(p)
        show(io, n[p[i]])
        if i < length(p) && length(p) > 1
            print_with_color(:blue, io, "    ***\n")
        end
    end
    return
end

function Base.show(io::IO, n::T) where T <: Result
    if n.is_final
        @printf io "["
        print_with_color(:blue, io, "Final Result")
        @printf io "]\n"
        print_with_color(:yellow, io, "Cost")
        @printf io "                  : "
        print_with_color(:bold, io, "$(n.cost_minimum)\n")
        print_with_color(:yellow, io, "Found in Iteration")
        @printf io "    : "
        print_with_color(:bold, io, "$(n.iterations)\n")
        print_with_color(:blue, io, "Current Iteration")
        @printf io "     : "
        print_with_color(:bold, io, "$(n.current_iteration)\n")
        print_with_color(:blue, io, "Technique")
        @printf io "             : "
        print_with_color(:bold, io, "$(n.technique)\n")
        print_with_color(:blue, io, "Function Calls")
        @printf io "        : "
        print_with_color(:bold, io, "$(n.cost_calls)\n")
        print_with_color(:blue, io, "Starting Configuration")
        @printf io ":\n"
        show(io, n.start)
        print_with_color(:blue, io, "Minimum Configuration")
        @printf io " :\n"
        show(io, n.minimum)
    else
        @printf io "["
        print_with_color(:blue, io, "Result")
        @printf io "]\n"
        print_with_color(:yellow, io, "Cost")
        @printf io "              : "
        print_with_color(:bold, io, "$(n.cost_minimum)\n")
        print_with_color(:yellow, io, "Found in Iteration")
        @printf io ": "
        print_with_color(:bold, io, "$(n.iterations)\n")
        print_with_color(:blue, io, "Current Iteration")
        @printf io " : "
        print_with_color(:bold, io, "$(n.current_iteration)\n")
        print_with_color(:blue, io, "Technique")
        @printf io "         : "
        print_with_color(:bold, io, "$(n.technique)\n")
        print_with_color(:blue, io, "Function Calls")
        @printf io "    : "
        print_with_color(:bold, io, "$(n.cost_calls)\n")
        print_with_color(:blue, io, "  ***\n")
    end
    return
end
