function chooseproc()
    nextidx = 0
    while true
        p = workers()[(nextidx) + 1]
        nextidx += 1
        if nextidx >= nworkers()
            nextidx = 0
        end
        produce(p)
    end
end
