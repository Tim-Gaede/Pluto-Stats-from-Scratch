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

# ╔═╡ e9220680-fb03-11ea-2b0b-5100c59644b8
md"# Coding Stats from Scratch

## Combinations

Timothy Gaede

2020-09-22"

# ╔═╡ 0dde87dc-fb04-11ea-2086-659b3ddc65ea
md"Recall the concept of combinations.  It tells how how many ways we can choose k items from a population of n items:"

# ╔═╡ 12e7db42-fb05-11ea-3979-95e6175d3939
md"ⁿCₖ = $${{n}\choose{k}} = {{n(n-1)(n-2)⋅⋅⋅(n-k+1)}\over{k(k-1)⋅⋅⋅1}}$$"

# ╔═╡ 17b51252-fb0a-11ea-16ab-45ed75c76819
md"For example, if we have 52 distinct cards how many ways can we choose five? The answer is \"fifty-two choose five\", which is 2,598,960."

# ╔═╡ d100e2d8-fb08-11ea-031f-b76b9d550720
md"⁵²C₅ = $${{52}\choose{5}} = {{52×51×50×49×48}\over{5×4×3×2×1}} = {{311,875,200}\over{120}} = 2,598,960$$"

# ╔═╡ 3337d8bc-fbd6-11ea-16e3-0fda349299cb
md"One notable aspect of combinations, is that is equavalent to choosing what items to exclude and getting the remaining items.  For example, from five cats in an animal shelter, there are ten ways to choose pairs of cats to bring home.  Likewise there are ten ways to choose trios of cats to remain."

# ╔═╡ d7f7f45e-fbd6-11ea-0b1d-738b6253f805
md"⁵C₂ = $${{5}\choose{2}} = {{5×4}\over{2×1}} = 10$$"

# ╔═╡ 67594792-fbd7-11ea-0aab-7b36659358e4
md"⁵C₃ = $${{5}\choose{3}} = {{5×4×3}\over{3×2×1}} = 10$$"

# ╔═╡ 90f1ee36-fbd7-11ea-1aa6-7f9480456579
md"So if 2k > n, then ⁿCₖ = ⁿCₙ₋ₖ.  We will use this fact to eliminate redundant computation."

# ╔═╡ c963b5bc-fb0a-11ea-1a8c-75de7ff49363
function ⁿCₖ_simple(n, k)	 
	
	#  if            then             else
	2k > n    ?    k′ = n-k	   :    k′ = k 	 
	
	 
	numerator = 1 # <---- Try changing to: numerator = Int128(1)
	for numᵢ in (n : -1 : n-k′+1)
		numerator *= numᵢ
	end
	
	 
	denominator = 1 # <---- Try changingto denominator = Int128(1)
	for denᵢ in (k′ : -1 : 2)
		denominator *= denᵢ
	end
	
	(numerator, denominator), numerator ÷ denominator
end

# ╔═╡ 643d286c-fcc2-11ea-3873-975f1a37dc81
 begin
	n₁_NF = @bind n₁ html"<input type=number min=1 max=99999 step=1 value=52>"
	k₁_NF = @bind k₁ html"<input type=number min=1 max=99999 step=1 value=5>"
	
	 
	
	md"""	 
	
	n: $(n₁_NF)		
	
	k: $(k₁_NF)"""
end

# ╔═╡ fa360648-fcc6-11ea-16a3-5b1a31128022
md"I used underscores as the thousands separator insead of commas.  You may use underscores while programming in Julia.  However, by default, Julia will print out without any thousands separator."

# ╔═╡ 30f3b338-fcc7-11ea-3906-6bb4a571f6d9
311_875_200 ÷ 120

# ╔═╡ 5ea40118-fcc8-11ea-1f37-076bd7cd31b2
md"Using commas as a thousands separator for input will not work."

# ╔═╡ 7f3b1c22-fcc8-11ea-39cf-31dbef8198ad
311,875,200 ÷ 120

# ╔═╡ dc93ca64-fcc2-11ea-27c6-677f858aec06
md"The default data type for integers is Int64, whose values ranges from -2⁶³ to 2⁶³ - 1 (-9,223,372,036,854,775,808 to 9,223,372,036,854,775,807)."

# ╔═╡ 7fb2c98a-fcc7-11ea-2eb8-3b3dea59ec9d
x = 9_223_372_036_854_775_806

# ╔═╡ 00c44d3c-fcc8-11ea-2c93-673b134dd73d
x + 1

