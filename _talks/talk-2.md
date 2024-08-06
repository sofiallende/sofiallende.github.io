---
title: " Oceananigans.jl Example: 1D Temperature and Salinity Diffusion"
collection: talks
type: "Talk"
permalink: /talks/talk-2
venue: "IRPHE"
date: 2024-08-01
location: "Marseille, France"
---

This Oceananigans.jl example simulates the diffusion of a one-dimensional Gaussian temperature and salinity tracers.

The governing equations are:

- $\partial_t S + \partial_z ( - \kappa_s \partial_z S) = 0$, where $\kappa_s$ is the molecular diffusivity of the salt.
- $\partial_t T + \partial_z ( - \kappa_T \partial_z T) = 0$, where $\kappa_T$ is the molecular diffusivity of the temperature.


<img src="/images/Exemples/IC_TS.pdf" width="250">