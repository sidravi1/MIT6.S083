using CSV
using DataFrames
using DataFramesMeta
using Plots
using Interact

# 1
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/"*
      "csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
download(url, "covid_data.csv");
data = CSV.read("covid_data.csv", DataFrame);
rename!(data, 1 => "province", 2 => "country")
all_countries = data[:, "country"] |> unique ;

# 2
countries = ["China", "Japan", "Korea, South", "US", "United Kingdom", "France", "Germany", "Australia"]
data_countries = @where(data, in.(:country, [countries]));

# 3
num_days = select(data, r"^[0-9]") |> ncol

# 4a
dates = names(data_countries)[5:end]
data_countries = combine(groupby(data_countries, :country), dates .=> sum) 

# 4b
countries_dict = Dict(countries .=> [zeros(num_days)])
p = plot()

# 5
for c in countries
    countries_dict[c] = data[data.country .== c, 5:end] |> eachcol .|> sum
    plot!(range(1, stop=num_days), countries_dict[c],  label = c)
end
plot!(legend = :topleft)
display(p)

# 6
p = plot()
for c in countries
    countries_dict[c] = data[data.country .== c, 5:end] |> eachcol .|> sum
    replace!(countries_dict[c], Pair(0, NaN))
    plot!(range(1, stop=num_days), countries_dict[c], label = c)
end
plot!(legend = :bottomright, yaxis=:log)
display(p)

# 7 
using Mux, WebIO
function app(req) # req is a Mux request dictionary
    @manipulate for i in 1:num_days
        plot!(p, xlims=(1,i))
    end
end
webio_serve(page("/", app), 8000)

