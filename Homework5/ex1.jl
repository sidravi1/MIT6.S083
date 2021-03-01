using Plots
using Interact
using Mux, WebIO

# 1
function euler_SIR(β, γ, S0, I0, R0, h, T)

    Ss = zeros(ceil(T/h) |> Int)
    Rs = zeros(ceil(T/h) |> Int)
    Is = zeros(ceil(T/h) |> Int)

    Ss[1] = S0
    Is[1] = I0
    Rs[1] = R0

    for t in 2:Int(T/h)
        Ss[t] = Ss[t-1] + h * -β * Ss[t-1] * Is[t-1]
        Is[t] = Is[t-1] + h * (β * Ss[t-1] * Is[t-1] - γ*Is[t-1])
        Rs[t] = Rs[t-1] + h * γ * Is[t-1]
    end

    return Ss, Is, Rs
end

# 2
β = 0.1
γ = 0.05
S0 = 0.99  
I0 = 0.01
R0 = 0
T = 300
h = 0.1

Ss, Is, Rs = euler_SIR(β, γ, S0, I0, R0, h, T);

plot(Ss, label = "S")
plot!(Is, label = "I")
plot!(Rs, label = "R")

# 3
## Yes - see growth then decline
## ~25% of population does not get infected

# 4
function app(req)
    @manipulate for β in 0.0:0.05:1.0, γ in 0.01:0.01:0.5
        
        Ss, Is, Rs = euler_SIR(β, γ, S0, I0, R0, h, T);
        
        p2 = plot(Ss, label='S')
        plot!(p2, Rs, label='R')
        plot!(p2, Is, lable='I')
    end
end
webio_serve(page("/", app), 8000)

## pandemic when β/γ is >1
