function random_walk(parameters::Dict{Symbol, Any})
    cost         = parameters[:cost]
    args         = parameters[:cost_args]
    initial_x    = parameters[:initial_config]
    initial_cost = parameters[:initial_cost]
    evaluations  = parameters[:evaluations]
    cost_calls   = parameters[:evaluations]
    costs        = parameters[:costs]
    x            = deepcopy(initial_x)
    name         = "Random Walk"
    neighbor!(x)
    f_x = @fetch (measure_mean!(cost, x, args,
                                evaluations, costs))
    cost_calls += evaluations
    return Result(name, initial_x, x, f_x, 1,
                  1, cost_calls, false)
end
