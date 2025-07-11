#!/usr/bin/env python3
"""Simple helper script to preview the first 5 rows of the `simulations` table
from a DuckDB database. Usage:

    python inspect_duckdb.py /path/to/database.duckdb

This prints the first five rows to stdout.
"""
import sys
import os
import duckdb
import pandas as pd
import re


def unique_pairs(db_path: str):
    """Print unique (y, z) pairs in the simulations table as whitespace-separated lines."""
    query = "SELECT DISTINCT y, z FROM simulations ORDER BY y, z;"
    with duckdb.connect(database=db_path, read_only=True) as conn:
        df = conn.execute(query).fetch_df()
    for _, row in df.iterrows():
        print(f"{int(row['y'])} {int(row['z'])}")


def preview_duckdb(db_path: str, n: int = 5) -> None:
    if not os.path.exists(db_path):
        sys.stderr.write(f"Error: file not found: {db_path}\n")
        sys.exit(1)

    query = "SELECT * FROM simulations LIMIT ?;"
    with duckdb.connect(database=db_path, read_only=True) as conn:
        df = conn.execute(query, [n]).fetch_df()
    print(df)


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Generate a heatmap from DuckDB simulation data.")
    parser.add_argument("duckdb", help="Path to .duckdb file")
    parser.add_argument("--hide-cbar", dest='show_cbar', action='store_false', help="Hide the color scale bar on the plot.")
    args = parser.parse_args()

    db_path = args.duckdb
    import matplotlib.pyplot as plt
    import seaborn as sns
    import numpy as np

    agg_rows = []  # store aggregated rows for heatmap
    with duckdb.connect(database=db_path, read_only=True) as conn:
        pairs = conn.execute("SELECT DISTINCT y, z FROM simulations ORDER BY y, z;").fetchall()
        for y, z in pairs:
            # fetch last available generation (<=500) per replicate
            df_pair = conn.execute(
                """
                WITH last AS (
                    SELECT rep, max(gen) AS last_gen
                    FROM simulations
                    WHERE y=? AND z=? AND gen<=500
                    GROUP BY rep
                )
                SELECT DISTINCT s.rep, s.gen, s."3tot" AS tot_vals
                FROM simulations s
                JOIN last l ON s.rep = l.rep AND s.gen = l.last_gen
                WHERE s.y=? AND s.z=?
                ORDER BY s.rep;
                """,
                [y, z, y, z],
            ).fetch_df()
            # remove any accidental duplicate rows
            df_pair = df_pair.drop_duplicates(subset=['rep', 'gen'])
            n_rep = df_pair['rep'].nunique()
            expected_reps = 100


            # parse tot_vals values in order (y, z)
            pattern = re.compile(r'([0-9.]+)\((-?[0-9]+)\)')
            parsed_vals = []
            for tot_str in df_pair['tot_vals']:
                matches = pattern.findall(tot_str)
                bias_map = {int(bias): float(val) for val, bias in matches}
                val_y = bias_map.get(int(y), float('nan'))
                val_z = bias_map.get(int(z), float('nan'))
                parsed_vals.append((val_y, val_z))
            df_pair[['val_y', 'val_z']] = pd.DataFrame(parsed_vals, index=df_pair.index)

            # compute S scale
            df_pair['S'] = 2 * df_pair['val_y'] / (df_pair['val_y'] + df_pair['val_z'] + 1e-9) - 1
            # compute aggregate stats across replicates
            n_rep = len(df_pair)
            mean_y = df_pair['val_y'].mean()
            mean_z = df_pair['val_z'].mean()
            mean_S = df_pair['S'].mean()
            sd_S = df_pair['S'].std(ddof=0)
            sd_y = df_pair['val_y'].std(ddof=0)
            sd_z = df_pair['val_z'].std(ddof=0)

            # completeness check (gens expected 501: 0..500)
            comp_df = conn.execute(
                "SELECT rep, COUNT(DISTINCT gen) AS n_gen FROM simulations WHERE y=? AND z=? GROUP BY rep HAVING COUNT(DISTINCT gen)<>501;",
                [y, z],
            ).fetch_df()
            if not comp_df.empty:
                missing_reps = comp_df['rep'].tolist()
                print(f"[!] Pair {int(y)} {int(z)} missing gens in reps: {missing_reps}")
            # collect for heatmap
            agg_rows.append((int(y), int(z), mean_S))
            # separator
            # print("-"*60)


    # === Plot heatmap from aggregated S values ===
    if agg_rows:
        heatmap_df = pd.DataFrame(agg_rows, columns=["bias_low", "bias_high", "S"])
        pivot = heatmap_df.pivot(index="bias_low", columns="bias_high", values="S")

        # --- Font & Style Settings ---
        plt.rcParams['font.family'] = 'sans-serif'
        plt.rcParams['font.sans-serif'] = ['Helvetica', 'Arial'] # Prioritize Helvetica, fallback to Arial
        plt.rcParams['font.size'] = 20 # Adjust font size if needed

        plt.figure(figsize=(10, 8), dpi=300)
        cmap = 'RdBu_r'
        cbar_kws = {
            "shrink": 1.0,  # Make scale height match y-axis
            "aspect": 10    # Aspect ratio: lower is wider
        }
        ax = sns.heatmap(pivot, cmap=cmap, vmin=-1, vmax=1, square=True, annot=False, 
                         cbar=args.show_cbar, cbar_kws=cbar_kws if args.show_cbar else None)
        
        ax.invert_yaxis()
        plt.xticks(rotation=45, ha='right') # Rotate x-axis labels
        plt.xlabel("Bias 1 TE")
        plt.ylabel("Bias 2 TE")

        if args.show_cbar:
            cbar = ax.collections[0].colorbar
            cbar.ax.tick_params(labelsize=24) # Increase font size on scale
            cbar.set_label('', rotation=270, labelpad=15)
        out_pdf = os.path.splitext(os.path.basename(db_path))[0] + "_heatmap.pdf"
        plt.savefig(out_pdf, format="pdf", bbox_inches="tight")
        plt.close()

if __name__ == "__main__":
    main()
