#!/bin/bash

julia --project=docs -e '
using Pkg
Pkg.activate("docs")
Pkg.add("tectonic_jll")
Pkg.instantiate()
'

julia --project=docs docs/make.jl

echo "PDF should be available at: docs/build/html/GeoSciML.pdf"