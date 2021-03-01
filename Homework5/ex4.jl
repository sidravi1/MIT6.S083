include("Homework5/ex3.jl")
using DataFrames

# 1
url = "https://raw.githubusercontent.com/mitmath/6S083/master/problem_sets/some_data.csv"
download(url, "Homework5/some_data.csv");
data = CSV.read("Homework5/some_data.csv", DataFrame);
xs = data.Column1
ys = data.Column2

# 2
plot(xs, ys)

# 3
f(x, μ, σ) = (1 / (σ * √(2π))) * exp(- ((x - μ)^2) / (2 * σ^2))

# 4
loss_function(μ, σ) = (f.(xs, [μ], [σ]) .- ys).^2 |> sum

# 5
mu, sd = gradient_descent_2d(loss_function, 0, 1, 5000, 0.001)
fitted_xs = Array(0:0.1:4)
fitted_ys = f.(fitted_xs, [mu], [sd])
plot(fitted_xs, fitted_ys, color = :red, label = "fitted")

# 6
function gradient_descent_2d_verbose(f, x0, y0, steps = 100, η = 0.01)
    x_new = Float32(x0)
    y_new = Float32(y0)
    all_xmin = [x_new]
    all_ymin = [y_new]
    for i in 1:steps
        dx, dy = gradient(f, x_new, y_new)
        x_new = x_new - dx * η
        y_new = y_new - dy * η
        push!(all_xmin, x_new)
        push!(all_ymin, y_new)
    end
    return all_xmin, all_ymin
end

mus, sds = gradient_descent_2d_verbose(loss_function, 0, 1, 500, 0.01)

using Mux, WebIO

fitted_xs = Array(0:0.1:4)
function app(req)
    @manipulate for i in 1:length(mus)
        
        fitted_ys = f.(fitted_xs, mus[i], sds[i])
        plot(xs, ys, label = "actual")
        plot!(fitted_xs, fitted_ys, label="fitted")        
    end
end
webio_serve(page("/", app), 8000)
