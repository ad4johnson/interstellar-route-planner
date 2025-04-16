import joblib
import numpy as np
import pandas as pd

class AnomalyDetector:
    def __init__(self, model_path="models/anomaly_detector.pkl"):
        try:
            self.model = joblib.load(model_path)
        except FileNotFoundError:
            raise FileNotFoundError(f"Model file not found at {model_path}. Please check the path.")
        except Exception as e:
            raise RuntimeError(f"An error occurred while loading the model: {e}")
        self.feature_names = getattr(
            self.model, "feature_names_in_", [f"feature_{i}" for i in range(38)]
        )

    def detect(self, data: np.ndarray):
        df = pd.DataFrame(data, columns=self.feature_names)
        preds = self.model.predict(df)
        return [i for i, val in enumerate(preds) if val == -1]