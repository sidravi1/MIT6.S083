#include("Homework5/ex2.jl")
include("ex2.jl")
using Mux, WebIO
using Plots

# 1 
function gradient_descent_1d(f, x0, steps = 100, η = 0.01)
    x_new = x0
    for i in 1:steps
        dx = deriv(f, x_new)
        x_new = x_new - dx * η
    end
    return x_new
end

# Better way is to test covergences. Δ is tiny

# 2
function make_1d_anim()
    x_min = -1.0 # or -0.5
    anim = @animate for i ∈ 1:20
        xs = Array(-2.5:0.1:1.5)
        f(x) = x^4 + 3*x^3 - 3*x + 5
        plot(xs, f.(xs), label="f(x)")
        x_min = gradient_descent_1d(f, x_min, 5)
        println(x_min)
        plot!([x_min], [f(x_min)], label = "min",
                seriestype = :scatter, color=:red)
    end
    gif(anim, "Homework5/anim_min.gif", fps = 15)
end
# Different minima: start at another point

# 3
function gradient_descent_2d(f, x0, y0, steps = 100, η = 0.01)
    x_new = x0
    y_new = y0
    for i in 1:steps
        dx, dy = gradient(f, x_new, y_new)
        x_new = x_new - dx * η
        y_new = y_new - dy * η
    end
    return x_new, y_new
end

# 4
function make_2d_anim()
    x_min = -1 # or -0.5
    y_min = -1
    xs = Array(-6:0.1:6)
    ys = Array(-6:0.1:6)
    anim2d = @animate for i ∈ 1:20
        p = contour(xs, ys, log10 ∘ f, levels = 20, scale =:log10)
        f(x, y) = (x^2 + y - 11)^2 + (x + y^2 - 7)^2
        x_min, y_min = gradient_descent_2d(f, x_min, y_min, 1, 0.01)
        println(x_min)
        plot!(p, [x_min], [y_min], label = :none,
                seriestype = :scatter, color=:red)
        xlims!(-6,6)
        ylims!(-6,6)
    end
    gif(anim2d, "Homework5/anim_min_2d.gif", fps = 15)
end


