using Plots
using Random
using Statistics
Random.seed!(42)

function plot_seismic_section()
    nt, nx = 500, 50
    dt, dx = 0.004, 25.0
    
    data = zeros(nt, nx)
    for i in 1:nx
        t0 = 0.2 + 0.001 * abs(i - 25)
        idx = round(Int, t0/dt)
        if idx <= nt
            data[idx:min(idx+20, nt), i] = sin.(range(0, 2π, length=min(21, nt-idx+1)))
        end
    end
    
    data += 0.1 * randn(nt, nx)
    
    time = (0:nt-1) * dt
    distance = (0:nx-1) * dx
    
    p = heatmap(distance, time, data,
        xlabel="Distance (m)",
        ylabel="Time (s)",
        title="Synthetic Seismic Section",
        yflip=true,
        color=:seismic,
        clims=(-1, 1))
    
    return p
end

p1 = plot_seismic_section()

function plot_gravity_anomaly()
    x = range(-100, 100, length=100)
    y = range(-100, 100, length=100)
    
    anomaly = [20 * exp(-(xi^2 + yi^2)/1000) for xi in x, yi in y]
    anomaly += 0.5 * randn(100, 100)
    
    p = contourf(x, y, anomaly',
        xlabel="Easting (km)",
        ylabel="Northing (km)",
        title="Bouguer Gravity Anomaly",
        color=:viridis,
        levels=15)
    
    return p
end

p2 = plot_gravity_anomaly()

function plot_velocity_model()
    depths = 0:0.5:30
    
    vp = zeros(length(depths))
    vp[depths .<= 2] .= 2.0
    vp[(depths .> 2) .& (depths .<= 10)] .= 5.5
    vp[(depths .> 10) .& (depths .<= 20)] .= 6.5
    vp[depths .> 20] .= 8.0
    
    vp += 0.1 * randn(length(depths))
    
    p = plot(vp, depths,
        xlabel="P-wave Velocity (km/s)",
        ylabel="Depth (km)",
        title="1D Velocity Model",
        yflip=true,
        linewidth=2,
        grid=true,
        legend=false)
    
    return p
end

p3 = plot_velocity_model()

function plot_well_logs()
    depth = 0:10:1000
    
    gr_log = 30 .+ 50 * (1 .- exp.(-depth/200)) .+ 5*randn(length(depth))
    res_log = 10 .* exp.(-depth/500) .+ 1 .+ 0.5*randn(length(depth))
    
    p1 = plot(gr_log, depth,
        xlabel="GR (API)",
        ylabel="Depth (m)",
        yflip=true,
        linewidth=1.5,
        title="Gamma Ray",
        legend=false)
    
    p2 = plot(res_log, depth,
        xlabel="Resistivity (Ω⋅m)",
        ylabel="",
        yflip=true,
        xscale=:log10,
        linewidth=1.5,
        title="Resistivity",
        legend=false)
    
    p = plot(p1, p2, layout=(1,2), size=(600, 400))
    
    return p
end

p4 = plot_well_logs()

combined = plot(p1, p2, p3, p4, layout=(2,2), size=(800, 800))

display(combined)