<p align="center">
    <img src="https://github.com/phrb/NODAL.jl/blob/master/img/logo.svg"
         height="280">
</p>
<p align="center">
    <a href="https://badge.fury.io/gh/phrb%2FNODAL.jl">
        <img src="https://badge.fury.io/gh/phrb%2FNODAL.jl.svg"
             alt="Git Version">
    </a>
    <a href="http://pkg.julialang.org/?pkg=StochasticSearch">
        <img src="http://pkg.julialang.org/badges/NODAL_0.7.svg"
             alt="Julia Package Version">
    </a>
    <a href="https://travis-ci.org/phrb/NODAL.jl">
        <img src="https://travis-ci.org/phrb/NODAL.jl.svg"
             alt="Build Status">
    </a>
    <a href="https://coveralls.io/r/phrb/NODAL.jl">
        <img src="https://coveralls.io/repos/phrb/NODAL.jl/badge.svg"
             alt="Coverage">
    </a>
    <a href="http://nodal.readthedocs.org/en/latest/?badge=latest">
        <img src="https://readthedocs.org/projects/nodal/badge/?version=latest"
             alt="Documentation Status">
    </a>
</p>

NODAL provides tools for implementing parallel and distributed
program autotuners.  This Julia package provides tools and optimization
algorithms for implementing different Stochastic Local Search methods, such as
Simulated Annealing and Tabu Search. NODAL is an ongoing project,
and will implement more optimization and local search algorithms.

You can use NODAL to optimize user-defined functions with a few
Stochastic Local Search basic methods, that are composed by building blocks
also provided in the package. The package distributes evaluations of functions
and technique executions between Julia workers. It is possible to have multiple
instances of search techniques running on the same problem.

### Installing

NODAL runs on Julia **nightly**. From the Julia REPL, run:

```jl
Pkg.add("NODAL")
```

If you want the latest version, which may be unstable, run instead:

```jl
Pkg.clone("NODAL")
```

### Documentation

