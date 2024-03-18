import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import duckdb

# Ensure the path to your DuckDB file is correct
conn = duckdb.connect(database='/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/storm/storm_invasion.duckdb')

query = """
WITH ValidReps AS (
    SELECT seed, rep
    FROM simulations
    GROUP BY seed, rep
    HAVING SUM(CASE WHEN popstat = 'fail' THEN 1 ELSE 0 END) = 0
)
SELECT s.y, s.z, s.gen, s.rep, AVG(s.avtes) as avg_avtes
FROM simulations s
JOIN ValidReps vr ON s.seed = vr.seed AND s.rep = vr.rep
WHERE s.gen = 5000
GROUP BY s.y, s.z, s.gen, s.rep
ORDER BY s.y, s.z, s.rep;
"""

# Use the connection object to execute the query
df = conn.execute(query).df()

# Now you can proceed with your data processing and visualization
# Don't forget to close the connection when done
conn.close()



# Step 2: Visualization with Seaborn
g = sns.FacetGrid(df, col="z", row="y", hue="rep", margin_titles=True, palette="viridis", legend_out=True)
g.map(sns.lineplot, "gen", "avg_avtes")

# Enhancements for better readability
g.add_legend(title="Replicate")
g.set_axis_labels("Generation", "Average avtes")
g.set_titles(row_template='y={row_name}', col_template='z={col_name}')

plt.show()
