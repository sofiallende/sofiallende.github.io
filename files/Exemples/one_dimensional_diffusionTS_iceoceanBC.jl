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
# pkg"add Oceananigans, CairoMakie"
# ```

# ## Using `Oceananigans.jl`
#
# Write

using Oceananigans
using Printf
using CairoMakie

# ## Instantiating and configuring a model
#
# We build a `NonhydrostaticModel` by passing it a `grid`.
# We build a rectilinear grid with 128 regularly-spaced grid points in
# the `z`-direction, where `z` spans from `z = -1` to `z = 0`. 

grid = RectilinearGrid(size=128, z=(-1, 0), topology=(Flat, Flat, Bounded))

# The default topology is `(Periodic, Periodic, Bounded)`. In this example, we're
# trying to solve a one-dimensional problem, so we assign `Flat` to the
# `x` and `y` topologies. We excise halos and avoid interpolation or differencing
# in `Flat` directions, saving computation and memory.

# ##Boundary condition  (with values in their dimensionless form)
T_bot= 273 #K
λ1= -5.73e-2 #(K/(g/Kg)) 
λ2= 8.32e-2 #K 
λ3= -7.53e-4 #K/dbar
@inline T_top(t,S) = 273+λ1*S+λ2;
T_bcs = FieldBoundaryConditions(top = ValueBoundaryCondition(T_top,field_dependencies=:S),
				bottom = ValueBoundaryCondition(T_bot))
                               
S_bot= 35
Cp= 3974 #J/K/Kg
Lf= 3.35e5 #J/Kg
Le= 10    
@inline grad_salt(i,j, grid, clock,  model_tracers) =
    @inbounds Le*(Cp/Lf)*0.5*(model_tracers.S[i,j+grid.Nz,1]+model_tracers.S[i,j-1+grid.Nz,1])*(grid.Nz/grid.Lz)*(model_tracers.T[i,j+grid.Nz,1]-model_tracers.T[i,j-1+grid.Nz,1]) 
    
S_bcs = FieldBoundaryConditions(top = GradientBoundaryCondition(grad_salt,discrete_form=true),
				bottom=ValueBoundaryCondition(S_bot))

no_slip_bc = ValueBoundaryCondition(0.0)
free_slip_surface_bcs = FieldBoundaryConditions(bottom=no_slip_bc, top=no_slip_bc);
                                				
# We next specify a model with an `ScalarDiffusivity`, which models either
# molecular or turbulent diffusion. 
# We differentiate the diffusion of salt and temperature. Please note 
# that the rate between both diffusivities represent the Lewis number
# (Le=Sc/Pr, Sc=ν/κs, Pr= ν/κT) 

closure = ScalarDiffusivity(κ=(T=1e-7,S=1e-8))

# We finally pass these two ingredients to `NonhydrostaticModel`,
model = NonhydrostaticModel(; grid, closure, tracers=(:T, :S),boundary_conditions = (u=free_slip_surface_bcs, T=T_bcs, S=S_bcs))

# By default, `NonhydrostaticModel` has no-flux (insulating and stress-free) boundary conditions on
# all fields.
#
# Next, we `set!` an initial condition on the temperature field,
# `model.tracers.T`. Our objective is to observe the diffusion of a Gaussian.

#width = 0.1
#initial_temperature(z) = exp(-z^2 / (2width^2))
#initial_salinity(z) = exp(-z^2 / (2width^2))

initial_temperature(z) = 273 + (-2-2*z)
initial_salinity(z)=35
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
xlims!(ax_T, 270, 274)
ax_S = Axis(fig[1, 2], title="t = 0", xlabel = "Salinity", ylabel = "z")
xlims!(ax_S, 34.5, 35.5)
label = "t = 0"


z = znodes(model.tracers.T)
T = interior(model.tracers.T, 1, 1, :)
S = interior(model.tracers.S, 1, 1, :)

hm_T=lines!(ax_T, T, z; label, color=:red)
hm_S=lines!(ax_S, S, z; label, color=:blue)
fig
#save("IC_TS_iceocean.pdf", fig, pdf_version="1.4")
save("IC_TS_iceocean.png", fig)

# The function `interior` above extracts a `view` of `model.tracers.T` over the
# physical points (excluding halos) at `(1, 1, :)`.
#
# ## Running a `Simulation`
#
# Next we set-up a `Simulation` that time-steps the model forward and manages output.

## Time-scale for diffusion across a grid cell
min_Δz = minimum_zspacing(model.grid)
diffusion_time_scale = min_Δz^2 / model.closure.κ.T

simulation = Simulation(model, Δt = 0.1 * diffusion_time_scale, stop_iteration = 100)

progress_message(sim) = @printf("Iteration: %04d, time: %s, Δt: %s, max(|w|) = %.1e ms⁻¹, wall time: %s\n",
                                iteration(sim), prettytime(sim), prettytime(sim.Δt),
                                maximum(abs, sim.model.velocities.w))
                                
# `simulation` will run for 1000 iterations with a time-step that resolves the time-scale
# at which our temperature field diffuses. All that's left is to

run!(simulation)

T_teo=(1/2)*(model.tracers.T[grid.Nz+3]+model.tracers.T[grid.Nz+1+3])
T_bou=273+λ1*(1/2)*(model.tracers.S[grid.Nz+3]+model.tracers.S[grid.Nz+1+3])
print("Temp BC %error ", (T_bou-T_teo)/T_teo*100)

S_teo=(grid.Nz/grid.Lz)*(model.tracers.S[grid.Nz+3]-model.tracers.S[grid.Nz+1+3])
S_bou=Le*(Cp/Lf)*0.5*(model.tracers.S[grid.Nz+3]+model.tracers.S[grid.Nz+1+3])*(grid.Nz/grid.Lz)*(model.tracers.T[grid.Nz+3]-model.tracers.T[grid.Nz+1+3])
print("Salt BC %error ",(S_bou-S_teo)/S_teo*100)

# ## Visualizing the results
#
# Let's look at how `model.tracers.T` changed during the simulation.

label = @sprintf("t = %.3f", model.clock.time)
lines!(interior(model.tracers.T, 1, 1, :), z; label)
axislegend()
current_figure() #hide

# Very interesting! Next, we run the simulation a bit longer and make an animation.
# For this, we use the `JLD2OutputWriter` to write data to disk as the simulation progresses.

simulation.output_writers[:temperature] =
    JLD2OutputWriter(model, model.tracers,
                     filename = "one_dimensional_diffusionTS_iceocean.jld2",
                     schedule=IterationInterval(100),
                     overwrite_existing = true)

# We run the simulation for 10,000 more iterations,

simulation.stop_iteration += 20000
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
filename = "one_dimensional_diffusionTS_iceocean"
filepath = filename * ".jld2"
timeseries = (T = FieldTimeSeries(filepath, "T"),
              S = FieldTimeSeries(filepath, "S"))
times = timeseries.T.times
xT, yT, zT = nodes(timeseries.T)
xS, yS, zS = nodes(timeseries.S)

fig = Figure(size = (700, 500))
ax_T = Axis(fig[2, 1]; xlabel = "Temperature", ylabel = "z")
xlims!(ax_T, 270, 274)
ax_S = Axis(fig[2, 2]; xlabel = "Salinity", ylabel = "z")
xlims!(ax_S, 33, 35.1)

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

record(fig, "one_dimensional_diffusion_TS_iceocean.mp4", frames, framerate=10) do i
    n[] = i
end
nothing #hide
# ![](one_dimensional_diffusion.mp4)


