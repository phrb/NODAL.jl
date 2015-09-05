add_iterative_greedy_construction!(f::Function,
                                   args::Dict{ASCIIString, Any},
                                   initial_x::Configuration,
                                   initial_f_x::Float64,
                                   iterations::Int,
                                   evaluations::Int,
                                   task_list::Array{Task},
                                   instances::Int) = begin
    for j = 1:instances
        push!(task_list, Task(() -> iterative_greedy_construction(f,
                                                                  args,
                                                                  initial_x,
                                                                  initial_f_x,
                                                                  iterations  = iterations,
                                                                  evaluations = evaluations)))
    end
end
