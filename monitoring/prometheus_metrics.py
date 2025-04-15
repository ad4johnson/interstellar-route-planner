from prometheus_client import start_http_server, Summary, Counter
import time
import logging
from prometheus_client import Gauge


logging.basicConfig(level=logging.INFO)



# Placeholder for the model; replace with actual model initialization
from sklearn.ensemble import IsolationForest  # Example import

# Initialize a dummy model for anomaly detection
model = IsolationForest(random_state=42)
model.fit([[0], [0.44], [0.45], [0.46], [1]])  # Example training data

def detect_anomaly(data):
    prediction = model.predict(data)
    is_anomaly = prediction[0] == -1  # Assuming -1 indicates anomaly
    ANOMALY_DETECTED.set(1 if is_anomaly else 0)
    return is_anomaly

# Create a metric to track request processing time with labels
REQUEST_TIME = Summary(
    'request_processing_seconds',
    'Time spent processing request',
    labelnames=['endpoint', 'status_code']
)

# Counter to track the number of processed requests
REQUEST_COUNT = Counter('request_count', 'Total number of processed requests')

# Gauge to track if an anomaly is detected
ANOMALY_DETECTED = Gauge('anomaly_detected', 'Indicates if an anomaly is detected (1 for yes, 0 for no)')

def process_request(endpoint, status_code):
    with REQUEST_TIME.labels(endpoint=endpoint, status_code=status_code).time():
        time.sleep(1)  # Simulate request processing
        REQUEST_COUNT.inc()  # Increment request count
        logging.info(f"Processed request: {endpoint} with status {status_code}")
        # Simulate processing logic (e.g., handle the request)
    return

if __name__ == '__main__':
    start_http_server(8001)  # Expose metrics at port 8000
    while True:
        # Example: Track requests for two different endpoints with statuses
        process_request('GET /health', '200')
        process_request('POST /api/data', '201')