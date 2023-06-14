### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils
using Plots

# Open the file in read mode
file = open("test_file_7.1.out", "r")

# Read the contents of the file
content = read(file, String)

# Split the content into lines
lines = split(content, "\n")

# Filter out lines starting with "Invade" or "#"
filtered_lines = filter(line -> !startswith(line, "Invade") && !startswith(line, "#"), lines)

# Initialize empty arrays for the columns
rep = Int[]
gen = Int[]
popstat = Float64[]
spacer_1 = Float64[]
fwte = Float64[]
avw = Float64[]
min_w = Float64[]
avtes = Float64[]
avpopfreq = Float64[]
fixed = Float64[]
spacer_2 = Float64[]
phase = Float64[]
fwcli = Float64[]
avcli = Float64[]
fixcli = Float64[]
spacer_3 = Float64[]
avbias = Float64[]
tot3 = Float64[]
cluster3 = Float64[]
spacer_4 = Float64[]
sampleid = String[]

# Parse the lines and extract the values
for line in filtered_lines
    values = split(line, "\t")
    push!(rep, parse(Int, values[1]))
    push!(gen, parse(Int, values[2]))
    push!(popstat, parse(Float64, values[3]))
    push!(spacer_1, parse(Float64, values[4]))
    push!(fwte, parse(Float64, values[5]))
    push!(avw, parse(Float64, values[6]))
    push!(min_w, parse(Float64, values[7]))
    push!(avtes, parse(Float64, values[8]))
    push!(avpopfreq, parse(Float64, values[9]))
    push!(fixed, parse(Float64, values[10]))
    push!(spacer_2, parse(Float64, values[11]))
    push!(phase, parse(Float64, values[12]))
    push!(fwcli, parse(Float64, values[13]))
    push!(avcli, parse(Float64, values[14]))
    push!(fixcli, parse(Float64, values[15]))
    push!(spacer_3, parse(Float64, values[16]))
    push!(avbias, parse(Float64, values[17]))
    push!(tot3, parse(Float64, values[18]))
    push!(cluster3, parse(Float64, values[19]))
    push!(spacer_4, parse(Float64, values[20]))
    push!(sampleid, values[21])
end

# Filter the data for gen 0 and gen 1
avtes_gen0 = avtes[gen .== 0]
avbias_gen0 = avbias[gen .== 0]
avtes_gen1 = avtes[gen .== 1]
avbias_gen1 = avbias[gen .== 1]

# Create side-by-side plots
plot1 = scatter(avbias_gen0, avtes_gen0, legend = false, xlabel = "avbias", ylabel = "avtes", title = "Gen 0")
plot2 = scatter(avbias_gen1, avtes_gen1, legend = false, xlabel = "avbias", ylabel = "avtes", title = "Gen 1")
plot_combined = plot(plot1, plot2, layout = (1, 2))

# Display the plot
display(plot_combined)

# Close the file
close(file)
