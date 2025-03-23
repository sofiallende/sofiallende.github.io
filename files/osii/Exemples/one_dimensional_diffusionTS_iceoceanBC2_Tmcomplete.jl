# # Created on Wen Aug 07 2024
# # @author: sallende
# # This example is a modified version of the one_dimensional_diffusion_example from the Oceananigans.jl GitHub repository.
#
# This Oceananigans.jl's example is simulating the diffusion of a one-dimensional Gaussian temperature and salinity tracers.
# The governing equations are:
# ∂tS + ∂zS(-κs*∂zS)=0, κs=molecular diffusivity of the salt 
# ∂tT + ∂zT(-κT*∂zT)=0, κT=molecular diffusivity of the temperature
# To model the ice-ocean interface, we consider the following boundary conditions:
# Top: T=λ1S + λ2 + λ3Pb  and ∂S/∂z=(κT/κs)*(Cp/Lf)*S*∂T/∂z)
# Bottom: T=T∞ and S=S∞ 
# Contantes:
# λ1=-5.73x10^-2 (K/(g/Kg)), λ2=8.32x10^-2 K, λ3=-7.53x10-4 K/dbar,
# Le=(κT/κs)=[1,100] car κT approx 10^-7 and κs approx 10^-9
# Cp=3974 J/K/Kg and Lf=3.35x10^5J/Kg
#
# ## Install dependencies
#
# First let's make sure we have all required packages installed.

# ```julia
# using Pkg
# pkg "add Oceananigans, CairoMakie, TaylorSeries"
# ```

# ## Using `Oceananigans.jl`
#
# Write

using Oceananigans
using Printf
using CairoMakie
using TaylorSeries, SpecialFunctions 

# ## Instantiating and configuring a model
#
# We build a `NonhydrostaticModel` by passing it a `grid`.
# We build a rectilinear grid with 128 regularly-spaced grid points in
# the `z`-direction, where `z` spans from `z = -1` to `z = 0`. 

grid = RectilinearGrid(size=1024, z=(-1, 0), topology=(Flat, Flat, Bounded))

# The default topology is `(Periodic, Periodic, Bounded)`. In this example, we're
# trying to solve a one-dimensional problem, so we assign `Flat` to the
# `x` and `y` topologies. We excise halos and avoid interpolation or differencing
# in `Flat` directions, saving computation and memory.

# ##Boundary condition  (with values in their dimensionless form)
T_bot= 273 #K
λ1= -5.73e-2 #(K/(g/Kg)) 
λ2= 8.32e-2 #K
λ3= -7.53e-4 #K/dbar
S_bot= 35
Cp= 3974 #J/K/Kg
Lf= 3.35e5 #J/Kg
Le= 10  


function get_T0(t, T, S)
    bb = -T - (1/Le)*(Lf/Cp)-273-λ2 #  L*kappa_S/(kappa_T*c_w)  #need to define T1
    cc =  (1/Le)*(Lf/Cp)*λ1*S+(273+λ2)*T+(273+λ2)*(1/Le)*(Lf/Cp) #  L*kappa_S*a_s*S / (kappa_T*c_w)  #need to define S1
    return (-bb-sqrt(bb^2-4*cc))/2
end

function get_S0( t, T, S)
    T0 = get_T0(t, T, S)
    S0 = (T0-λ2-273)/λ1
    return S0
end


#function get_T0(t, T, S)
#    bb = -T - (1/Le)*(Lf/Cp) - λ2#  L*kappa_S/(kappa_T*c_w)  #need to define T1
#    cc =  (1/Le)*(Lf/Cp)*λ1*S+λ2*T #  L*kappa_S*a_s*S / (kappa_T*c_w)  #need to define S1
#    return (-bb-sqrt(bb^2-4*cc))/2
#end
#function get_S0( t, T, S)
#    T0 = get_T0(t, T, S)
#    S0 = (T0-λ2)/λ1
#    return S0
#end




T_bcs = FieldBoundaryConditions(top = ValueBoundaryCondition(get_T0,field_dependencies=(:T, :S)),
				bottom = ValueBoundaryCondition(T_bot))
                               
    
S_bcs = FieldBoundaryConditions(top = ValueBoundaryCondition(get_S0, field_dependencies=(:T, :S)),
				bottom=ValueBoundaryCondition(S_bot))




