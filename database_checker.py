import psycopg2
import os
import time
from dotenv import load_dotenv

load_dotenv()

MAX_RETRIES = 3

for attempt in range(1, MAX_RETRIES + 1):
    try:
        conn = psycopg2.connect(
            dbname=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            host=os.getenv("DB_HOST"),
            port=os.getenv("DB_PORT"),
        )
        print(f"✅ Connected to DB on attempt {attempt}")
        conn.close()
        break
    except Exception as e:
        print(f"❌ Attempt {attempt} failed: {e}")
        if attempt < MAX_RETRIES:
            time.sleep(3)
        else:
            print("🚨 All attempts failed. Check RDS, network or credentials.")