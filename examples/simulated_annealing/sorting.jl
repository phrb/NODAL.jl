@everywhere begin
    using StochasticSearch

    function insertionsort!(A, i, j)
        for m = i + 1:j
            value = A[m]
            n = m - 1
            while n >= i && A[n] > value
                A[n + 1] = A[n]
                n = n - 1
            end
            A[n + 1] = value
        end
    end

    function quicksort!(A,cutoff,i=1,j=length(A))
        if j > i
            pivot = A[rand(i:j)]
            left, right = i, j
            while left <= right
                while A[left] < pivot
                    left += 1
                end
                while A[right] > pivot
                    right -= 1
                end
                if left <= right
                    A[left], A[right] = A[right], A[left]
                    left += 1
                    right -= 1
                end
            end
            if j - i <= cutoff
                insertionsort!(A, i, j)
            else
                quicksort!(A,cutoff,i,right)
                quicksort!(A,cutoff,left,j)
            end
        end
        return A
    end

    function sorting_cutoff(config::Configuration, args::Dict{ASCIIString, Any})
        A      = copy(args["array"])
        cutoff = config.value["cutoff"]
        @elapsed quicksort!(A, cutoff)
    end
end

array_size   = 100_000
cutoff       = 15
iterations   = 2_00
report_after = 4

args  = Dict{ASCIIString, Any}()
args["array"] = rand(array_size)

# Making sure code is already compiled.
@elapsed quicksort!(rand(10), 5)

configuration = Configuration([NumberParameter(0, array_size, cutoff, "cutoff")],
                               "Sorting Cutoff")

result = @task optimize(sorting_cutoff,
                        configuration,
                        [:simulated_annealing],
                        args         = args,
                        iterations   = iterations,
                        report_after = report_after,
                        evaluations  = 6,
                        instances    = [1])
partial = None
for i = 0:iterations
    partial = consume(result)
end
