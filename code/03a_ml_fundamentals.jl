using Random
using LinearAlgebra
using Statistics
Random.seed!(42)

function linear_regression(X::Matrix, y::Vector)
    X_with_bias = hcat(ones(size(X, 1)), X)
    
    θ = (X_with_bias' * X_with_bias) \ (X_with_bias' * y)
    
    predictions = X_with_bias * θ
    
    residuals = y - predictions
    mse = mean(residuals.^2)
    r2 = 1 - sum(residuals.^2) / sum((y .- mean(y)).^2)
    
    return θ, predictions, mse, r2
end

n_samples = 100
porosity = rand(n_samples) * 0.3
clay_content = rand(n_samples) * 0.4
true_density = 2.65 .- 1.5 * porosity .+ 0.3 * clay_content
density = true_density + 0.05 * randn(n_samples)

X = hcat(porosity, clay_content)
y = density

θ, pred, mse, r2 = linear_regression(X, y)

println("Linear Regression for Density Prediction:")
println("  Coefficients: [intercept, porosity, clay]")
println("  θ = $([round(c, digits=3) for c in θ])")
println("  MSE = $(round(mse, digits=5))")
println("  R² = $(round(r2, digits=4))")

function kmeans(X::Matrix, k::Int; max_iters::Int=100)
    n, d = size(X)
    
    idx = randperm(n)[1:k]
    centroids = X[idx, :]
    
    assignments = zeros(Int, n)
    
    for iter in 1:max_iters
        old_assignments = copy(assignments)
        
        for i in 1:n
            distances = [norm(X[i, :] - centroids[j, :]) for j in 1:k]
            assignments[i] = argmin(distances)
        end
        
        for j in 1:k
            cluster_points = X[assignments .== j, :]
            if size(cluster_points, 1) > 0
                centroids[j, :] = mean(cluster_points, dims=1)
            end
        end
        
        if assignments == old_assignments
            println("  Converged at iteration $iter")
            break
        end
    end
    
    return assignments, centroids
end

n_features = 200
vp = randn(n_features) * 500 .+ 3000
vs = vp / 1.73 + randn(n_features) * 100
features = hcat(vp, vs)

k = 3
clusters, centroids = kmeans(features, k)

println("\nK-means Clustering of Seismic Velocities:")
println("  Number of clusters: $k")
for i in 1:k
    n_points = sum(clusters .== i)
    vp_mean = round(centroids[i, 1], digits=0)
    vs_mean = round(centroids[i, 2], digits=0)
    println("  Cluster $i: $n_points points, Vp=$vp_mean m/s, Vs=$vs_mean m/s")
end

function sigmoid(x)
    return 1 ./ (1 .+ exp.(-x))
end

function logistic_regression(X::Matrix, y::Vector; lr::Float64=0.01, epochs::Int=1000)
    n, d = size(X, 2), size(X, 1)
    X_with_bias = hcat(ones(d), X)
    
    θ = randn(n + 1) * 0.01
    
    losses = Float64[]
    
    for epoch in 1:epochs
        z = X_with_bias * θ
        predictions = sigmoid(z)
        
        loss = -mean(y .* log.(predictions .+ 1e-10) .+ 
                    (1 .- y) .* log.(1 .- predictions .+ 1e-10))
        push!(losses, loss)
        
        gradient = X_with_bias' * (predictions - y) / d
        θ -= lr * gradient
        
        if epoch % 100 == 0 || epoch == 1
            accuracy = mean((predictions .>= 0.5) .== y)
            println("  Epoch $epoch: Loss = $(round(loss, digits=4)), Accuracy = $(round(accuracy, digits=3))")
        end
    end
    
    return θ, losses
end

n_samples = 200
amplitude = randn(n_samples) * 10 .+ 5
frequency = randn(n_samples) * 5 .+ 20
labels = Float64.((amplitude .> 5) .& (frequency .> 20))

X_class = hcat(amplitude, frequency)
y_class = labels

println("\nLogistic Regression for Anomaly Detection:")
θ_class, losses = logistic_regression(X_class, y_class, lr=0.1, epochs=500)

final_predictions = sigmoid(hcat(ones(n_samples), X_class) * θ_class)
final_accuracy = mean((final_predictions .>= 0.5) .== y_class)
println("  Final accuracy: $(round(final_accuracy * 100, digits=1))%")