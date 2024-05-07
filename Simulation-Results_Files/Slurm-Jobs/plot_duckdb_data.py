import duckdb
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

def plot_metrics(data):
    sns.set_theme(style="whitegrid", context='talk', palette='muted')

    line_styles = ["-.", "-", ":"]
    colors = ['blue', 'green', 'red']
    lighter_colors = [sns.light_palette(color, n_colors=1)[0] for color in colors]

    fig, axes = plt.subplots(1, 2, figsize=(22, 8), sharex=True, sharey=True, gridspec_kw={'wspace': 0.1}, constrained_layout=True)

    bias_map = {'b50': 'Insertion Bias = 50', 'b0': 'Insertion Bias = 0', 'bm50': 'Insertion Bias = -50'}
    lines = []
    sample_order = ['b50', 'b0', 'bm50']

    for sample_id in sample_order:
        group = data[data['sampleid'] == sample_id]
        line, = axes[0].plot(group['gen'], group['avg_min_w'], linestyle=line_styles[sample_order.index(sample_id)], color=colors[sample_order.index(sample_id)])
        axes[0].fill_between(group['gen'], group['avg_min_w'] - group['stddev_min_w'], group['avg_min_w'] + group['stddev_min_w'], color=lighter_colors[sample_order.index(sample_id)], alpha=0.5)
        lines.append(line)

    axes[0].set_title('Minimum Fitness Over Generations')
    axes[0].set_xlabel('Generation')
    axes[0].set_ylabel('Minimum Fitness of the Population')
    axes[0].set_ylim(0, 1)
    axes[0].legend(lines, [bias_map[sample] for sample in sample_order], title='', loc='lower left')

    lines = []
    for sample_id in sample_order:
        group = data[data['sampleid'] == sample_id]
        line, = axes[1].plot(group['gen'], group['avg_avw'], linestyle=line_styles[sample_order.index(sample_id)], color=colors[sample_order.index(sample_id)])
        axes[1].fill_between(group['gen'], group['avg_avw'] - group['stddev_avw'], group['avg_avw'] + group['stddev_avw'], color=lighter_colors[sample_order.index(sample_id)], alpha=0.5)
        lines.append(line)

    axes[1].set_title('Average Fitness Over Generations')
    axes[1].set_xlabel('Generation')
    axes[1].set_ylabel('Average Fitness of the Population')
    axes[1].set_ylim(0, 1)
    axes[1].legend(lines, [bias_map[sample] for sample in sample_order], title='', loc='lower left')
    axes[1].yaxis.set_tick_params(which='both', labelleft=True)


    plt.savefig('fitness_plots.pdf', format='pdf', dpi=600, bbox_inches='tight', pad_inches=0.5)
    plt.show()

conn = duckdb.connect(database="fitness.duckdb", read_only=True)
query = """
WITH data AS (
    SELECT sampleid, gen, AVG(min_w) AS avg_min_w, STDDEV(min_w) AS stddev_min_w, AVG(avw) AS avg_avw, STDDEV(avw) AS stddev_avw
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
