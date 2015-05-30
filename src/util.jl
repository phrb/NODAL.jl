rand_in(min::Integer, max::Integer) = begin
    rand(min:max)
end

rand_in(min::FloatingPoint, max::FloatingPoint) = begin
    rand() * (max - min) + min
end
