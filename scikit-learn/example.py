# Import necessary libraries
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# Step 1: Load the Iris dataset
iris = load_iris()
X = iris.data  # features (flower measurements)
y = iris.target  # labels (species)

# Step 2: Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Step 3: (Optional but good practice) Scale the features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Step 4: Train a simple Logistic Regression model
model = LogisticRegression()
model.fit(X_train_scaled, y_train)

# Step 5: Make predictions on the test set
y_pred = model.predict(X_test_scaled)

# Step 6: Evaluate the model
accuracy = accuracy_score(y_test, y_pred)
print(f"Accuracy on test set: {accuracy:.2f}")

# Bonus: Predict on a new sample
import numpy as np
sample = np.array([[5.1, 3.5, 1.4, 0.2]])  # Example flower measurements
sample_scaled = scaler.transform(sample)
prediction = model.predict(sample_scaled)
print(f"Predicted class for sample flower: {iris.target_names[prediction[0]]}")
