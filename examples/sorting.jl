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

    function sorting_cutoff(config::Configuration, args::Dict{Symbol, Any})
        A      = copy(args[:array])
        cutoff = config.value["cutoff"]
        @elapsed quicksort!(A, cutoff)
    end
end

# Defining the array properties
# and algorithm cutoff.
array_size   = 100_000
cutoff       = 15

# Adding extra function arguments
# for the array.
args  = Dict{Symbol, Any}()
args[:array] = rand(array_size)

# Making sure code is already compiled.
@elapsed quicksort!(rand(10), 5)

configuration = Configuration([NumberParameter(0, array_size, cutoff, "cutoff")],
                               "Sorting Cutoff")

methods     = [:simulated_annealing,
               :iterative_first_improvement,
               :randomized_first_improvement,
               :iterative_greedy_construction,
               :iterative_probabilistic_improvement]

instances   = [1, 1, 1, 1, 1]
iterations  = 1_00

parameters = Dict(:cost               => sorting_cutoff,
                  :cost_args          => args,
                  :initial_config     => configuration,
                  :iterations         => iterations,
                  :report_after       => 4,
                  :stopping_criterion => elapsed_time_criterion,
                  :seconds            => 120,
                  :measurement_method => sequential_measure_mean!,
                  :methods            => methods,
                  :instances          => instances,
                  :evaluations        => 4)

search_task = @task optimize(parameters)

result = consume(search_task)
print(result)
while result.is_final == false
    result = consume(search_task)
    print(result)
end
