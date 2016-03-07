function random_walk(tuning_run::Run)
    initial_x    = tuning_run.starting_point
    initial_cost = tuning_run.starting_cost
    x            = deepcopy(initial_x)
    name         = "Random Walk"
    cost_calls   = 0
    neighbor!(x)
    f_x = @fetch (tuning_run.measurement_method(tuning_run, x))
    cost_calls += tuning_run.cost_evaluations
    return Result(name, initial_x, x, f_x, 1,
                  1, cost_calls, false)
end
