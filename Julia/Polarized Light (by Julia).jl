### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ d195cbb0-4918-11eb-3e87-39fcec3da011
begin
	using Plots
	gr()
	# plotly()
	# To plot a 3d plot, Plotly is preferable.
	# But Plotly is slower than GR and does not support animation.
	
	using PlutoUI
	
	md"# Polarized Light (by Julia)"
end

# ╔═╡ 138c2700-8459-11eb-051e-b1a8e9e9cf56
begin
	# create controls of parameters
	local θslider = @bind θ Slider(0:15:90, default=90)
	local δAslider = @bind _δA Slider(-4:4, default=0)
	local δCslider = @bind _δC Slider(-4:4, default=0)
	
	md"""
	``\theta`` $θslider
	``\delta_A`` $δAslider
	``\delta_C`` $δCslider
	"""
end

# ╔═╡ f0414550-8458-11eb-2f0b-c72b0d352668
begin
	# amplitudes of e/o polarizations
	Ae = cosd(θ); Ao = sind(θ)
	# phase differences
	local __δA = _δA//4;      δA = __δA * π
	local __δC = _δC//4;      δC = __δC * π
	local __δB = __δA + __δC; δB = __δB * π
	
	# create table of parameters
	md"""
	``\theta\equiv\arctan\frac{A_o}{A_e}=`` $θ °
	
	* ``\delta_A=`` $__δA ``\pi``
	* ``\delta_C=`` $__δC ``\pi``, ``\Delta_C=`` $(__δC//2) ``\lambda``
	``\delta_B=\delta_A+\delta_C=`` $__δB ``\pi``
	"""
end

# ╔═╡ 8b7f57a0-4b1f-11eb-100a-299e1de7114b
begin
	# create controls of figure
	local figure_checkbox = @bind showfigure CheckBox(default=false)
	
	md"""
	 $figure_checkbox show figure
	"""
end

# ╔═╡ 12de3e00-4b25-11eb-39a6-69a20d24f397
if showfigure
	# create controls of figure
	local azimuthal_slider = @bind azimuthal Slider(0:10:90, default=40)
	local elevation_slider = @bind elevation Slider(0:10:90, default=20)
	local component_checkbox = @bind showcomponent CheckBox(default=true)
	local vector_checkbox = @bind showvector CheckBox(default=true)
	local animation_checkbox = @bind showanimation CheckBox(default=false)
	
	md"""	
	 $component_checkbox show component waves
	 $vector_checkbox show vectors
	 $animation_checkbox show animation
	
	view angle: azimuthal $azimuthal_slider elevation $elevation_slider
	"""
end

# ╔═╡ 7b58f640-4a7c-11eb-26a8-f9231c46a797
if showfigure
	
	# function that calculates and plots the figure
	function fig(t::Float64)
		xrange = 15
		# components of original wave
		xn = collect(-xrange:0.1:0) # negative x of original wave
		en = sin.(xn .- t .- δA) .* Ae
		on = sin.(xn .- t      ) .* Ao
		# components of polarized wave
		xp = collect(0:0.1:xrange)  # positive x of polarized wave
		ep = sin.(xp .- t .- δB) .* Ae
		op = sin.(xp .- t      ) .* Ao
		len = length(xn)
		
		# define a function to plot frames
		function plotframe(
			x::Float64,
			e::Float64, o::Float64,
			color::RGB{Float64})
			# plot the frames at the ends of the two waves
			plot3d!([x,x],[-1.5,1.5],[0,0], color=:gray, linestyle=:dash, linewidth=1)
			plot3d!([x,x],[0,0],[-1.5,1.5], color=:gray, linestyle=:dash, linewidth=1)
			# plot the endpoints of the two waves
			scatter3d!([x],[e],[o], markercolor=color, markersize=4)
		end
		# define a function to plot waves
		function plotwave(
			x::Array{Float64,1},
			e::Array{Float64,1}, o::Array{Float64,1},
			color::RGB{Float64})
			# plot wave
			plot3d!(x,e,o, color=color, linewidth=2)
			# plot component waves
			zero = zeros(len)
			if showcomponent
				plot3d!(x,e,zero, color=color, linestyle=:dash, linewidth=1)
				plot3d!(x,zero,o, color=color, linestyle=:dash, linewidth=1)
			end
			# plot vector field
			if showvector
				for i in 3:5:len
					plot3d!([x[i],x[i]],[0,e[i]],[0,o[i]],
						color=color, linewidth=0.5)
				end
			end
		end
		
		# set plot options
		plotcolor = palette(:tab10)
		plot3d(; xlims=(-xrange,xrange), ylims=(-2,2), zlims=(-2,2),
			ylabel="extraordinary", zlabel="ordinary",
			camera=(azimuthal,elevation), legend=false)
		
		# plot x axis
		plot3d!([-xrange,xrange],[0,0],[0,0], color=:gray, linestyle=:dash)
		# plot original wave
		plotframe(xn[begin],en[begin],on[begin], plotcolor[1])
		plotwave(xn,en,on, plotcolor[1])
		# plot polarizer
		plot3d!([0,0],[-1.5,1.5],[0,0], color=:gray)
		plot3d!([0,0],[0,0],[-1.5,1.5], color=:gray)
		# plot polarized wave
		plotwave(xp,ep,op, plotcolor[2])
		plotframe(xp[end],ep[end],op[end], plotcolor[2])
		
		# show the figure
		plot!()
	end
	
	# plot a static figure or create an animation
	if showanimation
		local anim = Animation()
		for t in 0:0.1:2π
			fig(t)
			frame(anim)
		end
		gif(anim, "polar.gif", fps=15)
	else
		fig(3π/4)
	end
end

# ╔═╡ Cell order:
# ╟─d195cbb0-4918-11eb-3e87-39fcec3da011
# ╟─f0414550-8458-11eb-2f0b-c72b0d352668
# ╟─138c2700-8459-11eb-051e-b1a8e9e9cf56
# ╟─8b7f57a0-4b1f-11eb-100a-299e1de7114b
# ╟─12de3e00-4b25-11eb-39a6-69a20d24f397
# ╟─7b58f640-4a7c-11eb-26a8-f9231c46a797
