import psycopg2
import os
import json
from fastapi import FastAPI, HTTPException

app = FastAPI()

# Correcting DB configuration with proper env vars
db_config = {
    "dbname": os.getenv("DB_NAME", "interstellar"),
    "user": os.getenv("DB_USER", "admin"),
    "password": os.getenv("DB_PASSWORD", "password"),
    "host": os.getenv("DB_HOST", "db"),  # Corrected host
    "port": os.getenv("DB_PORT", "5432"),
}


def get_db_connection():
    """Establishes a database connection and returns a cursor."""
    try:
        conn = psycopg2.connect(**db_config)
        return conn
    except Exception as e:
        raise RuntimeError(f"Database connection failed: {str(e)}")


def get_gates_from_db():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, name, connections FROM gate")
        rows = cur.fetchall()
        cur.close()
        conn.close()

        gates = {}
        for row in rows:
            gate_id, name, connections = row
            connections = (
                json.loads(connections) if isinstance(connections, str) else connections
            )
            gates[gate_id] = {
                "name": name,
                "connections": {
                    c["id"]: int(c["hu"]) for c in connections
                },  # Convert to adjacency list format
            }
        return gates
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


@app.get("/gates")
def get_gates():
    """API endpoint to retrieve all gates."""
    try:
        gates = get_gates_from_db()
        if not gates:
            return {"error": "No gates found in database"}
        return {"gates": [{"id": k, "name": v["name"]} for k, v in gates.items()]}
    except Exception as e:
        return {"error": f"Database error: {str(e)}"}
