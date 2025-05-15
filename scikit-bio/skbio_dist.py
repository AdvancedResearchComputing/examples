# test_skbio.py

from skbio.stats.distance import DistanceMatrix
from skbio.stats.distance import permanova
import numpy as np

# Create a small distance matrix
ids = ['A', 'B', 'C']
data = np.array([
    [0.0, 0.5, 0.75],
    [0.5, 0.0, 0.25],
    [0.75, 0.25, 0.0]
])

dm = DistanceMatrix(data, ids)

# Perform a simple PERMANOVA (Permutational Multivariate Analysis of Variance)
grouping = ['Group1', 'Group1', 'Group2']

result = permanova(dm, grouping, permutations=99)

print(result)
