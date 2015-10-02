function random_walk(parameters::Dict{Symbol, Any})
    initial_x    = parameters[:initial_config]
    initial_cost = parameters[:initial_cost]
    evaluations  = parameters[:evaluations]
    cost_calls   = parameters[:evaluations]
    x            = deepcopy(initial_x)
    measurement  = parameters[:measurement_method]
    name         = "Random Walk"
    neighbor!(x)
    f_x = @fetch (measurement(parameters, x))
    cost_calls += evaluations
    return Result(name, initial_x, x, f_x, 1,
                  1, cost_calls, false)
end
