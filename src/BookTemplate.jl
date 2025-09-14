module GeoSciML

using Reexport: @reexport
@reexport using Books:
    build_all,
    gen
@reexport using DataFrames:
    DataFrame,
    filter!,
    filter,
    select!,
    select
@reexport using LinearAlgebra
@reexport using Plots
@reexport using Statistics
@reexport using Random

export M, example_dataframe, geoscience_example

include("data.jl")

"""
    geoscience_example()

Example function demonstrating geoscientific data analysis.
"""
function geoscience_example()
    # Generate sample geophysical data
    depths = 0:5:100
    temperatures = 15.0 .+ 0.05 .* depths .+ randn(length(depths)) * 0.5
    
    return DataFrame(
        depth_m = collect(depths),
        temperature_c = temperatures
    )
end

"""
    build()

This function is called during CI to build the GeoSciML book.
"""
function build()
    println("Building Geoscientific Machine Learning & AI with Julia")
    # To avoid publishing broken websites.
    fail_on_error = true
    gen(; fail_on_error)
    build_all(; fail_on_error)
end

end # module
