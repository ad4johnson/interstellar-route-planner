from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import pandas as pd
from app.anomaly_detection.detection import AnomalyDetector
from app.database import get_db_connection, get_gates_from_db  # Ensure these are defined

router = APIRouter()
detector = AnomalyDetector()

# Request validation model
class AnomalyRequest(BaseModel):
    data: list[dict]

@router.get("/health")
def health_check():
    return {"status": "ok"}


@router.post("/anomaly")
def detect_anomalies(payload: AnomalyRequest):
    try:
        df = pd.DataFrame(payload.data)
        results = detector.predict(df)
        return {"anomalies": results.tolist()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")


@router.get("/gates")
def get_gates():
    try:
        gates = get_gates_from_db()
        if not gates:
            raise HTTPException(status_code=404, detail="No gates found")
        return {"gates": [{"id": k, "name": v["name"]} for k, v in gates.items()]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")