no_slip_bc = ValueBoundaryCondition(0.0)
free_slip_surface_bcs = FieldBoundaryConditions(bottom=no_slip_bc, top=no_slip_bc);
                                				
# We next specify a model with an `ScalarDiffusivity`, which models either
# molecular or turbulent diffusion. 
# We differentiate the diffusion of salt and temperature. Please note 
# that the rate between both diffusivities represent the Lewis number
# (Le=Sc/Pr, Sc=ν/κs, Pr= ν/κT) 

closure = ScalarDiffusivity(κ=(T=1,S=0.1))

# We finally pass these two ingredients to `NonhydrostaticModel`,
model = NonhydrostaticModel(; grid, closure, tracers=(:T, :S),boundary_conditions = (u=free_slip_surface_bcs, T=T_bcs, S=S_bcs))

# By default, `NonhydrostaticModel` has no-flux (insulating and stress-free) boundary conditions on all fields.
#
# Next, we `set!` an initial condition on the temperature field,
# `model.tracers.T`. Our objective is to observe the diffusion of a Gaussian.

S_0=35
T_melt=λ1*S_0+λ2
alpha=(-T_melt)/(1-exp(-1))
initial_temperature(z) = (273+T_melt) -  T_melt*0.5*(1.0-erf(25.0*(z+0.25)))
# (273+T_melt+alpha) - alpha*exp(-z^2)
# 271.0783*exp(z^2/141.56) 
# (273+T_melt) -  T_melt*0.5*(1.0-erf(25.0*(z+0.25)))
# 273-1.7*exp(-z^2/(0.1^2)) 
#+log10(40*z^2+1e-0)
initial_salinity(z)=S_0 #35-2*exp(-z^2/(0.05^2)) #log10(10*z^4+1e-2)
set!(model, T=initial_temperature, S=initial_salinity)

#set!(model, T=initial_temperature,S=initial_salinity)
#print(model.tracers.S[:])
#print(model.tracers.T[:])
#print(∂z(model.tracers.S)[:])
#print(∂z(model.tracers.T)[:])
#print(model.tracers.T[grid.Nz+3], model.tracers.T[grid.Nz+3+1])

T_teo=(1/2)*(model.tracers.T[grid.Nz+3]+model.tracers.T[grid.Nz+1+3])
T_bou=273+λ1*(1/2)*(model.tracers.S[grid.Nz+3]+model.tracers.S[grid.Nz+1+3])
print("Temp BC %error", (T_bou-T_teo)/T_teo*100)

S_teo=(grid.Nz/grid.Lz)*(model.tracers.S[grid.Nz+3]-model.tracers.S[grid.Nz+1+3])
S_bou=Le*(Cp/Lf)*0.5*(model.tracers.S[grid.Nz+3]+model.tracers.S[grid.Nz+1+3])*(grid.Nz/grid.Lz)*(model.tracers.T[grid.Nz+3]-model.tracers.T[grid.Nz+1+3])
print("Salt BC %error ",(S_bou-S_teo)/S_teo*100)

# ## Visualizing model data
#
# Calling `set!` above changes the data contained in `model.tracers.T`,
# which was initialized as `0`'s when the model was created.
# To see the new data in `model.tracers.T`, we plot it:

set_theme!(Theme(fontsize = 24, linewidth=3))
fig = Figure(size = (700, 500))
ax_T = Axis(fig[1, 1], title="t = 0", xlabel = "Temperature", ylabel = "z")
xlims!(ax_T, 271, 274)
ax_S = Axis(fig[1, 2], title="t = 0", xlabel = "Salinity", ylabel = "z")
xlims!(ax_S, 30, 36)
label = "t = 0"

z = znodes(model.tracers.T)
T = interior(model.tracers.T, 1, 1, :)
S = interior(model.tracers.S, 1, 1, :)

hm_T=lines!(ax_T, T, z; label, color=:red)
hm_S=lines!(ax_S, S, z; label, color=:blue)
fig
#save("IC_TS_iceocean.pdf", fig, pdf_version="1.4")
save("IC_TS_iceocean.png", fig)

