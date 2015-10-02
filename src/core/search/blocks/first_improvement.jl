function first_improvement(parameters::Dict{Symbol, Any})
    initial_x    = parameters[:initial_config]
    initial_cost = parameters[:initial_cost]
    cost_calls   = parameters[:evaluations]
    evaluations  = parameters[:evaluations]
    cutoff       = parameters[:cutoff]
    x            = deepcopy(initial_x)
    x_proposal   = deepcopy(initial_x)
    measurement  = parameters[:measurement_method]
    name         = "First Improvement"
    iteration    = 0
    while iteration <= cutoff
        iteration += 1
        neighbor!(x_proposal)
        proposal    = @fetch (measurement(parameters, x_proposal))
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
