# import matplotlib.pyplot as plt
# import pandas as pd
import numpy as np
import statsmodels.api as sm
import argparse
import time


begin_time = time.time()


# Define the parser.
parser = argparse.ArgumentParser(description='For output filename.')

# Declare an argument (`--algo`), saying that the
# corresponding value should be stored in the `algo`
# field, and using a default value if the argument
# isn't given
parser.add_argument('--outfile', action="store", dest='outfile', type=str, default=0)

# Now, parse the command line arguments and store the
# values in the `args` variable
args = parser.parse_args()

# Individual arguments can be accessed as attributes.
outfile=args.outfile

# Seed for reproducibility.
np.random.seed(9876789)


# Generate the data.
nsample = 100
x = np.linspace(0, 10, 100)
X = np.column_stack((x, x ** 2))
beta = np.array([1, 0.1, 10])
e = np.random.normal(size=nsample)

# Add the intercept for the model.
X = sm.add_constant(X)
y = np.dot(X, beta) + e

# Open output file.
# Write to file.
fhout=open(outfile,"w")


# Compute model.
model = sm.OLS(y, X)
results = model.fit()
## print(results.summary())
fhout.write( str( results.summary() ) )
fhout.write("\n")
fhout.write(" \n")
fhout.write(" \n")


# Output results.
## print("Parameters: ", results.params)
## print("R2: ", results.rsquared)
fhout.write("Parameters: \n")
fhout.write( str(results.params)  )
fhout.write("\n")
fhout.write(" \n")
fhout.write(" \n")
fhout.write("R2: \n")
fhout.write(   str(results.rsquared)  )
fhout.write("\n")

# Close output file.
fhout.close()


end_time = time.time()

delta_time = end_time - begin_time

print("  execution time (s): ",delta_time)

