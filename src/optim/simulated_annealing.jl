log_temperature(t::Real) = 1 / log(t)

constant_temperature(t::Real) = 1.0

default_neighbor!(x::Array{Parameter}, x_proposal::Array{Parameter}) = begin
    @assert size(x) == size(x_proposal)
    for i in 1:length(x)
        @inbounds neighbor!(x_proposal[i])
    end
    return
end

simulated_annealing{T}(cost::Function,
                           initial_x::Array{T};
                           neighbor!::Function = default_neighbor!,
                           iterations::Integer = 1_000,
                           temperature::Function = log_temperature) = begin
    # Maintain current and proposed state
    x, x_proposal = deepcopy(initial_x), deepcopy(initial_x)
    iteration = 0
    # Track calls to function and gradient
    f_calls = 0
    # Count number of parameters
    n = length(x)
    # Store f(x) in f_x
    f_x = cost(x)
    f_calls += 1
    # Store the best state ever visited
    best_x = deepcopy(x)
    best_f_x = f_x
    # We always perform a fixed number of iterations
    while iteration < iterations
        # Increment the number of steps we've had to perform
        iteration += 1
        # Determine the temperature for current iteration
        t = temperature(iteration)
        # Randomly generate a neighbor of our current state
        neighbor!(x, x_proposal)
        # Evaluate the cost function at the proposed state
        f_proposal = cost(x_proposal)
        f_calls += 1
        if f_proposal <= f_x
            # If proposal is superior, we always move to it
            x = deepcopy(x_proposal)
            f_x = f_proposal
            # If the new state is the best state yet, keep a record of it
            if f_proposal < best_f_x
                best_f_x = f_proposal
                best_x = deepcopy(x_proposal)
            end
        else
            # If proposal is inferior, we move to it with probability p
            p = exp(-(f_proposal - f_x) / t)
            if rand() <= p
                x = deepcopy(x_proposal)
                f_x = f_proposal
            end
        end
    end        
    best_x
end
