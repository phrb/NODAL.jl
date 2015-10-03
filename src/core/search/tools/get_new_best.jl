function get_new_best(results::Array{RemoteRef}, best::Result)
    for reference in results
        if isready(reference)
            partial = take!(reference)
            if partial.cost_minimum < best.cost_minimum
                best = deepcopy(partial)
            end
        end
    end
    best
end

function get_new_best(results::Array{RemoteRef})
    take!(results[rand(1:length(results))])
end
