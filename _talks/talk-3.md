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

- Bottom

$$
T=T_\infty = 273 \, \text{K}\\
S=S_\infty = 35 \, \text{g/kg}
$$

- Top

$$
T=273+\lambda_1 S + \lambda_2 + \lambda_3 Pb\\
\partial_z S = \left(\frac{\kappa_T}{\kappa_S}\right) \left(\frac{C_p}{L_f}\right) S \partial_z T
$$

$T_f$ represents the freezing temperature of water, which decreases as salinity increases, a phenomenon known as salt-induced freezing point depression. This effect occurs because dissolved salts interfere with the formation of ice crystals, requiring a lower temperature for the water to solidify.

Here:
$$
\lambda_1 = -5.73 \times 10^{-2} \quad \text{K}/(\text{g/kg})\\
\lambda_2 = 8.32 \times 10^{-2} \quad \text{K}\\
\lambda_3 = -7.53 \times 10^{-4} \quad \text{K/dbar}\\
Le = \left( \frac{\kappa_T}{\kappa_s} \right) = [1, 100]\\
C_p = 3974 \quad \text{J}/(\text{K} \text{kg})\\
L_f = 3.35 \times 10^5 \quad \text{J}/\text{kg}\\
$$


The salinity and temperature follow the initial conditions as: $T_i(z)=273-1.7 \exp{(-z^2/0.1^2)}$ and $S_i(z)=35-2 \exp{(-z^2/0.05^2)}$.

<img src="/images/Exemples/IC_TS_iceocean.png" width="700">

For this example, we set $\text{Le} = 1$, with values of $\kappa_S = 1 \text{m}^2/\text{s}$ and $\kappa_T =1 \text{m}^2/\text{s}$. Please note that these values are far from realistic oceanic values of salinity and temperture diffusivities. 

The video below illustrates the evolution of both tracers. At the ice-ocean boundary, as the ice melts, salinity decreases near the surface, while the temperature of the surrounding water drops. This happens because the melting process absorbs heat from the water, lowering its temperature—a phenomenon known as latent heat absorption, where the heat is used to convert solid ice into liquid water.


<video src="/videos/Exemples/one_dimensional_diffusion_TS_iceocean.mp4" width="100%" controls></video>

To access the Oceananigans.jl file, please download
[here!](http://sofiallende.github.io/files/Exemples/one_dimensional_diffusionTS_iceoceanBC.jl)

