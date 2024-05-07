import duckdb
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

def plot_bar_metrics(data):
    sns.set_theme(style="whitegrid", context='talk', palette='muted')
    
    # Map sample IDs to their display order based on bias_map
    bias_map = {'b50': 'Insertion Bias = 50', 'b0': 'Insertion Bias = 0', 'bm50': 'Insertion Bias = -50'}
    sample_order = ['b50', 'b0', 'bm50']  # This defines the desired order

    # Filter data for gen = 5000
    filtered_data = data[data['gen'] == 5000]

    # Reorder the data according to sample_order to match bias_map
    filtered_data['order'] = filtered_data['sampleid'].map({v: i for i, v in enumerate(sample_order)})
    filtered_data.sort_values('order', inplace=True)

    # Prepare the data for plotting
    bar_width = 0.35
    index = np.arange(len(sample_order))
    labels = [bias_map[id] for id in sample_order]
    min_w_values = filtered_data['avg_min_w'].tolist()
    avw_values = filtered_data['avg_avw'].tolist()
    min_w_stdevs = filtered_data['stddev_min_w'].tolist()
    avw_stdevs = filtered_data['stddev_avw'].tolist()

    fig, ax = plt.subplots(figsize=(12, 8))

    # Create bar plots with patterns
    bars1 = ax.bar(index, min_w_values, bar_width, label='Minimum Fitness', color='black', edgecolor='white', yerr=min_w_stdevs, capsize=5)
    bars2 = ax.bar(index + bar_width, avw_values, bar_width, label='Average Fitness', color='grey', edgecolor='black', yerr=avw_stdevs, capsize=5)

    # Adding labels and titles
    ax.set_xlabel('', fontsize=20)
    ax.set_ylabel('Fitness Values', fontsize=20)
    ax.set_title('', fontsize=24, pad=20)
    ax.set_xticks(index + bar_width / 2)
    ax.set_xticklabels(labels, fontsize=16)
    ax.set_ylim(0, 1)  # Set y-axis limits from 0 to 1
    ax.set_yticks(np.linspace(0, 1, num=5))
    ax.set_yticklabels([f'{y:.2f}' for y in np.linspace(0, 1, num=5)], fontsize=16)

    ax.legend(fontsize=16, frameon=True, loc='upper right')

    # Adjust grid lines
    ax.grid(True, which='major', color='grey', linestyle='-', linewidth=1.5)
    ax.grid(True, which='minor', color='black', linestyle=':', linewidth=1)

    # Save to PDF
    plt.savefig('/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/fitness_bar_gen5000.pdf', format='pdf', dpi=600, bbox_inches='tight')


# Fetch data
conn = duckdb.connect(database="/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/fitness/fitness.duckdb", read_only=True)
query = """
WITH data AS (
    SELECT sampleid, gen, AVG(min_w) AS avg_min_w, STDDEV(min_w) AS stddev_min_w, AVG(avw) AS avg_avw, STDDEV(avw) AS stddev_avw
    FROM simulations
    WHERE sampleid IN ('b50', 'b0', 'bm50') AND popstat = 'ok' AND gen = 5000
    GROUP BY sampleid, gen
)
SELECT * FROM data ORDER BY sampleid;
"""

df = conn.execute(query).fetch_df()

# Plotting
plot_bar_metrics(df)
