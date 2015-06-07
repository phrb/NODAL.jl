#
# Adapted from 'Optim/src/simulated_annealing.jl'.
#
log_temperature(t::Real) = 1 / log(t)

simulated_annealing{T <: Configuration}(cost::Function,
                                        args::Dict{ASCIIString, Any},
                                        initial_x::T,
                                        initial_cost::Float64;
                                        temperature::Function        = log_temperature,
                                        evaluations::Int             = 3,
                                        iterations::Int              = 100_000) = begin
    # Maintain current and proposed state
    x          = deepcopy(initial_x)
    x_proposal = deepcopy(initial_x)
    name       = "Simulated Annealing"
    # Record the number of iterations we perform
    iteration = 0
    # Track calls to function
    f_xs       = Float64[]
    for i = 1:evaluations
        push!(f_xs, 0.0)
    end
    next_proc = @task chooseproc()
    f_calls = 0
    f_x = initial_cost
    #
    #
    f_calls += evaluations
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
        # Start evaluations in parallel.
        for i = 1:evaluations
            f_xs[i] = remotecall_fetch(consume(next_proc), 
                                       cost, x_proposal, args)
        end
        f_proposal = mean(f_xs)
        f_calls += evaluations
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
        #
        # Yields best result so far, until
        # all evaluations have a chance to finish.
        #
        produce(Result(name,
                       initial_x,
                       best_x,
                       best_f_x,
                       iteration,
                       iteration,
                       f_calls,
                       false))
    end
end
