using LinearAlgebra
using Random
Random.seed!(42)

seismic_trace = randn(1000)
println("Seismic trace statistics:")
println("  Length: $(length(seismic_trace))")
println("  Mean: $(round(mean(seismic_trace), digits=4))")
println("  Max amplitude: $(round(maximum(abs.(seismic_trace)), digits=4))")

gravity_grid = randn(50, 50) .* 10 .+ 30
println("\nGravity grid (mGal):")
println("  Dimensions: $(size(gravity_grid))")
println("  Mean anomaly: $(round(mean(gravity_grid), digits=2)) mGal")
println("  Range: [$(round(minimum(gravity_grid), digits=2)), $(round(maximum(gravity_grid), digits=2))] mGal")

model_matrix = [
    1.0 0.5 0.2;
    0.5 1.0 0.3;
    0.2 0.3 1.0
]

observations = [10.5, 8.2, 12.1]

parameters = model_matrix \ observations
println("\nInversion result:")
println("  Model parameters: $([round(p, digits=3) for p in parameters])")

residuals = model_matrix * parameters - observations
rms_error = sqrt(mean(residuals.^2))
println("  RMS error: $(round(rms_error, digits=6))")

eigenvals = eigvals(model_matrix)
println("\nModel matrix eigenvalues: $([round(e, digits=4) for e in eigenvals])")
println("  Condition number: $(round(cond(model_matrix), digits=2))")

distances = [0.0, 100.0, 200.0, 300.0, 400.0]
travel_times = [0.0, 0.025, 0.048, 0.069, 0.088]

A = [ones(length(distances)) distances]
velocity_params = A \ travel_times
intercept = velocity_params[1]
slowness = velocity_params[2]
velocity = 1000 / slowness

println("\nSeismic refraction analysis:")
println("  Apparent velocity: $(round(velocity, digits=1)) m/s")
println("  Intercept time: $(round(intercept*1000, digits=1)) ms")

depths = 0:100:5000
densities = 2.67 .+ 0.00006 .* depths
println("\nDensity model (first 5 layers):")
for i in 1:5
    println("  Depth $(depths[i]) m: $(round(densities[i], digits=3)) g/cm³")
end