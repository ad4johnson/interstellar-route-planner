import requests
import threading
import time
import random
import os
import numpy as np
from dotenv import load_dotenv
from concurrent.futures import ThreadPoolExecutor, as_completed

load_dotenv()

API = os.getenv("BASE_URL", "http://interstellar-alb-1254490069.us-east-1.elb.amazonaws.com")

# ✅ Add session for HTTP connection pooling
session = requests.Session()
adapter = requests.adapters.HTTPAdapter(pool_connections=100, pool_maxsize=100)
session.mount('http://', adapter)
session.mount('https://', adapter)

def generate_anomalous_payload(prob_anomaly=0.2):
    """
    Generate payload for anomaly detection.
    With probability `prob_anomaly`, generate anomalous data.
    """
    if np.random.rand() < prob_anomaly:
        # 🚨 Generate anomalous payload
        values = [[random.uniform(-100, 100) for _ in range(38)]]
        print(f"[{time.strftime('%H:%M:%S')}] 🚨 Generated ANOMALOUS payload!")
    else:
        # Generate normal payload
        values = [[random.uniform(0, 1) for _ in range(38)]]

    return {"values": values}

def hit_get_routes():
    """
    Simulate route planning API call.
    """
    try:
        resp = session.get(f"{API}/gates/G1/to/G9", timeout=10)
        print(f"[{time.strftime('%H:%M:%S')}] [Route] Status: {resp.status_code}")
    except Exception as e:
        print(f"[{time.strftime('%H:%M:%S')}] Route error:", e)

def trigger_anomaly():
    """
    Simulate anomaly detection API call.
    """
    try:
        payload = generate_anomalous_payload()
        resp = session.post(f"{API}/anomaly-detection", json=payload, timeout=5)

        if resp.status_code == 200:
            result = resp.json()
            print(f"[{time.strftime('%H:%M:%S')}] [Anomaly] Status: {resp.status_code} {result}")
        else:
            print(f"[{time.strftime('%H:%M:%S')}] [Anomaly] Status: {resp.status_code}")

    except Exception as e:
        print(f"[{time.strftime('%H:%M:%S')}] Anomaly error:", e)

def run_load(iterations=50, delay=0.2):
    """
    Run load simulation with concurrent requests.
    """
    with ThreadPoolExecutor(max_workers=20) as executor:
        futures = []
        for _ in range(iterations):
            futures.append(executor.submit(hit_get_routes))
            futures.append(executor.submit(trigger_anomaly))
            time.sleep(delay)

        # Wait for all futures to complete
        for future in as_completed(futures):
            pass

if __name__ == "__main__":
    print("🚀 Simulating route planning + anomaly load (burst enabled)...")
    run_load()