# StochasticSearch
[![StochasticSearch](http://pkg.julialang.org/badges/StochasticSearch_0.3.svg)](http://pkg.julialang.org/?pkg=StochasticSearch&ver=0.3)
[![StochasticSearch](http://pkg.julialang.org/badges/StochasticSearch_0.4.svg)](http://pkg.julialang.org/?pkg=StochasticSearch&ver=0.4)
[![Build Status](https://travis-ci.org/phrb/StochasticSearch.jl.svg?branch=master)](https://travis-ci.org/phrb/StochasticSearch.jl)
[![Coverage Status](https://coveralls.io/repos/phrb/StochasticSearch.jl/badge.svg?branch=master)](https://coveralls.io/r/phrb/StochasticSearch.jl?branch=master)

===
StochasticSearch.jl is a julia package that provides tools and optimization algorithms for implementing different Stochastic Local Search methods, such as Simulated Annealing, Tabu Search, Nelder-Mead variations and Particle Swarm Optimization. It is an ongoing project, and currently implements only the Simulated Annealing algorithm. The package offers a limited interface to [Optim.jl](https://github.com/JuliaOpt/Optim.jl). StochasticSearch.jl will implement more optimization and local search algorithms. The API will provide tools for implementing parallel and distributed program autotuners.

Currently, it's possible to optimize user-defined functions with the Simulated Annealing search technique. Evaluations of functions are made in parallel, and it's possible to instantiate multiple instances of a search technique that run on the same problem.
### Installing
From the Julia REPL, run:
```jl
Pkg.add("StochasticSearch")
```
===
### Example
The following is a very simple example. For more interesting examples, check [Tuning cutoff for Sorting Algorithms](https://github.com/phrb/StochasticSearch.jl/wiki/Tuning-the-Cutoff-for-Sorting-Algorithms) and [Using Optim.jl methods](https://github.com/phrb/StochasticSearch.jl/wiki/Using-Optim.jl-methods).
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

Now we are ready to use the ```search``` method, which could be called with just a ```Configuration``` and a function that accepts a ```Configuration``` as input. The function must also return a ```Float64```.

We will also call ```search``` with specified ```iterations``` and ```report_after``` arguments, which will stop the task after a certain number of iterations, and make the task report back to us after fixed intervals.
```jl
iterations   = 1_000
report_after = 1_00

result = @task search(rosenbrock,
                      configuration,
                      iterations   = iterations,
                      report_after = report_after)
```
Without further configuration, 'search' will use the default neighboring and perturbation methods implemented by StochasticSearch.jl, and will optimize the configuration with the Simulated Annealing method. Since we wrapped ```search``` within a task, we must consume values from it to obtain the optimization results. For more information on how tasks work, check the [Julia Documentation](http://julia.readthedocs.org/en/latest/manual/control-flow/#tasks-aka-coroutines). Basically, we simply call ```consume``` to get an intermediate result, that can be processed or ignored. ```search``` will print in the terminal at every ```report_after``` iterations. The final piece of code is this:
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
