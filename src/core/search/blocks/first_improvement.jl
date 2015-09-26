function first_improvement(parameters::Dict{Symbol, Any})
    cost         = parameters[:cost]
    args         = parameters[:cost_args]
    initial_x    = parameters[:initial_config]
    initial_cost = parameters[:initial_cost]
    cost_calls   = parameters[:evaluations]
    evaluations  = parameters[:evaluations]
    costs        = parameters[:costs]
    cutoff       = parameters[:cutoff]
    x            = deepcopy(initial_x)
    x_proposal   = deepcopy(initial_x)
    name         = "First Improvement"
    iteration    = 0
    while iteration <= cutoff
        iteration += 1
        neighbor!(x_proposal)
        proposal    = @fetch (measure_mean!(cost, x_proposal, args,
                                           evaluations, costs))
        cost_calls += evaluations
        if proposal <= initial_cost
            update!(x, x_proposal.parameters)
            initial_cost = proposal
            return Result(name, initial_x, x, initial_cost, iteration,
                          iteration, cost_calls, false)
        end
    end
    Result(name, initial_x, x, initial_cost, iteration,
           iteration, cost_calls, false)
end