# ╔═╡ 10fb6a46-fcc8-11ea-3cff-9dddfe2c8e25
x + 2

# ╔═╡ 2283bae4-fc09-11ea-39a9-312efb484a14
function ⁿCₖ_BigInt(n, k)	 
	
	#  if            then             else
	2k > n    ?    k′ = n-k	   :    k′ = k 	 
	
	 
	numerator = BigInt(1)
	for numᵢ in (n : -1 : n-k′+1)
		numerator *= numᵢ
	end
	
	 
	denominator = BigInt(1)
	for denᵢ in (k′ : -1 : 2)
		denominator *= denᵢ
	end
	
	(numerator, denominator), numerator ÷ denominator
	
	#numerator ÷ denominator
end

# ╔═╡ 01faf890-fcc3-11ea-004f-8f484120419e
 begin
	n₂_NF = @bind n₂ html"<input type=number min=1 max=72 step=1 value=52>"
	k₂_NF = @bind k₂ html"<input type=number min=1 max=72 step=1 value=5>"
	
	 
	
	md"""	 
	
	n: $(n₂_NF)		
	
	k: $(k₂_NF)"""
end

# ╔═╡ f11b578a-fbce-11ea-2056-23ce76b82a0b
function ⁿCₖ_rational(n, k)	 
	
	#  if            then             else
	2k > n    ?    k′ = n-k	   :    k′ = k 	 
	
	 
	ans = 1//1  
	for diff in (0 : k′-1)
		ans *= n  - diff
		ans /= k′ - diff
	end
	 
	 
	ans
end

# ╔═╡ bf50d3be-fbcf-11ea-2d37-351d84c13ad0
ⁿCₖ_rational(n₁, k₁)

# ╔═╡ 4d6ec15e-fc09-11ea-1dea-8d418ced8231
ⁿCₖ_BigInt(n₁, k₁)

# ╔═╡ 8866f9de-fbd2-11ea-25f8-f7e500864c99
function ⁿCₖ_float(n, k)	
	
	#  if            then             else
	2k > n    ?    k′ = n-k	   :    k′ = k 	 
	
	 
	ans = 1.0  
	for diff in (0 : k′-1)
		ans *= n  - diff
		ans /= k′ - diff
	end
	 
	 
	ans
end

# ╔═╡ 973f3a48-fbd2-11ea-065d-f9ad9f09e031
ⁿCₖ_float(n₁, k₁)

# ╔═╡ 0a6d7726-fbda-11ea-3f01-f7be6b451ebf
try ⁿCₖ_rational(n₂, k₂) catch; "💣 Overflow! 💣" end
 

# ╔═╡ 46ef8e14-fbda-11ea-3b18-0f3ea8fc0f64
ⁿCₖ_float(n₂, k₂)

# ╔═╡ 67ba83ec-fbda-11ea-243f-d7a56286685a
 begin
	n₃_NF = @bind n₃ html"<input type=number min=1 max=1100 step=1 value=52>"
	k₃_NF = @bind k₃ html"<input type=number min=0 max=1100 step=1 value=5>"
	
	md""" 
	
	n: $(n₃_NF)
	
	k: $(k₃_NF)"""
end
 
	 

# ╔═╡ 8802c69a-fca3-11ea-257e-691b517e43da
ⁿCₖ_BigInt(n₃, k₃)

# ╔═╡ 81177b06-fbda-11ea-076b-b1981bad2281
log10(ⁿCₖ_float(n₃, k₃))

# ╔═╡ ce37e1e6-fbda-11ea-1431-7770d547c565
function log₁₀ⁿCₖ(n, k)

    #  if            then             else
	2k > n    ?    k′ = n-k	   :    k′ = k 	
	
	
    ans = 0.0
    for diff in (0 : k′-1)
		ans += log10(n - diff)
        ans -= log10(k′- diff)
    end
	 

    ans
end


# ╔═╡ 1806f3c2-fc90-11ea-13ce-91fe0b60ad0f
log10(ⁿCₖ_BigInt(n₃, k₃)[2])

# ╔═╡ 23e7f694-fc08-11ea-2c77-83bc417eb180
log10(ⁿCₖ_rational(n₃, k₃))

# ╔═╡ 1f83b768-fc90-11ea-2e6a-253c34d1ba04
log₁₀ⁿCₖ(n₃, k₃)

