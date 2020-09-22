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
	Pkg.add("Plots")
	Pkg.add("Formatting")
	using PlutoUI
	using Plots
	using Formatting
end

# ╔═╡ 8acda0be-fcb9-11ea-2028-751b8c1b78a7
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

# ╔═╡ b666dd84-f774-11ea-3d8d-e17255107d25
prob_binomial(p, n, k) = exp(lnⁿCₖ(n, k) + k*log(p) + (n-k)*log(1-p))

# ╔═╡ caa04bfa-f774-11ea-3ff2-8754047bc181
function ∑prob_binomial(p, n, kₗₒ, kₕᵢ)
    ∑prob = 0.0

    for k in (kₗₒ : kₕᵢ);    ∑prob += prob_binomial(p, n, k); end

    #if ∑prob > 1.0;    ∑prob = 1.0; end

    ∑prob
end


# ╔═╡ 55783466-7eb1-11ea-32d8-a97311229e93
prob_Hyper(N, K, n, k) = exp(lnⁿCₖ(K, k) + lnⁿCₖ(N-K, n-k) - lnⁿCₖ(N, n))

# ╔═╡ 39fa50fa-fcba-11ea-35f2-edeb5099577e
function ∑prob_hyper(N, K, n, kₗₒ, kₕᵢ)
	
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
    #if ∑prob > 1.0;    ∑prob = 1.0;    end

    ∑prob
end

# ╔═╡ dddb9f34-7f37-11ea-0abb-272ef1123d6f
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

# ╔═╡ 1da7d5ac-fcbb-11ea-163e-f3b3293e2c62
function plots_hyper_and_binomial_approx(N, K, n, kₗₒ, kₕᵢ)
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
	p_hₚₗ = [prob_Hyper(N, K, n, k)    for k in kₚₗ]
	
	p = K / N
	p_bₚₗ = [prob_binomial(p, n, k)    for k in kₚₗ]
	#pl = Plots.bar(kₚₗ, pₚₗ)
	
	pl_h = Plots.bar(kₚₗ, p_hₚₗ, 
		             title="Hypergeometric", label="probability of k",
	                 color="green")
	
	pl_b = Plots.bar(kₚₗ, p_bₚₗ, 
		             title="Binomial Approximation", label="probability of k",                              color="orange")	
	 
	
	pl_h, pl_b
end

# ╔═╡ 23db0e90-7f35-11ea-1c05-115773b44afa
 begin
	N_NF = @bind N html"<input type=number min=1 max=99999 step=1 value=600>"
	K_NF = @bind K html"<input type=number min=1 max=99999 step=1 value=100>"
	
	n_NF = @bind n html"<input type=number min=1 max=99999 step=1 value=18>"
	kₕᵢ_NF = @bind kₕᵢ html"<input type=number min=0 max=99999 step=1 value=6>"
	kₗₒ_NF = @bind kₗₒ html"<input type=number min=0 max=99999 step=1 value=0>"
	
	
	
	md"""	
	N: $(N_NF)	
	K: $(K_NF)
	
	 
	
	n: $(n_NF)			
	kₗₒ: $(kₗₒ_NF)
	kₕᵢ: $(kₕᵢ_NF)"""
end

# ╔═╡ 4dff1dc4-fcba-11ea-0d79-f573a402b7bb
function plot_binomial(p, n, kₗₒ, kₕᵢ)
	msg = ""
	if p < 0.0  ||  p > 1.0
		msg = "p is probability of a hit per chance must be between 0.0 and 1.0."
	elseif kₕᵢ > n
		msg = "kₕᵢ cannot exceed n.\n\n" * 
		      "k is the number of hits\n" *
		      "n is the number of chances."		
     elseif kₗₒ > kₕᵢ
		msg = "kₗₒ cannot exceed kₕᵢ."
    end
	
	if length(msg) > 0;    throw(ArgumentError(msg));    end
	
	
	kₚₗ = kₗₒ:kₕᵢ	
	pₚₗ = [prob_binomial(N, K, n, k)    for k in kₚₗ]
	#pl = Plots.bar(kₚₗ, pₚₗ)
	
	Plots.bar(kₚₗ, pₚₗ)
end

# ╔═╡ da5bb1ec-fcba-11ea-1c7f-f1dc2a230848
pl_hy, pl_bi = plots_hyper_and_binomial_approx(N, K, n, kₗₒ, kₕᵢ)

# ╔═╡ f361c234-fcbb-11ea-02fd-e150bdde8a90
pl_hy

# ╔═╡ f85d6f0e-fcbb-11ea-2340-01b877887a8c
pl_bi

# ╔═╡ 689c67b4-fccd-11ea-2a61-9dce83b9e6c7
html" <br><br><br><br><br> "

# ╔═╡ 39233710-fccd-11ea-1496-5dbd8941755b
md"###### Miscellaneous useful functions"

# ╔═╡ 0bb07ef0-fccd-11ea-3c7f-e97d9afb479a
function sup(n::Int)
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

