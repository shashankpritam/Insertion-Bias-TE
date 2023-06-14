### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 0d0f684f-9c56-4e8f-ab5a-91403b62a031
begin
	import Pkg
	Pkg.update()
	Pkg.precompile()
	
end

# ╔═╡ a09dad6e-e6e6-4aa8-a7cb-a5e2547a88fe
Pkg.add("Plots")

# ╔═╡ 89489e59-4bd3-4fcb-83b9-879792c7b9aa
# Open the file in read mode
file = open("test_file_7.1.out", "r")

# ╔═╡ d21a16c6-02c5-4dbf-825e-bbbe840361d3
# Read the contents of the file
content = read(file, String)

# ╔═╡ b204e748-c4d8-482d-860f-e9ca6d578503
# Split the content into lines
lines = split(content, "\n")

# ╔═╡ 136af4fd-bfbb-4ec8-b60f-84c1920c621a
# Filter out lines starting with "Invade" or "#"
filtered_lines = filter(line -> !startswith(line, "Invade") && !startswith(line, "#"), lines)

# ╔═╡ 7a6384ae-67d2-405a-8b00-9cf56d4d57dc
# Define column names
column_names = ["rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
                "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3",
                "avbias", "3tot", "3cluster", "spacer_4", "sampleid"]

# ╔═╡ 57571115-a677-4706-ae6b-e6d3acdf404b
# Initialize arrays to store data for Gen 0 and Gen 1
avtes_gen0 = Float64[]

# ╔═╡ 84c3c1c8-e1c1-4ac8-b85f-bf4f42deed82
avbias_gen0 = Float64[]

# ╔═╡ b6394999-0192-4ae2-b454-cb6943929549
avtes_gen1 = Float64[]

# ╔═╡ 0c7bbfbe-a597-4d4e-9733-3c4f50458ec1
avbias_gen1 = Float64[]

# ╔═╡ 87326f31-6616-422b-abe6-4dea0830730a
# Parse the data
for line in filtered_lines
    values = split(line, "\t")
    if length(values) == length(column_names)
        data_dict = Dict(zip(column_names, values))
        gen = parse(Int, data_dict["gen"])
        avtes = parse(Float64, data_dict["avtes"])
        avbias = parse(Float64, data_dict["avbias"])
        if gen == 0
            push!(avtes_gen0, avtes)
            push!(avbias_gen0, avbias)
        elseif gen == 1
            push!(avtes_gen1, avtes)
            push!(avbias_gen1, avbias)
        end
    end
end

# ╔═╡ dd5adbdf-d25c-42a6-abb3-e2684add030e
# Create side-by-side plots
plot1 = scatter(avbias_gen0, avtes_gen0, legend = false, xlabel = "avbias", ylabel = "avtes", title = "Gen 0")

# ╔═╡ 91043abe-b8db-4636-b77f-75cf14f84186
plot2 = scatter(avbias_gen1, avtes_gen1, legend = false, xlabel = "avbias", ylabel = "avtes", title = "Gen 1")

# ╔═╡ 2dd5f0c9-f08c-4c8f-a32b-596beaabdb46
plot_combined = plot(plot1, plot2, layout = (1, 2))

# ╔═╡ 398f6e65-3ee9-4eee-9c7d-784bbca9ed51
# Display the plot
display(plot_combined)

# ╔═╡ 1b46e797-cf99-4285-a075-5f6ebbc36e81
# Close the file
close(file)

# ╔═╡ Cell order:
# ╠═0d0f684f-9c56-4e8f-ab5a-91403b62a031
# ╠═a09dad6e-e6e6-4aa8-a7cb-a5e2547a88fe
# ╠═89489e59-4bd3-4fcb-83b9-879792c7b9aa
# ╠═d21a16c6-02c5-4dbf-825e-bbbe840361d3
# ╠═b204e748-c4d8-482d-860f-e9ca6d578503
# ╠═136af4fd-bfbb-4ec8-b60f-84c1920c621a
# ╠═7a6384ae-67d2-405a-8b00-9cf56d4d57dc
# ╠═57571115-a677-4706-ae6b-e6d3acdf404b
# ╠═84c3c1c8-e1c1-4ac8-b85f-bf4f42deed82
# ╠═b6394999-0192-4ae2-b454-cb6943929549
# ╠═0c7bbfbe-a597-4d4e-9733-3c4f50458ec1
# ╠═87326f31-6616-422b-abe6-4dea0830730a
# ╠═dd5adbdf-d25c-42a6-abb3-e2684add030e
# ╠═91043abe-b8db-4636-b77f-75cf14f84186
# ╠═2dd5f0c9-f08c-4c8f-a32b-596beaabdb46
# ╠═398f6e65-3ee9-4eee-9c7d-784bbca9ed51
# ╠═1b46e797-cf99-4285-a075-5f6ebbc36e81
