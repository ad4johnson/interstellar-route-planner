import os
import json
import psycopg2
from psycopg2.extras import RealDictCursor
from fastapi import HTTPException
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# ========================
# DB Configuration
# ========================
def get_db_config():
    return {
        "dbname": os.getenv("DB_NAME"),
        "user": os.getenv("DB_USER"),
        "password": os.getenv("DB_PASSWORD"),
        "host": os.getenv("DB_HOST"),
        "port": os.getenv("DB_PORT", "5432"),
    }

# ========================
# DB Connection Helper
# ========================
def get_db_connection():
    """
    Establish and return a new DB connection.
    Raises HTTPException on failure.
    """
    config = get_db_config()
    try:
        print(f"🔌 Connecting to DB at {config['host']}:{config['port']} as {config['user']}")
        return psycopg2.connect(**config)
    except psycopg2.OperationalError as e:
        print(f"❌ OperationalError: {e}")
        raise HTTPException(status_code=500, detail=f"Database connection failed: {e}")
    except Exception as e:
        print(f"❌ Unexpected DB error: {e}")
        raise HTTPException(status_code=500, detail=f"Unexpected DB error: {e}")

# ========================
# Query Helpers
# ========================
def get_gates_from_db():
    """
    Fetch and return all gates from the database in structured dict format.
    """
    query = "SELECT id, name, connections FROM gate;"
    
    try:
        conn = get_db_connection()
        with conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute(query)
                rows = cur.fetchall()

        gates = {}

        for row in rows:
            gate_id = row["id"]
            name = row["name"]
            raw_connections = row["connections"]

            try:
                connections_data = (
                    json.loads(raw_connections) if isinstance(raw_connections, str) else raw_connections
                )
                gates[gate_id] = {
                    "name": name,
                    "connections": {conn["id"]: int(conn["hu"]) for conn in connections_data},
                }
            except Exception as parse_error:
                print(f"⚠️ Skipped gate {gate_id} due to parse error: {parse_error}")

        return gates

    except psycopg2.Error as e:
        print(f"❌ DB query failed: {e}")
        raise HTTPException(status_code=500, detail=f"Database query failed: {e}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        raise HTTPException(status_code=500, detail=f"Unexpected error: {e}")
    finally:
        if conn:
            conn.close()