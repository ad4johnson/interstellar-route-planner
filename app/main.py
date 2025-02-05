from fastapi import FastAPI, Query
import os
import psycopg2
import json
from dotenv import load_dotenv

load_dotenv()

from app.utils import dijkstra

# Docker ECS PostgreSQL connection settings
DB_NAME = os.getenv("DB_NAME", "interstellar_db")
DB_USER = os.getenv("DB_USER", "admin")
DB_PASSWORD = os.getenv("DB_PASSWORD", "securepassword")
DB_HOST = os.getenv("DB_HOST", "postgres-service")  # Use the Docker container name, NOT "postgres-service"
DB_PORT = int(os.getenv("DB_PORT", 5432))

# Establish database connection
try:
    conn = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,  # Use container name "postgres"
        port=DB_PORT
    )
    cursor = conn.cursor()
except psycopg2.OperationalError as e:
    print("Database connection failed:", e)
    cursor = None  # Prevent crashes if DB is down

app = FastAPI()

@app.get("/")
def read_root():
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