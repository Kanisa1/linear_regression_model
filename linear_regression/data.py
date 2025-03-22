import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split

# Step 1: Load the existing dataset
data = pd.read_csv('testing.csv')

# Step 2: Explore and understand the dataset
print("Dataset Info:")
print(data.info())
print("\nDataset Head:")
print(data.head())
print("\nDataset Statistical Summary:")
print(data.describe())

# Step 3: Feature Engineering - Create New Features based on Existing Data
# Example of interaction feature: Age * Height
if 'Age' in data.columns and 'Height' in data.columns:
    data['Age_Height_Interaction'] = data['Age'] * data['Height']

# Example of BMI calculation: Weight / (Height^2)
if 'Weight' in data.columns and 'Height' in data.columns:
    data['BMI'] = data['Weight'] / (data['Height'] ** 2)

# Example: Categorize 'Age' into groups
if 'Age' in data.columns:
    data['Age_Group'] = pd.cut(data['Age'], bins=[0, 18, 35, 50, 100], labels=['Under 18', '18-35', '36-50', '50+'])

# Step 4: Simulate Random Features to Expand the Dataset
num_new_columns = 495  # Adjust based on the current column count
for i in range(num_new_columns):
    data[f'Random_Feature_{i+1}'] = np.random.normal(loc=0, scale=1, size=len(data))  # Random continuous feature

# Step 5: Duplicate Existing Columns to Expand (if necessary)
expanded_data = pd.concat([data] * 100, axis=1)  # Create 500 columns by repeating the dataset

# Renaming columns to maintain clarity
expanded_data.columns = [f'Feature_{i+1}' for i in range(500)]

# Step 6: Validate the Expanded Dataset
# Correlation matrix to check feature relationships
plt.figure(figsize=(10, 8))
sns.heatmap(data.corr(), annot=True, cmap='coolwarm', fmt='.2f', linewidths=0.5)
plt.title('Correlation Matrix of Original Dataset')
plt.show()

# Step 7: Preprocessing - Handle Missing Values (if any)
expanded_data.fillna(expanded_data.mean(), inplace=True)  # Filling missing values with the mean for simplicity

# Step 8: Split Data into Features (X) and Target (y)
# Assuming the target column is named 'Target_Column', change it to your actual target column name
if 'Target_Column' in expanded_data.columns:
    X = expanded_data.drop(columns=['Target_Column'])
    y = expanded_data['Target_Column']
else:
    X = expanded_data  # If there is no target column, use the entire data for training
    y = None  # No target variable for unsupervised learning

# Step 9: Split Data into Training and Testing Sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

print("\nTraining Data Shape:", X_train.shape)
print("Testing Data Shape:", X_test.shape)

# Step 10: Export the Expanded Dataset
expanded_data.to_csv('expanded_testing.csv', index=False)

print("\nExpanded dataset saved as 'expanded_testing.csv'.")

# Optional: View the first few rows of the expanded dataset
print("\nExpanded Data Sample:")
print(expanded_data.head())
