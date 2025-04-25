import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load dataset
train_df = pd.read_csv("data/Train_data.csv")


# Set plot style
sns.set(style="whitegrid")

# --- 1. Class Distribution ---
plt.figure(figsize=(10, 6))
sns.countplot(data=train_df, x='class', order=train_df['class'].value_counts().index)
plt.title("Figure X: Class Distribution (Normal vs Attack)")
plt.xlabel("Class Label")
plt.ylabel("Count")
plt.xticks(rotation=45)
plt.tight_layout()

# Create the 'figures' directory if it doesn't exist
os.makedirs("figures", exist_ok=True) 

plt.savefig("figures/class_distributions.png") # Now saves to the created directory
plt.show()

# --- 2. Feature Correlation Heatmap (Numerical Features) ---
numeric_features = train_df.select_dtypes(include=['int64', 'float64'])
plt.figure(figsize=(14, 12))
corr = numeric_features.corr()
sns.heatmap(corr, annot=False, cmap='coolwarm', linewidths=0.5)
plt.title("Figure X: Correlation Heatmap of Numerical Features")
plt.tight_layout()
plt.savefig("figures/correlation_heatmap.png")
plt.show()

# --- 3. Boxplot of src_bytes per class ---
plt.figure(figsize=(10, 6))
sns.boxplot(data=train_df, x='class', y='src_bytes')
plt.title("Figure X: Source Bytes Distribution by Class")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("figures/src_bytes_boxplot.png")
plt.show()

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("data/Train_data.csv")

plt.figure(figsize=(14, 6))
sns.countplot(data=df, x='class', order=df['class'].value_counts().index)
plt.xticks(rotation=45)
plt.title("Distribution of Original Classes")
plt.xlabel("Attack Type / Normal")
plt.ylabel("Count")
plt.tight_layout()
plt.savefig("figures/original_class_distribution.png")
plt.show()
