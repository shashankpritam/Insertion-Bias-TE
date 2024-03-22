import duckdb
import polars as pl
import matplotlib.pyplot as plt
import numpy as np
import imageio

# Function to fetch and plot data for a specific generation
def fetch_and_plot_generation(gen):
    conn = duckdb.connect(database='storm_invasion.duckdb', read_only=True)
    query = f"""
    SELECT gen, avtes, y, z
    FROM simulations
    WHERE gen = {gen}
    AND y BETWEEN -50 AND 49 AND z BETWEEN -49 AND 50
    AND popstat = 'ok'
    """
    df = conn.execute(query).fetch_df()
    conn.close()

    df = pl.DataFrame(df)

    avtes_values = df['avtes'].unique().to_numpy()
    colors = plt.cm.plasma(np.linspace(0, 1, len(avtes_values)))
    color_map = dict(zip(avtes_values, colors))
    color_values = df['avtes'].map_elements(lambda x: color_map.get(x, [0, 0, 0, 1]))
    df = df.with_columns(pl.Series('color_values', color_values.to_list(), dtype=pl.List(pl.Float64)))

    fig, ax = plt.subplots(figsize=(10, 8))
    ax.scatter(df['y'].to_numpy(), df['z'].to_numpy(), alpha=0.6, s=10, linewidth=0, c=np.array(df['color_values'].to_list()))
    ax.set_title(f'Avtes Color-coded on Y-Z Plane: Gen {gen}')
    ax.set_xlabel('Y')
    ax.set_ylabel('Z')
    plt.grid(True)
    
    plt.savefig(f'gen_images/gen_{gen}.png', dpi=150, format='png', bbox_inches='tight')
    plt.close()

# Generate images for each generation
for gen in range(5001):
    fetch_and_plot_generation(gen)

# Compile the generated images into a GIF
images = []
for gen in range(5001):
    images.append(imageio.imread(f'gen_images/gen_{gen}.png'))
imageio.mimsave('simulation_evolution.gif', images, fps=20)
