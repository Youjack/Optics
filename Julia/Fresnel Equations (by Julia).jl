### A Pluto.jl notebook ###
# v0.14.8

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

# ╔═╡ a8ba6ad0-b000-11eb-3400-9b6f0888447d
begin
	using Plots
	gr()
	# plotly()
	# To plot a 3d plot, Plotly is preferable.
	# But Plotly is slower than GR.
	
	using PlutoUI
	
	md"# Fresnel Equations (by Julia)"
end

# ╔═╡ d6e1e448-4962-4819-a7f2-3dc3d2eb5202
begin
	# create controls of parameters
	local n1slider = @bind n1 Slider(1:0.1:2, default=  1)
	local n2slider = @bind n2 Slider(1:0.1:2, default=1.5)
	local θislider = @bind θi Slider(0:1:90, default=0)
	local vector_magnitude_select = @bind vector_magnitude Select(["Amplitude","Intensity","Power"], default="Power")
	
	md"""
	``n_1`` $n1slider
	``n_2`` $n2slider
	
	``\theta_i`` $θislider
	
	vector magnitude $vector_magnitude_select
	"""
end

# ╔═╡ 1801f33b-01a7-45e4-b092-488219fd09b2
begin
	# angles
	θt = asind(n1/n2 * sind(θi) +0im)
	θt = imag(θt)==0 ? real(θt) : θt # get rid of the imaginary part if θt is real
	local θb = atand(n2/n1)      # Brewster angle
	local θc = asind(n2/n1 +0im) # critical angle of total internel reflection
	totalreflection = n1<=n2 ? false : θi>real(θc)
	
	# complex reflection coefficients
	Sr = (n1 * cosd(θi) - n2 * cosd(θt)) / (n1 * cosd(θi) + n2 * cosd(θt)) |> z->[abs(z),-(rad2deg∘angle)(z)]
	Pr = (n2 * cosd(θi) - n1 * cosd(θt)) / (n2 * cosd(θi) + n1 * cosd(θt)) |> z->[abs(z),-(rad2deg∘angle)(z)]
	# transmission coefficients
	St = 2*n1 * cosd(θi) / (n1 * cosd(θi) + n2 * cosd(θt))
	Pt = 2*n1 * cosd(θi) / (n2 * cosd(θi) + n1 * cosd(θt))
	# intensity and power
	if vector_magnitude=="Intensity"
        Sr[1] = Sr[1]^2; St = n2/n1 * St^2
        Pr[1] = Pr[1]^2; Pt = n2/n1 * Pt^2
	end
    if vector_magnitude=="Power"
        Sr[1] = Sr[1]^2; St = St!=0 ? cosd(θt)/cosd(θi) * n2/n1 * St^2 : St
        Pr[1] = Pr[1]^2; Pt = Pt!=0 ? cosd(θt)/cosd(θi) * n2/n1 * Pt^2 : Pt
    	# examine if St,Pt==0 to avoid cosd(90)==0
	end
	
	# create table of parameters
	md"""
	``n_1=`` $n1, ``n_2=`` $n2
	* ``\theta_b=`` $(round(θb,digits=2))
	* ``\theta_c=`` $(round(θc,digits=2))
	
	|🐄🍺|incident|reflected|transmitted|
	|:-- |:-:     |:-:      |:-:        |
	|**angle**|$θi|$θi|$(round(θt,digits=2))|
	|**S ($vector_magnitude)**|1|$(round(Sr[1],digits=2)) ``\angle`` $(round(Sr[2],digits=2))|$(totalreflection ? "evanescent" : round(St,digits=2))|
	|**P ($vector_magnitude)**|1|$(round(Pr[1],digits=2)) ``\angle`` $(round(Pr[2],digits=2))|$(totalreflection ? "evanescent" : round(Pt,digits=2))|
	"""
end

