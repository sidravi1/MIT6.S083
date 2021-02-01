using Plots

# 1-4
abstract type AbstractWalker end
abstract type Abstract2DWalker <: AbstractWalker end
struct Location
    x::Int64
    y::Int64
end

mutable struct Walker2D <: Abstract2DWalker
    position::Location
end

# 5
methods(Walker2D)
## 2 methods for type constructor:
#[1] Walker2D(position::Location) in Main at REPL[4]:2
#[2] Walker2D(position) in Main at REPL[4]:2

# 6
function Walker2D(x::Int64, y::Int64)
    loc = Location(x, y)
    return Walker2D(loc)
end

# 7
function make_tuple(loc::Location)
    tuple(loc.x, loc.y)
end

# 8
function pos(w::Abstract2DWalker) 
    w.position
end

# 9
function set_pos!(w::Abstract2DWalker, l::Location)
    w.position = l
end

# 10

import Base.+
function +(l1::Location, l2::Location)
    Location(l1.x + l2.x, l1.y + l2.y)
end

function jump(w::Abstract2DWalker)
    neighbours = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    # diagonal as well
    # x = [-1, 0, -1]
    # neighbours = hcat(tuple.(x, x')...)
    w_pos_tuple = pos(w) |> make_tuple
    return Location(w_pos_tuple .+ rand(neighbours)...)
end

#  11

function jump!(w::Abstract2DWalker)
    set_pos!(w, jump(w))
end

# 12

function trajectory(w::Abstract2DWalker, N::Int)
    [make_tuple(jump!(w)) for _ in 1:N]
end

# 13

trajs = trajectory.([Walker2D(0, 0)], repeat([10000], 10)); 

p = plot!(trajs[1], label=:none)
for i in 2:length(trajs)
    plot!(trajs[i], label=:none)
end
scatter!([0], [0], ms = 4, m = :x, color=:black, label=:none)
