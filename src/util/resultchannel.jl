mutable struct ResultChannel <: AbstractChannel{Result}
    current_result::Result
    ResultChannel(result::Result) = new(result)
end

function put!(channel::ResultChannel, result::Result)
    if result.cost_minimum < channel.current_result.cost_minimum
        channel.current_result = result
    end
    channel
end

function take!(channel::ResultChannel)
    fetch(channel)
end

function fetch(channel::ResultChannel)
    channel.current_result
end
