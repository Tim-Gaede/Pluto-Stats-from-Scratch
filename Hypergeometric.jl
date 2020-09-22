### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ 816ea402-7eae-11ea-2134-fb595cca3068
begin
	using Pkg
	
	Pkg.add("PlutoUI")
	Pkg.add("Interact")
	Pkg.add("Plots")
	Pkg.add("Formatting")
	using PlutoUI
	using Interact
	using Plots
	using Formatting
end

# ╔═╡ e9220680-fb03-11ea-2b0b-5100c59644b8
md"# Coding Stats from Scratch

## Hypergeometric Distribution

Timothy Gaede

2020-09-20"

# ╔═╡ ce7bec8c-7eae-11ea-0edb-ad27d2df059d
md"From a population of an N items, with K items of interest, we sample n items.  What is the probability the sample contains exactly k items of interest?"

# ╔═╡ e2ec2790-fc9e-11ea-2a88-e1076f6e453c
md"ⁿCₖ = $${{n}\choose{k}} = {{n(n-1)(n-2)⋅⋅⋅(n-k+1)}\over{k(k-1)⋅⋅⋅1}}$$"

# ╔═╡ 0dde87dc-fb04-11ea-2086-659b3ddc65ea
md"## Combinations

To understand the hyergeometric distribution, we first need to recall the concept of  combinations:"

# ╔═╡ 12e7db42-fb05-11ea-3979-95e6175d3939
md"$${{{K}\choose{k}}{{N-K}\choose{n-k}}}\over{{N}\choose{n}}$$"

# ╔═╡ 17b51252-fb0a-11ea-16ab-45ed75c76819
md"If we have 52 distinct cards how many ways can we choose five? The answer is \"fifty-two choose five\":"

# ╔═╡ b8ab92d6-f8ac-11ea-2c6d-e348859be41a
function superscript(n::Int)
    if n == 0;    return "⁰";    end

    res = ""
    n < 0    ?    rem = -n    :    rem = n

    sups = split("¹²³⁴⁵⁶⁷⁸⁹⁰", "")

    while rem > 0
        d = rem % 10 # digit
        rem ÷= 10

        d == 0    ?    res *= string(sups[10])    :    res *= string(sups[d])
    end
    if n < 0;    res *= "⁻";   end

    reverse(res) # returned
end

# ╔═╡ c2ed84ca-f8ac-11ea-29d2-b946ee92f2c5
#=
    Timothy Gaede

  	Converts a number to a string in scientific notation

  	string_for_plus should be "+", " ", or ""

  	underscores may aid in comparing numbers of similar magnitude:
    3.973_614_538 × 10²⁶
    3.973_614_627 × 10²⁶
=#
function sci(n::Number, sigFigs::Int, string_for_plus::String, underscores::Bool)
    pwr = convert(Int, floor(log10(abs(n))))

    mant_fmd = format(n / 10.0^pwr, precision=sigFigs-1)
    if n < 0.0  &&  length(mant_fmd) > sigFigs + 2  ||
       n > 0.0  &&  length(mant_fmd) > sigFigs + 1
        pwr += 1
        mant_fmd = format(n / 10.0^pwr, precision=sigFigs-1)
    end

    # add underscores as thousands separator to right of decimal ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
	if underscores
		if n < 0.0
			mant_fmd_final = mant_fmd[1:3]
			i_start = 4
		else
			mant_fmd_final = mant_fmd[1:2]
			i_start = 3
		end

		for i in (i_start :  length(mant_fmd))        
			mant_fmd_final *= mant_fmd[i]


			if i < length(mant_fmd)     
				Δi = i - i_start + 1
				if Δi > 0  &&   Δi % 3 == 0
					mant_fmd_final *= '_'
				end
			end
		end
	else
		mant_fmd_final = mant_fmd
	end	
    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅

	if n > 0.0
		mant = string_for_plus * mant_fmd_final
	else
		mant = mant_fmd_final
	end
	
    mant * " × 10" * superscript(pwr)
end

# ╔═╡ e65722fa-fc98-11ea-03dc-633ff72a758a
function lnⁿCₖ(n, k) 
	
    #  if            then             else
	2k > n    ?    k′ = n-k	   :    k′ = k 	
		
	
    ans = 0.0
    for diff in (0 : k′-1)
		ans += log(n - diff)
        ans -= log(k′- diff)
	end 

    ans
end

# ╔═╡ 3e1ad31a-f76c-11ea-004c-e742c657dae6
prob_Hyper(N, K, n, k) = exp(lnⁿCₖ(K, k) + lnⁿCₖ(N-K, n-k) - lnⁿCₖ(N, n))

