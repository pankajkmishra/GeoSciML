# Geoscientific Machine Learning & AI with Julia

A comprehensive book on machine learning and artificial intelligence applications in geosciences using the Julia programming language.

[![Book](https://img.shields.io/badge/book-online-blue.svg)](https://pankajkmishra.github.io/GeoSciML)

## About

This book demonstrates how to apply machine learning and AI techniques to geoscientific problems using Julia. It covers fundamental programming concepts, data analysis techniques, and practical applications relevant to earth sciences.

## Contents

- **Chapter 1**: Julia Fundamentals - Core programming concepts and syntax
- **Chapter 2**: Arrays & Visualization - Data manipulation and plotting techniques
- **Future chapters**: Advanced ML/AI applications in geosciences

## Building the Book

### Prerequisites

- Julia 1.9+ 
- Books.jl package

### Local Development

To serve the book locally with live reloading:

```bash
julia --project -e 'using Books; Books.serve()'
```

The book will be available at `http://localhost:8004` (or the port specified in `config.toml`).

### Static Build

To build static HTML and PDF versions:

```bash
julia --project -e 'using Books; Books.build()'
```

The output will be generated in the `_build` directory.

## Technology Stack

- **Books.jl**: Book generation and live serving
- **Julia**: Programming language and execution environment  
- **Pandoc**: Document conversion (handled automatically by Books.jl)

## Contributing

Contributions are welcome! Please feel free to submit issues, suggestions, or pull requests.



---

*Built with ❤️ using [Books.jl](https://books.huijzer.xyz)*
