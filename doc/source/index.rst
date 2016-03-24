StochasticSearch.jl
=====================

This Julia package provides tools and optimization algorithms for implementing
different Stochastic Local Search methods, such as Simulated Annealing and Tabu
Search. StochasticSearch.jl is an ongoing project, and will implement more
optimization and local search algorithms. The API provides tools for
implementing parallel and distributed program autotuners.

You can use StochasticSearch.jl to optimize user-defined functions with a few
Stochastic Local Search basic methods, that are composed by building blocks
also provided in the package. The package distributes evaluations of functions
and technique executions between Julia workers using ``remotecall``\s in
different ``Tasks``\s. It is possible to have multiple instances of
search techniques running on the same problem.

Contents:

.. toctree::
    :maxdepth: 2

    getting_started.rst
    examples.rst
    types.rst
    search_module.rst
    measurement.rst



Indices and tables
==================

* :ref:`genindex`
* :ref:`search`
