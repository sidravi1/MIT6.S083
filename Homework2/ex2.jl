include("Homework2/ex1.jl")
using Statistics
using Plots
using Interact
using Mux, WebIO

# 1
function bernoulli(p)
    return rand() < p
end

# 2
function geometric(p)
    t = 1
    while !bernoulli(p)
        t += 1
    end
    return t
end

# 3
function experiment(p, N)
    return [geometric(p) for i in 1:N]
end

# 4
p = 0.25
N = 10000

sims = experiment(p, N);
ks, dist = probability_distribution(sims);
plot(ks, dist)

# 5
vline!([mean(sims)], ls=:dash, color=:black)

# 6
plot!(yscale=:log)

# 7
function app(req)
    @manipulate for p in slider(0.01:0.01:1.0, value=0.5), N in slider(0:100000, value=1000)
        sims = experiment(p, N);
        ks, dist = probability_distribution(sims);
        plot(ks, dist)
        vline!([mean(sims)], ls=:dash, color=:black)
    end
end
webio_serve(page("/", app), 8000)

# 8
N = 10000
ps = 0.01:0.1:1.0
μ = experiment.(ps, [N]) .|> mean
plot(ps, 1 ./ μ)
