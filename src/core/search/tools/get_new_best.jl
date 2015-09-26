function get_new_best(search_tasks::Array{Task}, best::Result)
    for task in search_tasks
        partial = consume(task)
        if partial.cost_minimum < best.cost_minimum
            best = deepcopy(partial)
        end
    end
    best
end
