#
# Adapted from 'Optim/src/simulated_annealing.jl'.
#
log_temperature(t::Real) = 1 / log(t)

simulated_annealing{T <: Configuration}(cost::Function,
                                        initial_x::T;
                                        temperature::Function = log_temperature,
                                        iterations::Integer   = 100_000) = begin
    # Maintain current and proposed state
    x          = deepcopy(initial_x)
    x_proposal = deepcopy(initial_x)

    # Record the number of iterations we perform
    iteration = 0

    # Track calls to function
    f_calls = 0

    # Store f(x) in f_x
    f_x = cost(x)
    f_calls += 1

    # Store the best state ever visited
    best_x = deepcopy(x)
    best_f_x = f_x

    # We always perform a fixed number of iterations
    while iteration <= iterations
        # Increment the number of steps we've had to perform
        iteration += 1

        # Determine the temperature for current iteration
        t = temperature(iteration)

        # Randomly generate a neighbor of our current state
        neighbor!(x_proposal)

        # Evaluate the cost function at the proposed state
        f_proposal = cost(x_proposal)
        f_calls += 1

        if f_proposal <= f_x
            # If proposal is superior, we always move to it
            update!(x, x_proposal.parameters)
            f_x = f_proposal

            # If the new state is the best state yet, keep a record of it
            if f_proposal < best_f_x
                best_f_x = f_proposal
                update!(best_x, x_proposal.parameters)
            end
        else
            # If proposal is inferior, we move to it with probability p
            p = exp(-(f_proposal - f_x) / t)
            if rand() <= p
                update!(x, x_proposal.parameters)
                f_x = f_proposal
            end
        end
        produce(Result("Simulated Annealing",
                       initial_x,
                       best_x,
                       best_f_x,
                       iteration,
                       f_calls,
                       false))
    end
end
