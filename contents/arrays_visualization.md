# Arrays & Visualization

Working with arrays and creating effective visualizations are essential skills for geoscientific data analysis. Julia provides powerful tools for both numerical computation and data visualization.

## Arrays and Linear Algebra

Julia's built-in support for linear algebra makes it excellent for geoscientific computations involving matrices and vectors.

### Creating and Manipulating Arrays

```jl
# Create different types of arrays
depths = collect(0:5:100)  # Range converted to array
temperatures = [15.0, 15.3, 15.8, 16.2, 16.8, 17.1, 17.5, 18.0, 18.4, 18.9, 
                19.2, 19.6, 20.0, 20.3, 20.7, 21.1, 21.4, 21.8, 22.1, 22.5, 22.8]

println("Number of depth measurements: $(length(depths))")
println("Depth range: $(minimum(depths))m to $(maximum(depths))m")
println("Temperature range: $(minimum(temperatures))C to $(maximum(temperatures))C")
```

### Matrix Operations

```jl
using LinearAlgebra

# Create sample matrices representing geophysical data
A = [1.0 2.0 3.0; 4.0 5.0 6.0; 7.0 8.0 9.0]  # 3x3 matrix
B = [2.0 1.0 0.5; 1.5 3.0 2.5; 0.8 1.2 4.0]  # Another 3x3 matrix

println("Matrix A:")
display(A)
println("\nMatrix B:")
display(B)

# Matrix operations
C = A * B  # Matrix multiplication
D = A .+ B # Element-wise addition

println("\nMatrix multiplication A × B:")
display(C)
println("\nElement-wise addition A + B:")
display(D)
```

### Eigenvalues and Eigenvectors

These are important in many geoscientific applications, such as principal component analysis:

```jl
# Calculate eigenvalues and eigenvectors
eigenvals_A = eigvals(A)
eigenvecs_A = eigvecs(A)

println("Eigenvalues of matrix A:")
for (i, λ) in enumerate(eigenvals_A)
    println("λ$i = $(round(λ, digits=3))")
end
```

## Data Visualization with Plots.jl

Visualization is crucial for understanding geoscientific data patterns and relationships.

### Basic Line Plots

```jl
using Plots

# Create a depth-temperature profile
p1 = plot(temperatures, depths,
    title="Temperature vs Depth Profile",
    xlabel="Temperature (C)",
    ylabel="Depth (m)",
    yflip=true,  # Flip y-axis to show depth increasing downward
    linewidth=2,
    color=:red,
    marker=:circle,
    markersize=4,
    legend=false)

display(p1)
```

### Scatter Plots for Data Exploration

```jl
# Simulate some geophysical measurements
using Random
Random.seed!(42)  # For reproducible results

n_samples = 50
porosity = rand(n_samples) * 0.4  # 0-40% porosity
permeability = porosity.^2 * 1000 .+ randn(n_samples) * 50  # Correlated with noise

p2 = scatter(porosity * 100, permeability,
    title="Porosity vs Permeability Relationship",
    xlabel="Porosity (%)",
    ylabel="Permeability (mD)",
    color=:blue,
    alpha=0.7,
    markersize=5,
    legend=false)

display(p2)
```

### Multiple Subplots for Complex Data

```jl
# Create multiple related plots
time = 1:12  # months
precipitation = [45, 52, 48, 65, 70, 85, 88, 82, 75, 58, 50, 47]
temperature = [2, 4, 8, 12, 16, 20, 23, 22, 18, 12, 7, 3]

# Individual plots
p3 = plot(time, precipitation,
    title="Monthly Precipitation",
    xlabel="Month",
    ylabel="Precipitation (mm)",
    color=:blue,
    linewidth=2,
    marker=:circle)

p4 = plot(time, temperature,
    title="Monthly Temperature",
    xlabel="Month", 
    ylabel="Temperature (C)",
    color=:red,
    linewidth=2,
    marker=:square)

# Combine into a single figure
combined_plot = plot(p3, p4, layout=(2,1), size=(600, 500))
display(combined_plot)
```

### Heatmaps for 2D Data

```jl
# Create a 2D temperature field
x_coords = 0:2:20
y_coords = 0:1:10
temperature_field = [20 + 0.1*x + 0.2*y + sin(x/5)*cos(y/3) 
                    for x in x_coords, y in y_coords]

p5 = heatmap(x_coords, y_coords, temperature_field',
    title="2D Temperature Field",
    xlabel="X Coordinate (km)",
    ylabel="Y Coordinate (km)",
    color=:thermal,
    aspect_ratio=:equal)

display(p5)
```

## Statistical Analysis of Arrays

### Basic Statistics

```jl
using Statistics

# Statistical analysis of our temperature data
temp_mean = mean(temperatures)
temp_std = std(temperatures)
temp_median = median(temperatures)

println("Temperature Statistics:")
println("Mean: $(round(temp_mean, digits=2))C")
println("Standard deviation: $(round(temp_std, digits=2))C")
println("Median: $(round(temp_median, digits=2))C")
```

### Data Filtering and Processing

```jl
# Find measurements above/below certain thresholds
hot_indices = temperatures .> 20.0
cold_indices = temperatures .< 18.0

hot_temps = temperatures[hot_indices]
hot_depths = depths[1:length(hot_temps)]

println("Temperatures above 20C: $(length(hot_temps)) measurements")
println("Hot temperature range: $(minimum(hot_temps)) - $(maximum(hot_temps))C")
```

### Correlation Analysis

```jl
# Calculate correlation between depth and temperature
if length(depths) == length(temperatures)
    correlation = cor(depths, temperatures)
    println("Correlation between depth and temperature: $(round(correlation, digits=3))")
else
    # Adjust arrays to same length for correlation
    min_length = min(length(depths), length(temperatures))
    correlation = cor(depths[1:min_length], temperatures[1:min_length])
    println("Correlation between depth and temperature: $(round(correlation, digits=3))")
end
```

## Advanced Visualization Techniques

### Custom Color Schemes and Styling

```jl
# Create a professional-looking plot
p6 = plot(depths[1:length(temperatures)], temperatures,
    title="Geothermal Gradient Analysis",
    xlabel="Depth (m)",
    ylabel="Temperature (C)",
    linewidth=3,
    color=:darkred,
    marker=:diamond,
    markersize=6,
    markercolor=:orange,
    grid=true,
    gridwidth=1,
    gridcolor=:lightgray,
    background_color=:white,
    foreground_color=:black,
    legend=false,
    dpi=300)

display(p6)
```

## Key Takeaways

This chapter covered essential tools for geoscientific data analysis:

- **Array operations**: Creating, manipulating, and analyzing numerical data
- **Linear algebra**: Matrix operations, eigenvalues, and eigenvectors  
- **Data visualization**: Line plots, scatter plots, heatmaps, and subplots
- **Statistical analysis**: Basic statistics, filtering, and correlation
- **Professional plotting**: Custom styling for publication-ready figures

These skills form the foundation for more advanced machine learning and AI applications in geosciences, which we'll explore in future chapters.

## Further Reading

- Julia Documentation: [Arrays](https://docs.julialang.org/en/v1/manual/arrays/)
- Plots.jl Documentation: [Plotting](https://docs.juliaplots.org/stable/)
- LinearAlgebra.jl: [Linear Algebra](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/)
