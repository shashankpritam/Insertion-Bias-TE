import duckdb
import polars as pl
import matplotlib.pyplot as plt
import numpy as np

# Connect to DuckDB in read-only mode for safer data querying
conn = duckdb.connect(database='storm_invasion.duckdb', read_only=True)

# Execute the query and directly fetch the result into a Polars DataFrame
query = """
SELECT gen, avtes, y, z
FROM simulations
WHERE rep NOT IN (
    SELECT rep
    FROM simulations
    WHERE popstat = 'fail'
    GROUP BY rep
)
AND y BETWEEN -5 AND 4 AND z BETWEEN -4 AND 5
"""
df = conn.execute(query).fetch_df()
conn.close()

# Convert the DuckDB DataFrame to a Polars DataFrame
df = pl.from_pandas(df)

# Generate a unique identifier for each y-z pair efficiently
df = df.with_columns(
    pl.concat_str([df['y'].cast(pl.Utf8), pl.lit('_'), df['z'].cast(pl.Utf8)]).alias('yz_id')
)

# Map each unique yz_id to a color
unique_yz_ids = df.select(pl.col('yz_id')).unique().to_numpy().flatten()
colors = plt.cm.jet(np.linspace(0, 1, len(unique_yz_ids)))
color_map = dict(zip(unique_yz_ids, colors))

# Create a new column with the color values using map_elements
df = df.with_columns(
    df['yz_id'].map_elements(lambda x: color_map.get(x, [0, 0, 0, 1])).alias('color_values')
)

# Extract the RGBA values for each row in 'color_values' for plotting
color_values_for_plot = np.array(df['color_values'].to_list())

# Plotting
fig, ax = plt.subplots(figsize=(12, 10))
ax.scatter(df['gen'].to_numpy(), df['avtes'].to_numpy(), alpha=0.6, s=10, linewidth=0, color=color_values_for_plot)
ax.set_title('Avtes vs Gen Scatter Plot with Y-Z Color Coding')
ax.set_xlabel('Gen')
ax.set_ylabel('Avtes')
plt.grid(True)

# Save the plot with optimized settings
plt.savefig('avtes_vs_gen_color_coded.png', dpi=150, format='png', bbox_inches='tight')
plt.show()
