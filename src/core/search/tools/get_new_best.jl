function get_new_best(results::Array{RemoteChannel}, best::Result)
    for channel in results
        try
            partial = take!(channel)
            if partial.cost_minimum < best.cost_minimum
                best = deepcopy(partial)
            end
        catch
        end
    end
    best
end

function get_new_best(results::Array{RemoteChannel})
    try
        take!(results[rand(1:length(results))])
    catch
    end
end
