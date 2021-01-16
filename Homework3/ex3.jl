include("Homework3/ex1.jl")

#1 
function step!(agents::Vector{Agent}, 
               p_I::Float64, 
               p_R::Float64, id::Int64)

    i = rand(1:length(agents))
    if agents[i].status == I
        j = rand(setdiff(1:length(agents), i))
        if (agents[j].status == S) & (rand() < p_I)
            agents[j].status = I
            agents[i].num_infected += 1
        end
    end

    if agents[id].status == I
        agents[id].status = rand() < p_R ? R : I
    end
end

function sweep!(agents, p_I, p_R)
    for i in 1:length(agents)
        step!(agents, p_I, p_R, i)
    end
end

function simulation_with_recovery(N, p_I, p_R, T)
    agents = [Agent() for _ in 1:N]
    agents[1].status = I

    Ss = zeros(T)
    Rs = zeros(T)
    Is = zeros(T)

    for t in 1:T
        sweep!(agents, p_I, p_R)
        Ss[t] = map(x -> (x.status == S), agents) |> sum
        Rs[t] = map(x -> (x.status == R), agents) |> sum
        Is[t] = map(x -> (x.status == I), agents) |> sum
        
    end

    prob_n_infected = probability_distribution([a.num_infected for a in agents])

    return Ss, Rs, Is, prob_n_infected

end

#2 
Ss, Rs, Is, p_inf = simulation_with_recovery(1000, 0.1, 0.01, 1000)

plot(Ss, label="Susceptible")
plot!(Rs, label="Recovered")
plot!(Is, label="Infected")

#3 
plot(p_inf, yscale=:log10)

#4
n_sim = 50
results = simulation_with_recovery.(repeat([1000], n_sim), [0.1], [0.01], [1000])
Is_runs = map(x -> x[3], results)
Is_runs = hcat(Is_runs...)
plot(Is_runs, color="gray", alpha = 0.4, label=:none)
plot!(median(Is_runs, dims = 2), lw=3, label="median")
plot!(mean(Is_runs, dims = 2), lw=3, label="mean")

#5

## max_infected at any time
max_infected = max(Is)

## time to peak
time_to_peak = argmax(Is)

## time to 95% Recovered
findfirst(x -> x==1, Rs .>= N * 0.95)
