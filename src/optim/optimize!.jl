optimize!(f::Function,
         initial_x::Configuration;
         method::Symbol       = :simulated_annealing,
         iterations::Integer  = 1_000,
         store_trace::Bool    = false,
         show_trace::Bool     = false,
         extended_trace::Bool = false,
         ftol::Real = 1e-8) = begin
    parameter_dict  = ASCIIString[]
    parameter_array = deepcopy(convert(Array{Float64}, initial_x, parameter_dict))
    if method == :simulated_annealing
        name = "Simulated Annealing"
        result = Optim.simulated_annealing(f,
                                           parameter_array,
                                           iterations     = iterations,
                                           store_trace    = store_trace,
                                           show_trace     = show_trace,
                                           extended_trace = extended_trace)
        start = deepcopy(initial_x)
        update!(initial_x, result.minimum, parameter_dict)
    elseif method == :nelder_mead
        name = "Nelder Mead"
        result = Optim.nelder_mead(f,
                                   parameter_array,
                                   ftol           = ftol,
                                   iterations     = iterations,
                                   store_trace    = store_trace,
                                   show_trace     = show_trace,
                                   extended_trace = extended_trace)
        start = deepcopy(initial_x)
        update!(initial_x, result.minimum, parameter_dict)
    else
        throw(ArgumentError("Unimplemented Optim.jl interface to method $method"))
    end
    return Result(name,
                  start,
                  initial_x,
                  result.f_minimum,
                  result.iterations,
                  result.f_calls,
                  true)
end
