function end_search_tasks!(results::Array{RemoteChannel})
    for channel in results
        close(channel)
    end
end
