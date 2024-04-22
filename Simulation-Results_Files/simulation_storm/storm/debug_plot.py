import re
import pandas as pd
import duckdb
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import gridspec

# Set up the regular expression pattern for data parsing
pattern = re.compile(r'([0-9.-]+)\((-?[0-9]+)\)')

plt.rcParams.update({
    "text.usetex": True,
    "font.family": "serif",
    "font.serif": ["Computer Modern Roman"],
    "font.size": 14
})

def parse_3tot(df, y_col_series, z_col_series):
    def extract_values(series):
        y_vals = pd.Series([np.nan] * len(series))
        z_vals = pd.Series([np.nan] * len(series))
        for i, cell in enumerate(series):
            if isinstance(cell, str):
                parts = cell.split(',')
                for part in parts:
                    match = pattern.match(part)
                    if match:
                        value, key = float(match.group(1)), int(match.group(2))
                        if key == y_col_series[i]:
                            y_vals[i] = value
                        elif key == z_col_series[i]:
                            z_vals[i] = value
        return y_vals, z_vals

    y_vals, z_vals = extract_values(df['3tot'])
    return df.assign(tot_y=y_vals, tot_z=z_vals)

def fetch_and_process_data(database, gen):
    print(f"Fetching data for generation {gen} from {database}")
    conn = duckdb.connect(database=database, read_only=True)
    query = f"""
        SELECT y, z, "3tot", gen
        FROM simulations
        WHERE gen = {gen} AND y BETWEEN -50 AND -43 AND z BETWEEN 47 AND 50

        ORDER BY gen;
    """
    df = conn.execute(query).fetch_df()
    if not df.empty:
        parsed_data = parse_3tot(df, df['y'], df['z'])
        # Directly using the parsed data without mean aggregation
        print("Data for current generation:")
        print(parsed_data[['y', 'z', 'tot_y', 'tot_z']])
        return parsed_data
    return pd.DataFrame()

def scale_data(pivot_y, pivot_z):
    s_values = np.where(pivot_z + pivot_y != 0, 2 * (pivot_y / (pivot_z + pivot_y)) - 1, 0)
    print("Scaled values:\n", s_values)
    return pd.DataFrame(s_values, index=pivot_y.index, columns=pivot_y.columns)

def plot_data(database, output_file):
    plt.figure(figsize=(22, 18))
    gs = gridspec.GridSpec(4, 3)
    generations = [1, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]

    for i, gen in enumerate(generations):
        ax = plt.subplot(gs[i // 3, i % 3])
        gen_data = fetch_and_process_data(database, gen)

        if not gen_data.empty:
            print(f"Gen {gen} - tot_y and tot_z values:")
            print(gen_data[['y', 'z', 'tot_y', 'tot_z']])
            pivot_y = gen_data.pivot(index='y', columns='z', values='tot_y').fillna(0)
            pivot_z = gen_data.pivot(index='y', columns='z', values='tot_z').fillna(0)
            scaled_data = scale_data(pivot_y, pivot_z)
            sns.heatmap(scaled_data, cmap="RdBu_r", center=0, ax=ax, vmin=-1, vmax=1)

        ax.set_title(f'Gen {gen}', fontsize=20)
        ax.set_xlabel('Bias 1 TE', fontsize=20)
        ax.set_ylabel('Bias 2 TE' if (i % 3 == 0) else "", fontsize=20)
        ax.invert_yaxis()
        ax.grid(True, color='lightgrey', linestyle='dotted', linewidth=0.15)

    plt.tight_layout()
    plt.savefig(output_file)
    print(f"Saved plot to {output_file}")

if __name__ == '__main__':
    database = 'reStorm1.duckdb'
    output_file = 'debug_reStorm1.pdf'
    plot_data(database, output_file)
