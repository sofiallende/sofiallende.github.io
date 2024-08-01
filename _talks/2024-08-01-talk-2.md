---
title: " Oceananigans.jl Example: 1D Temperature and Salinity Diffusion"
collection: talks
type: "Talk"
permalink: /talks/talk-2
venue: "UC San Francisco, Department of Testing"
date: 2024-08-01
location: "Marseille, France"
---

# Oceananigans.jl Example: Diffusion of Gaussian Temperature and Salinity Tracers

This Oceananigans.jl example simulates the diffusion of a one-dimensional Gaussian temperature and salinity tracers. The governing equations are:

- \(\partial_t S + \partial_z S(-\kappa_s \partial_z S) = 0\), where \(\kappa_s\) is the molecular diffusivity of the salt.
- \(\partial_t T + \partial_z T(-\kappa_T \partial_z T) = 0\), where \(\kappa_T\) is the molecular diffusivity of the temperature.

## Install Dependencies

First, ensure that all required packages are installed:

```julia
using Pkg
pkg"add Oceananigans, CairoMakie"


