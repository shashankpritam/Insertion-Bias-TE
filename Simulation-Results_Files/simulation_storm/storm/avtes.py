import concurrent.futures
import numpy as np
import matplotlib.pyplot as plt
import duckdb
import pandas as pd
import datetime

def parse_3tot(value):
    """Parse the '3tot' field from the database."""
    return float(value.split(',')[0].split('(')[0]) if value else 0

def fetch_data_in_bulk():
    """Fetch all relevant data in one go to minimize database connections."""
    query = """
    SELECT y, z, "3tot"
    FROM simulations
    WHERE z > y;
    """
    with duckdb.connect(database='storm2_invasion.duckdb', read_only=True) as conn:
        df = conn.execute(query).df()
    return df

def process_data(df, y, z):
    """Process data for a specific y and z from the pre-fetched DataFrame."""
    # Creating a new DataFrame to avoid SettingWithCopyWarning
    df_subset = df[(df['y'] == y) & (df['z'] == z)].copy()
    if not df_subset.empty:
        # Use .loc to ensure changes are made on the DataFrame directly
        df_subset['avg_3tot'] = df_subset['3tot'].apply(parse_3tot)
        avg_3tot = df_subset['avg_3tot'].mean()
    else:
        avg_3tot = np.nan
    return y, z, avg_3tot

if __name__ == '__main__':
    # Pre-fetch data
    df = fetch_data_in_bulk()

    results = []
    unique_yz_pairs = [(y, z) for y in range(-50, 51) for z in range(-50, 51) if z > y]

    # Process data in parallel
    with concurrent.futures.ThreadPoolExecutor(max_workers=64) as executor:
        futures = [executor.submit(process_data, df, y, z) for y, z in unique_yz_pairs]

        for future in concurrent.futures.as_completed(futures):
            try:
                results.append(future.result())
            except Exception as exc:
                print(f'Exception occurred: {exc}')

    # Convert results to DataFrame
    results_df = pd.DataFrame(results, columns=['y', 'z', 'avg_3tot'])

    # Visualization
    heatmap_data = np.full((101, 101), np.nan)
    for y, z, avg_3tot in results:
        heatmap_data[y + 50, z + 50] = avg_3tot

    plt.figure(figsize=(12, 10))
    plt.imshow(heatmap_data, cmap='viridis', interpolation='nearest', origin='lower', extent=[-50, 50, -50, 50])
    plt.colorbar(label='Average of avg_3tot')
    plt.xlabel('y')
    plt.ylabel('z')
    plt.title('Heatmap of Average 3tot Values for (y, z) Pairs')

    # Save the plot
    current_time = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    file_name = f"{current_time}_3tot_heatmap.png"
    plt.savefig(file_name)

