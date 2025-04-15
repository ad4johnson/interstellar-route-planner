import os
import json
import psycopg2
from psycopg2.extras import RealDictCursor
from fastapi import HTTPException
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# ========================
# DB Configuration via Env
# ========================
def get_db_config():
    return {
        "dbname": os.getenv("DB_NAME"),
        "user": os.getenv("DB_USER"),
        "password": os.getenv("DB_PASSWORD"),
        "host": os.getenv("DB_HOST"),
        "port": os.getenv("DB_PORT", "5432"),  # Default PostgreSQL port
    }

# ========================
# Establish DB Connection
# ========================
def get_db_connection():
    """
    Create and return a new DB connection using environment variables.
    Raises HTTPException if connection fails.
    """
    try:
        config = get_db_config()
        print(f"🔌 Connecting to DB at {config['host']}:{config['port']} as {config['user']}")
        conn = psycopg2.connect(**config)
        return conn
    except psycopg2.OperationalError as e:
        print(f"❌ OperationalError: {e}")
        raise HTTPException(status_code=500, detail=f"Database connection failed: {e}")
    except Exception as e:
        print(f"❌ Unexpected DB error: {e}")
        raise HTTPException(status_code=500, detail=f"Unexpected DB error: {e}")

# ========================
# Query: Fetch All Gates
# ========================
def get_gates_from_db():
    """
    Fetch all gates from the database.
    Returns a dictionary like:
    {
        "A1": {"name": "Alpha", "connections": {"B1": 3, "C1": 5}},
        ...
    }
    """
    try:
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT id, name, connections FROM gate;")
        rows = cur.fetchall()

        gates = {}
        for row in rows:
            gate_id = row["id"]
            name = row["name"]
            raw_connections = row["connections"]

            try:
                parsed_connections = (
                    json.loads(raw_connections)
                    if isinstance(raw_connections, str)
                    else raw_connections
                )
                gates[gate_id] = {
                    "name": name,
                    "connections": {
                        conn["id"]: int(conn["hu"]) for conn in parsed_connections
                    },
                }
            except Exception as parse_error:
                print(f"⚠️ Skipped gate {gate_id} due to parse error: {parse_error}")

        cur.close()
        conn.close()
        return gates

    except psycopg2.Error as e:
        print(f"❌ DB query failed: {e}")
        raise HTTPException(status_code=500, detail=f"Database query failed: {e}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        raise HTTPException(status_code=500, detail=f"Unexpected error: {e}")
    
    print(f"✅ Connecting to DB @ {os.getenv('DB_HOST')}")