import requests
import threading
import time
import random
import os
from dotenv import load_dotenv
from concurrent.futures import ThreadPoolExecutor, as_completed

load_dotenv()

API = os.getenv("BASE_URL", "http://interstellar-alb-1254490069.us-east-1.elb.amazonaws.com")

# ✅ Add session for HTTP connection pooling
session = requests.Session()
adapter = requests.adapters.HTTPAdapter(pool_connections=100, pool_maxsize=100)
session.mount('http://', adapter)
session.mount('https://', adapter)

def hit_get_routes():
    try:
        resp = session.get(f"{API}/gates/G1/to/G9", timeout=15)
        print(f"[{time.strftime('%H:%M:%S')}] [Route] Status: {resp.status_code}")
    except Exception as e:
        print(f"[{time.strftime('%H:%M:%S')}] Route error:", e)

def trigger_anomaly():
    try:
        payload = {"values": [[random.uniform(0, 1) for _ in range(38)]]}
        resp = session.post(f"{API}/anomaly-detection", json=payload, timeout=5)
        print(f"[{time.strftime('%H:%M:%S')}] [Anomaly] Status: {resp.status_code} {resp.json()}")
    except Exception as e:
        print(f"[{time.strftime('%H:%M:%S')}] Anomaly error:", e)

def run_load(iterations=50, delay=0.2):
    with ThreadPoolExecutor(max_workers=20) as executor:
        futures = []
        for _ in range(iterations):
            futures.append(executor.submit(hit_get_routes))
            futures.append(executor.submit(trigger_anomaly))
            time.sleep(delay)

        # Optional: Wait for all to complete
        for future in as_completed(futures):
            pass

if __name__ == "__main__":
    print("🚀 Simulating route planning + anomaly load...")
    run_load()