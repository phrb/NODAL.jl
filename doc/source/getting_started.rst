.. _ref-getting_started:

----------------------------
Getting Started
----------------------------

This page will tell you how to install,
test and contribute to the package.

Installing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

StochasticSearch.jl runs on Julia **v0.4.0**. From the Julia REPL, run::

    julia> Pkg.add("StochasticSearch")

If you want the latest version, which may be unstable, run instead::

    julia> Pkg.clone("StochasticSearch")

Running Tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can check that all tests pass with::

    $ julia --color=yes test/runtests.jl

Contributing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You will need **Julia v0.4.3** and the FactCheck
module. Check the project's ``REQUIRE`` file for an up-to-date
dependency list.

Please, feel free to fork the `repository
<https://github.com/phrb/StochasticSearch.jl>`_ and submit a pull request.
You can also check the **GitHub** `issues page
<https://github.com/phrb/StochasticSearch.jl/issues>`_ for things that
need to be done.
