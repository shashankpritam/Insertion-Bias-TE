import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Step 1: Load the dataframe
df = pd.read_csv("Simulation-Results_Files/validation_5.2/2023_05_01_simulation_5_2_bias", 
                 sep="\t", header=None, na_values=[""])

# Step 2: Assign column names
column_names = ["rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", 
                "avpopfreq", "fixed", "spacer_2", "phase", "fwcli", "avcli", 
                "fixcli", "spacer_3", "avbias", "3tot", "3cluster", "spacer_4", "sampleid"]
df.columns = column_names

# Step 3: Filter relevant columns and remove rows with NA in 'sampleid'
relevant_columns = ["rep", "phase", "sampleid", "fwcli", "avcli", "avtes", "gen"]
df = df[relevant_columns].dropna(subset=["sampleid"])

# Convert 'phase' to factors and set 'sampleid' with specific order
df["phase"] = pd.Categorical(df["phase"], categories=["rapi", "shot", "inac"], ordered=True)
df["sampleid"] = pd.Categorical(df["sampleid"], categories=["b50", "b0", "bm50"], ordered=True)

# Step 4: Further processing
df1 = df[df["sampleid"] == "bm50"]
df2 = df[df["sampleid"] == "b0"]
df3 = df[df["sampleid"] == "b50"]

# Step 5: Summary statistics
df_summary = df.groupby(["sampleid", "phase"]).agg(
    av_fwcli=("fwcli", "mean"),
    sd_fwcli=("fwcli", "std"),
    av_cli=("avcli", "mean"),
    sd_cli=("avcli", "std"),
    av_tes=("avtes", "mean"),
    sd_tes=("avtes", "std")
).reset_index()

# Step 6: Plotting
g_avtes = sns.barplot(data=df_summary, x="phase", y="av_tes", hue="phase")
g_avtes.set(ylim=(0, 1500))
g_avtes.set(xlabel="Phase", ylabel="Insertions per individual")
g_avtes.set_title("Bias vs TE Insertions")
plt.legend(title="Phase", loc="lower center")
plt.savefig("images/average_te_ins_wbias.jpg", dpi=600)
plt.show()
