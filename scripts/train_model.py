import pandas as pd
from sklearn.ensemble import IsolationForest
import joblib
import os

def train_anomaly_detector():
    # Dynamically build the absolute path to the dataset
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    data_path = os.path.join(base_dir, "data", "Train_data.csv")

    if not os.path.exists(data_path):
        raise FileNotFoundError(f"❌ Dataset not found at {data_path}")

    # Load dataset with automatic header detection
    df = pd.read_csv(data_path)
    print("📊 Columns in dataset:", df.columns)

    # Preprocessing: Select only numeric columns for model training
    numeric_features = df.select_dtypes(include=["number"])
    print("✅ Selected numeric feature columns:", numeric_features.columns.tolist())

    # Train the Isolation Forest model
    model = IsolationForest(n_estimators=100, contamination=0.05, random_state=42)
    model.fit(numeric_features)

    # Save the model to the models directory
    model_dir = os.path.join(base_dir, "models")
    os.makedirs(model_dir, exist_ok=True)
    model_path = os.path.join(model_dir, "anomaly_detector.pkl")
    joblib.dump(model, model_path)
    print(f"✅ Model trained and saved to {model_path}")

if __name__ == "__main__":
    train_anomaly_detector()