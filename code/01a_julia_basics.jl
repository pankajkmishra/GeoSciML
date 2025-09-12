using Random
Random.seed!(42)

x = 42
y = 3.14159
z = 2.718281828
name = "Geophysics"
is_scientific = true

println("x = $x, type: $(typeof(x))")
println("y = $y, type: $(typeof(y))")

a = 10.5
b = 6.3
sum_ab = a + b
prod_ab = a * b
quot_ab = a / b

println("Sum: $sum_ab, Product: $prod_ab, Quotient: $quot_ab")

const EARTH_RADIUS_KM = 6371.0
const GRAVITY_MS2 = 9.80665
const MAGNETIC_FIELD_NT = 50000.0

println("Earth radius: $(EARTH_RADIUS_KM) km")
println("Standard gravity: $(GRAVITY_MS2) m/s²")

depth_km = 10.0
pressure_gpa = depth_km * 0.03

println("Pressure at $(depth_km) km depth: $(pressure_gpa) GPa")

velocity_model = Dict(
    "sediments" => 2.0,
    "upper_crust" => 6.0,
    "lower_crust" => 6.8,
    "mantle" => 8.0
)

println("P-wave velocities (km/s):")
for (layer, vp) in velocity_model
    println("  $layer: $vp")
end

temperatures = [15.2, 18.5, 22.1, 25.8, 21.3]
mean_temp = sum(temperatures) / length(temperatures)
println("Mean temperature: $(round(mean_temp, digits=2))°C")