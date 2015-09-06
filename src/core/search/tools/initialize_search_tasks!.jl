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
            add_simulated_annealing!(f, args, initial_x, initial_f_x,
                                     iterations, evaluations, 
                                     task_list, instances[i])
        elseif methods[i] == :iterative_first_improvement
            add_iterative_first_improvement!(f, args, initial_x, initial_f_x,
                                             iterations, evaluations,
                                             task_list, instances[i])
        elseif methods[i] == :randomized_first_improvement
            add_randomized_first_improvement!(f, args, initial_x, initial_f_x,
                                              iterations, evaluations,
                                              task_list, instances[i])
        elseif methods[i] == :iterative_greedy_construction
            add_iterative_greedy_construction!(f, args, initial_x, initial_f_x,
                                               iterations, evaluations,
                                               task_list, instances[i])
        elseif methods[i] == :iterative_probabilistic_improvement
            add_iterative_probabilistic_improvement!(f, args, initial_x,
                                                     initial_f_x, iterations,
                                                     evaluations,
                                                     task_list, instances[i])
        else
            error("Search technique \"$(methods[i])\" not implemented.")
        end
    end
end