# ╔═╡ 42116bf2-fcc9-11ea-253c-23cc18e8ee99
md"To help understand logarithms imagine how to get the value of 1 × 10 × 100 × 1000 × 10,000 × 100,000.  In this example you could have just added up the fifteen zeros to get 10¹⁵."

# ╔═╡ 0710215a-fcca-11ea-1689-2fc4085f3a51
md"What you did was get 10⁽ ˡᵒᵍ⁽¹⁾ ⁺ ˡᵒᵍ⁽¹⁰⁾ ⁺ ˡᵒᵍ⁽¹⁰⁰⁾⁺ ˡᵒᵍ⁽¹⁰⁰⁰⁾ ⁺ ˡᵒᵍ⁽¹⁰⁰⁰⁰⁾ ⁺ ˡᵒᵍ⁽¹⁰⁰⁰⁰⁰⁾ ⁾"

# ╔═╡ f06e4e62-fcca-11ea-107c-256d38c8b912
md"Which is 10⁽ ⁰ ⁺ ¹ ⁺ ² ⁺ ³ ⁺ ⁴ ⁺ ⁵ ⁾"

# ╔═╡ 254a9e38-fccb-11ea-12df-99cc0ac69317
md"Which is 10¹⁵"

# ╔═╡ f70aef34-fc05-11ea-0f08-d36ab6ecbaa2
# Implementation of the Sieve of Eratosthenes (era-TOSS-the-knees)
function primesTo(n::Int)
    if n < 2;    return []; end
    primes = Int64[2]
    sizehint!(primes, convert( Int64, floor( n / log(n) ) ))
    oddsAlive = trues((n-1) ÷ 2) # oddsAlive[i] represents 2i + 1

    i_sqrt = (convert( Int64, floor(√n) ) - 1) ÷ 2
    for i in (1 : i_sqrt)
        if oddsAlive[i] # It's prime.  Kill odd multiples of it
            push!(primes, 2i + 1)
            Δi = 2i + 1
            for iₓ = i+Δi : Δi : length(oddsAlive);   oddsAlive[iₓ] = false; end
        end
    end
    for i in (i_sqrt + 1 : length(oddsAlive)) # Surviving odds also prime
        if oddsAlive[i];    push!(primes, 2i + 1); end
    end

    primes
end

# ╔═╡ d40fcbdc-fc8f-11ea-2a0a-a957fe3328a8
primes = primesTo(1100)

# ╔═╡ 9850e098-fc05-11ea-086b-27e6f95dc946
function ⁿCₖ_primes(n, k, primes)

    if (k == 0) return Int128(1) end

    #  if            then             else
	2k > n    ?    k′ = n-k	   :    k′ = k 	 
 


    # assert n <= last(primes)
    # inner function
    function factorPowersByPrimeIndex(n::Int, primes::Array{Int64,1})

        powers = []

        rem = n # remaining
        i = 1

        while rem !== 1    &&    primes[i] ≤ n
            if rem % primes[i] == 0

                power = 0
                while rem % primes[i] == 0
                    rem = rem ÷ primes[i]
                    power += 1
                end

                push!(powers, power)

            else
                push!(powers, 0)
            end
            i += 1
        end



        if rem > 1;    push!(powers, 1);    end

        powers
    end


    powersTotal = factorPowersByPrimeIndex(n, primes)

    for i = 1 : k′-1
        powers = factorPowersByPrimeIndex(n - i, primes)


        if  length(powersTotal) ≥ length(powers)
            for i = 1 : length(powers)
                powersTotal[i] += powers[i]
            end
        else
            for i = 1 : length(powersTotal)
                powersTotal[i] += powers[i]
            end
            for i = length(powersTotal) + 1 : length(powers)
                push!(powersTotal, powers[i])
            end
        end
    end

    for i = 0 : k′-1
        powers = factorPowersByPrimeIndex(k′ - i, primes)
        if  length(powersTotal) >= length(powers)
            for i = 1 : length(powers)
                powersTotal[i] -= powers[i]
            end
        else
            for i = 1 : length(powersTotal)
                powersTotal[i] -= powers[i]
            end
            for i = length(powersTotal) + 1 : length(powers)
                push!(powersTotal, -powers[i])
            end
        end
    end



    result = Int128(1)
    for i = 1 : length(powersTotal)
        result *= primes[i]^powersTotal[i]
    end

    
	result
end


# ╔═╡ 275a2f56-fc06-11ea-1f00-dfd9a6bd7bb1
log10(ⁿCₖ_primes(n₃, k₃, primes))

