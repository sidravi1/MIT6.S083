using Plots
using Statistics

# 1
@enum InfectionStatus S I R
x = S
typeof(x)

# Enum InfectionStatus:
# S = 0
# I = 1
# R = 2

# 2
Int(S) # 0
Int(I) # 1
Int(R) # 2

# 3
N = 100
agents = [S for _ in 1:N];

# 4
idx = rand(1:N)
agents[idx] = I

# 5
function step!(agents, p_I)
    i = rand(1:length(agents))
    if agents[i] == I
        # print(i)
        j = rand(setdiff(1:length(agents), i))
        if (agents[j] == S) & (rand() < p_I)
            # println(" infected ", j)
            agents[j] = I
        end
    else
        # println(i , "th agent: ", agents[i])
    end
end

# 6
function sweep!(agents, p_I)
    for i in 1:length(agents)
        step!(agents, p_I)
    end
end

# 7
function infection_simulation(N::Int64, p_I::Float64, T::Int64)
    # 7.1
    agents = [S for _ in 1:N];
    idx = rand(1:N)
    agents[idx] = I

    Is = zeros(T)
    Is[1] = (agents .== I) |> sum

    # 7.2
    for t in 1:T
        sweep!(agents, p_I)
        Is[t] = (agents .== I) |> sum
    end

    # 7.3
    return Is
end

# 8
N_sims = 50
N = 100
T = 1000
p = 0.02

infected_sims = zeros(N_sims, T);
for sim in 1:N_sims
    infected_sims[sim, :] = infection_simulation(N, p, T);
end

plot(1:T, infected_sims', color=:gray, alpha=0.5, legend=:none)
xlabel!("T")
ylabel!("Number Infected")

# 9 / 10
μ = mean(infected_sims; dims = 1);
σ = std(infected_sims; dims = 1);
plot!(μ[1, :], yerr = σ[1, :],color = :dodgerblue, 
        seriesalpha = 0.3,
        lw = 4, legend = :none)

# 11
# The mean number of infections - average case




