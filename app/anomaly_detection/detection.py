import joblib
import numpy as np
import pandas as pd

class AnomalyDetector:
    def __init__(self, model_path: str = "models/anomaly_detector.pkl"):
        self.model = joblib.load(model_path)
        self.feature_names = self.model.feature_names_in_

    def detect(self, data: np.ndarray):
        if isinstance(data, np.ndarray):
            if data.shape[1] != len(self.feature_names):
                raise ValueError(f"Expected {len(self.feature_names)} features, but got {data.shape[1]}")

            data = pd.DataFrame(data, columns=self.feature_names)

            prediction = self.model.predict(data)
            anomalies = [i for i, val in enumerate(prediction) if val == -1]
            return anomalies