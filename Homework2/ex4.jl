include("Homework2/ex3.jl")

#1

# Sum of time spent in each phase 
# τ_{total} = τ_S + τ_E + τ_I
# Each of these is a geometric random variable

#2
function total_time(ps)
    bin_num.(ps, rand(length(ps))) |> sum
end

# 3
pE = 0.25; 
pI = 0.1; 
pR = 0.05;

N_runs = 10000
total_time_vals = [total_time([pE, pI, pR]) for _ in 1:N_runs];
ks, vals = probability_distribution(total_time_vals)
bar(ks, vals, label="Total Time", lc=:white, lw = 0.2)

# 4
p = 0.25

function app(req)
    @manipulate for n in slider(0:1:50, value=5)
        ps = repeat([p], n);
        total_time_vals = [total_time(ps) for _ in 1:N_runs];
        ks, vals = probability_distribution(total_time_vals)
        bar(ks, vals, label="Total Time", lc=:white, lw = 0.2)
        #xlims!(0, 200)
        #ylims!(0, 0.03)
    end
end
webio_serve(page("/", app), 8000)

# 5
ps = [0.02, 0.02, 0.02]
N = 1000
T = 600

transition_times = [bin_num.(ps, rand(length(ps))) for _ in 1:N]
transition_times = hcat(transition_times...) |> x -> cumsum(x, dims = 1)

pop_status =zeros(T, 4)

for time in 1:T
    pop_status[time, 1] = (transition_times[1, :] .> time) |> sum
    pop_status[time, 2] = ((transition_times[1, :] .< time) .& (transition_times[2, :] .> time)) |> sum
    pop_status[time, 3] = ((transition_times[2, :] .< time) .& (transition_times[3, :] .> time)) |> sum
    pop_status[time, 4] = (transition_times[3, :] .< time) |> sum
end

plot(pop_status, label=["S" "E" "I" "R"])
    