# ╔═╡ 0df7d117-6c7c-4ede-a671-81ee11fc77bc
begin
	# create controls of figure
	local figure_checkbox = @bind showfigure CheckBox(default=false)
	
	md"""
	 $figure_checkbox show figure
	"""
end

# ╔═╡ 08a3a564-3e91-4545-937e-6704134b7474
if showfigure
	# create controls of figure
	local azimuthal_slider = @bind azimuthal Slider(0:10:90, default=40)
	local elevation_slider = @bind elevation Slider(0:10:90, default=20)
	
	md"""	
	view angle: azimuthal $azimuthal_slider elevation $elevation_slider
	"""
end

# ╔═╡ 66bc6201-a3cf-4510-9132-50dff07e2843
if showfigure
	# define a function to conveniently plot a line connecting two points
	function plotline(point1,point2; args...)
		plot3d!(
			[ point1[1], point2[1] ],
			[ point1[2], point2[2] ],
			[ point1[3], point2[3] ];
			args...
		)
	end
	
	# set plot options
	local plotcolor = palette(:tab10)
	local plotrange = 2
	plot3d(; xlims=(-plotrange,plotrange), ylims=(-plotrange,plotrange), zlims=(-plotrange,plotrange),
		grid=false, showaxis=false, ticks=false, aspectratio=:equal,
		camera=(azimuthal,elevation), legend=false)
	
	# plot interface of medium
    plotline([-plotrange,0,0],[plotrange,0,0], color=:gray)
    plotline([0,-plotrange,0],[0,plotrange,0], color=:gray)
    # plot normal line
    plotline([0,0,-plotrange],[0,0,plotrange], color=:gray, linestyle=:dash)

	# points to draw light vectors
    iPoint = plotrange/2 * [-sind(θi),0, cosd(θi)]
    rPoint = plotrange/2 * [ sind(θi),0, cosd(θi)]
    tPoint = plotrange/2 * [ sind(θt),0,-cosd(θt)]
    # plot light beams
    plotline([0,0,0],2*iPoint, color=:goldenrod)
    plotline([0,0,0],2*rPoint, color=:gold)
    !totalreflection ?
	plotline([0,0,0],2*tPoint, color=:gold) : nothing
	
	# plot light vectors
    # represent phase shift of reflected light by a counterclockwise rotation of the light vetors
    # S light
	plotline(iPoint, iPoint +                      [0,-1,0]                                       , linewidth=2, color=plotcolor[1])
    plotline(rPoint, rPoint + Sr[1]* ( cosd(Sr[2])*[0,-1,0] + sind(Sr[2])*[cosd(θi),0,-sind(θi)] ), linewidth=2, color=plotcolor[1])
    !totalreflection ?
	plotline(tPoint, tPoint + St   *               [0,-1,0]                                       , linewidth=2, color=plotcolor[1]) : nothing
	# P light
    plotline(iPoint, iPoint +                      [ cosd(θi),0,sind(θi)]                         , linewidth=2, color=plotcolor[2])
    plotline(rPoint, rPoint + Pr[1]* ( cosd(Pr[2])*[-cosd(θi),0,sind(θi)] + sind(Pr[2])*[0,-1,0] ), linewidth=2, color=plotcolor[2])
	!totalreflection ?
    plotline(tPoint, tPoint + Pt   *               [ cosd(θt),0,sind(θt)]                         , linewidth=2, color=plotcolor[2]) : nothing

	# show the figure
	plot!()
end

# ╔═╡ Cell order:
# ╟─a8ba6ad0-b000-11eb-3400-9b6f0888447d
# ╟─1801f33b-01a7-45e4-b092-488219fd09b2
# ╟─d6e1e448-4962-4819-a7f2-3dc3d2eb5202
# ╟─0df7d117-6c7c-4ede-a671-81ee11fc77bc
# ╟─08a3a564-3e91-4545-937e-6704134b7474
# ╟─66bc6201-a3cf-4510-9132-50dff07e2843
