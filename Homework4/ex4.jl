include("ex3.jl")
using Interact
using Statistics

# 1
function step!(agents, L, pI, pR)
    i = rand(agents)
    # println(i)
    pos = jump(i, L)
    j_idx = findfirst(x -> x.position == pos, agents)
    if j_idx == nothing
        set_pos!(i, pos)
    else
        if i.state == I
            if (rand() < pI) && (agents[j_idx].state == S)
                agents[j_idx].state = I
            end
            if rand() < pR
                i.state = R
            end
        end
    end
end

# 2
L = 5
agents = initialize(L, 20)
visualize_agents(agents, L)
step!(agents, L, 0.9, 0.1)

# 3
L = 10
agents = initialize(L, 60)
visualize_agents(agents, L)
anim = @animate for i in 1:100
    visualize_agents(agents, L, i)
    step!(agents, L, 0.9, 0.1)
end
gif(anim)

# 4 
function sweep!(agents, L, pI, pR)
    for i in 1:length(agents)
        step!(agents, L, pI, pR)
    end
end

# 5  
function dynamics!(agents, L, pI, pR, N_sweeps)
    Ss = zeros(N_sweeps)
    Rs = zeros(N_sweeps)
    Is = zeros(N_sweeps) 
    state = Array{Agent}[]
    for i in 1:N_sweeps
        sweep!(agents, L, pI, pR)
        push!(state, deepcopy(agents))
        Ss[i] = count(x -> x.state == S, agents)
        Rs[i] = count(x -> x.state == R, agents)
        Is[i] = count(x -> x.state == I, agents)
    end

    return state, Ss, Rs, Is
end

# 6

using Mux, WebIO

N_sweeps = 200
pI = 0.5
pR = 0.01
L = 10
agents = initialize(L, 60)
state, Ss, Rs, Is = dynamics!(agents, L, pI, pR, N_sweeps);

function app(req)
    @manipulate for i in 1:N_sweeps
        p1 = visualize_agents(state[i], L, i)

        p2 = plot(Ss[1:i], label='S')
        plot!(p2, Rs[1:i], label='R')
        plot!(p2, Is[1:i], lable='I')

        hbox([p1, p2])
    end
end
webio_serve(page("/", app), 8000)

# 7
L = 20
N = 100
N_sweeps = 400
pI = 0.7
pR = 0.05

agents = initialize(L, N)
state, Ss, Rs, Is = dynamics!(agents, L, pI, pR, N_sweeps);

function app(req)
    @manipulate for i in 1:N_sweeps
        p1 = visualize_agents(state[i], L, i)

        p2 = plot(Ss[1:i], label='S')
        plot!(p2, Rs[1:i], label='R')
        plot!(p2, Is[1:i], lable='I')

        hbox([p1, p2])
    end
end

# 8
n_sims = 50
all_Ss = zeros((n_sims, N_sweeps))
all_Rs = zeros((n_sims, N_sweeps))
all_Is = zeros((n_sims, N_sweeps))

for i in 1:n_sims
    agents = initialize(L, N)
    _, all_Ss[i, :], all_Rs[i, :], all_Is[i, :] = dynamics!(agents, L, pI, pR, N_sweeps);
end

p = plot(all_Ss', color = :seagreen, alpha =0.1, label=:none)
p = plot!(all_Rs', color = :dodgerblue, alpha =0.1, label=:none)
p = plot!(all_Is', color = :firebrick, alpha =0.1, label=:none)

S_mean = mean(all_Ss, dims=1);
R_mean = mean(all_Rs, dims=1);
I_mean = mean(all_Is, dims=1);
S_σ = std(all_Ss, dims=1);
R_σ = std(all_Rs, dims=1);
I_σ = std(all_Is, dims=1);

# 9
plot!(S_mean', color = :seagreen, ribbon=S_σ', fillalpha=.5, lw = 2, label="S")
plot!(R_mean', color = :dodgerblue, ribbon=R_σ', lw = 2, label="R")
plot!(I_mean', color = :firebrick, ribbon=I_σ', lw = 2, label="I")


