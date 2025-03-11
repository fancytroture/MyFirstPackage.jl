using MyFirstPackage
using Documenter

DocMeta.setdocmeta!(MyFirstPackage, :DocTestSetup, :(using MyFirstPackage); recursive=true)

makedocs(;
    modules=[MyFirstPackage],
    authors="xuezhencai",
    sitename="MyFirstPackage.jl",
    format=Documenter.HTML(;
        canonical="https://fancytroture.github.io/MyFirstPackage.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/fancytroture/MyFirstPackage.jl",
    devbranch="main",
)
