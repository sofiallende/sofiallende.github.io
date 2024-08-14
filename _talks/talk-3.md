---
title: " Oceananigans.jl Example: 1D Temperature and Salinity Diffusion at the ice-ocean interface"
collection: talks
type: "Talk"
permalink: /talks/talk3
venue: "IRPHE"
date: 2024-08-07
location: "Marseille, France"
---

This Oceananigans.jl example simulates the diffusion of one-dimensional Gaussian temperature and salinity tracers in an ice-ocean environment.

The governing equations are:

$$
\partial_t S + \partial_z ( - \kappa_S \partial_z S) = 0\\
\partial_t T + \partial_z ( - \kappa_T \partial_z T) = 0
$$

where $\kappa_S$ is the molecular diffusivity of the salt and $\kappa_T$ is the molecular diffusivity of the temperature.

The boundary conditions that simulate the ice-ocean interface are:

# TOP

$$
T=\lambda_1 S + \lambda_2 + \lambda_3 Pb
\partial_z S = \left(\frac{\kappa_T}{\kappa_S}\right) \left(\frac{C_p}{L_f}\right) S \partial_z T
$$

# BOTTOM

$$
T=T_\infty\\
S=S_\infty
$$

where \$lambda_1 = -5.73 \times 10^{-2} \, \left( \frac{\text{K}}{\text{g/kg}} \right), \quad
\lambda_2 = 8.32 \times 10^{-2} \, \text{K}, \quad
\lambda_3 = -7.53 \times 10^{-4} \, \text{K/dbar}$, $Le = \left( \frac{\kappa_T}{\kappa_s} \right) = [1, 100]$, $C_p = 3974 \, \frac{\text{J}}{\text{K} \cdot \text{kg}}$, $\quad L_f = 3.35 \times 10^5 \, \frac{\text{J}}{\text{kg}}$


Our initial state is:

<img src="/images/Exemples/IC_TS_iceocean.png" width="500">

For this example, we choose $\text{Le} = 10$. The video below shows the evolution of both tracers. In the presence of the ice-ocean boundary, as the ice melts, salinity decreases near the surface, while temperature increases due to the release of latent heat.


<video src="/videos/Exemples/one_dimensional_diffusion_TS_iceocean.mp4" width="500" controls></video>

To access the Oceananigans.jl file, please download
[here!](http://sofiallende.github.io/files/Exemples/one_dimensional_diffusionTS_iceoceanBC.jl)

