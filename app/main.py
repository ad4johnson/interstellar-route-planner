from fastapi import FastAPI, APIRouter, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from prometheus_fastapi_instrumentator import Instrumentator
from app.route import gates, anomaly
from app.utils import dijkstra
from app.anomaly_detection.detection import AnomalyDetector
import os
import json
from app.utils import fetch_graph
import threading
import psycopg2
from psycopg2 import OperationalError
from typing import List
import numpy as np
from dotenv import load_dotenv
from prometheus_client import Gauge


# ========================
# Metrics & Monitoring
# ========================
ANOMALY_DETECTED = Gauge("anomaly_detected", "1 = anomaly, 0 = normal")
load_dotenv()

app = FastAPI(title="Interstellar Route Planner", version="1.0")
router = APIRouter()
Instrumentator().instrument(app).expose(app)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(gates.router, prefix="/api/v1")
app.include_router(anomaly.router, prefix="/api/v1")

# ========================
# Anomaly Detection Setup
# ========================
class AnomalyInput(BaseModel):
    values: List[List[float]]

detector = AnomalyDetector('models/anomaly_detector.pkl')

@app.post("/anomaly-detection")
def detect_anomalies(data: AnomalyInput):
    try:
        data_array = np.array(data.values)
        anomalies = detector.detect(data_array)
        ANOMALY_DETECTED.set(1 if anomalies else 0)
        return {
            "anomalies_detected": bool(anomalies),
            "anomaly_indices": anomalies if anomalies else [],
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Anomaly detection failed: {str(e)}")

# Optional: simulate anomaly detection to populate metrics
def anomaly_ping_loop():
    import time
    while True:
        # Example input with 38 features
        detect_anomalies(AnomalyInput(values=[[0.1] * 38]))
        time.sleep(10)

threading.Thread(target=anomaly_ping_loop, daemon=True).start()

print("🚀 Application started with AnomalyDetector version: detect() present")

# ========================
# Database Connection
# ========================
def get_database_url():
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT", "5432")
    name = os.getenv("DB_NAME")
    return f"postgresql://{user}:{password}@{host}:{port}/{name}"

DATABASE_URL = os.getenv("DATABASE_URL", get_database_url())

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
except OperationalError as e:
    print("Database connection failed:", e)
    cursor = None

# ========================
# API Endpoints
# ========================
@app.get("/")
def root():
    return {"message": "Interstellar API is live!"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/api")
def api_root():
    return {"message": "Interstellar API is live!"}

@app.get("/gates")
def get_gates():
    if not cursor:
        return {"error": "Database connection failed"}
    cursor.execute("SELECT id, name FROM gate;")
    result = cursor.fetchall()
    return [{"id": row[0], "name": row[1]} for row in result]

@app.get("/gates/{gateCode}")
def get_gate(gateCode: str):
    if not cursor:
        return {"error": "Database connection failed"}
    cursor.execute("SELECT * FROM gate WHERE id = %s;", (gateCode,))
    gate = cursor.fetchone()
    if gate:
        return {"id": gate[0], "name": gate[1], "connections": json.loads(gate[2])}
    return {"error": "Gate not found"}

import traceback

@app.get("/gates/{gateCode}/to/{targetGateCode}")
def get_cheapest_route(gateCode: str, targetGateCode: str):
    try:
        path, cost = dijkstra(gateCode, targetGateCode)
        if path:
            return {"route": path, "total_cost": cost}
        return {"error": "Route not found"}
    except Exception as e:
        print("❌ Routing exception:", e)
        traceback.print_exc()  # <-- get full stack trace in CloudWatch logs
        return {"error": f"Routing failed: {str(e)}"}

@app.post("/api/data")
async def receive_data(request: Request):
    data = await request.json()
    return {"received": data}

@router.get("/routes")
async def get_routes():
    return {"routes": ["Route1", "available"]}

# ========================
# Local Debug
# ========================
# @app.get("/debug/graph")
def debug_graph():
    from app.utils import fetch_graph
    graph = fetch_graph()
    return graph

@app.get("/debug/graph")
def debug_graph():
    return fetch_graph()
    print("🚀 Application started with AnomalyDetector version: detect() present")

# ========================
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)