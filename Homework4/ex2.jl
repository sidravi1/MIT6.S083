#include("Homework4/ex1.jl")
include("ex1.jl")

# 1
@enum InfectionStatus S I R

mutable struct Agent <: Abstract2DWalker
    position::Location
    state::InfectionStatus
end

function Agent(x::Int, y::Int, s::InfectionStatus)
    Agent(Location(x, y), s)
end

# 2
function jump(a::Agent, L::Int)
    proposal = jump(a)

    if abs(proposal.x) > L/2 || abs(proposal.y) > L/2
        pos(a)
    else
        proposal
    end
end

function jump!(a::Agent, L::Int)
    set_pos!(a, jump(a, L))
end

# 3
function trajectory(w::Agent, N::Int, L::Int)
    [make_tuple(jump!(w, L)) for _ in 1:N]
end

a = Agent(0, 0, S)
traj = trajectory(a, 1000, 20)

box_coords = [(-10, -10), (-10, 10), 
                (10, 10), (10, -10), (-10, -10)]
plot(box_coords, label =:none, lw=4)
plot!(traj)