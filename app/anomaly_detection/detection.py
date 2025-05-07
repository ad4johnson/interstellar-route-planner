import joblib
import numpy as np
import pandas as pd

class AnomalyDetector:
    """
    AnomalyDetector loads a pre-trained model (and optional scaler) 
    to predict anomalies in incoming data.
    """

    def __init__(self, model_path="models/anomaly_detector.pkl", scaler_path="models/scaler.pkl"):
        # Load anomaly detection model
        try:
            self.model = joblib.load(model_path)
            print(f"✅ Anomaly detection model loaded from {model_path}")
        except FileNotFoundError:
            raise FileNotFoundError(f"❗ Model file not found at {model_path}. Please check the path.")
        except Exception as e:
            raise RuntimeError(f"❗ An error occurred while loading the model: {e}")

        # Load scaler if available
        try:
            self.scaler = joblib.load(scaler_path)
            print(f"✅ Scaler loaded from {scaler_path}")
        except FileNotFoundError:
            self.scaler = None
            print("ℹ️ No scaler found, proceeding without scaling.")

        # Feature names (fallback to generic names if not available)
        self.feature_names = getattr(
            self.model, "feature_names_in_", [f"feature_{i}" for i in range(38)]
        )

    def detect(self, data: np.ndarray) -> list:
        """
        Detect anomalies in the provided data.

        Args:
            data (np.ndarray): Input features.

        Returns:
            list: Indices of detected anomalies.
        """
        # Prepare dataframe
        df = pd.DataFrame(data, columns=self.feature_names)

        # Scale if scaler is available
        if self.scaler:
            df_scaled = pd.DataFrame(self.scaler.transform(df), columns=self.feature_names)
        else:
            df_scaled = df

        # Predict anomalies (-1 means anomaly)
        preds = self.model.predict(df_scaled)

        # Return indices of anomalies
        anomaly_indices = [i for i, val in enumerate(preds) if val == -1]

        return anomaly_indices