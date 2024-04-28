import re
import pandas as pd
import duckdb
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import gridspec

plt.rcParams.update({
    "text.usetex": True,
    "font.family": "serif",
    "font.serif": ["Computer Modern Roman"],
    "font.size": 14
})

def parse_3tot(df, y_col_series, z_col_series):
    def extract_values(series):
        y_vals = pd.Series([None] * len(series))
        z_vals = pd.Series([None] * len(series))
        
        for i, cell in enumerate(series.to_list()):
            if isinstance(cell, str):
                parts = cell.split(',')
                for part in parts:
                    match = re.match(r'([0-9.-]+)\((-?[0-9]+)\)', part)
                    if match:
                        value, key = match.groups()
                        value = float(value)
                        key = int(key)
                        if key == y_col_series[i]:
                            y_vals[i] = value
                        elif key == z_col_series[i]:
                            z_vals[i] = value
        y_vals.name = '3tot_y'
        z_vals.name = '3tot_z'
        return y_vals, z_vals
    
    y_vals, z_vals = extract_values(df['3tot'])
    return df.assign(**{'3tot_y': y_vals, '3tot_z': z_vals})

def fetch_data_in_bulk(database, rep_values, generations):
    print(f"Fetching data from {database}")
    conn = duckdb.connect(database=database, read_only=True)
    all_data = pd.DataFrame()
    
    for gen in generations:
        gen_data = pd.DataFrame()
        for rep in rep_values:
            query = f"""
                SELECT y, z, "3tot", gen
                FROM simulations
                WHERE popstat = 'ok' AND rep = {rep} AND gen = {gen}
                ORDER BY gen;
            """
            df = conn.execute(query).fetch_df()
            if not df.empty:
                gen_data = pd.concat([gen_data, df], ignore_index=True)
        
        if not gen_data.empty:
            parsed_data = parse_3tot(gen_data, gen_data['y'], gen_data['z'])
            # Group by y and z to calculate the mean for each pair
            mean_data = parsed_data.groupby(['y', 'z']).agg({'3tot_y': 'mean', '3tot_z': 'mean', 'gen': 'first'}).reset_index()
            all_data = pd.concat([all_data, mean_data], ignore_index=True)

    return all_data



def plot_data(database, output_file):
    rep_values = range(1, 101)
    generations = [1, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    
    # Creating a figure with a specific size to accommodate all subplots
    plt.figure(figsize=(22, 18))  # Adjusted figure size to provide adequate space
    gs = gridspec.GridSpec(4, 3)  # 4x3 grid

    # Fetch all required data, excluding 'Annotations' as it does not fetch data
    all_data = fetch_data_in_bulk(database, rep_values, generations)

    for i, gen in enumerate(generations):
        # Determine the position of the current plot
        row = i // 3
        col = i % 3
        ax = plt.subplot(gs[row, col])
        ax.grid(True, color='lightgrey', linestyle='dotted', linewidth=0.15)


        gen_data = all_data[all_data['gen'] == gen].copy()

        # Explicit handling of future deprecation and type issues
        pd.set_option('future.no_silent_downcasting', True)
        pivot_y = gen_data.pivot(index="y", columns="z", values="3tot_y").fillna(0).infer_objects(copy=False)
        pivot_z = gen_data.pivot(index="y", columns="z", values="3tot_z").fillna(0).infer_objects(copy=False)

        def scale_data(y, x):
            with np.errstate(divide='ignore', invalid='ignore'):  # Handle division and invalid operations gracefully
                s_values = 2 * (y / (x + y)) - 1
            s_values[(y == 0) & (x == 0)] = 0  # Explicitly set 0 when both X and Y are zero
            # Also handle the case where X+Y == 0 but not both are zero (if necessary)
            s_values[np.isinf(s_values)] = 0  # Replace infinity (result from division by zero when not both are zero)
            return s_values


        scaled_data = scale_data(pivot_y, pivot_z)

        
        if not gen_data.empty:
            sns.heatmap(scaled_data, cmap="RdBu_r", center=0, ax=ax, mask=np.isnan(scaled_data), vmin=-1, vmax=1)
        else:
            ax.text(0.5, 0.5, 'No data available', ha='center', va='center')
            ax.set_xlim(0, 1)
            ax.set_ylim(0, 1)

        ax.set_title(r'Gen ${}$'.format(gen), fontsize=20)
        ax.set_xlabel(r'Bias 1 TE', fontsize=20,)
        ax.set_ylabel(r'Bias 2 TE' if col == 0 else "", fontsize=20)
        ax.invert_yaxis()
        



    # Add explanatory subplot with Markdown-styled text
    ax = plt.subplot(gs[3, 2])
    ax.axis('off')
    ax.set_title('Scale and Color Code Explanation', fontsize=20)
    

    annotations = r"""
        \textbf{Scale:} \( S = 2 \cdot \frac{Y}{X+Y} - 1 \) \\
        \textbf{Near -1:} when \( X\ (Bias\ 1) \) dominates (Blue) \\
        \textbf{Near 1:} when \( Y\ (Bias\ 2) \) dominates (Red) \\
        \textbf{Near 0:} when neither dominates (White) \\
        \textbf{Exactly 0:} when both are zero (Grey Dot)
        """
    ax.text(0.1, 0.5, annotations, ha='left', va='center', fontsize=20, color='black', style='italic')


    plt.tight_layout()
    plt.savefig(output_file)



if __name__ == '__main__':
    databases = ['reStormAll3.duckdb']#, 'storm2_invasion.duckdb', 'storm3_invasion.duckdb']
    files = ['reStormAll3.pdf']#, 'averaged_insertion_plot2.pdf', 'averaged_insertion_plot3.pdf']

    for db, file in zip(databases, files):
        plot_data(db, file)
