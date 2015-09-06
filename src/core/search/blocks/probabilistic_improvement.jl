probabilistic_improvement(cost::Function,
                          args::Dict{ASCIIString, Any},
                          initial_x::Configuration,
                          initial_cost::Float64,
                          evaluations::Int,
                          f_xs::Array{Float64},
                          t::Float64) = begin
    x          = deepcopy(initial_x)
    x_proposal = deepcopy(initial_x)
    name       = "Probabilistic Improvement"
    f_calls    = 0
    iteration  = 0
    f_x = initial_cost
    neighbor!(x_proposal)
    f_proposal = @fetch (measure_mean!(cost, x_proposal, args,
                                       evaluations, f_xs))
    f_calls += evaluations
    if f_proposal <= f_x
        update!(x, x_proposal.parameters)
        f_x = f_proposal
    else
        p = exp(-(f_proposal - f_x) / t)
        if rand() <= p
            update!(x, x_proposal.parameters)
            f_x = f_proposal
        end
    end
    Result(name, initial_x, x, f_x, iteration,
           iteration, f_calls, false)
end
