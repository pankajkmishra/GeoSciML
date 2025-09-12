using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

using Documenter
using Literate
using Random
using LinearAlgebra
using Statistics
using Plots

function generate_pages()
    
    codedir = joinpath(@__DIR__, "..", "code")
    srcdir  = joinpath(@__DIR__, "src")
    isdir(srcdir) || mkpath(srcdir)

    
    for file in readdir(srcdir)
        if endswith(file, ".md") && file != "index.md"
            rm(joinpath(srcdir, file))
        end
    end

    
    jl_files = sort([f for f in readdir(codedir) if endswith(f, ".jl")])
    for jl_file in jl_files
        Literate.markdown(joinpath(codedir, jl_file), srcdir; execute=true)
    end

    
    md_files = sort([f for f in readdir(srcdir) if endswith(f, ".md") && f != "index.md"])

    
    page_structure = Dict{String, Vector{Pair{String, String}}}()
    for file in md_files
        part_match = match(r"^(\d+)", file)
        if part_match !== nothing
            part_num = part_match.captures[1]
            part_key = "Part " * string(parse(Int, part_num))
            
            if !haskey(page_structure, part_key)
                page_structure[part_key] = []
            end
            
            title_str = replace(splitext(file)[1], r"^\d+[a-z]_" => "")
            title = join(titlecase.(split(title_str, '_')), " ")
            
            push!(page_structure[part_key], title => file)
        end
    end
    
    
    sorted_parts = sort(collect(keys(page_structure)), by = x -> parse(Int, split(x)[2]))
    
    
    final_pages = Any["Home" => "index.md"]
    for part in sorted_parts
        push!(final_pages, part => page_structure[part])
    end
    
    return final_pages
end


pages = generate_pages()


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
    pages = pages,
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


pdf_path = joinpath(pdfdir, "documenter.pdf")
if isfile(pdf_path)
    cp(pdf_path, joinpath(htmldir, "GeoSciML.pdf"); force=true)
end


deploydocs(
    repo = "github.com/pankajkmishra/GeoSciML.git",
    target = htmldir,
    branch = "gh-pages",
    devbranch = "main",
    push_preview = false,
)