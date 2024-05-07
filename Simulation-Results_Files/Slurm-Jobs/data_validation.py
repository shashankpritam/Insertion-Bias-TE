import duckdb

def fetch_data(query):
    conn = duckdb.connect(database="fitness.duckdb", read_only=True)
    return conn.execute(query).fetch_df()

# Query to fetch generation 5000 data for bar plots
query_bar = """
WITH data AS (
    SELECT sampleid, gen, AVG(min_w) AS avg_min_w, STDDEV(min_w) AS stddev_min_w, AVG(avw) AS avg_avw, STDDEV(avw) AS stddev_avw
    FROM simulations
    WHERE sampleid IN ('b50', 'b0', 'bm50') AND popstat = 'ok' AND gen = 5000
    GROUP BY sampleid, gen
    ORDER BY sampleid
)
SELECT * FROM data;
"""
data_bar = fetch_data(query_bar)

# Query to fetch generation 5000 data for line plots (needs to be adjusted to ensure it matches)
query_line = """
WITH data AS (
    SELECT sampleid, gen, AVG(min_w) AS avg_min_w, STDDEV(min_w) AS stddev_min_w, AVG(avw) AS avg_avw, STDDEV(avw) AS stddev_avw
    FROM simulations
    WHERE sampleid IN ('b50', 'b0', 'bm50') AND popstat = 'ok' AND gen = 5000
    GROUP BY sampleid, gen
    ORDER BY sampleid
)
SELECT * FROM data;
"""
data_line = fetch_data(query_line)

print("Data from Bar Plot Script:\n", data_bar)
print("Data from Line Plot Script:\n", data_line)
