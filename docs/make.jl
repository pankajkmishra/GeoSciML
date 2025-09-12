using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

using Documenter
using Literate
using Random
using LinearAlgebra
using Statistics
using Plots

codedir = joinpath(@__DIR__, "..", "code")
srcdir  = joinpath(@__DIR__, "src")
isdir(srcdir) || mkpath(srcdir)

jlfiles = sort(filter(f -> endswith(f, ".jl"), readdir(codedir; join=true)))
for jl in jlfiles
    Literate.markdown(jl, srcdir; execute=true)
end

pages = begin
    idx = ["index.md"]
    gens = sort(filter(f -> endswith(f, ".md") && f != "index.md", readdir(srcdir)))
    vcat(idx, gens)
end

htmldir = joinpath(@__DIR__, "build", "html")
makedocs(
    root = @__DIR__,
    source = "src",
    build  = htmldir,
    sitename = "Geoscientific Machine Learning",
    authors = "Pankaj K. Mishra",
    format = Documenter.HTML(
        assets = ["assets/custom.css"],
        prettyurls = true,
        canonical = "https://pankajkmishra.github.io/GeoSciML"
    ),
    pages = [
        "Home" => "index.md",
        "Part I: Julia Foundations" => [
            "Julia Basics" => "01a_julia_basics.md",
            "Arrays & Linear Algebra" => "01b_arrays_linalg.md",
        ],
        "Part II: Data & Visualization" => [
            "Data Loading" => "02a_data_loading.md",
            "Visualization" => "02b_visualization.md",
        ],
        "Part III: Machine Learning" => [
            "ML Fundamentals" => "03a_ml_fundamentals.md",
            "Geophysical Applications" => "03b_geophysical_example.md",
        ],
    ],
    clean = true,
)

pdfdir = joinpath(@__DIR__, "build", "pdf")
makedocs(
    root = @__DIR__,
    source = "src",
    build  = pdfdir,
    sitename = "Geoscientific Machine Learning",
    authors = "Pankaj K. Mishra",
    format = Documenter.LaTeX(platform = "tectonic"),
    pages = pages,
    clean = true,
)

pdf = joinpath(pdfdir, "documenter.pdf")
isfile(pdf) && cp(pdf, joinpath(htmldir, "GeoSciML.pdf"); force=true)

deploydocs(
    repo = "github.com/pankajkmishra/GeoSciML.git",
    target = htmldir,
    branch = "gh-pages",
    devbranch = "main",
    push_preview = false,
)