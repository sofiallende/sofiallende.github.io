---
title: "Governing Equations at the Ice-Ocean Interface"
collection: talks
type: "Talk"
permalink: /talks/talk-1
venue: "UC San Francisco, Department of Testing"
date: 2024-07-04
location: "Marseille, France"
---



To model the ice-ocean boundary layer, we utilize the Navier-Stokes equations under the Boussinesq approximation. In the bulk, the governing equations can be written as follows:

\begin{align}
\frac{\partial \mathbf{u}}{\partial t} + (\mathbf{u} \cdot \nabla) \mathbf{u} &= -\frac{1}{\rho_0} \nabla p + \nu \nabla^2 \mathbf{u} + \mathbf{g} \rho+\mathbf{F}(z) \\
\nabla \cdot \mathbf{u} &= 0\\
\frac{\partial T}{\partial t} + (\mathbf{u} \cdot \nabla) T& = \kappa_T \nabla^2 T\\
\frac{\partial S}{\partial t} + (\mathbf{u} \cdot \nabla) S &= \kappa_S \nabla^2 S
\end{align}



The first equation represents the momentum equation. Here, \(\mathbf{u} = \mathbf{u}(x,y,z)\) denotes the fluid velocity in m/s, \(\rho_0\) is the reference density in \(\text{kg/m}^3\), \(p\) is the pressure in \(\text{Pa}\), and \(\nu\) is the kinematic viscosity in \(\text{m}^2/\text{s}\). The term \(\mathbf{g}\) represents the gravitational acceleration in \(\text{m/s}^2\), and \(\rho\) is the fluid density given by:

\[
\rho = \rho_0 \left[ 1 - \beta_T (T - T_0) + \beta_S (S - S_0) \right]
\]

In this expression:

- \(\beta_T\) is the thermal expansion coefficient in \(\text{1/K}\),
- \(\beta_S\) is the haline contraction coefficient in \(\text{1/(g/kg)}\),
- \(T\) is the temperature in \(\text{K}\),
- \(T_0\) is the reference temperature in \(\text{K}\),
- \(S\) is the salinity in \(\text{g/kg}\),
- \(S_0\) is the reference salinity in \(\text{g/kg}\),


The second equation is the continuity equation, which ensures the incompressibility of the fluid. The third and fourth equations describe the transport of temperature and salinity, respectively, where \(\kappa_T\) is the thermal diffusivity and \(\kappa_S\) is the salinity diffusivity.

##Ice-ocean boundary conditions




<iframe src="/files/governing_equations.pdf" width="100%" height="500" frameborder="no" border="0" marginwidth="0" marginheight="0"></iframe>


