using Random
using Statistics
Random.seed!(42)

function generate_synthetic_seismic(nsamples::Int, dt::Float64=0.002)
    time = (0:nsamples-1) * dt
    
    wavelet_freq = 30.0
    wavelet = exp.(-50 .* (time .- 0.1).^2) .* sin.(2π * wavelet_freq .* time)
    
    noise = 0.05 * randn(nsamples)
    
    seismic = wavelet + noise
    
    return time, seismic
end

time, trace = generate_synthetic_seismic(500)
println("Generated synthetic seismic data:")
println("  Duration: $(time[end]) seconds")
println("  Sampling rate: $(1/(time[2]-time[1])) Hz")
println("  Peak amplitude: $(round(maximum(abs.(trace)), digits=4))")

function create_gravity_grid(nx::Int, ny::Int; anomaly_strength=10.0)
    x = range(-1000, 1000, length=nx)
    y = range(-1000, 1000, length=ny)
    
    grid = zeros(nx, ny)
    for i in 1:nx, j in 1:ny
        r = sqrt(x[i]^2 + y[j]^2)
        grid[i,j] = anomaly_strength * exp(-r^2 / 500000) + 0.1*randn()
    end
    
    return x, y, grid
end

x_coords, y_coords, gravity = create_gravity_grid(30, 30)
println("\nCreated gravity anomaly grid:")
println("  Grid size: $(size(gravity))")
println("  X range: [$(x_coords[1]), $(x_coords[end])] m")
println("  Y range: [$(y_coords[1]), $(y_coords[end])] m")
println("  Peak anomaly: $(round(maximum(gravity), digits=2)) mGal")

struct WellLog
    depth::Vector{Float64}
    density::Vector{Float64}
    porosity::Vector{Float64}
    vp::Vector{Float64}
end

function synthetic_well_log(max_depth::Float64=1000.0, dz::Float64=1.0)
    depths = 0:dz:max_depth
    n = length(depths)
    
    density = 2.3 .+ 0.0003 .* depths .+ 0.05 .* randn(n)
    
    porosity = 0.3 .* exp.(-depths ./ 500) .+ 0.02 .* randn(n)
    porosity = clamp.(porosity, 0.0, 0.4)
    
    vp = 2000 .+ 2.0 .* depths .+ 50 .* randn(n)
    
    return WellLog(collect(depths), density, porosity, vp)
end

well = synthetic_well_log(500.0, 5.0)
println("\nGenerated well log data:")
println("  Depth range: 0 - $(well.depth[end]) m")
println("  Number of samples: $(length(well.depth))")
println("  Mean density: $(round(mean(well.density), digits=3)) g/cm³")
println("  Mean porosity: $(round(mean(well.porosity)*100, digits=1))%")
println("  Mean P-wave velocity: $(round(mean(well.vp), digits=0)) m/s")

function process_seismic_gather(ntraces::Int, nsamples::Int)
    gather = randn(nsamples, ntraces)
    
    for i in 1:ntraces
        moveout = 0.001 * i^2
        shift = round(Int, moveout * 500)
        if shift < nsamples
            gather[shift+1:end, i] = gather[1:end-shift, i]
            gather[1:shift, i] .= 0
        end
    end
    
    return gather
end

gather = process_seismic_gather(24, 200)
println("\nCreated seismic gather:")
println("  Dimensions: $(size(gather)) (samples × traces)")
println("  Total energy: $(round(sum(gather.^2), digits=1))")