# ## Running a `Simulation`
# Next we set-up a `Simulation` that time-steps the model forward and manages output.

simulation = Simulation(model, Δt = 1e-7 , stop_iteration = 100000)

progress_message(sim) = @printf("Iteration: %04d, time: %s, Δt: %s, max(|w|) = %.1e ms⁻¹, wall time: %s\n",
                                iteration(sim), prettytime(sim), prettytime(sim.Δt),
                                maximum(abs, sim.model.velocities.w))
                                
                                
                                
run!(simulation)

T_teo=(1/2)*(model.tracers.T[grid.Nz+3]+model.tracers.T[grid.Nz+1+3])
T_bou=273+λ1*(1/2)*(model.tracers.S[grid.Nz+3]+model.tracers.S[grid.Nz+1+3])
print("Temp BC %error ", (T_bou-T_teo)/T_teo*100)

S_teo=(grid.Nz/grid.Lz)*(model.tracers.S[grid.Nz+3]-model.tracers.S[grid.Nz+1+3])
S_bou=Le*(Cp/Lf)*0.5*(model.tracers.S[grid.Nz+3]+model.tracers.S[grid.Nz+1+3])*(grid.Nz/grid.Lz)*(model.tracers.T[grid.Nz+3]-model.tracers.T[grid.Nz+1+3])
print("Salt BC %error ",(S_bou-S_teo)/S_teo*100)


simulation.output_writers[:temperature] =
    JLD2OutputWriter(model, model.tracers,
                     filename = "one_dimensional_diffusionTS_iceocean2_tmc_1024.jld2",
                     schedule=IterationInterval(100),
                     with_halos = true,
                     overwrite_existing = true)

# We run the simulation for 10,000 more iterations,

simulation.stop_iteration += 100000
run!(simulation)

T_teo=(1/2)*(model.tracers.T[grid.Nz+3]+model.tracers.T[grid.Nz+1+3])
T_bou=273+λ1*(1/2)*(model.tracers.S[grid.Nz+3]+model.tracers.S[grid.Nz+1+3])
print("Temp BC %error ", (T_bou-T_teo)/T_teo*100)

S_teo=(grid.Nz/grid.Lz)*(model.tracers.S[grid.Nz+3]-model.tracers.S[grid.Nz+1+3])
S_bou=Le*(Cp/Lf)*0.5*(model.tracers.S[grid.Nz+3]+model.tracers.S[grid.Nz+1+3])*(grid.Nz/grid.Lz)*(model.tracers.T[grid.Nz+3]-model.tracers.T[grid.Nz+1+3])
print("Salt BC %error ",(S_bou-S_teo)/S_teo*100)
                               
# Finally, we animate the results by opening the JLD2 file, extract the
# iterations we ended up saving at, and plot the evolution of the
# temperature profile in a loop over the iterations.

## Temperature and salinity movie
filename = "one_dimensional_diffusionTS_iceocean2_tmc_1024"
filepath = filename * ".jld2"
timeseries = (T = FieldTimeSeries(filepath, "T"),
              S = FieldTimeSeries(filepath, "S"))
times = timeseries.T.times
xT, yT, zT = nodes(timeseries.T)
xS, yS, zS = nodes(timeseries.S)

fig = Figure(size = (700, 500))
ax_T = Axis(fig[2, 1]; xlabel = "Temperature", ylabel = "z")
xlims!(ax_T, 271, 274)
ax_S = Axis(fig[2, 2]; xlabel = "Salinity", ylabel = "z")
xlims!(ax_S, 30, 36)

n = Observable(1)

T = @lift interior(timeseries.T[$n], 1, 1, :)
hm_T=lines!(ax_T, T, zT; label, color=:red)

S = @lift interior(timeseries.S[$n], 1, 1, :)
hm_S=lines!(ax_S, S, zS; label, color=:blue)

label = @lift "t = " * string(round(times[$n], digits=5))
fig[1, 1:2] = Label(fig, label, tellwidth=false)

current_figure() #hide
fig

frames = 1:length(times)

@info "Making an animation..."

record(fig, "one_dimensional_diffusion_TS_iceocean2_tmc.mp4", frames, framerate=10) do i
    n[] = i
end
nothing #hide
# ![](one_dimensional_diffusion.mp4)