# ╔═╡ 9f4ceb88-fcd2-11ea-2436-ed0c9ed72954
html" <br><br><br><br><br> "

# ╔═╡ bd95d462-fcd2-11ea-0f1c-a311fe0d7395
md"###### Miscellaneous useful functions"

# ╔═╡ 9a3df1be-fcd2-11ea-17db-3dd7fe2188fd
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

# ╔═╡ 139c4e68-fcd8-11ea-1779-13d6c28d1579
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

# ╔═╡ d9b25ec2-fcd2-11ea-27f8-09814c999b0d
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

# ╔═╡ eb561904-fcd2-11ea-2871-69babea7f5ba
function sub(n::Int)
    if n == 0;    return "⁰";    end

    res = ""
    n < 0    ?    rem = -n    :    rem = n

    subs = split("₁₂₃₄₅₆₇₈₉₀", "")

    while rem > 0
        d = rem % 10 # digit
        rem ÷= 10

        d == 0    ?    res *= string(subs[10])    :    res *= string(subs[d])
    end
    if n < 0;    res *= "⁻";   end

    reverse(res) # returned
end

# ╔═╡ 1019eca0-fcd3-11ea-2acd-09b3decb150c
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

# ╔═╡ 29f7f3d8-fcd3-11ea-2d8c-2b2dfb307478
function mpad(text::String, width::Int)
    if length(text) > width
        msg = "\n\n\n" *
              "             ┌──────────────┐\n" *
              "             │ ᴴᵉʳᵉ ᵇᵉ ʷʰᵉʳᵉ│\n" *
              "             │ʸᵒᵘ ˢᶜʳᵉʷᵉᵈ ᵘᵖ│\n" *
              "             └──────────────┘\n" *
              "            /                \n" *
              "         😃                  \n" *
              "              length(text) ᵇᵉ ᵐᵒʳᵉ width\n" *
              "                          ↓\n" *
              "        function cpad(text::String, width::Int)\n\n\n"

        throw(DomainError(msg))
    end

    pad_totl = width - length(text)
    pad_left = pad_totl ÷ 2
    pad_rght = pad_totl - pad_left


    " "^pad_left * text * " "^pad_rght
end

# ╔═╡ 3e0b07b6-fcd3-11ea-0384-c5b39e5faef1
larger(a,b) = a>b    ?    a    :    b

# ╔═╡ d250dd4a-fb0e-11ea-37ca-b166a3207825
begin
	(num_s, den_s), ans_s =  ⁿCₖ_simple(n₁, k₁)
	
	num_fmd = und(num_s)
	den_fmd = und(den_s)
	
	wid = larger(length(num_fmd), length(den_fmd))	
	
	div_fmd = "─"^wid
	den_fmd = mpad(den_fmd, wid)
	
	@bind output TextField((60, 7), 				          sup(n₁)*"C"*sub(k₁)*"\n\n"*num_fmd*"\n"*div_fmd*"\n"*den_fmd*"\n\n"*und(ans_s))
end

# ╔═╡ 38008176-fcc3-11ea-2751-4773d7304044
begin
	(num_b, den_b), ans_b =  ⁿCₖ_BigInt(n₂, k₂)
	
	num_b_fmd = unders(num_b)
	den_b_fmd = unders(den_b)
	
	wid_b = larger(length(num_b_fmd), length(den_b_fmd))	
	
	div_b_fmd = "─"^wid_b
	den_b_fmd = mpad(den_b_fmd, wid_b)
	
	@bind output_b TextField((83, 7), 				          sup(n₂)*"C"*sub(k₂)*"\n\n"*num_b_fmd*"\n"*div_b_fmd*"\n"*den_b_fmd*"\n\n"*unders(ans_b))
end

# ╔═╡ 83aa44ca-fc9d-11ea-2d64-c9e7c1194ae5
md"# Old Code:"

# ╔═╡ dddb9f34-7f37-11ea-0abb-272ef1123d6f
md""

# ╔═╡ 23db0e90-7f35-11ea-1c05-115773b44afa
md""

