rand_in(min::Integer, max::Integer) = begin
    rand(min:max)
end

rand_in(min::AbstractFloat, max::AbstractFloat) = begin
    rand() * (max - min) + min
end
