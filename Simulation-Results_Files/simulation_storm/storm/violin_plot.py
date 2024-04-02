import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Generating a sample DataFrame
np.random.seed(0)  # For reproducible results
y = np.random.randint(0, 5, 100)  # Random y coordinates
z = np.random.randint(0, 5, 100)  # Random z coordinates
rep = np.random.randint(1, 4, 100)  # Random repetition values
tot = np.random.rand(100) * 100  # Random '3tot' values

# Creating a DataFrame
df = pd.DataFrame({'y': y, 'z': z, 'rep': rep, '3tot': tot})

# Prepare data for violin plot for selected (y, z) pairs
def prepare_violin_data(df, yz_pairs=[(0, 1), (2, 3)]):
    """Prepare data for violin plot for selected (y, z) pairs."""
    # Filter the dataframe for only the selected (y, z) pairs
    filtered_df = df[df.apply(lambda row: (row['y'], row['z']) in yz_pairs, axis=1)]
    
    # Create a new column combining y and z for plotting
    filtered_df['y_z'] = filtered_df.apply(lambda row: f"({row['y']}, {row['z']})", axis=1)
    
    return filtered_df

# Selecting specific (y, z) pairs for illustration
selected_yz_pairs = [(0, 1), (2, 3)]
violin_data = prepare_violin_data(df, selected_yz_pairs)

# Create violin plots for the selected (y, z) pairs
plt.figure(figsize=(10, 6))
sns.violinplot(x='y_z', y='3tot', data=violin_data)
plt.xlabel('(Y, Z) Pairs')
plt.ylabel('3tot Values')
plt.title('Distribution of 3tot Values for Selected (Y, Z) Pairs')
plt.xticks(rotation=45)
plt.show()
