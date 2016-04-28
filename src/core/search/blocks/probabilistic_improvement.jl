function metropolis(T::Real, initial::Real, candidate::Real)
    if candidate < initial
        true
    else
        rand() < exp((initial - candidate) / T)
    end
end

function probabilistic_improvement(tuning_run::Run;
                                   threshold::AbstractFloat = 2.,
                                   acceptance_criterion::Function = metropolis)
    initial_cost  = tuning_run.starting_cost
    x             = deepcopy(tuning_run.starting_point)
    x_proposal    = deepcopy(tuning_run.starting_point)
    name          = "Probabilistic Improvement"
    cost_calls    = 0
    iteration     = 1
    neighbor!(x_proposal)
    proposal      = @fetch (tuning_run.measurement_method(tuning_run, x_proposal))
    cost_calls   += tuning_run.cost_evaluations
    if acceptance_criterion(threshold, initial_cost, proposal)
        update!(x, x_proposal.parameters)
        initial_cost = proposal
    end
    Result(name, tuning_run.starting_point, x, initial_cost, iteration,
           iteration, cost_calls, false)
end
