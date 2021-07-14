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

# ╔═╡ ca2cbf90-8fcd-11eb-2d2b-a97d54ee0c6b
begin
	using Plots
	gr()
	
	using PlutoUI
	
	md"# Fraunhofer Diffraction (by Julia)"
end

# ╔═╡ f765e590-8fcd-11eb-049e-bd481effaa12
begin
	# create controls of parameters
	local λslider = @bind _λ Slider(400:50 :800, default=500)
	local aslider = @bind _a Slider(1  :    5  , default=1  )
	local dslider = @bind _d Slider(1  :0.5:5  , default=3  )
	local Nslider = @bind N  Slider(1  :    10 , default=5  )
	
	md"""
	``\lambda`` $λslider
	``a`` $aslider
	
	``d/a`` $dslider
	``N`` $Nslider
	"""
end

# ╔═╡ e875dce2-8fd0-11eb-2b70-9f0901291e01
begin
	# parameters
	λ = _λ *10^(-9)
	a = _a *10^(-6)
	d = _d * a
	
	md"""
	``\lambda=`` $_λ nm, ``a=`` $_a μm
	
	``d/a=`` $_d, ``N=`` $N
	"""
end

# ╔═╡ d819bde0-8fcf-11eb-37ed-dd97cff7fea7
begin
	# create controls of figure
	local figure_checkbox = @bind showfigure CheckBox(default=false)
	
	md"""
	 $figure_checkbox show figure
	"""
end

# ╔═╡ 68e94660-8fd0-11eb-06d3-5536f491cb00
if showfigure
	# create controls of figure
	local envelope_checkbox = @bind showenvelope CheckBox(default=true)
	local scale_checkbox = @bind scale CheckBox(default=false)
	
	md"""
	 $envelope_checkbox show envelope
	 $scale_checkbox scale
	"""
end

# ╔═╡ 2461697e-8fd2-11eb-222c-57ceb93acf3a
if showfigure
	
	s = range(-1,1, length=2000) # s=sin(θ)
	# fringe of single-slit diffraction
	α = π * a / λ .* s
	envelope = ( sin.(α) ./ α ).^2
	# fringe of multi-slit diffraction
	γ = π * d / λ .* s
	fringe = envelope .* ( sin.(N.*γ) ./ sin.(γ) ).^2
	envelope = envelope .* N^2
	
	# plot
	if scale # scale the intensity to make secondary bright fringes more visible
		envelope = sqrt.(envelope)
		fringe = sqrt.(fringe)
	end
	plot(; xlabel="\$\\sin\\ \\theta\$", ylabel="Intensity", legend=false)
	if showenvelope
		plot!(s,envelope, color=:gray)
	end
	plot!(s,fringe, color=palette(:tab10)[1], linewidth=2)
end

# ╔═╡ Cell order:
# ╟─ca2cbf90-8fcd-11eb-2d2b-a97d54ee0c6b
# ╟─e875dce2-8fd0-11eb-2b70-9f0901291e01
# ╟─f765e590-8fcd-11eb-049e-bd481effaa12
# ╟─d819bde0-8fcf-11eb-37ed-dd97cff7fea7
# ╟─68e94660-8fd0-11eb-06d3-5536f491cb00
# ╟─2461697e-8fd2-11eb-222c-57ceb93acf3a
