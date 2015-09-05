initialize_search_tasks!(f::Function,
                         initial_x::Configuration,
                         initial_f_x::Float64,
                         methods::Array{Symbol},
                         args::Dict{ASCIIString, Any},
                         instances::Array{Int},
                         iterations::Int,
                         evaluations::Int,
                         task_list::Array{Task}) = begin
    for i = 1:length(methods)
        if methods[i] == :simulated_annealing
            for j = 1:instances[i]
                push!(task_list, Task(() -> simulated_annealing(f,
                                                                args,
                                                                initial_x,
                                                                initial_f_x,
                                                                iterations  = iterations,
                                                                evaluations = evaluations)))
            end
        elseif methods[i] == :iterative_first_improvement
            for j = 1:instances[i]
                push!(task_list, Task(() -> iterative_first_improvement(f,
                                                                        args,
                                                                        initial_x,
                                                                        initial_f_x,
                                                                        iterations  = iterations,
                                                                        evaluations = evaluations)))
            end
        else
            error("Error: Unknown Method.")
        end
    end
end
