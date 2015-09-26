function probabilistic_improvement(parameters::Dict{Symbol, Any})
    cost         = parameters[:cost]
    args         = parameters[:cost_args]
    initial_x    = parameters[:initial_config]
    initial_cost = parameters[:initial_cost]
    evaluations  = parameters[:evaluations]
    costs        = parameters[:costs]
    t            = parameters[:t]
    x            = deepcopy(initial_x)
    x_proposal   = deepcopy(initial_x)
    name         = "Probabilistic Improvement"
    cost_calls   = 0
    iteration    = 0
    neighbor!(x_proposal)
    proposal   = @fetch (measure_mean!(cost, x_proposal, args,
                                          evaluations, costs))
    cost_calls      += evaluations
    if proposal <= initial_cost
        update!(x, x_proposal.parameters)
        initial_cost = proposal
    else
        p = exp(-(proposal - initial_cost) / t)
        if rand() <= p
            update!(x, x_proposal.parameters)
            initial_cost = proposal
        end
    end
    Result(name, initial_x, x, initial_cost, iteration,
           iteration, cost_calls, false)
end
