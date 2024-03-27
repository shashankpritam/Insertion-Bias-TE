import matplotlib
matplotlib.use('macosx')

import matplotlib.pyplot as plt
import duckdb
import pandas as pd

# Connect to DuckDB
conn = duckdb.connect(database='storm_invasion.duckdb')

# Fetch data for specified x, y, z, and rep values with corrected syntax
query = """
SELECT gen, "3tot"
FROM simulations
WHERE x = 5 AND y = 13 AND z = 35 AND rep = 1;
"""
df = conn.execute(query).df()

# Close the connection to DuckDB early for safety
conn.close()

# Function to parse the '3tot' column
def parse_3tot(value):
    # Check if the value is empty and return an empty dictionary if so
    if not value or value.strip() == "":
        return {"0": 0.0}  # Default to bias "0" with 0.0 insertions if empty

    biases = value.split(',')
    parsed_biases = {}
    for bias in biases:
        parts = bias.split('(')
        average_insertions = 0.0  # Default value
        bias_value = "0"  # Default bias value

        if len(parts) == 1:
            # If there's no parenthesis, assume it's just the bias value without insertions
            try:
                bias_value = parts[0]
                average_insertions = 0.0  # Default to 0.0 insertions
            except ValueError:
                print(f"Skipping or logging unexpected format/value: {bias}")
        elif len(parts) == 2:
            # The expected format with both insertions and bias value
            try:
                average_insertions = float(parts[0])
                bias_value = parts[1].rstrip(')')
            except ValueError:
                print(f"Skipping or logging unexpected format/value: {bias}")
        # For len(parts) == 0, it's effectively handled by the initial empty check

        parsed_biases[bias_value] = average_insertions

    return parsed_biases


# Expand the '3tot' column into structured format
organized_data = {'gen': [], 'bias': [], 'average_insertions': [], 'rep': []}
for index, row in df.iterrows():
    parsed_biases = parse_3tot(row['3tot'])
    for bias_value, average_insertions in parsed_biases.items():
        organized_data['gen'].append(row['gen'])
        organized_data['bias'].append(bias_value)
        organized_data['average_insertions'].append(average_insertions)
        organized_data['rep'].append(1)  # Rep is fixed in this query

organized_df = pd.DataFrame(organized_data)

# Aggregation
aggregated_data = organized_df.groupby(['gen', 'bias']).agg({'average_insertions': 'mean'}).reset_index()

# Visualization
plt.figure(figsize=(10, 6))

for bias in aggregated_data['bias'].unique():
    subset = aggregated_data[aggregated_data['bias'] == bias]
    plt.plot(subset['gen'], subset['average_insertions'], label=f"Bias {bias}")

plt.xlabel('Generation Number')
plt.ylabel('Average Number of Total Insertions per Diploid')
plt.title('Transposon Insertions Across Generations for x=5, y=13, z=35, Rep=1')
plt.legend()
plt.grid(True)
plt.show()
