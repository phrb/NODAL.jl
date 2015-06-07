# StochasticSearch
[![Build Status](https://travis-ci.org/phrb/StochasticSearch.jl.svg?branch=master)](https://travis-ci.org/phrb/StochasticSearch.jl)
[![Coverage Status](https://coveralls.io/repos/phrb/StochasticSearch.jl/badge.svg?branch=master)](https://coveralls.io/r/phrb/StochasticSearch.jl?branch=master)

===
StochasticSearch.jl is a julia package that provides tools and optimization algorithms for implementing different Stochastic Local Search methods, such as Simulated Annealing, Tabu Search, Nelder-Mead variations and Particle Swarm Optimization. It is an ongoing project, and currently implements only the Simulated Annealing algorithm. The package offers a limited interface to [Optim.jl](https://github.com/JuliaOpt/Optim.jl). StochasticSearch.jl will implement more optimization and local search algorithms. The API will provide tools for implementing parallel and distributed program autotuners.

Currently, it's possible to optimize user-defined functions with the Simulated Annealing search technique. Evaluations of functions are made in parallel, and it's possible to instantiate multiple instances of a search technique that run on the same problem.
### Installing
From the Julia REPL, run:
```jl
Pkg.clone("StochasticSearch")
```
===
### Example
First, let's define a a ```Configuration``` that will represent arguments for the [Rosenbrock](http://en.wikipedia.org/wiki/Rosenbrock_function) function. The configuration will have two ```NumberParameter```, which will be ```Float64``` values constrained to an interval:
```jl
@everywhere using StochasticSearch

configuration = Configuration([NumberParameter(-2.0, 2.0, 0.0,"i0"),
                               NumberParameter(-2.0, 2.0, 0.0,"i1")],
                               "rosenbrock_config")
```
Here, the intervas are ```[-2.0, 2.0]``` for both parameters, and the parameters start at value ```0.0```. Now we define the Rosenbrock function. Our definition accepts a configuration as input and uses its parameters values, encoded as ```"i0"``` and ```"i1"```, to produce an output.

Note that the package is imported with ```@everywhere```, because we want to load it in every worker that is available.

Now, we write the Rosebrock function:
```jl
@everywhere function rosenbrock(x::Configuration)
    return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
end
```
For the same reasons as before, we declare ```rosenbrock``` in every available worker.

Now we are ready to use the ```optimize``` method, which could be called with just a ```Configuration``` and a function that accepts a ```Configuration``` as input. The function must also return a ```Float64```.

We will also call ```optimize``` with specified ```iterations``` and ```report_after``` arguments, which will stop the task after a certain number of iterations, and make the task report back to us after fixed intervals.
```jl
iterations   = 1_000
report_after = 1_00

result = @task optimize(rosenbrock,
                        configuration,
                        iterations   = iterations,
                        report_after = report_after)
```
Without further configuration, 'optimize' will use the default neighboring and perturbation methods implemented by StochasticSearch.jl, and will optimize the configuration with the Simulated Annealing method. Since we wrapped ```optimize``` within a task, we must consume values from it to obtain the optimization results. For more information on how tasks work, check the [Julia Documentation](http://julia.readthedocs.org/en/latest/manual/control-flow/#tasks-aka-coroutines). Basically, we simply call ```consume``` to get an intermediate result, that can be processed or ignored. ```optimize``` will print in the terminal at every ```report_after``` iterations. The final piece of code is this:
```jl
partial = None
for i = 0:iterations
    partial = consume(result)
end
```
Running the complete example program, we get:
```jl
% julia examples/rosenbrock.jl
---
(other partial results)
---
[Partial Result] [Cost] 0.156211 
[Technique] Simulated Annealing [Found in Iteration]   342 
[Current Iteration]   900

[Final Result]        :
[Technique]           : Simulated Annealing
[Cost]                : 0.156211
[Found in Iteration]  : 342
[Function Calls]      : 342
[Start Configuration]
  [Configuration] Configuration{NumberParameter{Float64}}
  (name: rosenbrock_config,
    [Parameters]
     ==========
    ("i0",
    [NumberParameter] NumberParameter{Float64}
    (name: i0, min: -2.000000, max: 2.000000, value: 0.000000)
)
    ("i1",
    [NumberParameter] NumberParameter{Float64}
    (name: i1, min: -2.000000, max: 2.000000, value: 0.000000)
)
     =========
  )
[Minimum Configuration]
  [Configuration] Configuration{NumberParameter{Float64}}
  (name: rosenbrock_config,
    [Parameters]
     ==========
    ("i0",
    [NumberParameter] NumberParameter{Float64}
    (name: i0, min: -2.000000, max: 2.000000, value: 1.371554)
)
    ("i1",
    [NumberParameter] NumberParameter{Float64}
    (name: i1, min: -2.000000, max: 2.000000, value: 1.867684)
)
     =========
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
    return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end
```
StochasticSearch converts configurations into ```Array{Number}```, and does not keep the intervals they are constrained to inside the array. Therefore, the boundaries set by the parameters are not respected when optimizing a configuration in this way.

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