# ╔═╡ c175bc90-fcab-11ea-1664-eb0ea063969c
function ⁿCₖ_BigFloat(n, k)	
	
	#  if            then             else
	2k > n    ?    k′ = n-k	   :    k′ = k 	 
	
	 
	ans = BigFloat(1.0) 
	for diff in (0 : k′-1)
		ans *= n  - diff
		ans /= k′ - diff
	end
	 
	 
	ans
end

# ╔═╡ 79784f38-fcac-11ea-3bd2-af5a1e28d344
function prob_Hyper_BigFloat(N, K, n, k) 
	(ⁿCₖ_BigFloat(K, k) / ⁿCₖ_BigFloat(N, n)) * ⁿCₖ_BigFloat(N-K, n-k)
end

# ╔═╡ 9e365f02-f76d-11ea-096d-3bca6f24dcb2
function ∑Hyper(N, K, n, kₗₒ, kₕᵢ)
	
	msg = ""
	if K > N
		msg = "K cannot exceed N.\n\n" *
		      "K is the number of target items in the population\n" *
		      "N is the number of items in the population."
    elseif n > N
		msg = "n cannot exceed N.\n\n" *
		      "n is the number of items in the sample\n" *
		      "N is the number of items in the populuation."		
    elseif kₕᵢ > n
		msg = "kₕᵢ cannot exceed n.\n\n" * 
		      "k is the number of target items in the sample\n" *
		      "n is the number of items in the sample."		
    elseif kₕᵢ > K
		msg = "kₕᵢ cannot exceed K.\n\n" *
		      "k is the number of target items in the sample\n" *
		      "K is the number of target items in the population."
    elseif kₗₒ > kₕᵢ
		msg = "kₗₒ cannot exceed kₕᵢ."
    end

    if length(msg) > 0;    throw(ArgumentError(msg));    end

    ∑prob = 0.0

    for k in (kₗₒ : kₕᵢ)
        ∑prob += prob_Hyper(N, K, n, k)
    end

	# roundoff errors may occur
    if ∑prob > 1.0;    ∑prob = 1.0;    end

    ∑prob
end

# ╔═╡ eda6ece8-fcac-11ea-1723-6f0552a1f61a
function ∑Hyper_BigFloat(N, K, n, kₗₒ, kₕᵢ)
	
	msg = ""
	if K > N
		msg = "K cannot exceed N.\n\n" *
		      "K is the number of target items in the population\n" *
		      "N is the number of items in the population."
    elseif n > N
		msg = "n cannot exceed N.\n\n" *
		      "n is the number of items in the sample\n" *
		      "N is the number of items in the populuation."		
    elseif kₕᵢ > n
		msg = "kₕᵢ cannot exceed n.\n\n" * 
		      "k is the number of target items in the sample\n" *
		      "n is the number of items in the sample."		
    elseif kₕᵢ > K
		msg = "kₕᵢ cannot exceed K.\n\n" *
		      "k is the number of target items in the sample\n" *
		      "K is the number of target items in the population."
    elseif kₗₒ > kₕᵢ
		msg = "kₗₒ cannot exceed kₕᵢ."
    end

    if length(msg) > 0;    throw(ArgumentError(msg));    end

    ∑prob = 0.0

    for k in (kₗₒ : kₕᵢ)
        ∑prob += prob_Hyper_BigFloat(N, K, n, k)
    end

	# roundoff errors may occur
    if ∑prob > 1.0;    ∑prob = 1.0;    end

    ∑prob
end

# ╔═╡ 519940cc-fca6-11ea-3cca-7399ad534725
function plot_Hyper(N, K, n, kₗₒ, kₕᵢ)
	msg = ""
	if K > N
		msg = "K cannot exceed N.\n\n" *
		      "K is the number of target items in the population\n" *
		      "N is the number of items in the population."
    elseif n > N
		msg = "n cannot exceed N.\n\n" *
		      "n is the number of items in the sample\n" *
		      "N is the number of items in the populuation."		
    elseif kₕᵢ > n
		msg = "kₕᵢ cannot exceed n.\n\n" * 
		      "k is the number of target items in the sample\n" *
		      "n is the number of items in the sample."		
    elseif kₕᵢ > K
		msg = "kₕᵢ cannot exceed K.\n\n" *
		      "k is the number of target items in the sample\n" *
		      "K is the number of target items in the population."
    elseif kₗₒ > kₕᵢ
		msg = "kₗₒ cannot exceed kₕᵢ."
    end
	
	if length(msg) > 0;    throw(ArgumentError(msg));    end
	
	
	kₚₗ = kₗₒ:kₕᵢ	
	pₚₗ = [prob_Hyper(N, K, n, k)    for k in kₚₗ]
	#pl = Plots.bar(kₚₗ, pₚₗ)
	
	Plots.bar(kₚₗ, pₚₗ)
