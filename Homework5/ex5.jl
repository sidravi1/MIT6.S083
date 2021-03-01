include("Homework4/ex3.jl")
include("Homework4/ex4.jl")
include("Homework5/ex1.jl")
include("Homework5/ex3.jl")

# 1
L = 20
N = 100
N_sweeps = 400
pI = 0.7
pR = 0.05

agents = initialize(L, N)
state, Ss, Rs, Is = dynamics!(agents, L, pI, pR, N_sweeps);


p1 = visualize_agents(state[400], L)

p2 = plot(Ss, label='S')
plot!(p2, Rs, label='R')
plot!(p2, Is, lable='I')
plot(p1, p2)
hbox([p1, p2])

using CSV, Tables
M = hcat(1:N_sweeps, Ss, Is, Rs)
tbl = Tables.table(M, header = ["ts", "Ss", "Is", "Rs"])
CSV.write("Homework5/mydata.csv", tbl)

# 2
## See above

# 3
function loss(β, γ)
    h = 0.1
    skip_v = (1 / h) |> Int
    Ss_fit, Is_fit, Rs_fit = euler_SIR(β, γ, (N - 1), 1, 0, h, N_sweeps)
    Ls = (Ss .- Ss_fit[1:skip_v:end]).^2 / N |> sum 
    Li = (Is .- Is_fit[1:skip_v:end]).^2 / N |> sum
    Lr = (Rs .- Rs_fit[1:skip_v:end]).^2 / N |> sum

    return Ls + 2* Li + Lr
end

β = 0.0009
γ = 0.01
#β = 0.00068
#γ = 0.013
loss(β, γ)

# 4
β, γ = gradient_descent_2d(loss, β, γ, 1000, 1e-12)
loss(β, γ)
gradient(loss, β, γ)

Ss_fit, Is_fit, Rs_fit = euler_SIR(β, γ, (N - 1), 1, 0, h, N_sweeps)
#Ss, Is, Rs = euler_SIR(β, γ, S0, I0, R0, h, T);
p2 = plot(Ss_fit[1:skip_v:end], label='S')
plot!(p2, Rs_fit[1:skip_v:end], label='R')
plot!(p2, Is_fit[1:skip_v:end], lable='I')
plot!(Ss, label='s')
plot!(p2, Rs, label='r')
plot!(p2, Is, lable='i')


