.. _ref-getting_started:

----------------------------
Getting Started
----------------------------

This page will tell you how to install,
test and contribute to the package.

Installing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NODAL.jl runs on Julia `nightly`_. To get the latest version run:

.. _nightly: http://julialang.org/downloads/

.. code:: julia

    julia> Pkg.clone("NODAL")

Running Tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run all tests with:

.. code:: julia

    $ julia --color=yes test/runtests.jl

Contributing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You will need Julia `nightly`_.  Check the project's ``REQUIRE`` file for an
up-to-date dependency list.  Please, feel free to fork the `repository`_ and
submit a pull request.  You can also check the **GitHub** `issues page`_ for
things that need to be done.

.. _issues page: https://github.com/phrb/NODAL.jl/issues
.. _repository: https://github.com/phrb/NODAL.jl
