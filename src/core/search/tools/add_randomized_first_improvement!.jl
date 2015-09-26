add_randomized_first_improvement!(f::Function,
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
                push!(task_list, @task randomized_first_improvement(f,
                                                                    args,
                                                                    initial_x,
                                                                    initial_f_x;
                                                                    iterations  = iterations,
                                                                    evaluations = evaluations))
            end
        end
    end
end
