## Autotuning NVCC Parameters
>6th NVIDIA GPU Workshop @ USP

This diretory contains resources for autotuning CUDA compiler parameters
using the [NODAL autotuning library](https://github.com/phrb/NODAL.jl).
This code was presented at the 6th NVIDIA GPU Workshop in 2017.

### Autotuner Dependencies

To run the autotuner you will need the latest Julia version, or nightly.
You can download the pre-compiled Julia nightly binaries from the language's
[Downloads](https://julialang.org/downloads/) page.

After downloading the binaries to a `JULIA_NIGHTLY` path of your preference, run the REPL:

```
$ JULIA_NIGHTLY/bin/julia
```

You should be greeted with the Julia logo and the prompt. Then, run:

```
julia> Pkg.clone("NODAL")
...
julia> Pkg.add("JSON")
...
```

### Running the Autotuner

Now you are ready to launch the autotuner. It comes with a simple vector addition CUDA example
in the directory `vec_add_example`.

To run the autotuner with default settings, run:

```
$ JULIA_NIGHTLY/bin/julia autotuner.jl
```

The final autotuned parameters will be written to the `final_configuration.txt` file.
To compile the optimized binary, simply run the NVCC command in `final_configuration.txt`.
You can also run, in `zsh`:

```
$ echo `$(cat final_configuration.txt)`
```

Or, for `bash`:

```
$ cat final_configuration.txt | bash
```

You can easily add new tunable NVCC or GCC parameters by changing the `settings/nvcc_flags.json`.
Make sure to follow the template for flags, enumerations and numerical parameters in the file.

### Configuring the Autotuner

You can change autotuner settings, such as tuning run duration and your CUDA path,
by modifying the contents of the `settings/settings.json` file:

```JSON
{
    "final_configuration": "final_configuration.txt",
    "report_after": 20,
    "duration": 300,
    "cost_evaluations": 5,
    "source_dir": "vec_add_example",
    "source": "vec_add.cu",
    "executable": "vec_add",
    "make_cmd": "nvcc -w --Wno-deprecated-gpu-targets",
    "use_makefile": false,
    "flags_variable": "NVCC_FLAGS=",
    "cuda_path": "-I/opt/cuda/include"
}
```

To autotune NVCC parameters for a new program, change the `"source_dir"`, `"source"` and
`"executable"` values.

If your application uses `make` or other build tools, change the values of
`"make_cmd"`, `"use_makefile"` and `"flags_variable"` to:

```JSON
"make_cmd": "make -sC",
"use_makefile": true,
"flags_variable": "NVCC_FLAGS=",
```

You will need to access the values of the variable `NVCC_FLAGS` from your `Makefile` or build script.
You can adapt the `Makefile` in `vec_add_example` to your program, or use it to modify
you existing `Makefile`. Otherwise, make sure your build tool can build from other directories and
pass the equivalent option to `make`'s `-C`.

### Extending the Autotuner

Feel free to modify the `autotuner.jl` file, and to submit pull requests and
issues to this repository!
