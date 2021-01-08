# 1

using Dates
using CSV
using DataFrames
using DataFramesMeta
using Plots
using Interact
using Dates
using StatsPlots

url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/"*
      "csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
download(url, "covid_data.csv");
data = CSV.read("covid_data.csv", DataFrame)
rename!(data, 1 => "province", 2 => "country")
all_countries = data[:, "country"] |> unique ;

countries = ["China", "Japan", "Korea, South", "US", "United Kingdom", "France", "Germany", "Australia"]
data_countries = @where(data, in.(:country, [countries]));
num_days = select(data, r"^[0-9]") |> ncol

dates = names(data)[5:end]
data_countries_grp = combine(groupby(data_countries, :country), dates .=> sum) 
rename!(data_countries_grp, dates .* ["_sum"] .=> dates)
data_countries_grp = DataFrames.stack(data_countries_grp, Not(:country))
format = Dates.DateFormat("m/d/Y");
data_countries_grp.variable = parse.(Date, data_countries_grp.variable, format) .+ Year(2000)

# 2

function runsum(x) 
    out = zeros(length(x))
    for i in 1:length(x)
        out[i] = sum(view(x, max(1, i-7):i))
    end
    return out
end

gby = groupby(data_countries_grp, :country);
gby = transform(gby, :value => (x -> pushfirst!(diff(x), 0)) => :difference, ungroup=false);
data_countries_final = transform(gby, :difference => runsum => :new7day);
data_countries_final.value = convert.(Float32, data_countries_final.value);
replace!(data_countries_final.value, Pair(0.0, NaN));
data_countries_final[data_countries_final.new7day .< 1, :new7day] .= NaN;
data_countries_final[.!isnan.(data_countries_final.new7day), :]

#3, 4

using Mux, WebIO
min_date = minimum(data_countries_final.variable) + Day(1)
max_date = maximum(data_countries_final.variable) - Day(1)  

function app(req)
    @manipulate for i in min_date:Day(1):max_date 
        base = @df data_countries_final plot(:value, :new7day, group = :country, 
                linecolor="lightgray", legend = :none)                          
        new_df = data_countries_final[data_countries_final[!, :variable] .< i, :]
        max_date_df = combine(last, groupby(new_df[isfinite.(new_df.new7day), :], :country))
        @df max_date_df plot!(base, :value, :new7day, seriestype = :scatter, group = :country)
        country_label = [(a,b*0.7,text(c, 10, :black)) for (a,b,c) in zip(max_date_df.value, max_date_df.new7day, max_date_df.country)]
        annotate!(country_label)
        base = @df new_df plot!(base, :value, :new7day, group = :country)
        plot!(base, yaxis=:log10, xaxis=:log10)
        plot!(base, yaxis=:log10, xaxis=:log10)
    end
end
webio_serve(page("/", app), 8000)