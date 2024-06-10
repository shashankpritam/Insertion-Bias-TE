import duckdb
import seaborn as sns
import matplotlib.pyplot as plt

def plot_metrics(data):
    sns.set_theme(style="whitegrid", context='talk', palette='muted')
    line_styles = ["-.", "-", ":"]
    colors = ['red', 'green', 'blue']
    lighter_colors = [sns.light_palette(color, n_colors=5)[2] for color in colors]
    # Set up a subplot grid that is 1x3
    fig, axes = plt.subplots(1, 3, figsize=(22, 8), sharex=True, sharey=True, gridspec_kw={'wspace': 0.1}, constrained_layout=True)
    
    bias_map = {'bm50': 'Insertion Bias = -50', 'b50': 'Insertion Bias = 50', 'b0': 'Insertion Bias = 0'}
    lines = []
    sample_order = ['bm50', 'b0', 'b50']

    # Plot each sample on a different axis
    for idx, sample_id in enumerate(sample_order):
        group = data[data['sampleid'] == sample_id]
        line, = axes[idx].plot(group['gen'], group['avg_avw'], linestyle=line_styles[idx], color=colors[idx])
        axes[idx].fill_between(group['gen'], group['avg_avw'] - group['stddev_avw'], group['avg_avw'] + group['stddev_avw'], color=lighter_colors[idx], alpha=0.5)
        axes[idx].set_title(bias_map[sample_id])
        axes[idx].set_xlabel('Generation')
        if idx == 0:
            axes[idx].set_ylabel('Average Fitness of the Population')
        axes[idx].set_ylim(0, 1.2)
        #axes[idx].legend([line], [bias_map[sample_id]], loc='lower left')
        axes[idx].yaxis.set_tick_params(which='both', labelleft=True)

    plt.savefig('/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/fitness_ncs_plots_avw.pdf', format='pdf', dpi=600, bbox_inches='tight', pad_inches=0.5)
    plt.show()

# Database connection and data fetching
conn = duckdb.connect(database="/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/fitness_ncs/fitness_ncs.duckdb", read_only=True)
query = """
WITH data AS (
    SELECT sampleid, gen, AVG(avw) AS avg_avw, STDDEV(avw) AS stddev_avw
    FROM simulations
    WHERE sampleid IN ('b50', 'b0', 'bm50') AND popstat = 'ok'
    GROUP BY sampleid, gen
    ORDER BY sampleid, gen
)
SELECT * FROM data;
"""
df = conn.execute(query).fetch_df()

# Plotting
plot_metrics(df)
