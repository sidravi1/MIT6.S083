using DataStructures

# 1
function counts(data)
    counts = DefaultDict{Int, Int}(0)
    for d in data
        counts[d] += 1
    end
    return counts
end

# 2
vv = [1, 0, 1, 0, 1000, 1, 1, 1000]
counts(vv)

# 3
function counts2(data)
    count_dict = counts(data)
    ks = keys(count_dict) |> collect
    vs = values(count_dict) |> collect

    p = sortperm(ks)

    return ks[p], vs[p]
end

function probability_distribution(data)
    ks, vs = counts2(data)
    return ks, vs/sum(vs)
end