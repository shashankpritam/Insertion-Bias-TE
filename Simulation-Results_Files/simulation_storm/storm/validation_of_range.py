import duckdb
import polars as pl
import matplotlib.pyplot as plt
import numpy as np

# Connect to DuckDB in read-only mode for safer data querying
conn = duckdb.connect(database='storm_invasion.duckdb', read_only=True)

# Execute the query and directly fetch the result into a DataFrame
query = """
SELECT gen, avtes, y, z
FROM simulations
WHERE gen = 5000
AND y BETWEEN -50 AND 49 AND z BETWEEN -49 AND 50
AND popstat = 'ok'
"""
df = conn.execute(query).fetch_df()
conn.close()

# Convert the fetched DataFrame to a Polars DataFrame explicitly
df = pl.DataFrame(df)

print(type(df))
# Map each avtes value to a color
avtes_values = df['avtes'].unique().to_numpy()
colors = plt.cm.plasma(np.linspace(0, 1, len(avtes_values)))
color_map = dict(zip(avtes_values, colors))

# Correctly apply colors to each avtes value
color_values = df['avtes'].map_elements(lambda x: color_map.get(x, [0, 0, 0, 1]))

# Add the color values column to the DataFrame
df = df.with_columns(pl.Series('color_values', color_values.to_list(), dtype=pl.List(pl.Float64)))

# Plotting
fig, ax = plt.subplots(figsize=(10, 8))
ax.scatter(df['y'].to_numpy(), df['z'].to_numpy(), alpha=0.6, s=10, linewidth=0, c=np.array(df['color_values'].to_list()))
ax.set_title('Avtes Color-coded on Y-Z Plane')
ax.set_xlabel('Y')
ax.set_ylabel('Z')
plt.grid(True)

# Save the plot with optimized settings
plt.savefig('avtes_yz_color_coded.png', dpi=150, format='png', bbox_inches='tight')
