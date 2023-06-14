### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

using CSV
using DataFrames
using Plots

# Define column names
column_names = ["rep", "gen", "popstat", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                "fixed", "phase", "fwcli", "avcli", "fixcli",
                "avbias", "3tot", "3cluster", "sampleid"]

# Read the CSV file directly into a DataFrame
# Silently handle any inconsistencies in column numbers or types
df = CSV.File("test_file_7.1.out", 
              header=column_names, 
              delim='\t', 
              ignoreemptyrows=true, 
              silencewarnings=true, 
              comment="#") |> DataFrame

println("DataFrame after initial loading:")
println(df)

# Filter out lines starting with "Invade"
df = filter(row -> row[:rep] != "Invade", df)

println("\nDataFrame after filtering out 'Invade' rows:")
println(df)

# Handle inaccessible data in '3tot' and '3cluster' columns
# by splitting at comma, parsing the first part to Float64, and assigning NA to the second part if it doesn't exist
df[!, "3tot"] = [let parts = split(x, ',')
                      length(parts) > 1 ? parse(Float64, parts[1]) : missing
                  end for x in df[!, "3tot"]]

df[!, "3cluster"] = [let parts = split(x, ',')
                          length(parts) > 1 ? parse(Float64, parts[1]) : missing
                      end for x in df[!, "3cluster"]]

println("\nDataFrame after handling '3tot' and '3cluster' columns:")
println(df)

# Plot avtes vs avpopfreq
scatter(df.avpopfreq, df.avtes, legend=false, xlabel="avpopfreq", ylabel="avtes", title="avtes vs avpopfreq")