end

# ╔═╡ 4e9ecb92-f76e-11ea-3ba6-d992fb4dc1db
 begin
	N_NF = @bind N html"<input type=number min=1 max=9999 step=1 value=600>"
	K_NF = @bind K html"<input type=number min=1 max=9999 step=1 value=100>"
	
	n_NF = @bind n html"<input type=number min=1 max=9999 step=1 value=60>"
	kₕᵢ_NF = @bind kₕᵢ html"<input type=number min=0 max=9999 step=1 value=15>"
	kₗₒ_NF = @bind kₗₒ html"<input type=number min=0 max=9999 step=1 value=5>"
	
	
	
	md"""	
	N: $(N_NF)	
	K: $(K_NF)
	
	 
	
	n: $(n_NF)			
	kₗₒ: $(kₗₒ_NF)
	kₕᵢ: $(kₕᵢ_NF)"""
end
 

# ╔═╡ c9b226d2-fca8-11ea-3fb9-1fc70f564612
plot_Hyper(N, K, n, kₗₒ, kₕᵢ)

# ╔═╡ e3204b38-7eae-11ea-32be-39db6cc9faba
md""

# ╔═╡ ecdf2db2-f76f-11ea-127f-7bf5a7293f29
∑pr = ∑Hyper(N, K, n, kₗₒ, kₕᵢ)

# ╔═╡ fec4ed40-fcac-11ea-202e-b10a07dcce36
∑pr_BigFloat = ∑Hyper_BigFloat(N, K, n, kₗₒ, kₕᵢ)

# ╔═╡ 0471bdf6-f774-11ea-38c1-9511559d3e45
begin 
	
	error_relative = 1.0 - (∑pr / ∑pr_BigFloat)
	err_rel_sci = sci(error_relative, 7, " ", true)
	
	msg = "The relative error is " * err_rel_sci * "."
	
	msg
end

# ╔═╡ f1f953d4-fcad-11ea-2ac4-135c55acfee1
md"We can see that computing logarithms is considerably faster than using BigFloats.  There is some discrepancy in the computed result, but this is usually within one part in 10¹³ (a baker's trillion)."

# ╔═╡ dddb9f34-7f37-11ea-0abb-272ef1123d6f
md""

# ╔═╡ 23db0e90-7f35-11ea-1c05-115773b44afa
md""

# ╔═╡ Cell order:
# ╟─e9220680-fb03-11ea-2b0b-5100c59644b8
# ╠═816ea402-7eae-11ea-2134-fb595cca3068
# ╠═ce7bec8c-7eae-11ea-0edb-ad27d2df059d
# ╠═e2ec2790-fc9e-11ea-2a88-e1076f6e453c
# ╟─0dde87dc-fb04-11ea-2086-659b3ddc65ea
# ╠═12e7db42-fb05-11ea-3979-95e6175d3939
# ╠═17b51252-fb0a-11ea-16ab-45ed75c76819
# ╟─b8ab92d6-f8ac-11ea-2c6d-e348859be41a
# ╟─c2ed84ca-f8ac-11ea-29d2-b946ee92f2c5
# ╠═3e1ad31a-f76c-11ea-004c-e742c657dae6
# ╠═e65722fa-fc98-11ea-03dc-633ff72a758a
# ╟─c175bc90-fcab-11ea-1664-eb0ea063969c
# ╠═79784f38-fcac-11ea-3bd2-af5a1e28d344
# ╟─9e365f02-f76d-11ea-096d-3bca6f24dcb2
# ╟─eda6ece8-fcac-11ea-1723-6f0552a1f61a
# ╟─519940cc-fca6-11ea-3cca-7399ad534725
# ╟─c9b226d2-fca8-11ea-3fb9-1fc70f564612
# ╠═4e9ecb92-f76e-11ea-3ba6-d992fb4dc1db
# ╟─e3204b38-7eae-11ea-32be-39db6cc9faba
# ╠═ecdf2db2-f76f-11ea-127f-7bf5a7293f29
# ╠═fec4ed40-fcac-11ea-202e-b10a07dcce36
# ╠═0471bdf6-f774-11ea-38c1-9511559d3e45
# ╟─f1f953d4-fcad-11ea-2ac4-135c55acfee1
# ╟─dddb9f34-7f37-11ea-0abb-272ef1123d6f
# ╟─23db0e90-7f35-11ea-1c05-115773b44afa
