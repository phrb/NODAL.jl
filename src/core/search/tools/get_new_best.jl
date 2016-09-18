function get_new_best(results::Array{RemoteChannel}, best::Result)
    for reference in results
        partial = take!(reference)
        if partial.cost_minimum < best.cost_minimum
            best = deepcopy(partial)
        end
    end
    best
end

function get_new_best(results::Array{RemoteChannel})
    take!(results[rand(1:length(results))])
end
