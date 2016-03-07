function first_improvement(tuning_run::Run;
                           cutoff::Integer = 10_000)
    initial_x    = tuning_run.starting_point
    initial_cost = tuning_run.starting_cost
    x            = deepcopy(initial_x)
    x_proposal   = deepcopy(initial_x)
    name         = "First Improvement"
    cost_calls   = 0
    iteration    = 1
    while iteration <= cutoff
        iteration  += 1
        neighbor!(x_proposal)
        proposal    = @fetch (tuning_run.measurement_method(tuning_run, x_proposal))
        cost_calls += tuning_run.cost_evaluations
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
