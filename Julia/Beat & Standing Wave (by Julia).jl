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
	
	using PlutoUI
	
	# const parameters
	A = 1
	ω1 = 4.0
	k1 = 2.0
	
	md"# Beat & Standing Wave (by Julia)"
end

# ╔═╡ 4c53a8be-49ed-11eb-223e-4fb78067f21c
begin
	# create controls of parameters
	local ω2slider = @bind ω2  Slider(ω1-0.5:0.05:ω1, default=ω1)
	local k2slider = @bind _k2 Slider(k1-0.3:0.05:k1, default=k1)
	local k2checkbox = @bind k2reversed CheckBox(default=false)
	
	md"""
	``\omega_2`` $ω2slider
	``k_2`` $k2slider
	$k2checkbox direction reversed
	"""
end

# ╔═╡ 93f81810-83f8-11eb-3aa0-a561a45e060c
begin	
	# angular frequencies
	ωa = (ω1+ω2)/2
	ωm = (ω1-ω2)/2
	# wave numbers
	k2 = (k2reversed ? -1 : 1) * _k2
	ka = (k1+k2)/2
	km = (k1-k2)/2
	# velocities
	up = ωa / ka
	ug = ωm / km
	
	# create table of parameters
	md"""
	|wave 1|wave 2|average|modulation|velocity|
	|:-:   |:-:   |:-:    |:-:       |:-:     |
	|``\omega_1=`` $(round(ω1,digits=2))|``\omega_2=`` $(round(ω2,digits=2))|``\bar{\omega}=`` $(round(ωa,digits=2))|``\omega_m=`` $(round(ωm,digits=2))|``u_p=`` $(round(up,digits=2))|
	|``k_1=``      $(round(k1,digits=2))|``k_2=``      $(round(k2,digits=2))|``\bar{k}=``      $(round(ka,digits=2))|``k_m=``      $(round(km,digits=2))|``u_g=`` $(round(ug,digits=2))|
	"""
end

# ╔═╡ 48ca75b0-83fb-11eb-066e-fff8243569d2
begin
	# create controls of figure
	local figure_checkbox = @bind showfigure CheckBox(default=false)
	
	md"""
	 $figure_checkbox show figure
	"""
end

# ╔═╡ 0e65cbf0-4a7a-11eb-14e4-a1ee75211a33
if showfigure
	# create controls of figure
	local envelope_checkbox = @bind showenvelope CheckBox(default=true)
	local animation_checkbox = @bind showanimation CheckBox(default=false)
	
	md"""
	 $envelope_checkbox show envelope
	 $animation_checkbox show animation
	"""
end

# ╔═╡ f8309bb0-4918-11eb-1ea1-53bd754864e0
if showfigure
	# function that calculates and plots the figure
	function fig(t::Float64)
		x = 0:0.1:80
		carrier  =     cos.(ka.*x .- ωa*t)
		envelope = 2A.*cos.(km.*x .- ωm*t)
		wave = carrier .* envelope
		
		# plot
		plot(; ylims=(-7,7), xlabel="\$x\$",ylabel="\$y\$", legend=false)
		if showenvelope
			plot!(x,  envelope, color=:gray)
			plot!(x,.-envelope, color=:gray)
		end
		plot!(x,wave, color=palette(:tab10)[1], linewidth=2)
	end
	
	# plot a static figure or create an animation
	if showanimation
		local anim = Animation()
		for t in 0:0.1:10
			fig(t)
			frame(anim)
		end
		gif(anim, "beat.gif", fps=15)
	else
		fig(0.3)
	end
end

# ╔═╡ Cell order:
# ╟─d195cbb0-4918-11eb-3e87-39fcec3da011
# ╟─93f81810-83f8-11eb-3aa0-a561a45e060c
# ╟─4c53a8be-49ed-11eb-223e-4fb78067f21c
# ╟─48ca75b0-83fb-11eb-066e-fff8243569d2
# ╟─0e65cbf0-4a7a-11eb-14e4-a1ee75211a33
# ╟─f8309bb0-4918-11eb-1ea1-53bd754864e0
