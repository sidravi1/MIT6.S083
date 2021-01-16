pwd()
include("Homework3/ex1.jl")
include("Homework2/ex1.jl")

using DataStructures
# 1 
mutable struct Agent
    status::InfectionStatus
    num_infected::Int
end

# 2
Agent() = Agent(S, 0)

# 3 / 4
N = 100

function step!(agents::Vector{Agent}, p_I::Float64)
    i = rand(1:length(agents))
    if agents[i].status == I
        j = rand(setdiff(1:length(agents), i))
        if (agents[j].status == S) & (rand() < p_I)
            agents[j].status = I
            agents[i].num_infected += 1
        end
    end
end

# 5
function num_infected_dist_simulation(T::Int, p_I::Float64)
    agents = [Agent() for _ in 1:N]
    agents[1].status = I

    for t in 1:T
        sweep!(agents, p_I)
    end
    return probability_distribution([a.num_infected for a in agents])

end

# 6
N_sims = 50
T = 1000
p_I = 0.02

dist_infected = Dict() #DefaultDict{Int, Int}(0)
for sim in 1:N
    n_infected, prob_vals = num_infected_dist_simulation(T, p_I)
    dist_infected = merge(+, dist_infected, Dict(zip(n_infected, prob_vals)))
end

map!(x->x/N_sims, values(dist_infected))

bar(dist_infected |> sort, yscale=:log10, label = "# infected" )
plot!(dist_infected |> sort, yscale=:log10, lw =3, label = "linear in log")

# Data is exponentially distributed since it is linear on log scale
