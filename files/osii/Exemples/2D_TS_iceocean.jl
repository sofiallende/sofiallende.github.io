# # Created on Fri Aug 09 2024
# # @author: sallende
# This Oceananigans.jl's example is simulating the two-dimensional ice-ocean interface.
# To model the ice-ocean boundary layer, we utilize the Navier-Stokes equations under the Boussinesq approximation. In the bulk, the governing equations can be written as follows:
# ∂u/∂t+(u⋅∇)u=−(1/ρ0)∇p+ν∇^2u+gρ+F(z)
# ∇⋅u=0
# ∂T/∂t+(u⋅∇)T=κT∇^2T
# ∂S/∂t+(u⋅∇)S=κS∇^2S
# The first equation represents the momentum equation. Here, u = u(x, y, z) denotes the fluid
# velocity in m/s, ρ0 is the reference density in kg/m3, p is the pressure in dbar, and ν is the kinematic
# viscosity in m2/s. The term g represents the gravitational acceleration in m/s2, and ρ is the fluid
# density, κT is the thermal diffusivity and κS is the salinity diffusivity.
# Boundaries conditions:
# Top: T=λ1S + λ2 + λ3Pb  and ∂S/∂z=(κT/κs)*(Cp/Lf)*S*∂T/∂z)
# Bottom: T=T∞ and S=S∞ 
# Contantes:
# λ1=-5.73x10^-2 (K/(g/Kg)), λ2=8.32x10^-2 K, λ3=-7.53x10-4 K/dbar,
# Le=(κT/κs)=[1,100] car κT approx 10^-7 and κs approx 10^-9
# Cp=3974 J/K/Kg and Lf=3.35x10^5J/Kg

## Packages and functions
using Random
using Printf
using CairoMakie
using Oceananigans
using Oceananigans.Units: minute, minutes, hour

## The physical domain
#
# We simulate a ice-salt water scheme in two-dimensions in ``x, z``
# and therefore assign `Flat` to the `y` direction, periodic in 'x' 
# and bounded in 'z'

Nx = 256     # number of points in the horizontal direction.
Nz = 256     # number of points in the vertical direction.

Lx = 1     # (m) domain horizontal extents
Lz = 1     # (m) domain depth

grid = RectilinearGrid(size = (Nx, Nz), 
			x = (0, Lx),
                        z = (-Lz,0),
			topology=(Periodic, Flat, Bounded))

# ## Buoyancy that depends on temperature and salinity
# We use the `SeawaterBuoyancy` model with a linear equation of state,                        
buoyancy = SeawaterBuoyancy(equation_of_state=LinearEquationOfState(thermal_expansion = 3.87e-5, haline_contraction = 7.86e-4))
                                                                    
# ##Boundary condition
T_bot= 273 #K
λ_1= -5.73e-2 #(K/(g/Kg)) 
λ_2= 8.32e-2 #K 
λ_3= -7.53e-4 #K/dbar
@inline T_top(x,t,S) = 273 + λ_1*S + λ_2;
T_bcs = FieldBoundaryConditions(top = ValueBoundaryCondition(T_top,field_dependencies=:S),
				bottom = ValueBoundaryCondition(T_bot))
                               
S_bot= 35 #gr/Kg
Cp= 3974 #J/K/Kg
Lf= 3.35e5 #J/Kg
Le= 10
@inline grad_salt(i,j, grid, clock,  model_tracers) =
    @inbounds Le*(Cp/Lf)*0.5*(model_tracers.S[i,j+grid.Nz,1]+model_tracers.S[i,j-1+grid.Nz,1])*(grid.Nz/grid.Lz)*(model_tracers.T[i,j+grid.Nz,1]-model_tracers.T[i,j-1+grid.Nz,1]) 
S_bcs = FieldBoundaryConditions(top = GradientBoundaryCondition(grad_salt,discrete_form=true),
				bottom=ValueBoundaryCondition(S_bot))

 
