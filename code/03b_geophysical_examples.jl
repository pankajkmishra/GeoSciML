using Random
using LinearAlgebra
using Statistics
Random.seed!(42)

function gravity_forward(x_obs, z_obs, x_source, z_source, density_contrast, radius)
    G = 6.67430e-11
    
    g = zeros(length(x_obs))
    
    for i in 1:length(x_obs)
        dx = x_obs[i] - x_source
        dz = z_obs[i] - z_source
        r = sqrt(dx^2 + dz^2)
        
        if r > radius
            mass = (4/3) * π * radius^3 * density_contrast
            g[i] = G * mass * dz / r^3 * 1e5
        end
    end
    
    return g
end

x_stations = range(-500, 500, length=50)
z_stations = zeros(50)

true_x = 0.0
true_z = 100.0
true_density = 500.0
true_radius = 50.0

observed = gravity_forward(x_stations, z_stations, true_x, true_z, true_density, true_radius)
observed += 0.01 * randn(length(observed))

println("Gravity Anomaly Modeling:")
println("  True source position: ($(true_x), $(true_z)) m")
println("  True density contrast: $(true_density) kg/m³")
println("  True radius: $(true_radius) m")
println("  Peak anomaly: $(round(maximum(observed), digits=3)) mGal")

function invert_gravity(observed, x_stations, z_stations; max_iters=100)
    x_source = 10.0
    z_source = 80.0
    density = 400.0
    radius = 40.0
    
    learning_rate = 0.1
    
    for iter in 1:max_iters
        predicted = gravity_forward(x_stations, z_stations, x_source, z_source, density, radius)
        
        residual = observed - predicted
        rms = sqrt(mean(residual.^2))
        
        Δ = 1e-3
        
        grad_x = sum(residual .* 
            (gravity_forward(x_stations, z_stations, x_source + Δ, z_source, density, radius) - predicted) / Δ)
        grad_z = sum(residual .* 
            (gravity_forward(x_stations, z_stations, x_source, z_source + Δ, density, radius) - predicted) / Δ)
        grad_density = sum(residual .* 
            (gravity_forward(x_stations, z_stations, x_source, z_source, density + Δ, radius) - predicted) / Δ)
        grad_radius = sum(residual .* 
            (gravity_forward(x_stations, z_stations, x_source, z_source, density, radius + Δ) - predicted) / Δ)
        
        x_source += learning_rate * grad_x
        z_source += learning_rate * grad_z
        density += learning_rate * grad_density * 10
        radius += learning_rate * grad_radius
        
        if iter % 20 == 0 || iter == 1
            println("  Iter $iter: RMS = $(round(rms, digits=4)) mGal")
        end
        
        if rms < 0.01
            break
        end
    end
    
    return x_source, z_source, density, radius
end

x_inv, z_inv, density_inv, radius_inv = invert_gravity(observed, x_stations, z_stations)

println("\nInversion Results:")
println("  Estimated position: ($(round(x_inv, digits=1)), $(round(z_inv, digits=1))) m")
println("  Estimated density: $(round(density_inv, digits=0)) kg/m³")
println("  Estimated radius: $(round(radius_inv, digits=1)) m")
println("  Position error: $(round(sqrt((x_inv-true_x)^2 + (z_inv-true_z)^2), digits=1)) m")

function seismic_velocity_tomography(travel_times, ray_paths, grid_size)
    n_cells = grid_size^2
    n_rays = length(travel_times)
    
    A = zeros(n_rays, n_cells)
    for i in 1:n_rays
        A[i, ray_paths[i]] .= 1.0
    end
    
    slowness = (A' * A + 0.01 * I) \ (A' * travel_times)
    
    velocity_model = reshape(1 ./ slowness, grid_size, grid_size)
    
    return velocity_model
end

grid_size = 10
n_rays = 100

true_velocity = 3000 * ones(grid_size, grid_size)
true_velocity[4:7, 4:7] .= 2500

ray_paths = [randperm(grid_size^2)[1:10] for _ in 1:n_rays]

travel_times = Float64[]
for path in ray_paths
    time = sum(1 ./ true_velocity[path])
    push!(travel_times, time + 0.001 * randn())
end

recovered_velocity = seismic_velocity_tomography(travel_times, ray_paths, grid_size)

println("\nSeismic Tomography:")
println("  Grid size: $(grid_size) × $(grid_size)")
println("  Number of rays: $(n_rays)")
println("  True anomaly velocity: 2500 m/s")
println("  Recovered anomaly: $(round(minimum(recovered_velocity), digits=0)) m/s")
println("  Background velocity: $(round(mean(recovered_velocity[recovered_velocity .> 2700]), digits=0)) m/s")

function neural_network_facies(features, hidden_size=10)
    n_samples, n_features = size(features)
    n_classes = 3
    
    W1 = randn(n_features, hidden_size) * 0.1
    b1 = zeros(hidden_size)
    W2 = randn(hidden_size, n_classes) * 0.1
    b2 = zeros(n_classes)
    
    function forward(X)
        z1 = X * W1 .+ b1'
        a1 = tanh.(z1)
        z2 = a1 * W2 .+ b2'
        
        exp_z2 = exp.(z2 .- maximum(z2, dims=2))
        probs = exp_z2 ./ sum(exp_z2, dims=2)
        
        return probs, a1
    end
    
    probs, hidden = forward(features)
    predictions = [argmax(probs[i, :]) for i in 1:n_samples]
    
    return predictions
end

n_samples = 150
gamma_ray = vcat(30*ones(50), 60*ones(50), 90*ones(50)) .+ 5*randn(n_samples)
resistivity = vcat(100*ones(50), 10*ones(50), 1*ones(50)) .+ randn(n_samples)
features = hcat(gamma_ray/100, log10.(resistivity)/3)

facies = neural_network_facies(features)

println("\nNeural Network Facies Classification:")
println("  Number of samples: $(n_samples)")
println("  Input features: [GR, Resistivity]")
println("  Predicted facies distribution:")
for i in 1:3
    count = sum(facies .== i)
    println("    Facies $i: $count samples ($(round(count/n_samples*100, digits=1))%)")
end