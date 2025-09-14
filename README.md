# Geoscientific Machine Learning 
.

A modern approach to machine learning in geosciences using Julia.

[![Build & Deploy Book](https://github.com/pankajkmishra/GeoSciML/actions/workflows/docs.yml/badge.svg)](https://github.com/pankajkmishra/GeoSciML/actions/workflows/docs.yml)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://pankajkmishra.github.io/GeoSciML/)

## About

This book demonstrates machine learning applications in geosciences 

## Quick Start

### Read Online
- [HTML Documentation](https://pankajkmishra.github.io/GeoSciML/)
- [PDF Version](https://pankajkmishra.github.io/GeoSciML/GeoSciML.pdf)

### Build Locally

```bash
git clone https://github.com/pankajkmishra/GeoSciML.git
cd GeoSciML
julia --project=docs -e 'using Pkg; Pkg.instantiate(); include("docs/make.jl")'
```

### Add New Chapters

1. Create Julia scripts in `code/` directory
2. Use Literate.jl comment syntax for documentation
3. Push to main branch - GitHub Actions will rebuild automatically

## Prerequisites

- Julia 1.10+
- Git

## License

MIT License

## Author

Pankaj K. Mishra