no_slip_bc = ValueBoundaryCondition(0.0)
free_slip_surface_bcs = FieldBoundaryConditions(bottom=no_slip_bc, top=no_slip_bc);
                                

# ## Model instantiation
#
# We fill in the final details of the model here: 3rd-order 
# Runge-Kutta time-stepping, and the `AnisotropicMinimumDissipation` closure
# for large eddy simulation to model the effect of turbulent motions at
# scales smaller than the grid scale that we cannot explicitly resolve.

model = NonhydrostaticModel(; grid, buoyancy,
                            timestepper = :RungeKutta3,
                            tracers = (:T, :S),
                            closure = ScalarDiffusivity(ν=1.8e-6,κ=(T=1e-7,S=1e-8)),
                            boundary_conditions = (u=free_slip_surface_bcs, T=T_bcs, S=S_bcs))
                            
# Notes:
#
# * To use the Smagorinsky-Lilly turbulence closure (with a constant model coefficient) rather than
#   `AnisotropicMinimumDissipation`, use `closure = SmagorinskyLilly()` in the model constructor.
#
# * To change the architecture to `GPU`, replace `CPU()` with `GPU()` inside the
#   `grid` constructor.

# ## Initial conditions
## Random noise damped at top and bottom
Ξ(z) = randn() * z / model.grid.Lz * (1 + z / model.grid.Lz) # noise

ρₒ = 1026.0 # kg m⁻³, average density at the surface of the world ocean
u₁₀ = 10    # m s⁻¹, average wind velocity 10 meters above the ocean
cᴰ = 2.5e-3 # dimensionless drag coefficient
ρₐ = 1.225  # kg m⁻³, average density of air at sea-level

Qᵘ = - ρₐ / ρₒ * cᴰ * u₁₀ * abs(u₁₀) # m² s⁻²

## Temperature initial condition: a stable density gradient with random noise superposed.
dTdz = 2 # K m⁻¹
#Tᵢ(x, z) = -2 - dTdz * z - dTdz * model.grid.Lz * 1e-6 * Ξ(z)
Tᵢ(x, z) = -2-dTdz*z+273

## Velocity initial condition: random noise scaled by the friction velocity.
uᵢ(x, z) = sqrt(abs(Qᵘ)) * 1e-3 * Ξ(z)
## `set!` the `model` fields using functions or constants:`
set!(model, u=uᵢ, w=uᵢ, T=Tᵢ, S=35)

fig = Figure(size = (700, 500))
ax_T = Axis(fig[2, 1],
          xlabel="x [m]",
          ylabel="z [m]")

ax_S = Axis(fig[3, 1],
          xlabel="x [m]",
          ylabel="z [m]")


x= xnodes(model.tracers.T)
z= znodes(model.tracers.T)
T = interior(model.tracers.T, :, 1, :)
S = interior(model.tracers.S, :, 1, :)

Tlims = (271, 273)
Slims = (34.5, 35)

hm_T = heatmap!(ax_T, x, z, T; colormap = :thermal, colorrange = Tlims)
Colorbar(fig[2, 2], hm_T; label = "K")

hm_S= heatmap!(ax_S, x, z, S; colormap = :haline, colorrange = Slims)
Colorbar(fig[3, 2], hm_S; label = "g / kg")

fig
save("IC_2D_TS_iceocean.png", fig)

# ## Setting up a simulation
#
# We set-up a simulation with an initial time-step of 10 seconds
# that stops at 40 minutes, with adaptive time-stepping and progress printing.

simulation = Simulation(model, Δt=0.1, stop_time=120minutes)

# The `TimeStepWizard` helps ensure stable time-stepping
# with a Courant-Freidrichs-Lewy (CFL) number of 1.0.

wizard = TimeStepWizard(cfl=1.0, max_change=1.1, max_Δt=1minute)
simulation.callbacks[:wizard] = Callback(wizard, IterationInterval(10))

