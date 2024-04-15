import re
import pandas as pd
import duckdb
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import gridspec


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

def fetch_data_in_bulk(database, rep_v, generations):
    print(f"Fetching data from {database}")
    conn = duckdb.connect(database=database, read_only=True)
    all_data = pd.DataFrame()
    
    for gen in generations:
        query = f"""
            SELECT y, z, "3tot", gen
            FROM simulations
            WHERE popstat = 'ok' AND rep = {rep_v} AND gen = {gen}
            ORDER BY gen;
        """
        df = conn.execute(query).fetch_df()
        all_data = pd.concat([all_data, df], ignore_index=True)
        
    return all_data

def main():
    database = 'storm3_invasion.duckdb'
    rep_value = 2
    generations = [0, 500, 1000, 1500, 2000, 3000, 4000, 4500, 5000]
    
    all_data = fetch_data_in_bulk(database, rep_value, generations)
    prepared_data = parse_3tot(all_data, all_data['y'], all_data['z'])

    plt.figure(figsize=(20, 10))
    gs = gridspec.GridSpec(2, len(generations))

    for i, gen in enumerate(generations):
        gen_data = prepared_data[prepared_data['gen'] == gen].copy()  # Ensure it's a copy

        # Ensure data is numeric and handle NaNs
        gen_data['3tot_y'] = pd.to_numeric(gen_data['3tot_y'], errors='coerce').fillna(0)
        gen_data['3tot_z'] = pd.to_numeric(gen_data['3tot_z'], errors='coerce').fillna(0)

        # # Debugging: Print types and check for non-floats
        # print(gen_data['3tot_y'].dtype, gen_data['3tot_z'].dtype)
        # print(gen_data['3tot_y'].isnull().sum(), gen_data['3tot_z'].isnull().sum())  # Check for NaNs
        # print(gen_data[['3tot_y', '3tot_z']].describe())  # Get a summary

        # Pivot data
        pivot_y = gen_data.pivot(index="y", columns="z", values="3tot_y")
        pivot_z = gen_data.pivot(index="y", columns="z", values="3tot_z")

        # Plotting 3tot_y
        ax_y = plt.subplot(gs[0, i])
        sns.heatmap(pivot_y, cmap="viridis", ax=ax_y, cbar=False)
        ax_y.set_title(f'Gen {gen} (3tot_y)')
        ax_y.set_xlabel('')
        ax_y.set_ylabel('')

        # Plotting 3tot_z
        ax_z = plt.subplot(gs[1, i])
        sns.heatmap(pivot_z, cmap="viridis", ax=ax_z, cbar=False)
        ax_z.set_title(f'Gen {gen} (3tot_z)')
        ax_z.set_xlabel('')
        ax_z.set_ylabel('')

    plt.tight_layout()
    plt.savefig('insertion_plot.pdf')

if __name__ == '__main__':
    main()