# ╔═╡ Cell order:
# ╟─e9220680-fb03-11ea-2b0b-5100c59644b8
# ╟─816ea402-7eae-11ea-2134-fb595cca3068
# ╟─0dde87dc-fb04-11ea-2086-659b3ddc65ea
# ╠═12e7db42-fb05-11ea-3979-95e6175d3939
# ╟─17b51252-fb0a-11ea-16ab-45ed75c76819
# ╟─d100e2d8-fb08-11ea-031f-b76b9d550720
# ╟─3337d8bc-fbd6-11ea-16e3-0fda349299cb
# ╟─d7f7f45e-fbd6-11ea-0b1d-738b6253f805
# ╟─67594792-fbd7-11ea-0aab-7b36659358e4
# ╟─90f1ee36-fbd7-11ea-1aa6-7f9480456579
# ╟─c963b5bc-fb0a-11ea-1a8c-75de7ff49363
# ╟─643d286c-fcc2-11ea-3873-975f1a37dc81
# ╟─d250dd4a-fb0e-11ea-37ca-b166a3207825
# ╠═fa360648-fcc6-11ea-16a3-5b1a31128022
# ╠═30f3b338-fcc7-11ea-3906-6bb4a571f6d9
# ╠═5ea40118-fcc8-11ea-1f37-076bd7cd31b2
# ╠═7f3b1c22-fcc8-11ea-39cf-31dbef8198ad
# ╠═dc93ca64-fcc2-11ea-27c6-677f858aec06
# ╠═7fb2c98a-fcc7-11ea-2eb8-3b3dea59ec9d
# ╠═00c44d3c-fcc8-11ea-2c93-673b134dd73d
# ╠═10fb6a46-fcc8-11ea-3cff-9dddfe2c8e25
# ╟─2283bae4-fc09-11ea-39a9-312efb484a14
# ╟─01faf890-fcc3-11ea-004f-8f484120419e
# ╠═38008176-fcc3-11ea-2751-4773d7304044
# ╟─f11b578a-fbce-11ea-2056-23ce76b82a0b
# ╟─bf50d3be-fbcf-11ea-2d37-351d84c13ad0
# ╟─4d6ec15e-fc09-11ea-1dea-8d418ced8231
# ╟─8866f9de-fbd2-11ea-25f8-f7e500864c99
# ╠═973f3a48-fbd2-11ea-065d-f9ad9f09e031
# ╟─0a6d7726-fbda-11ea-3f01-f7be6b451ebf
# ╠═46ef8e14-fbda-11ea-3b18-0f3ea8fc0f64
# ╟─d40fcbdc-fc8f-11ea-2a0a-a957fe3328a8
# ╟─67ba83ec-fbda-11ea-243f-d7a56286685a
# ╟─8802c69a-fca3-11ea-257e-691b517e43da
# ╠═81177b06-fbda-11ea-076b-b1981bad2281
# ╟─ce37e1e6-fbda-11ea-1431-7770d547c565
# ╠═275a2f56-fc06-11ea-1f00-dfd9a6bd7bb1
# ╠═1806f3c2-fc90-11ea-13ce-91fe0b60ad0f
# ╠═23e7f694-fc08-11ea-2c77-83bc417eb180
# ╠═1f83b768-fc90-11ea-2e6a-253c34d1ba04
# ╟─42116bf2-fcc9-11ea-253c-23cc18e8ee99
# ╟─0710215a-fcca-11ea-1689-2fc4085f3a51
# ╟─f06e4e62-fcca-11ea-107c-256d38c8b912
# ╟─254a9e38-fccb-11ea-12df-99cc0ac69317
# ╟─f70aef34-fc05-11ea-0f08-d36ab6ecbaa2
# ╟─9850e098-fc05-11ea-086b-27e6f95dc946
# ╟─9f4ceb88-fcd2-11ea-2436-ed0c9ed72954
# ╟─bd95d462-fcd2-11ea-0f1c-a311fe0d7395
# ╟─9a3df1be-fcd2-11ea-17db-3dd7fe2188fd
# ╟─139c4e68-fcd8-11ea-1779-13d6c28d1579
# ╟─d9b25ec2-fcd2-11ea-27f8-09814c999b0d
# ╟─eb561904-fcd2-11ea-2871-69babea7f5ba
# ╟─1019eca0-fcd3-11ea-2acd-09b3decb150c
# ╟─29f7f3d8-fcd3-11ea-2d8c-2b2dfb307478
# ╟─3e0b07b6-fcd3-11ea-0384-c5b39e5faef1
# ╟─83aa44ca-fc9d-11ea-2d64-c9e7c1194ae5
# ╟─dddb9f34-7f37-11ea-0abb-272ef1123d6f
# ╟─23db0e90-7f35-11ea-1c05-115773b44afa