# Nice progress messaging is helpful:

## Print a progress message
progress_message(sim) = @printf("Iteration: %04d, time: %s, Δt: %s, max(|w|) = %.1e ms⁻¹, wall time: %s\n",
                                iteration(sim), prettytime(sim), prettytime(sim.Δt),
                                maximum(abs, sim.model.velocities.w), prettytime(sim.run_wall_time))

add_callback!(simulation, progress_message, IterationInterval(20))

# We then set up the simulation:

# ## Output
#
# We use the `JLD2OutputWriter` to save ``x, z`` field
## Create a NamedTuple with eddy viscosity
#eddy_viscosity = (; νₑ = model.diffusivity_fields.νₑ)

filename = "2D_TS_iceocean"

simulation.output_writers[:fields] =
    JLD2OutputWriter(model, merge(model.velocities, model.tracers),
                     filename = filename * ".jld2",
                     schedule = TimeInterval(1minute),
                     overwrite_existing = true)

# We're ready:

run!(simulation) 

#print(model.tracers.S[:]) 

# ## Turbulence visualization
#
# We animate the data saved in `ocean_wind_mixing_and_convection.jld2`.
# We prepare for animating the flow by loading the data into
# FieldTimeSeries and defining functions for computing colorbar limits.

filepath = filename * ".jld2"

time_series = (w = FieldTimeSeries(filepath, "w"),
               T = FieldTimeSeries(filepath, "T"),
               S = FieldTimeSeries(filepath, "S"))

## Coordinate arrays
xw= xnodes(model.velocities.w)
zw=znodes(model.velocities.w)

xT= xnodes(model.tracers.T)
zT=znodes(model.tracers.T)

# We start the animation at ``t = 10`` minutes since things are pretty boring till then:

times = time_series.w.times
intro = searchsortedfirst(times, 1minutes)

# We are now ready to animate using Makie. We use Makie's `Observable` to animate
# the data. To dive into how `Observable`s work we refer to
# [Makie.jl's Documentation](https://makie.juliaplots.org/stable/documentation/nodes/index.html).

n = Observable(intro)

 wₙ = @lift interior(time_series.w[$n],  :, 1, :)
 Tₙ = @lift interior(time_series.T[$n],  :, 1, :)
 Sₙ = @lift interior(time_series.S[$n],  :, 1, :)

fig = Figure(size = (1000, 500))

axis_kwargs = (xlabel="x (m)",
               ylabel="z (m)")

ax_w  = Axis(fig[2, 1]; title = "Vertical velocity", axis_kwargs...)
ax_T  = Axis(fig[2, 3]; title = "Temperature", axis_kwargs...)
ax_S  = Axis(fig[3, 1]; title = "Salinity", axis_kwargs...)

title = @lift @sprintf("t = %s", prettytime(times[$n]))

wlims = (-0.05, 0.05)
Tlims = (271, 273)
Slims = (34.95, 35.05)

hm_w = heatmap!(ax_w, xw, zw, wₙ; colormap = :balance, colorrange = wlims)
Colorbar(fig[2, 2], hm_w; label = "m s⁻¹")

hm_T = heatmap!(ax_T, xT, zT, Tₙ; colormap = :thermal, colorrange = Tlims)
Colorbar(fig[2, 4], hm_T; label = "K")

hm_S = heatmap!(ax_S, xT, zT, Sₙ; colormap = :cork, colorrange = Slims)
Colorbar(fig[3, 2], hm_S; label = "g / kg")

fig[1, 1:4] = Label(fig, title, fontsize=24, tellwidth=false)

current_figure() #hide
fig

# And now record a movie.

frames = intro:length(times)

@info "Making a motion picture of ocean sea ice interactions..."

record(fig, filename * ".mp4", frames, framerate=8) do i
    n[] = i
end
nothing #hide

