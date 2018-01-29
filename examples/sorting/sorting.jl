using Distributed
import NODAL

addprocs()

@everywhere begin
    using NODAL

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
        cutoff = config.value["cutoff"]
        time   = @elapsed quicksort!(args[:array], cutoff)
        shuffle!(args[:array])
        time
    end
end

function sorting()
    # Defining the array properties
    # and algorithm cutoff.
    array_size   = 10_000
    cutoff       = 15

    # Adding extra function arguments
    # for the array.
    args  = Dict{Symbol, Any}()
    args[:array] = rand(array_size)

    # Making sure code is already compiled.
    @elapsed quicksort!(rand(10), 5)

    configuration = Configuration([IntegerParameter(0, array_size, cutoff, "cutoff")],
                                   "Sorting Cutoff")

    tuning_run = Run(cost                = sorting_cutoff,
                     cost_arguments      = args,
                     cost_evaluations    = 4,
                     starting_point      = configuration,
                     methods             = [[:iterative_first_improvement 2];
                                            [:iterative_greedy_construction 2];
                                            [:iterative_probabilistic_improvement 2];
                                            [:randomized_first_improvement 2];
                                            [:simulated_annealing 2];],
                     stopping_criterion  = elapsed_time_criterion,
                     duration            = 30,
                     reporting_criterion = elapsed_time_reporting_criterion,
                     report_after        = 6)

    @spawn optimize(tuning_run)
    result = take!(tuning_run.channel)

    print(result)
    while !result.is_final
        result = take!(tuning_run.channel)
        print(result)
    end
end

sorting()
