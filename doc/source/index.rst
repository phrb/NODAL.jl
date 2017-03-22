%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    StochasticSearch.jl Documentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

StochasticSearch.jl provides tools for implementing parallel and distributed
program autotuners.  This Julia package provides tools and optimization
algorithms for implementing different Stochastic Local Search methods, such as
Simulated Annealing and Tabu Search. StochasticSearch.jl is an ongoing project,
and will implement more optimization and local search algorithms.

You can use StochasticSearch.jl to optimize user-defined functions with a few
Stochastic Local Search basic methods, that are composed by building blocks
also provided in the package. The package distributes evaluations of functions
and technique executions between Julia workers. It is possible to have multiple
instances of search techniques running on the same problem.

.. _manual:

##################
Manual
##################

.. toctree::
    :maxdepth: 1

    manual/introduction
    manual/getting_started
    manual/examples

.. _library:

##################
Library
##################

.. toctree::
    :maxdepth: 1

    library/introduction
    library/core
    library/types
    library/search_module
    library/measurement
