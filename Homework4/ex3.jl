#include("Homework4/ex2.jl")
include("ex2.jl")

using Plots

function get_agent(loc_grid)

    L = size(loc_grid, 1)
    proposed_loc = [rand(1:L), rand(1:L)]
    while loc_grid[proposed_loc...] != 0
        proposed_loc = [rand(1:L), rand(1:L)]
    end
    agentloc = ceil.(proposed_loc .- (L ./ 2)) .|> Int
    return Agent(agentloc..., S), proposed_loc
end

function initialize(L, N)
    loc_grid = zeros(L, L)
    agents = []

    for i in 1:N
        agent, proposed_loc = get_agent(loc_grid)
        push!(agents, agent)
        loc_grid[proposed_loc...] = 1
    end
    agents[1].state = I

    return agents
end

# 2 
agents = initialize(10, 20)

# 3
function visualize_agents(agents, L, i = Nothing)
    statuses = [Int(x.state) for x in agents]
    locations = [make_tuple(pos(x)) for x in agents]
    p = scatter(locations, c=statuses, ratio = 1, 
            color_palette = [:red, :gray, :green],
            label=:none, xaxis=false, yaxis=false)
    xlims!(-L/2*1.1, L/2*1.1)
    ylims!(-L/2*1.1, L/2*1.1)

    box_coords = [(-L/2, -L/2), (-L/2, L/2), 
                  (L/2, L/2), (L/2, -L/2), (-L/2, -L/2)]
    plot!(box_coords, label =:none, lw=4)

    if i != Nothing
        annotate!(L/2*0.9, L/2*0.9, text(i, :red, :right, 6))
    end
    return p
end

# 4
visualize_agents(agents, 5, 2)