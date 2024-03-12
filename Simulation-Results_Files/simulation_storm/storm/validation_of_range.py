import duckdb
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Connect to DuckDB database
conn = duckdb.connect(database='storm_invasion.duckdb', read_only=False)

# Execute the query to select y and z from simulations table
query = "SELECT y, z FROM simulations"
df_yz = conn.execute(query).df()

# Close the database connection
conn.close()

# Set the aesthetic style of the plots
sns.set_style("whitegrid")

# Create the scatter plot
plt.figure(figsize=(10, 8))
scatter_plot = sns.scatterplot(data=df_yz, x='z', y='y')

# Customize the plot
plt.title('Y vs Z Scatter Plot')
plt.xlabel('Z Value')
plt.ylabel('Y Value')

# Save the plot to a file
plt.savefig('../../../images/storm_validation_yvsz.png', dpi=1200)
