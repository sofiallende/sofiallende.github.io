# # Created on Mon Jul 29 2024
# # @author: sallende
# # This example is a modified version of the one_dimensional_diffusion_example from the Oceananigans.jl GitHub repository.
#
# This Oceananigans.jl's example is simulating the diffusion of a one-dimensional Gaussian temperature and salinity tracers.
# The governing equations are:
# ∂tS + ∂zS(-κs*∂zS)=0, κs=molecular diffusivity of the salt 
# ∂tT + ∂zT(-κT*∂zT)=0, κT=molecular diffusivity of the temperature

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
# the `z`-direction, where `z` spans from `z = -0.5` to `z = 0.5`. 

grid = RectilinearGrid(size=128, z=(-0.5, 0.5), topology=(Flat, Flat, Bounded))

# The default topology is `(Periodic, Periodic, Bounded)`. In this example, we're
# trying to solve a one-dimensional problem, so we assign `Flat` to the
# `x` and `y` topologies. We excise halos and avoid interpolation or differencing
# in `Flat` directions, saving computation and memory.

# Next, we specify a model with `ScalarDiffusivity`, which accounts for either molecular or turbulent diffusion. Since we are dealing with a one-dimensional problem, we only set up the molecular diffusivity for salt and temperature. Please note that the rate between both diffusivities represent the Lewis number (Le=Sc/Pr, Sc=ν/κs, Pr= ν/κT) 

closure = ScalarDiffusivity(κ=(T=10,S=1))

# We finally pass these ingredients to `NonhydrostaticModel`,
model = NonhydrostaticModel(; grid, closure, tracers=(:T, :S))

# By default, `NonhydrostaticModel` has no-flux (insulating and stress-free) boundary conditions on
# all fields.
#
# Next, we `set!` the same initial condition on the temperature and salinity fields,`model.tracers.T` and `model.tracers.S`. Our objective is to observe the diffusion of a Gaussian.

width = 0.1
initial_temperature(z) = exp(-z^2 / (2width^2))
initial_salinity(z) = exp(-z^2 / (2width^2))
set!(model, T=initial_temperature, S=initial_salinity)


# ## Visualizing model data
#
# Calling `set!` above changes the data contained in `model.tracers.T`,
# which was initialized as `0`'s when the model was created.
# To see the new data in `model.tracers.T`, we plot it:

set_theme!(Theme(fontsize = 24, linewidth=3))
fig = Figure(size = (700, 500))
ax_T = Axis(fig[1, 1], title="t = 0", xlabel = "Temperature", ylabel = "z")
ax_S = Axis(fig[1, 2], title="t = 0", xlabel = "Salinity", ylabel = "z")
label = "t = 0"

z = znodes(model.tracers.T)
T = interior(model.tracers.T, 1, 1, :)
S = interior(model.tracers.S, 1, 1, :)

hm_T=lines!(ax_T, T, z; label, color=:red)
hm_S=lines!(ax_S, S, z; label, color=:blue)
#current_figure() #hide
fig
save("IC_TS.pdf", fig, pdf_version="1.4")

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
                     filename = "one_dimensional_diffusionTS.jld2",
                     schedule=IterationInterval(100),
                     overwrite_existing = true)

# We run the simulation for 10,000 more iterations,

simulation.stop_iteration += 20000
run!(simulation)

# Finally, we animate the results by opening the JLD2 file, extract the
# iterations we ended up saving at, and plot the evolution of the
# temperature profile in a loop over the iterations.

## Temperature and salinity movie
filename = "one_dimensional_diffusionTS"
filepath = filename * ".jld2"
timeseries = (T = FieldTimeSeries(filepath, "T"),
              S = FieldTimeSeries(filepath, "S"))
times = timeseries.T.times
xT, yT, zT = nodes(timeseries.T)
xS, yS, zS = nodes(timeseries.S)

fig = Figure(size = (700, 500))
ax_T = Axis(fig[2, 1]; xlabel = "Temperature", ylabel = "z")
xlims!(ax_T, 0, 1)
ax_S = Axis(fig[2, 2]; xlabel = "Salinity", ylabel = "z")
xlims!(ax_S, 0, 1)

n = Observable(1)

T = @lift interior(timeseries.T[$n], 1, 1, :)
hm_T=lines!(ax_T, T, zT; label, color=:red)

S = @lift interior(timeseries.S[$n], 1, 1, :)
hm_S=lines!(ax_S, S, zS; label, color=:blue)

label = @lift "t = " * string(round(times[$n], digits=3))
fig[1, 1:2] = Label(fig, label, tellwidth=false)

current_figure() #hide
fig

frames = 1:length(times)

@info "Making an animation..."

record(fig, "one_dimensional_diffusion_TS.mp4", frames, framerate=24) do i
    n[] = i
end
nothing #hide

