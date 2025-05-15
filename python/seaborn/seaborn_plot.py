# seaborn_plot.py

import seaborn as sns
import matplotlib.pyplot as plt

# Load example dataset
df = sns.load_dataset("penguins")

# Create a simple seaborn scatter plot
sns.set(style="whitegrid")
plot = sns.scatterplot(data=df, x="bill_length_mm", y="bill_depth_mm", hue="species")

# Save the plot
plt.title("Penguin Bill Dimensions")
plt.savefig("penguin_plot.png")
print("Plot saved as penguin_plot.png")
