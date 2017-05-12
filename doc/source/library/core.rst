.. _ref-core:

####
Core
####

This page will describes core and
utility functions.

``Run`` - ``mutable struct``
----------------------------

The ``Run`` type encapsulates the configuration parameters
of a tuning run. All parameters of ``Run`` are named and
have default values, so it is possible to call its constructor
with no parameters.

``cost::Function``
""""""""""""""""""

The ``cost`` parameter is the function that computes your program's fitness
value, or cost, for a given ``Configuration``.  This function must receive a
``Configuration``. Optionally, it can also receive a ``Dict`` with extra
invariant parameters. The ``cost`` default value is a constant function:

.. code:: julia

    cost::Function = (c(x) = 0)

``cost_arguments::Dict{Symbol, Any}``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    cost_arguments::Dict{Symbol, Any} = Dict{Symbol, Any}()

``cost_evaluations::Integer``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    cost_evaluations::Integer = 1

``cost_values::Array{AbstractFloat, 1}``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    cost_values::Array{AbstractFloat, 1} = [0.0]

``starting_point::Configuration``
"""""""""""""""""""""""""""""""""""""
.. code:: julia

    starting_point::Configuration = Configuration("empty")

``starting_cost::AbstractFloat = 0.0``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    starting_cost::AbstractFloat = 0.0

``report_after::Integer``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    report_after::Integer = 100

``reporting_criterion::Function``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    reporting_criterion::Function = iterations_reporting_criterion

``measurement_method::Function``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    measurement_method::Function = measure_mean!

``stopping_criterion::Function``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    stopping_criterion::Function = iterations_criterion

``duration::Integer``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    duration::Integer = 1_000

``methods::Array{Any, 2}``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    methods::Array{Any, 2} = [[:simulated_annealing 2];]

``channel::RemoteChannel``
"""""""""""""""""""""""""""""""""""""

.. code:: julia

    channel::RemoteChannel = RemoteChannel(()->Channel{Any}(128))
