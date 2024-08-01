---
title: " Oceananigans.jl Example: 1D Temperature and Salinity Diffusion"
collection: talks
type: "Talk"
permalink: /talks/talk-2
venue: "UC San Francisco, Department of Testing"
date: 2024-08-01
location: "Marseille, France"
---



This Oceananigans.jl example simulates the diffusion of a one-dimensional Gaussian temperature and salinity tracers. The governing equations are:


<head>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
</head>
<body>
    <div>
        <p>- \( \partial_t S + \partial_z ( - \kappa_s \partial_z S) = 0 \), where \( \kappa_s \) is the molecular diffusivity of the salt.</p>
        <p>- \( \partial_t T + \partial_z ( - \kappa_T \partial_z T) = 0 \), where \( \kappa_T \) is the molecular diffusivity of the temperature.</p>
    </div>
</body>

