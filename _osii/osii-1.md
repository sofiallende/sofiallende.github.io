---
title: "Governing Equations at the Ice-Ocean Interface"
collection: osii
type: osii
permalink: /osii/osii-1
date: 2024-07-04
number: 1
excerpt: "informal notes on modeling the ice-ocean interface"
---

To model the ice-ocean boundary layer, we utilize the Navier-Stokes equations under the Boussinesq approximation. In the bulk, the governing equations can be written as follows:

$$
\frac{\partial \mathbf{u}}{\partial t} + (\mathbf{u} \cdot \nabla) \mathbf{u} = -\frac{1}{\rho_0} \nabla p + \nu \nabla^2 \mathbf{u} + \mathbf{g} \rho+\mathbf{F}(z) \\
\nabla \cdot \mathbf{u} = 0\\
\frac{\partial T}{\partial t} + (\mathbf{u} \cdot \nabla) T = \kappa_T \nabla^2 T\\
\frac{\partial S}{\partial t} + (\mathbf{u} \cdot \nabla) S = \kappa_S \nabla^2 S
$$



The first equation represents the momentum equation. Here, $\mathbf{u} = \mathbf{u}(x,y,z)$ denotes the fluid velocity in m/s, $\rho_0$ is the reference density in $\text{kg/m}^3$, $p$ is the pressure in $\text{dbar}$, and $\nu$ is the kinematic viscosity in $\text{m}^2/\text{s}$. The term $\mathbf{g}$ represents the gravitational acceleration in $\text{m/s}^2$, and $\rho$ is the fluid density given by:

$$\rho = \rho_0 \left[ 1 - \beta_T (T - T_0) + \beta_S (S - S_0) \right]$$

In this expression:

- $\beta_T$ is the thermal expansion coefficient in $\text{1/K}$,
- $\beta_S$ is the haline contraction coefficient in $\text{1/(g/kg)}$,
- $T$ is the temperature in $\text{K}$,
- $T_0$ is the reference temperature in $\text{K}$,
- $S$ is the salinity in $\text{g/kg}$,
- $S_0$ is the reference salinity in $\text{g/kg}$,


The second equation is the continuity equation, which ensures the incompressibility of the fluid. The third and fourth equations describe the transport of temperature and salinity, respectively, where $\kappa_T$ is the thermal diffusivity and $\kappa_S$ is the salinity diffusivity.

## Ice-ocean boundary conditions

Our setup assumes a two-dimension flow with a homogeneous ice-ocean interface. The temperature at this interface is equal to the melting temperature $(T_M)$. We also assume that this interface moves with a velocity equal to $u_z\mid_{z=h(t)}=\dot{h}(t)$.

To describe the boundary conditions at the ice-ocean interface, we calculate the internal energy of the water

$$
E_i (t) = C_p \int_0 ^{L_x} dx \int_0 ^{h(t)} dz \,T(x,z,t),
$$

where $T(x,z,t)$ is the seawater temperature and  $C_p$ is the seawater heat capacity $(J/(kg K))$.

When the ice is melting, the ice thickness decreases and freshwater is released into the ocean, leading to an increase in the internal energy. This variation is given by:

$$
\frac{d}{dt} E_i (t) = C_p \int_0 ^{L_x} dx \,T(x,h(t),t) \, \dot{h}(t) +  C_p \int_0 ^{L_x} dx \int_0 ^{h(t)} dz \,\partial_t T(x,z,t) = L_f L_x u_z
$$

where $L_f$ is the latent heat of fusion $(J/kg)$. We can write this expresion as:

$$
 \int_0 ^{L_x} dx \int_0 ^{h(t)} dz \,\partial_t T(x,z,t) = \frac{L_f}{C_p} L_x u_z - \int_0 ^{L_x} dx \,T(x,h(t),t) \, \dot{h}(t).
$$

Therefore,

$$
 \int_0 ^{L_x} dx \int_0 ^{h(t)} dz \,\partial_t T(x,z,t) =\frac{ L_f}{C_p} L_x u_z - L_x T_M \dot{h}(t)
$$

On the other hand, the temperature transport equation at the ice boundary is given by:

$$
\frac{\partial T}{\partial t} + \nabla \cdot ( \mathbf{u} T - \kappa_T \nabla T)=0
$$

where $\mathbf{u} T$ represents the advective flux of temperature and $-\kappa_T \nabla T$ represents the diffusive flux of temperature. Integrating over a control volume $V$ with surface $S$, we get:

$$
\int_V \left( \frac{\partial T}{\partial t} + \nabla \cdot (T \mathbf{u} - \kappa_T \nabla T) \right) \, dV = 0
$$

Applying the divergence theorem:

$$
\int_V \frac{\partial T}{\partial t} \, dV + \int_S (T \mathbf{u} - \kappa_T \nabla T) \cdot \mathbf{n} \, dS =0
$$

where $\mathbf{n}$ is the unit normal vector to the surface $S$. For a control volume where the surface $S$ is aligned with the $z$-axis, the surface integral becomes:

$$
\int_V \frac{\partial T}{\partial t} \, dV + \int_0 ^{L_x} dx  \, (T \mathbf{u} - \kappa_T \nabla T) \cdot \mathbf{e}_z=0
$$

Thus,

$$
\int_V \frac{\partial T}{\partial t} \, dV + L_x T_M u_z  - L_x \kappa_T  \partial _z T=0
$$


Replacing the term $\int_V \frac{\partial T}{\partial t} \, dV$ with the previously derived result and $u_z=\dot{h}(t)$, the expression follows as:

$$
\frac{ L_f}{C_p} L_x u_z - L_x T_M \dot{h}(t) + L_x T_M \dot{h}(t)  - L_x \kappa_T  \partial _z T =0
$$

Finally, the heat boundary condition at the ice-ocean interface can be expressed as:

$$
-\kappa_T \partial_z T=\frac{ L_f}{C_p} \dot{h}(t)
$$


We can follow a similar approach for salinity. At the ice-ocean interface, the phase change due to melting or freezing is associated with the salt flux across the boundary, which is given by:

$$
-\kappa_S \partial_z S  = S \frac{\partial h}{\partial t}
$$

where $S$ is the salinity of the ocean.

Equating both boundary conditions, we find:

$$
\partial_z S = \left(\frac{\kappa_T}{\kappa_S}\right) \left(\frac{C_p}{L_f}\right) S \partial_z T
$$



<iframe src="/files/governing_equations.pdf" width="100%" height="500" frameborder="no" border="0" marginwidth="0" marginheight="0"></iframe>


