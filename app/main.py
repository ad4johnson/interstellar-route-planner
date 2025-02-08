from fastapi import FastAPI, APIRouter
import os
import psycopg2
import json
from dotenv import load_dotenv
from psycopg2 import OperationalError
import sys
sys.path.append("/app/")
from app.utils import dijkstra


load_dotenv()
app = FastAPI()
router = APIRouter()

@app.get("/health")
def health_check():
    return {"status": "ok"}

@router.get("/routes")
async def get_routes():
    return {"routes": ["Route1", "available"]}


app.include_router(router, prefix="/api/v1")

# Docker ECS PostgreSQL connection settings
DATABASE_URL = os.getenv("DATABASE_URL")

# Establish database connection
try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
except OperationalError as e:
    print("Database connection failed:", e)
    cursor = None  # Prevent crashes if DB is down


@app.get("/")
def root():
    return {"message": "API is running!"}


@app.get("/gates")
def get_gates():
    """Returns a list of all gates"""
    if not cursor:
        return {"error": "Database connection failed"}
    cursor.execute("SELECT id, name FROM gate;")
    gates = cursor.fetchall()
    return [{"id": g[0], "name": g[1]} for g in gates]


@app.get("/gates/{gateCode}")
def get_gate(gateCode: str):
    """Returns the details of a single gate"""
    if not cursor:
        return {"error": "Database connection failed"}
    cursor.execute("SELECT * FROM gate WHERE id = %s;", (gateCode,))
    gate = cursor.fetchone()
    if gate:
        return {"id": gate[0], "name": gate[1], "connections": json.loads(gate[2])}
    return {"error": "Gate not found"}


@app.get("/gates/{gateCode}/to/{targetGateCode}")
def get_cheapest_route(gateCode: str, targetGateCode: str):
    """Finds the cheapest route between two gates"""
    path, cost = dijkstra(gateCode, targetGateCode)
    if path:
        return {"route": path, "total_cost": cost}
    return {"error": "Route not found"}


# Run server with: `uvicorn main:app --reload`
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
