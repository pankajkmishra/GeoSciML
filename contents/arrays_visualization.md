# Arrays & Visualization

Working with arrays and creating effective visualizations are essential skills for geoscientific data analysis. Julia provides powerful tools for both numerical computation and data visualization.

## Arrays and Linear Algebra

Julia's built-in support for linear algebra makes it excellent for geoscientific computations involving matrices and vectors.

```jl
using LinearAlgebra

# Create different types of arrays
depths = collect(0:10:100)  # Depth measurements
temperatures = [15.0, 15.5, 16.0, 16.8, 17.5, 18.2, 19.0, 19.8, 20.5, 21.2, 22.0]

println("Number of depth measurements: $(length(depths))")
println("Depth range: $(minimum(depths))m to $(maximum(depths))m")
println("Temperature range: $(minimum(temperatures))°C to $(maximum(temperatures))°C")

# Matrix operations
A = [1.0 2.0 3.0; 4.0 5.0 6.0; 7.0 8.0 9.0]
B = [2.0 1.0 0.5; 1.5 3.0 2.5; 0.8 1.2 4.0]

println("Matrix A:")
display(A)
println("Matrix B:")
display(B)

# Matrix multiplication and element-wise operations
C = A * B  # Matrix multiplication
D = A .+ B # Element-wise addition

println("Matrix multiplication A × B:")
display(C)
```

## Data Visualization

Creating effective plots is crucial for understanding geoscientific data:

```jl
using Plots

# Create sample geophysical data
x = 1:10
temperature_profile = 15.0 .+ 0.5 .* x .+ 0.1 .* randn(10)
pressure_profile = 1013.0 .- 12.0 .* x .+ 2.0 .* randn(10)

# Create plots
p1 = plot(x, temperature_profile, 
          title="Temperature Profile", 
          xlabel="Depth (km)", 
          ylabel="Temperature (°C)",
          marker=:circle, 
          linewidth=2,
          legend=false)

p2 = plot(x, pressure_profile,
          title="Pressure Profile",
          xlabel="Depth (km)", 
          ylabel="Pressure (hPa)",
          marker=:square,
          linewidth=2,
          legend=false,
          color=:red)

# Combine plots
combined_plot = plot(p1, p2, layout=(1,2), size=(800,300))
display(combined_plot)

# Statistical analysis
using Statistics
println("Temperature statistics:")
println("  Mean: $(round(mean(temperature_profile), digits=2))°C")
println("  Std:  $(round(std(temperature_profile), digits=2))°C")

println("Pressure statistics:")
println("  Mean: $(round(mean(pressure_profile), digits=2)) hPa") 
println("  Std:  $(round(std(pressure_profile), digits=2)) hPa")
```
