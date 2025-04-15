import os
import psycopg2
from psycopg2 import sql
import json
from dotenv import load_dotenv

load_dotenv()

def get_database_url():
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT", "5432")
    name = os.getenv("DB_NAME")
    return f"postgresql://{user}:{password}@{host}:{port}/{name}"

DATABASE_URL = get_database_url()

dummy_data = [
    {
        "id": "G1",
        "name": "Earth Gate",
        "connections": {"G2": 10, "G3": 20}
    },
    {
        "id": "G2",
        "name": "Mars Gate",
        "connections": {"G1": 10, "G4": 15}
    },
    {
        "id": "G3",
        "name": "Jupiter Gate",
        "connections": {"G1": 20, "G4": 30}
    },
    {
        "id": "G4",
        "name": "Saturn Gate",
        "connections": {"G2": 15, "G3": 30}
    }
]

def seed_database():
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()

        # Create table if not exists
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS gate (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                connections JSONB NOT NULL
            );
        """)

        # Insert dummy data
        for gate in dummy_data:
            cursor.execute(
                sql.SQL("INSERT INTO gate (id, name, connections) VALUES (%s, %s, %s) ON CONFLICT (id) DO NOTHING;"),
                (gate["id"], gate["name"], json.dumps(gate["connections"]))
            )

        conn.commit()
        print("✅ Dummy gate data seeded successfully.")
    except Exception as e:
        print("❌ Seeding failed:", e)
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    seed_database()
#     return {"message": "Data received"}