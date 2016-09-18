function greedy_construction(tuning_run::Run,
                             target::String;
                             cutoff::Integer = 10_000)
    initial_cost = tuning_run.starting_cost
    x            = deepcopy(tuning_run.starting_point)
    x_proposal   = deepcopy(tuning_run.starting_point)
    name         = "Greedy Construction"
    cost_calls   = 0
    iteration    = 1
    while iteration <= cutoff
        iteration += 1
        neighbor!(x_proposal, target)
        proposal    = @fetch (tuning_run.measurement_method(tuning_run, x_proposal))
        cost_calls += tuning_run.cost_evaluations
        if proposal <= initial_cost
            update!(x, x_proposal.parameters)
            initial_cost = proposal
            return Result(name, tuning_run.starting_point, x, initial_cost, iteration,
                          iteration, cost_calls, false)
        end
    end
    Result(name, tuning_run.starting_point, x, initial_cost, iteration,
           iteration, cost_calls, false)
end
