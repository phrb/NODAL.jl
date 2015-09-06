greedy_construction(cost::Function,
                    args::Dict{ASCIIString, Any},
                    initial_x::Configuration,
                    initial_cost::Float64,
                    evaluations::Int,
                    f_xs::Array{Float64},
                    target::ASCIIString,
                    cutoff::Int) = begin
    x          = deepcopy(initial_x)
    x_proposal = deepcopy(initial_x)
    name       = "Greedy Construction"
    f_calls    = 0
    iteration  = 0
    f_x = initial_cost
    while iteration <= cutoff
        iteration += 1
        neighbor!(x_proposal, target)
        f_proposal = @fetch (measure_mean!(cost, x_proposal, args,
                                           evaluations, f_xs))
        f_calls += evaluations
        if f_proposal <= f_x
            update!(x, x_proposal.parameters)
            f_x = f_proposal
            return Result(name, initial_x, x, f_x, iteration,
                          iteration, f_calls, false)
        end
    end
    Result(name, initial_x, x, f_x, iteration,
           iteration, f_calls, false)
end
