import concurrent.futures
import polars as pl
import duckdb
import os
import sys
import re
from tqdm.auto import tqdm

# Configuration and patterns
folder_path = '/storehouse/shashank/validinvadego/reStormAll3'
filename_pattern = re.compile(r'output_sample_(\d+)_(-?\d+)_(-?\d+).txt')
header_pattern = re.compile(r'Invade:.*seed: (\d+)|#')

# Column configurations
column_names = [
    "rep", "gen", "popstat", "spacer_1", "fwte", "avw", "min_w", "avtes", "avpopfreq",
    "fixed", "spacer_2", "phase", "fwcli", "avcli", "fixcli", "spacer_3", "avbias",
    "3tot", "3cluster"]#, "spacer_4", "sampleid"]

# Define which columns are expected to be of which type
int_columns = ["rep", "gen", "fixed", "fixcli"]
float_columns = ["fwte", "avw", "min_w", "avtes", "avpopfreq", "fwcli", "avcli", "avbias"]

total_columns = ['x', 'y', 'z', 'seed'] + column_names

def parse_file(full_file_path):
    file_path = os.path.basename(full_file_path)
    match = filename_pattern.search(file_path)
    if not match:
        return None, f"Filename pattern not matched: {file_path}"

    x, y, z, seed = match.groups() + (None,)  # Ensure there are always at least 4 items
    data = []

    with open(full_file_path, 'r') as file:
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
                    parsed_row = [int(x), int(y), int(z), int(seed)]
                    for i, part in enumerate(parts):
                        column_name = column_names[i]
                        if column_name in int_columns and part:
                            parsed_row.append(int(part))
                        elif column_name in float_columns and part:
                            parsed_row.append(float(part))
                        else:
                            parsed_row.append(part)  # Keeping as string if not in int or float columns
                    data.append(parsed_row)
                except ValueError as e:
                    return None, f"Type conversion error in {file_path}: {e}"

    if not data:
        return None, f"No valid data found in: {file_path}"

    df = pl.DataFrame(data, schema=total_columns)
    return df, None

def insert_into_duckdb(dfs):
    conn = duckdb.connect(database='reStormAll3.duckdb', read_only=False)
    try:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS simulations (
                x INTEGER, y INTEGER, z INTEGER, seed BIGINT,
                rep INTEGER, gen INTEGER, popstat VARCHAR, spacer_1 VARCHAR,
                fwte FLOAT, avw FLOAT, min_w FLOAT, avtes FLOAT, avpopfreq FLOAT,
                fixed INTEGER, spacer_2 VARCHAR, phase VARCHAR, fwcli FLOAT,
                avcli FLOAT, fixcli INTEGER, spacer_3 VARCHAR, avbias FLOAT,
                "3tot" VARCHAR, "3cluster" VARCHAR
            )
        """)

        for df in dfs:
            pandas_df = df.to_pandas()
            conn.from_df(pandas_df).insert_into("simulations")
    finally:
        conn.close()

# Process files
files = [os.path.join(folder_path, f) for f in os.listdir(folder_path) if (f.endswith('.txt') and f.startswith('output_sample'))]
num_cpus = os.cpu_count() or 4  # Fallback to 4 if os.cpu_count() returns None
max_workers = min(64, num_cpus)

dfs_to_insert = []
with tqdm(total=len(files), desc="Parsing files", unit="file") as pbar:
    with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(parse_file, file) for file in files]
        for future in tqdm(concurrent.futures.as_completed(futures), total=len(files), desc="Processing", unit="file"):
            df, error = future.result()
            if df is not None:
                dfs_to_insert.append(df)
            elif error:
                print(error, file=sys.stderr)
            pbar.update(1)

# Insert data into DuckDB
insert_into_duckdb(dfs_to_insert)
