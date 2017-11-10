.. _ref-examples:

----------------------------
Examples
----------------------------

This page provides examples that
will help you learn the package's
API.

.. note::

    The package is in heavy development. If something does not work as is show
    here, it is likely the API changed but the docs didn't. Submit an issue at the
    `GitHub repository`_ and the docs will be updated.

.. _GitHub repository: https://github.com/phrb/NODAL.jl

The Rosenbrock Function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following is a very simple example, and you can find the `source code`_ for
its latest version in the GitHub repository.

.. _source code: https://github.com/phrb/NODAL.jl/blob/master/examples/rosenbrock/rosenbrock.jl

We will optimize the `Rosenbrock`_ cost function.
For this we must define a ``Configuration`` that represents the arguments to
be tuned. We also have to create and configure a tuning run. First, let's
import NODAL.jl and define the cost function:

.. _Rosenbrock: http://en.wikipedia.org/wiki/Rosenbrock_function

.. code:: julia

    addprocs()

    import NODAL

    @everywhere begin
        using NODAL
        function rosenbrock(x::Configuration, parameters::Dict{Symbol, Any})
            return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
        end
    end

We use the ``addprocs()`` function to add the default number of Julia workers,
one per processing core, to our application. The ``import`` statement loads
NODAL.jl in the current Julia worker, and the ``@everywhere`` macro defines
the ``rosenbrock`` function and the module in all Julia workers available.

Cost functions must accept a ``Configuration`` and a ``Dict{Symbol, Any}`` as
input. The ``Configuration`` is used to define the autotuner's search space,
and the parameter dictionary can store data or function configurations.

Our cost function simply ignores the parameter dictionary, and uses the
``"i0"`` and ``"i1"`` parameters of the received configuration to calculate a
value. There is no restriction on the names of ``Configuration`` parameter.

Our configuration will have two ``FloatParameter``\s, which will be ``Float64``
values constrained to an interval. The intervals are ``[-2.0, 2.0]`` for both
parameters, and their values start at ``0.0``. Since we already used the names
``"i0"`` and ``"i1"``, we name the parameters the same way:

.. code:: julia

    configuration = Configuration([FloatParameter(-2.0, 2.0, 0.0, "i0"),
                                   FloatParameter(-2.0, 2.0, 0.0, "i1")],
                                   "rosenbrock_config")

Now we must configure a new tuning run using the ``Run`` type. There are many
parameters to configure, but they all have default values. Since we won't be
using them all, please see ``Run``'s `source`_ for further details:

.. _source: https://github.com/phrb/NODAL.jl/blob/master/src/core/run.jl

.. code:: julia

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

The ``methods`` array defines the search methods, and their respective number of
instances, that will be used in this tuning run. This example uses one instance
of every implemented search technique. The search will start at the point
defined by ``starting_point``.

The ``stopping_criterion`` parameter is a function. It tells your autotuner
when to stop iterating. The two default criteria implemented are
``elapsed_time_criterion`` and ``iterations_criterion``.  The
``reporting_criterion`` parameter is also function, but it tells your autotuner
when to report the current results. The two default implementations are
``elapsed_time_reporting_criterion`` and ``iterations_reporting_criterion``.
Take a look at the `code`_ if you want to dive deeper.

.. _code: https://github.com/phrb/NODAL.jl/tree/master/src/core/search/tools

We are ready to start autotuning, using the ``@spawn`` macro. For more
information on how parallel and distributed computing works in Julia, please check
the `Julia Docs`_.
This macro call will run the ``optimize`` method, which receives a tuning run
configuration and runs the search techniques in the background. The autotuner
will write its results to a ``RemoteChannel`` stored in the tuning run configuration:

.. _Julia Docs: http://docs.julialang.org/en/latest

.. code:: julia

    @spawn optimize(tuning_run)
    result = take!(tuning_run.channel)

The tuning run will use the default neighboring and perturbation methods
implemented by NODAL.jl to find new results. Now we can process the
current result. In this example we just ``print`` it and loop until ``optimize`` is
done:

.. code:: julia

    print(result)
    while !result.is_final
        result = take!(tuning_run.channel)
        print(result)
    end

Running the complete example, we get:

.. code::

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

.. note::

    The Rosenbrock function is by no means a good autotuning objetive, although
    it is a good tool to help you get familiar with the API.
    NODAL.jl certainly performs worse than most tools for this kind
    of function.  Look at further examples is this page for more fitting
    applications.

Autotuning Genetic Algorithms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Autotuning LLVM Pass Ordering and Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
