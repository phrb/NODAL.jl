add_iterative_greedy_construction!(f::Function,
                                   args::Dict{ASCIIString, Any},
                                   initial_x::Configuration,
                                   initial_f_x::Float64,
                                   iterations::Int,
                                   evaluations::Int,
                                   task_list::Array{Task},
                                   instances::Int) = begin
    @sync begin
        for j = 1:instances
            @async begin
                push!(task_list, @task iterative_greedy_construction(f,
                                                                     args,
                                                                     initial_x,
                                                                     initial_f_x,
                                                                     iterations  = iterations,
                                                                     evaluations = evaluations))
            end
        end
    end
end
