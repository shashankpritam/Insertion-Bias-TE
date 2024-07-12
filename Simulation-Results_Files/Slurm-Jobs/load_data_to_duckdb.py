import concurrent.futures
import polars as pl
import duckdb
import os
import re
import sys

# Configuration and patterns
header_pattern = re.compile(r'Invade:.*seed: (\d+)|#')

# Column configurations
column_names = [
    "rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
    "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias",
    "3tot", "3cluster", "spacer_4", "sampleid"]
int_columns = ["rep", "gen", "fixed", "fixcli"]
float_columns = ["fwte", "avw", "min_w", "avtes", "avpopfreq", "fwcli", "avcli", "avbias"]

def parse_file(full_file_path):
    data = []
    with open(full_file_path, 'r') as file:
        seed = None
        for line in file:
            seed_match = header_pattern.search(line)
            if seed_match and not seed:
                seed = seed_match.group(1)
                continue
            if line.startswith('#') or "Invade:" in line:
                continue
            parts = line.strip().split('\t')
            if len(parts) == len(column_names):
                try:
                    parsed_row = [int(seed)] if seed else []
                    for i, part in enumerate(parts):
                        column_name = column_names[i]
                        if column_name in int_columns and part:
                            parsed_row.append(int(part))
                        elif column_name in float_columns and part:
                            parsed_row.append(float(part))
                        else:
                            parsed_row.append(part)
                    data.append(parsed_row)
                except ValueError as e:
                    print(f"Type conversion error in {full_file_path}: {e}", file=sys.stderr)

    if not data:
        print(f"No valid data found in: {full_file_path}", file=sys.stderr)
        return None
    df = pl.DataFrame(data, schema=column_names)
    return df

def insert_into_duckdb(dfs):
    conn = duckdb.connect(database='/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/fitness_ncs_2/fitness_ncs2.duckdb', read_only=False)
    try:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS simulations (
                rep INTEGER, gen INTEGER, popstat VARCHAR, spacer_1 VARCHAR,
                fwte FLOAT, avw FLOAT, min_w FLOAT, avtes FLOAT, avpopfreq FLOAT,
                fixed INTEGER, spacer_2 VARCHAR, phase VARCHAR, fwcli FLOAT,
                avcli FLOAT, fixcli INTEGER, spacer_3 VARCHAR, avbias FLOAT,
                "3tot" VARCHAR, "3cluster" VARCHAR, spacer_4 VARCHAR, sampleid VARCHAR)
        """)
        for df in dfs:
            if df is not None:
                conn.from_df(df.to_pandas()).insert_into("simulations")
    finally:
        conn.close()

def main():
    files = ["/Users/shashankpritam/github/Insertion-Bias-TE/Simulation-Results_Files/simulation_storm/fitness_ncs_2/fitness_Simulation_exploration.txt"]
    num_cpus = os.cpu_count() or 4
    max_workers = min(2, num_cpus)
    dfs_to_insert = []

    with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers) as executor:
        futures = {executor.submit(parse_file, file): file for file in files}
        for future in concurrent.futures.as_completed(futures):
            df = future.result()
            if df is not None:
                dfs_to_insert.append(df)

    insert_into_duckdb(dfs_to_insert)

if __name__ == '__main__':
    main()
