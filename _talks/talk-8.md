---
title: "First excited mode at the Ice-Ocean Boundary: Impact of Initial Conditions and Lewis Numbers"
collection: talks
type: "Talk"
permalink: /talks/talk-8
venue: "IRPHE"
date: 2024-12-08
location: "Marseille, France"
---

In the 3D simulations with constant initial conditions for temperature and salinity, we observe that the first excited mode leads to an unstable density profile, with heavier layers overlying lighter ones, for all Lewis numbers greater than 1. Here, we explore this instability by varying the initial conditions, ranging from a uniform profile in the vertical direction to a stratified one. Additionally, we examine the effects of different Le values.

For all simulations, the spatial resolution is set to 128 in each of the three directions. The spatial grid is uniform in $x$ and $y$, while being refined in $z$ near the boundary. The time step is adaptive, determined by the minimum value of $\Delta z$. The simulations run for a total of 20 seconds, with output generated every 1 second.

The dynamic viscosity ($\nu$) and thermal diffusivity ($\kappa_T$) are both fixed at $1.8 \times 10^{-6}$. The salinity diffusivity ($\kappa_S$) is varied between $1.8 \times 10^{-6}$ and $1.8 \times 10^{-8}$ to achieve different values of the Lewis number.

The density profile is calculated based on the linear approximation:  

$$
\rho = \rho_0 \left[ 1 - \beta_T (T - T_0) + \beta_S (S - S_0) \right],
$$  

where $\rho_0 = 1000 \, \text{kg/m}^3$, $T_0 = 277.15 \, \text{K}$, and $S_0 = 0 \, \text{g/kg}$. The thermal expansion coefficient is $\beta_T = 3.87 \times 10^{-5} \, \text{K}^{-1}$, and the haline contraction coefficient is $\beta_S = 7.86 \times 10^{-4} \, \text{(g/kg)}^{-1}$.


Finally, the melting temperature ($T_{\text{melt}}$) is determined by the equation:  

$$
T_{\text{melt}} = \lambda_1 S + \lambda_2
$$

where $\lambda_1 = -5.73 \times 10^{-2} \, \text{K/(g/kg)}$ and $\lambda_2 = 8.32 \times 10^{-2} \, \text{K}$.





## 1. Uniform temperature and salinity:

$$
T_i(x,y,z)=273.3\\
S_i(x,y,z)=34.572
$$


### 1.1 $Le=1$
<video src="/videos/3D/firstmode/ICTSunif_Le1.mp4" width="800" controls></video>
.


### 1.2 $Le=2$
<video src="/videos/3D/firstmode/ICTSunif_Le2.mp4" width="800" controls></video>
.


### 1.3 $Le=10$
<video src="/videos/3D/firstmode/ICTSunif_Le10.mp4" width="800" controls></video>
.

### 1.4 $Le=100$
<video src="/videos/3D/firstmode/ICTSunif_Le100.mp4" width="800" controls></video>
.



## 2. Uniform salinity and stratified temperature:

$$
T_i(x,y,z)=273.3+T_{melt}(1+2z)\\
S_i(x,y,z)=35
$$

### 2.1 $Le=1$
<video src="/videos/3D/firstmode/ICSunifTstrat_Le1.mp4" width="800" controls></video>
.

### 2.2 $Le=2$
<video src="/videos/3D/firstmode/ICSunifTstrat_Le2.mp4" width="800" controls></video>
.

### 2.3 $Le=10$
<video src="/videos/3D/firstmode/ICSunifTstrat_Le10.mp4" width="800" controls></video>
.


### 2.4 $Le=100$
<video src="/videos/3D/firstmode/ICSunifTstrat_Le100.mp4" width="800" controls></video>
.


## 3. Uniform temperature and stratified salinity:

$$
T_i(x,y,z)=273.3\\
S_i(x,y,z)=33-4z
$$


## 4.Stratified temperature and salinity:

$$
T_i(x,y,z)=273.3+T_{melt}(1+2z)\\
S_i(x,y,z)=33-4z
$$

### 4.1 $Le=1$
<video src="/videos/3D/firstmode/ICTSstrat_Le1.mp4" width="800" controls></video>
.

### 4.2 $Le=2$
<video src="/videos/3D/firstmode/ICTSstrat_Le2.mp4" width="800" controls></video>
.

### 4.3 $Le=10$
<video src="/videos/3D/firstmode/ICTSstrat_Le10.mp4" width="800" controls></video>
.

### 4.4 $Le=100$
<video src="/videos/3D/firstmode/ICTSstrat_Le100.mp4" width="800" controls></video>
.