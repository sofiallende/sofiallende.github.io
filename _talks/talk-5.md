---
title: "Non-Dimensional Governing Equations at the Ice-Ocean Interface"
collection: talks
type: "Talk"
permalink: /talks/talk-5
venue: "IRPHE"
date: 2024-09-06
location: "Marseille, France"
---


We utilize the Navier-Stokes equations under the Boussinesq approximation. The governing equations can be written as follows:

$$
\frac{\partial \mathbf{u}}{\partial t} + (\mathbf{u} \cdot \nabla) \mathbf{u} = -\frac{1}{\rho_0} \nabla p + \nu \nabla^2 \mathbf{u} + \mathbf{g} \rho+\mathbf{F}(z) \\
\nabla \cdot \mathbf{u} = 0\\
\frac{\partial T}{\partial t} + (\mathbf{u} \cdot \nabla) T = \kappa_T \nabla^2 T\\
\frac{\partial S}{\partial t} + (\mathbf{u} \cdot \nabla) S = \kappa_S \nabla^2 S
$$

Using the dimensionless variables:


$$
(\tilde x, \tilde y , \tilde z)=\frac{(x,y,z)}{H}\\
\tilde T=\frac{T-T_f(S_\infty, P_b)}{T_{*,\infty}}\\
\tilde S=\frac{S-S_\infty}{S_{\infty}}\\
\tilde u = \frac{u}{u_\nu}\\
\tilde t = \frac{t}{t_\nu}\\
\tilde P = \frac{P-P_{st}}{P\nu}
$$


where $H$ is the domaine depth,  $u_\nu=\frac{\nu}{H}$ is the viscous velocity, $t_\nu=\frac{H^2}{\nu}$ is the viscous time, $T_f(S_\infty, P_b)= \lambda_1 S_\infty+ \lambda_2 + \lambda_3 P_b$  is the frezing temperature as a function of the far-field salinity $S_\infty$ and the constant hydrostatic pressure at the ice-ocean interface $P_b$, $T_{*,\infty}=T_\infty -T_f(S_\infty)$ is the far-field thermal driving, $P_{st}=P_b-\rho\, \nu^ 2/  H^2$ is the hydrostatic pressure and $P_\nu=\rho_0 \nu ^2/H^2$ is the dynamic pressure scale.

Substituting the dimensionless variables into the N-S equations, we obtained:\\

$$
\frac{\partial \tilde u }{\partial \tilde t}+(\tilde u \nabla)\tilde u = - \tilde \nabla \tilde P + \tilde \nabla ^2 \tilde u +\mathrm{Re}_{\tau} ^2 \, \mathrm{Ri}_\tau \, (\mathrm R_\rho \tilde T-\tilde S)\\
\frac{\partial \tilde T}{\partial \tilde t}+\tilde u \tilde \nabla \tilde T = \frac{1}{\mathrm{Pr}} \tilde \nabla ^2 \tilde T\\
\frac{\partial \tilde S}{\partial \tilde t}+\tilde u \tilde \nabla \tilde S = \frac{1}{\mathrm{Sc}} \tilde \nabla ^2 \tilde S
$$


The boundary conditions are free-slip (appropriate for a half channel flow), fixed temperature and
fixed salinity on the bottom boundary, and no-slip, freezing temperature and melt-induced dilution
at the top boundary, i.e., in dimensionless form:\\

$$
\tilde T_\infty =1\\
\tilde S_\infty =0
$$
 
$$
\tilde T =\gamma \, \tilde S\\
\frac{\partial \tilde S}{\partial \tilde z}=\mathrm {Le}\, \mathrm{St}^{-1}\,(1+\tilde S)\, \frac{\partial \tilde T}{\partial \tilde z}
$$

List of the dimensionless control parameters appearing in the governing equations:





