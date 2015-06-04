# StochasticSearch
[![Build Status](https://travis-ci.org/phrb/StochasticSearch.jl.svg?branch=master)](https://travis-ci.org/phrb/StochasticSearch.jl)
[![Coverage Status](https://coveralls.io/repos/phrb/StochasticSearch.jl/badge.svg?branch=master)](https://coveralls.io/r/phrb/StochasticSearch.jl?branch=master)

===
StochasticSearch.jl is a julia package that provides tools and optimization algorithms for implementing different Stochastic Local Search methods, such as FocusedILS and Racing Algorithms. It is an ongoing project, and currently offers a limited interface to [Optim.jl](https://github.com/JuliaOpt/Optim.jl). In the future, StochasticSearch.jl will implement its own optimization and local search algorithms. The API will provide tools for implementing parallel and distributed program autotuners.
### Installing
From the Julia REPL, run:
```jl
Pkg.clone("git@github.com:phrb/StochasticSearch.jl.git")
```
===
### Example
First, let's define a a ```Configuration``` that will represent arguments for the Rosenbrock function. The configuration will have two ```NumberParameter```, which will be ```Float64``` values constrained to an interval:
```jl
using StochasticSearch

configuration = Configuration([NumberParameter(-2.0,2.0,0.0,:i0),
                               NumberParameter(-2.0,2.0,0.0,:i1)],
                               :rosenbrock_config)
```
Here, the intervas are ```[-2.0, 2.0]``` for both parameters, and the parameters start at value ```0.0```. Now we define the Rosenbrock function. Our definition accepts a configuration as input and uses its parameters values, encoded as ```:i0``` and ```:i1```, to produce an output.
```jl
function rosenbrock(x::Configuration)
    return (1.0 - x[:i0].value)^2 + 100.0 * (x[:i1].value - x[:i0].value^2)^2
end
```
Now we are ready to use the ```optimize``` method, which can be called with just a ```Configuration``` and a function that accepts a ```Configuration``` as input, and must return a ```Number``` or some other comparable type.
```jl
result = optimize(rosenbrock, configuration)
```
Without further configuration, 'optimize' will use the default neighboring and perturbation methods implemented by StochasticSearch.jl. Running the complete example program, we get:
```jl
% julia examples/rosenbrock.jl      
*Result               :
*Technique            : Simulated Annealing
*Cost                 : 0.036373
*Iterations           : 1000
*Function Calls       : 1001
*Start Configuration  :

        *Configuration: Configuration{NumberParameter{Float64}}
                  name: rosenbrock_config
           *Parameters:
(:i1,
      *NumberParameter:     NumberParameter{Float64}
                  name:     i1
                   min:     -2.000000
                   max:     2.000000
         current value:     0.000000
)(:i0,
      *NumberParameter:     NumberParameter{Float64}
                  name:     i0
                   min:     -2.000000
                   max:     2.000000
         current value:     0.000000
)
*Minimum Configuration:

        *Configuration: Configuration{NumberParameter{Float64}}
                  name: rosenbrock_config
           *Parameters:
(:i1,
      *NumberParameter:     NumberParameter{Float64}
                  name:     i1
                   min:     -2.000000
                   max:     2.000000
         current value:     1.417410
)(:i0,
      *NumberParameter:     NumberParameter{Float64}
                  name:     i0
                   min:     -2.000000
                   max:     2.000000
         current value:     1.190689
)
```
===
### Using Optim.jl methods
Let's use the Simulated Annealing algorithm implemented in Optim.jl to optimize the Rosenbrock function. We will represent the problem as a ```Configuration``` with two ```NumberParameter```, which are ```Float64``` values constrained to an interval.
```jl
using StochasticSearch

configuration = Configuration([NumberParameter(-2.0,2.0,0.0,:a), 
                               NumberParameter(-2.0,2.0,0.0,:b)],
                               :rosenbrock_config)
```
Here, the interval is ```[-2.0, 2.0]```, and both parameters start at point ```0.0```. In this example we will use the default neighboring and perturbation methods already implemented in StochasticSearch, so the next step is defining the Rosenbrock function. The ```Symbol``` ```:rosenbrock_config``` is simply an identifier for this configuration.
```jl
function rosenbrock(x::Array)
    return (1.0 - x[1])^2 + 100.0 * (x[4] - x[1]^2)^2
end
```
Note the weird access pattern on ```x```. This is done like this because in the current implementation of the interface to Optim.jl, StochasticSearch converts configurations into ```Array{Number}```, but keeps the intervals they are constrained to inside the array, to be used by the neighboring and pertubation methods.

The optimization is done with:
```jl
result = optimize!(rosenbrock, configuration)
```
Now, ```result``` contains an object that describes the results of the optimization. Running the code on the REPL, and adding a ```println(result)```, we have:
```jl
$ julia examples/optim_rosenbrock.jl
*Result               :
*Technique            : Simulated Annealing
*Cost                 : 0.000614
*Iterations           : 100000
*Function Calls       : 100001
*Start Configuration  :

        *Configuration: Configuration{NumberParameter{Float64}}
                  name: rosenbrock_config
           *Parameters:
(:b,
      *NumberParameter:     NumberParameter{Float64}
                  name:     b
                   min:     -2.000000
                   max:     2.000000
         current value:     0.000000
)(:a,
      *NumberParameter:     NumberParameter{Float64}
                  name:     a
                   min:     -2.000000
                   max:     2.000000
         current value:     0.000000
)
*Minimum Configuration:

        *Configuration: Configuration{NumberParameter{Float64}}
                  name: rosenbrock_config
           *Parameters:
(:b,
      *NumberParameter:     NumberParameter{Float64}
                  name:     b
                   min:     -2.000000
                   max:     2.000000
         current value:     0.975271
)(:a,
      *NumberParameter:     NumberParameter{Float64}
                  name:     a
                   min:     -2.000000
                   max:     2.000000
         current value:     0.950996
)
```
The original ```Configuration``` object is already updated with the optimized results. Since we're using the Optim.jl interface for the optimization, we'll have to convert the configuration to an ```Array``` so we can check the results with the ```rosenbrock``` function. This can be done with:
```jl
 a = Symbol[]
 println(rosenbrock(convert(Array{Number}, configuration, a)))
```
And would print the value ```0.0006139995371618324```, for this example.
