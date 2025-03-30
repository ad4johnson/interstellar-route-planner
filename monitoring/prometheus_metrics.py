from prometheus_client import start_http_server, Summary, Counter
import time
import logging

logging.basicConfig(level=logging.INFO)

# Create a metric to track request processing time with labels
REQUEST_TIME = Summary(
    'request_processing_seconds',
    'Time spent processing request',
    labelnames=['endpoint', 'status_code']
)

# Counter to track the number of processed requests
REQUEST_COUNT = Counter('request_count', 'Total number of processed requests')

def process_request(endpoint, status_code):
    with REQUEST_TIME.labels(endpoint=endpoint, status_code=status_code).time():
        time.sleep(1)  # Simulate request processing
        REQUEST_COUNT.inc()  # Increment request count
        logging.info(f"Processed request: {endpoint} with status {status_code}")
        # Simulate processing logic (e.g., handle the request)
    return

if __name__ == '__main__':
    start_http_server(8000)  # Expose metrics at port 8000
    while True:
        # Example: Track requests for two different endpoints with statuses
        process_request('GET /health', '200')
        process_request('POST /api/data', '201')