Please, refer to the
[documentation](http://stochasticsearchjl.readthedocs.org/) for more
information and examples.

### Example: The Rosenbrock Function

The following is a very simple example, and you can find the [source
code](https://github.com/phrb/NODAL.jl/blob/master/examples/rosenbrock/rosenbrock.jl)
for its latest version in the GitHub repository.

We will optimize the
[Rosenbrock](http://en.wikipedia.org/wiki/Rosenbrock_function) cost function.
For this we must define a `Configuration` that represents the arguments to be
tuned. We also have to create and configure a tuning run. First, let's import
NODAL and define the cost function:

``` julia
addprocs()

import NODAL

@everywhere begin
    using NODAL
    function rosenbrock(x::Configuration, parameters::Dict{Symbol, Any})
        return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
    end
end
```
**Note**:

>The Rosenbrock function is by no means a good autotuning objetive, although
>it is a good tool to help you get familiar with the API.
>NODAL certainly performs worse than most tools for this kind
>of function.  Look at further examples is this page for more fitting
>applications.

We use the `addprocs()` function to add the default number of Julia workers,
one per processing core, to our application. The `import` statement loads
NODAL in the current Julia worker, and the `@everywhere` macro defines
the `rosenbrock` function and the module in all Julia workers available.

Cost functions must accept a `Configuration` and a `Dict{Symbol, Any}` as
input. The `Configuration` is used to define the autotuner's search space,
and the parameter dictionary can store data or function configurations.

Our cost function simply ignores the parameter dictionary, and uses the
`"i0"` and `"i1"` parameters of the received configuration to calculate a
value. There is no restriction on the names of `Configuration` parameter.

Our configuration will have two `FloatParameter`s, which will be `Float64`
values constrained to an interval. The intervals are `[-2.0, 2.0]` for both
parameters, and their values start at `0.0`. Since we already used the names
`"i0"` and `"i1"`, we name the parameters the same way:

``` julia
configuration = Configuration([FloatParameter(-2.0, 2.0, 0.0, "i0"),
                               FloatParameter(-2.0, 2.0, 0.0, "i1")],
                               "rosenbrock_config")
```

Now we must configure a new tuning run using the `Run` type. There are many
parameters to configure, but they all have default values. Since we won't be
using them all, please see `Run`'s
[source](https://github.com/phrb/NODAL.jl/blob/master/src/core/run.jl)
for further details:

``` julia
tuning_run = Run(cost                = rosenbrock,
                 starting_point      = configuration,
                 stopping_criterion  = elapsed_time_criterion,
                 report_after        = 10,
                 reporting_criterion = elapsed_time_reporting_criterion,
                 duration            = 60,
                 methods             = [[:simulated_annealing 1];
                                        [:iterative_first_improvement 1];
                                        [:iterated_local_search 1];
                                        [:randomized_first_improvement 1];
                                        [:iterative_greedy_construction 1];])
```

The `methods` array defines the search methods, and their respective number of
instances, that will be used in this tuning run. This example uses one instance
of every implemented search technique. The search will start at the point
defined by `starting_point`.

The `stopping_criterion` parameter is a function. It tells your autotuner when
to stop iterating. The two default criteria implemented are
`elapsed_time_criterion` and `iterations_criterion`.  The `reporting_criterion`
parameter is also function, but it tells your autotuner when to report the
current results. The two default implementations are
`elapsed_time_reporting_criterion` and `iterations_reporting_criterion`.  Take
a look at the
[code](https://github.com/phrb/NODAL.jl/tree/master/src/core/search/tools)
if you want to dive deeper.

We are ready to start autotuning, using the `@spawn` macro. For more
information on how parallel and distributed computing works in Julia, please
check the [Julia Docs](http://docs.julialang.org/en/latest).  This macro call
will run the `optimize` method, which receives a tuning run configuration and
runs the search techniques in the background. The autotuner will write its
results to a `RemoteChannel` stored in the tuning run configuration:

``` julia
@spawn optimize(tuning_run)
result = take!(tuning_run.channel)
```

The tuning run will use the default neighboring and perturbation methods
implemented by NODAL to find new results. Now we can process the
current result. In this example we just `print` it and loop until `optimize` is
done:

``` julia
print(result)
while !result.is_final
    result = take!(tuning_run.channel)
    print(result)
end
```

Running the complete example, we get:

``` bash
$ julia --color=yes rosenbrock.jl
[Result]
Cost              : 1.0
Found in Iteration: 1
Current Iteration : 1
Technique         : Initialize
Function Calls    : 1
  ***
[Result]
Cost              : 1.0
Found in Iteration: 1
Current Iteration : 3973
Technique         : Initialize
Function Calls    : 1
  ***
[Result]
Current Iteration : 52289
Technique         : Iterative First Improvement
Function Calls    : 455
  ***
[Result]
Cost              : 0.01301071782455056
Found in Iteration: 10
Current Iteration : 70282
Technique         : Randomized First Improvement
Function Calls    : 3940
  ***
[Result]
Cost              : 0.009463518035824526
Found in Iteration: 11
Current Iteration : 87723
Technique         : Randomized First Improvement
Function Calls    : 4594
  ***
[Final Result]
Cost                  : 0.009463518035824526
Found in Iteration    : 11
Current Iteration     : 104261
Technique             : Randomized First Improvement
Function Calls        : 4594
Starting Configuration:
  [Configuration]
  name      : rosenbrock_config
  parameters:
    [NumberParameter]
    name : i0
    min  : -2.000000
    max  : 2.000000
    value: 1.100740
    ***
    [NumberParameter]
    name : i1
    min  : -2.000000
    max  : 2.000000
    value: 1.216979
Minimum Configuration :
  [Configuration]
  name      : rosenbrock_config
  parameters:
    [NumberParameter]
    name : i0
    min  : -2.000000
    max  : 2.000000
    value: 0.954995
    ***
    [NumberParameter]
    name : i1
    min  : -2.000000
    max  : 2.000000
    value: 0.920639
```
