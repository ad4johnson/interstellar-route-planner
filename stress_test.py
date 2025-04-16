import requests
import threading
import time
import random

API = "http://interstellar-alb-1155191774.us-east-1.elb.amazonaws.com"

def hit_get_routes():
    try:
        resp = requests.get(f"{API}/gates/G1/to/G9")  # Example route
        print("[Route] Status:", resp.status_code)
    except Exception as e:
        print("Route error:", e)

def trigger_anomaly():
    try:
        payload = {"values": [[0.1] * 38]}
        resp = requests.post(f"{API}/anomaly-detection", json=payload)
        print("[Anomaly] Status:", resp.status_code, resp.json())
    except Exception as e:
        print("Anomaly error:", e)

def run_load():
    for _ in range(50):
        threading.Thread(target=hit_get_routes).start()
        threading.Thread(target=trigger_anomaly).start()
        time.sleep(0.2)

if __name__ == "__main__":
    print("🚀 Simulating route planning + anomaly load...")
    run_load()