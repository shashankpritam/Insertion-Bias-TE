import numpy as np
import matplotlib.pyplot as plt
import duckdb
import pandas as pd
from matplotlib.colors import LinearSegmentedColormap

def parse_3tot(value):
    """Parse the '3tot' field from the database."""
    return np.array([float(x.split(',')[0].split('(')[0]) if x else 0 for x in value])

def fetch_data_in_bulk(database, generation):
    """Fetch all relevant data in one go, filtering by popstat and generation, including rep."""
    query = f"""
    SELECT y, z, rep, avcli
    FROM simulations
    WHERE popstat = 'ok' AND gen = {generation};
    """
    with duckdb.connect(database=database, read_only=True) as conn:
        df = conn.execute(query).df()
    return df

def create_custom_colormap():
    """Create a custom colormap from green to yellow to blue."""
    colors = ["green", "yellow", "blue"]  # Color gradient
    cmap_name = 'gyb'
    return LinearSegmentedColormap.from_list(cmap_name, colors, N=256)

def process_data(df):
    """Compute average 'avcli' values across all reps for each (y, z) pair."""
    avg_avcli_df = df.groupby(['y', 'z'])['avcli'].mean().reset_index()
    return avg_avcli_df

def main():
    generations = [1, 2500, 5000]
    databases = ['storm2_invasion.duckdb', 'storm_invasion.duckdb']
    fig, axes = plt.subplots(nrows=2, ncols=3, figsize=(20, 10), dpi=300, constrained_layout=True)
    cmap = create_custom_colormap()

    global_min, global_max = float('inf'), float('-inf')
    for database in databases:
        for generation in generations:
            df = fetch_data_in_bulk(database, generation)
            global_min = min(global_min, df['avcli'].min())
            global_max = max(global_max, df['avcli'].max())

    for i, database in enumerate(databases):
        for j, generation in enumerate(generations):
            df = fetch_data_in_bulk(database, generation)
            avg_avcli_df = process_data(df)
            y_min, z_min = df['y'].min(), df['z'].min()
            y_range = df['y'].max() - y_min + 1
            z_range = df['z'].max() - z_min + 1
            heatmap_data = np.full((y_range, z_range), np.nan)

            for _, row in avg_avcli_df.iterrows():
                heatmap_data[int(row['y'] - y_min), int(row['z'] - z_min)] = row['avcli']

            ax = axes[i, j]
            im = ax.imshow(heatmap_data, cmap=cmap, interpolation='nearest', origin='lower',
                           extent=[y_min, df['y'].max(), z_min, df['z'].max()], vmin=0, vmax=1)
            ax.set_title(f'Gen {generation} in {"Simulation " + database.split("_")[0]}')
            ax.grid(False)

    cbar = fig.colorbar(im, ax=axes.ravel().tolist(), shrink=0.95, label='Average of avcli')

    plt.suptitle('Comparative Heatmaps across Generations and Simulations', fontsize=16)
    plt.savefig('StormHeatmap_avcli.png', dpi=600)

if __name__ == '__main__':
    main()