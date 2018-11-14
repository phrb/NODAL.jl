function measure_mean!(tuning_run::Run, x::Configuration)
    configurations = Array{Configuration}(undef, tuning_run.cost_evaluations)
    fill!(configurations, deepcopy(x))

    pmap_cost(x::Configuration) = tuning_run.cost(x, tuning_run.cost_arguments)
    results = pmap(pmap_cost, configurations)

    for i = 1:tuning_run.cost_evaluations
        tuning_run.cost_values[i] = results[i]
    end

    mean(results)
end

function sequential_measure_mean!(tuning_run::Run, x::Configuration)
    for i = 1:tuning_run.cost_evaluations
        tuning_run.cost_values[i] = tuning_run.cost(x, tuning_run.cost_arguments)
    end
    mean(tuning_run.cost_values)
end