# ╔═╡ 1977fb94-fccd-11ea-01ba-5f143a94be36
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
	
    mant * " × 10" * sup(pwr)
end

# ╔═╡ dde910b2-fcbe-11ea-1d1c-2d44ade0771c
begin 
	∑pr = ∑prob_hyper(N, K, n, kₗₒ, kₕᵢ)
	
	true_pct_text = lpad(format(100.0*∑pr, precision=5), 9) * "%"
	
	p = K/N
	∑pr_bi_approx = ∑prob_binomial(p, n, kₗₒ, kₕᵢ)
	
	appr_pct_text =lpad(format(100.0*∑pr_bi_approx, precision=5), 9) * "%"
	
	error_relative = 1.0 - (∑pr_bi_approx / ∑pr)
	err_rel_sci = sci(error_relative, 7, " ", true)
	
	
	
	msg = "True value    : " * true_pct_text * "\n" *
	      "Approximation : " * appr_pct_text * "\n\n\n" *
	      "The relative (not absolute) error of the binomial approximation is\n\n" *                 err_rel_sci * "."
	
	@bind output_comparison TextField((83,7), msg)
end

# ╔═╡ 0e1f8fc0-fcd5-11ea-1c62-5bf0886bfc02
function und(n)
	
	if typeof(n) <: Number

		n_commas = format(n, commas=true)

		decimal_index = nothing
		n_fmd = ""
		for i in (1 :  length(n_commas))
			n_commas[i] == ','    ?    n_fmd *= '_'    :    n_fmd *= n_commas[i]

			if n_commas[i] == '.';    decimal_index = i;    end


			if decimal_index !== nothing  &&  i < length(n_commas)     
				Δi = i - decimal_index
				if Δi > 0  &&   Δi % 3 == 0
					n_fmd *= '_'
				end
			end
		end
		
		
	elseif typeof(n) <: String
		throw(DomainError("Strings not yet supported"))
	else
		throw(DomainError("Invalid type"))
	end

    n_fmd
end

# ╔═╡ 4ce22c12-fcd6-11ea-0d85-d5d72010b3de
und(2342442)

# ╔═╡ 93f54d5e-fcd7-11ea-14af-35ccadf1b272
function und_prec(n, prec)
	
	if typeof(n) <: Number

		n_commas = format(n, commas=true, precision=prec)

		decimal_index = nothing
		n_fmd = ""
		for i in (1 :  length(n_commas))
			n_commas[i] == ','    ?    n_fmd *= '_'    :    n_fmd *= n_commas[i]

			if n_commas[i] == '.';    decimal_index = i;    end


			if decimal_index !== nothing  &&  i < length(n_commas)     
				Δi = i - decimal_index
				if Δi > 0  &&   Δi % 3 == 0
					n_fmd *= '_'
				end
			end
		end
		
		
	elseif typeof(n) <: String
		throw(DomainError("Strings not yet supported"))
	else
		throw(DomainError("Invalid type"))
	end

    n_fmd
end

# ╔═╡ be8bcebc-fcd7-11ea-0463-73d6027928c3
und_prec(2342442.233212413, 6)

# ╔═╡ Cell order:
# ╠═816ea402-7eae-11ea-2134-fb595cca3068
# ╟─8acda0be-fcb9-11ea-2028-751b8c1b78a7
# ╠═b666dd84-f774-11ea-3d8d-e17255107d25
# ╟─caa04bfa-f774-11ea-3ff2-8754047bc181
# ╟─55783466-7eb1-11ea-32d8-a97311229e93
# ╟─39fa50fa-fcba-11ea-35f2-edeb5099577e
# ╟─dddb9f34-7f37-11ea-0abb-272ef1123d6f
# ╟─4dff1dc4-fcba-11ea-0d79-f573a402b7bb
# ╠═1da7d5ac-fcbb-11ea-163e-f3b3293e2c62
# ╟─da5bb1ec-fcba-11ea-1c7f-f1dc2a230848
# ╟─f361c234-fcbb-11ea-02fd-e150bdde8a90
# ╟─f85d6f0e-fcbb-11ea-2340-01b877887a8c
# ╟─23db0e90-7f35-11ea-1c05-115773b44afa
# ╟─dde910b2-fcbe-11ea-1d1c-2d44ade0771c
# ╟─689c67b4-fccd-11ea-2a61-9dce83b9e6c7
# ╟─39233710-fccd-11ea-1496-5dbd8941755b
# ╟─0bb07ef0-fccd-11ea-3c7f-e97d9afb479a
# ╟─1977fb94-fccd-11ea-01ba-5f143a94be36
# ╠═0e1f8fc0-fcd5-11ea-1c62-5bf0886bfc02
# ╟─4ce22c12-fcd6-11ea-0d85-d5d72010b3de
# ╠═93f54d5e-fcd7-11ea-14af-35ccadf1b272
# ╟─be8bcebc-fcd7-11ea-0463-73d6027928c3
