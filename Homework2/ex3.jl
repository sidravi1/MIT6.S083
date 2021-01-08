include("Homework2/ex2.jl")

#1
p = 0.25
n = 1:50
Pn(p, n) = p*(1-p)^(n-1)
Pn_vals = Pn.([0.25], n)

#2
p = 0.25
N = 10000
sims = experiment(p, N);
ks, dist = probability_distribution(sims);
plot(ks, dist, label="simulation")
plot!(Pn_vals, label="actual")

#3
cumsum(Pn_vals) # but i guess we have to write the function
one_cumulative_sum(data, i) = sum(data[1:i])
cumulative_sum(data) = one_cumulative_sum.([data], 1:length(data))

#4
scatter(cumulative_sum(Pn_vals), [1], ylims = (0, 2))

#5
Pn_sum(p, n) = 1 - (1-p)^n

#6

# s = 1 - (1 - p)^n
# 1 - s = (1 - p)^n
# log(1 - s) = n * log(1 - p)
# n = log(1 - s) / log( 1 - p)

#7
bin_num(p, r) = floor(log(1 - r) / log( 1 - p)) + 1




