import matplotlib.pyplot as plt
import math
import random

def get_rand_clusters():
    lower_limit = 0  # Lower bound
    upper_limit = math.log10(1e+4)  # Upper bound, note the cluster size is in kb
    r = math.floor(10**random.uniform(lower_limit, upper_limit))
    return f"{r},{r},{r},{r},{r}"

# Generate data
data = []
for _ in range(1000):
    clusters = get_rand_clusters().split(',')
    data.extend([int(x) for x in clusters])

# Plotting
plt.hist(data, bins=50, edgecolor='black')
plt.xlabel('Cluster Size (kb)')
plt.ylabel('Frequency')
plt.title('Distribution of Random Cluster Sizes')
plt.show()
