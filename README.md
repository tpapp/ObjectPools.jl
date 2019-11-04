# ObjectPools.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/tpapp/ObjectPools.jl.svg?branch=master)](https://travis-ci.com/tpapp/ObjectPools.jl)
[![codecov.io](http://codecov.io/github/tpapp/ObjectPools.jl/coverage.svg?branch=master)](http://codecov.io/github/tpapp/ObjectPools.jl?branch=master)

An implementation of user-managed object pools in Julia.

# Overview

This package is designed for use cases where some *inner* functions would need to allocate a large number of arrays which would not escape an outer function `f`. An object pool allows the user to obtain new objects with the `new!`, then allow them to be recycled with `recycle!`.

Consider this (contrived) example:

```julia
function f(pool, x::AbstractVector{T}) where T
    recycle!(pool)                   # reuse all arrays
    S = float(T)
    l = length(x)
    y = new!(pool, Vector{S}, l)     # taken from pool
    z = new!(pool, Matrix{S}, l, l)  # taken from pool
    @. y = abs2(x)
    z .= x .+ permutedims(x)
    z * y                            # the only allocated array
end
```

`pool = ArrayPool()` will save the relevant interim arrays and avoid allocation when necessary. If the function is called with various types, these will eventually accumulate too in `pool`.
