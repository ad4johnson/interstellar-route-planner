from fastapi import FastAPI
import joblib
import numpy as np

app = FastAPI()

model = joblib.load('anomaly_detector.pkl')  # Placeholder for trained model

@app.get("/predict")
def predict(features: list):
    prediction = model.predict([features])
    return {"prediction": "anomaly" if prediction[0] == -1 else "normal"}